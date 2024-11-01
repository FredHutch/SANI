function mdata=SANPostStarDistAPP(cellStack,FrameLabels,prepData)

% This function uses the simpletrack algorithm to create the fake tracks

nFrames=size(cellStack,1);
StatsgCampfromSD=cell(nFrames,1);

for i=1:nFrames
    G=cellStack{i};
    S=regionprops3(FrameLabels{i},G,'Volume','MeanIntensity','VoxelValues');
    tf=isnan(S.MeanIntensity);
    S(tf,:)=[];
    S.NormIntensity=normalize(S.MeanIntensity);
    StatsgCampfromSD{i}=S;
end


for i=1:nFrames
    T=StatsgCampfromSD{i};
    TT=table(prepData{i,1},'VariableNames',{'Centroid'});
    n=size(T,1);
    TTT=table(repmat(i,n,1), 'VariableNames',{'FrameID'});
    T=[T TT TTT]; %if using simpletracker
    StatsgCampfromSD{i}=T;
end


%%% using simptracker %%%%%%%%%%%%%%%%%%%%%

[~, adjtracks]=simpletracker(prepData(:,1),'MaxLinkingDistance',3,'MaxGapClosing',nFrames,'Method','NearestNeighbor');


StatsCat=vertcat(StatsgCampfromSD{:});
Centori=table(vertcat(prepData{:,2}),'VariableNames',{'OrigCentroid'});
StatsCat=[StatsCat Centori];
nf=cellfun(@numel,adjtracks);
tf=nf<nFrames/3;
adjtracks(tf)=[];
Data=cellfun(@(adj) StatsCat(adj,:),adjtracks,'UniformOutput',false);

mdata=mergeTracks(Data);









