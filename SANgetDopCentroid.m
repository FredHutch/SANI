function [dopid, ndopid]=SANgetDopCentroid(L,B)

% this function finds the centroids of the dopaminergic neurons. There is
% theoretically 6 dopaminergic neurons in the head, but the reporter line
% usually labels 4 or 5. Moreover, the reporter is cytoplasmic, and the
% signal may leak to neighbor nuclei.
% The algo gets the centroid and meanintensity of all the labelled nuclei,
% pick the centroids of the 6 most intense nuclei, check their relative
% distance and discard the nuclei that are too close (10 pixels) from one
% another, i.e. keep the mre intense between the two.


%% Get position and mean intensity of all labeled nuclei
S=regionprops3(L,B,'Centroid','MeanIntensity');
tf=isnan(S.MeanIntensity);
S(tf,:)=[];
C=S.Centroid;
M=S.MeanIntensity;
[sM, dopid]=sort(M,'descend'); % sorting not essential but why not

%% Consider high intensity (mean + 2xstd) nuclei as potential Dopa neurons
TM=mean(M)+2*std(M);
ttf=sM<TM;
sM(ttf)=[];dopid(ttf)=[];
DopCent=C(dopid,:);

%% Calculate pairwise distance between nuclei
dist=squareform(pdist(DopCent));
Z=triu(dist);
Z(Z==0)=NaN;

%% Find pairs that are very close (likely due to leaking) and get rid of the less intense one
[r, c]=find(Z<10);
delid=zeros(size(r,1),1);
for i=1:size(r,1)
    if sM(r(i))>sM(c(i))
        delid(i)=c(i);
    else
        delid(i)=r(i);
    end
end

dopid(delid)=[];
ndopid=1:size(C,1);
ndopid(dopid)=[];


