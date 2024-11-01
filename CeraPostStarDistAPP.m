function mdata=CeraPostStarDistAPP(cellStack,FrameLabels,prepData)

% Scale is pixel size from metadata ims file

nFrames=size(cellStack,1);
StatsgCampfromSD=cell(nFrames,1);

for i=1:nFrames
    G=cellStack{i};
    S=regionprops3(FrameLabels{i},G,'Volume','MeanIntensity','VoxelValues');
    StatsgCampfromSD{i}=S;
end

if nFrames>1
%% Track nuclei
%nFrames=size(StatsgCampfromSD,1);
% XScale=Scale(1);
% ZScale=Scale(2);
%Points=cell(nFrames,1);
movieInfo=struct;
for i=1:nFrames
T=StatsgCampfromSD{i};
TT=table(prepData{i,1},'VariableNames',{'Centroid'});
n=size(T,1);
TTT=table(repmat(i,n,1), 'VariableNames',{'FrameID'});
TTTT=table(prepData{i,2},'VariableNames',{'OrigCentroid'}); % remove if using simpletracker
%T=[T TT TTT]; if using simpletracker 
T=[T TT TTT TTTT]; 
StatsgCampfromSD{i}=T;
xx=[StatsgCampfromSD{i,1}.OrigCentroid(:,1) zeros(size(StatsgCampfromSD{i,1},1),1)];
yy=[StatsgCampfromSD{i,1}.OrigCentroid(:,2) zeros(size(StatsgCampfromSD{i,1},1),1)];
zz=[StatsgCampfromSD{i,1}.OrigCentroid(:,3) zeros(size(StatsgCampfromSD{i,1},1),1)];
mm=[StatsgCampfromSD{i,1}.MeanIntensity zeros(size(StatsgCampfromSD{i,1},1),1)];
movieInfo(i).xCoord=xx;
movieInfo(i).yCoord=yy;
movieInfo(i).zCoord=zz;
movieInfo(i).amp=mm;
end


%%% using simptracker %%%%%%%%%%%%%%%%%%%%%

%[~, adjtracks]=simpletracker(prepData(:,1),'MaxLinkingDistance',3,'MaxGapClosing',nFrames,'Method','NearestNeighbor');
%[~, adjtracks]=simpletracker(prepData(:,1),'MaxLinkingDistance',3,'MaxGapClosing',nFrames);



%StatsCat=vertcat(StatsgCampfromSD{:});
%Centori=table(vertcat(prepData{:,2}),'VariableNames',{'OrigCentroid'});
%StatsCat=[StatsCat Centori];
%nf=cellfun(@numel,adjtracks);
%tf=nf<nFrames/3;
%adjtracks(tf)=[];
%Data=cellfun(@(adj) StatsCat(adj,:),adjtracks,'UniformOutput',false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tracksFinal=trackGeneral(movieInfo);
Data=cell(numel(tracksFinal),1);
for i=1:numel(tracksFinal)
    matfill=cell(nFrames,1);
    CG=tracksFinal(i).tracksFeatIndxCG;
    start=tracksFinal(i).seqOfEvents(1);
    CG=[zeros(1,start-1) CG];
    ncd=numel(CG);
    for j=1:ncd
        if CG(j)~=0
            matfill{j}=StatsgCampfromSD{j,1}(CG(j),3:6);
        end
    end
    %tf=isnan(matfill(:,1));
    %matfill(tf,:)=[];
    tempmat=vertcat(matfill{:});
    tempmat.NormIntensity=normalize(tempmat.MeanIntensity);
    Data{i}=tempmat;
end

mdata=mergeTracks(Data);
else
    S=regionprops('table',FrameLabels{1},cellStack{1},'Centroid','MeanIntensity');
FrameID=array2table(ones(size(S,1),1),'VariableNames',{'FrameID'});
OrigCentroid=S(:,1);
NormIntensity=array2table(zeros(size(S,1),1),'VariableNames',{'NormIntensity'});
OrigCentroid.Properties.VariableNames={'OrigCentroid'};
Scomp=[S FrameID OrigCentroid NormIntensity];
mdata=cell(size(Scomp,1),1);

for i=1:size(Scomp,1)
    mdata{i}=Scomp(i,:);
end

end









