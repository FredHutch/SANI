function [FrameLabels, prepData, rmse, ncflag] = SANprepData(L)

% pd is the dir of L_xxx.mat files containing the Labels of the panneuron
% 3D stack.



%% Import labels and permute dimension from zxy to xyz
nframes=5; % replicate labels frame 5x to create pseudo timelapse
FrameLabels=cell(nframes,1);
ncell=zeros(nframes,1);

% S=load(pd(1).name); % 'Lcomb' should be the only variable
% fn=fieldnames(S);
% L=S.(fn{1});

for i=1:nframes

    cid=i;

    %%% check if dim permutation needed. Assume z size < x or y sizes
    [s1, s2, s3]=size(L);
    if s1<s2 && s1<s3
        L=permute(L,[2 3 1]);
    end
    %%% Need to double check if label stack already permuted

    FrameLabels{cid}=L;
    ncell(cid)=numel(unique(L(:)))-1;
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
    tf=isnan(Sref.Centroid(:,1));
    Sref(tf,:)=[];
    %Sref.Centroid(:,[1 2])=Sref.Centroid(:,[1 2])*scale(1);
    %Sref.Centroid(:,3)=Sref.Centroid(:,3)*scale(2);
    ptref=pointCloud(Sref.Centroid);

    %% In-data pc registration
    prepData=cell(nframes,2);
    rmse=zeros(nframes,1);
    for i=1:nframes
        curFrame=FrameLabels{i};
        Scur=regionprops3(curFrame,'Centroid');
        tf=isnan(Scur.Centroid(:,1));
        Scur(tf,:)=[];
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



