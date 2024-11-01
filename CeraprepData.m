function [FrameLabels, prepData, rmse, ncflag] = CeraprepData(pd)

% pd is the dir of Fxxx.mat files containing the Label images for each time
% frame from dragonfly acquisition .ims file.
% scale is1-by-2 vector with pixel size in XY (scale(1)) and Z (scale(2))


%% Import labels and permute dimension from zxy to xyz
nframes=numel(pd);
FrameLabels=cell(nframes,1);
ncell=zeros(nframes,1);

for i=1:nframes
c=pd(i).name;
cf=split(c,{'F','.'});
cid=str2double(cf{2});
load(pd(i).name);
Tp=permute(T,[2 3 1]);
FrameLabels{cid}=Tp;
S=regionprops3(Tp,'Volume');
ncell(cid)=numel(S.Volume);
end

%% select frame with highest number of neurons to use as ref for point clouds registering
[mnc,im]=max(ncell);
if mnc<50
    FrameLabels=[];
    prepData=[];
    rmse=[];
    ncflag=mnc;
    return
else

    if numel(im)>1, im=im(1); end
    
    ncflag=0;
refFrame=FrameLabels{im};
Sref=regionprops3(refFrame,'Centroid');
%Sref.Centroid(:,[1 2])=Sref.Centroid(:,[1 2])*scale(1);
%Sref.Centroid(:,3)=Sref.Centroid(:,3)*scale(2);
ptref=pointCloud(Sref.Centroid);

%% In-data pc registration
prepData=cell(nframes,2);
rmse=zeros(nframes,1);
for i=1:nframes
    curFrame=FrameLabels{i};
    Scur=regionprops3(curFrame,'Centroid');
    ScurOr=Scur;
    %Scur.Centroid(:,[1 2])=Scur.Centroid(:,[1 2])*scale(1);
    %Scur.Centroid(:,3)=Scur.Centroid(:,3)*scale(2);
    ptcur=pointCloud(Scur.Centroid);
    [~, ptcurreg, rms]=pcregistercpd(ptcur,ptref,'MaxIterations',30);
    prepData{i,1}=ptcurreg.Location;
    prepData{i,2}=ScurOr.Centroid;
    rmse(i)=rms;
end
end



