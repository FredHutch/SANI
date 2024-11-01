function Lclean=SANremoveDupNeuronsLabel(L,XPixsize,mindist)

S=regionprops3(L,"Volume","Centroid","VoxelIdxList");
S(S.Volume==0,:)=[];

C=S.Centroid;
D=squareform(pdist(C));
Du=triu(D);
Du(Du==0)=NaN;
Du=Du*XPixsize;

[r, c]=find(Du<mindist);
p=[r c];
v=S.Volume(p);
tf=v(:,1)<v(:,2);

del=[unique(p(tf,1));unique(p(~tf,2))];

RemVox=S(del,3);
RemVox=vertcat(RemVox.VoxelIdxList{:});
Lclean=L;
Lclean(RemVox)=0;
        