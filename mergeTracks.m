function mdata=mergeTracks(data)


mcen=cellfun(@(x) mean(x.OrigCentroid,1,'omitnan'),data,'UniformOutput',false);
vm=vertcat(mcen{:});
d=pdist2(vm,vm);
d=triu(d);
d(d==0)=Inf;

[r c]=find(d<1);
comp=[r c];

u=unique(comp);
k=setdiff(1:size(data,1),u);
mdata=data(k);

while u
    [rr cc]=find(comp==u(1));
    s=comp(rr,:);
    su=unique(s);
    sudel=su;
    dtemp=data{su(1)};
    dtest=data{su(2)};
    k=intersect(dtest.FrameID,dtemp.FrameID);
    if isempty(k) && dtemp.FrameID(end)<dtest.FrameID(1)
        dtemp=[dtemp;dtest];
    elseif isempty(k) && dtemp.FrameID(1)>dtest.FrameID(end)
        dtemp=[dtest;dtemp];
    end
    su([1 2])=[];
    while su
        dtest=data{su(1)};
        k=intersect(dtest.FrameID,dtemp.FrameID);
    if isempty(k) && dtemp.FrameID(end)<dtest.FrameID(1)
        dtemp=[dtemp;dtest];
    elseif isempty(k) && dtemp.FrameID(1)>dtest.FrameID(end)
        dtemp=[dtest;dtemp];
    end
    su(1)=[];
    end
    mdata=[mdata;{dtemp}];
    u(ismember(u,sudel))=[];
end

