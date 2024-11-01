function data=computeassignment(source_vectorMatrix,target_cellArray)

tic
sxtarget=cellfun(@(x) sum(sign(x(:,1)))/188,target_cellArray);
sxsource=sum(sign(source_vectorMatrix(:,1))/size(source_vectorMatrix,1));
diffsx=sxtarget-sxsource;
tf=diffsx<0.2 & diffsx>-0.2;
pidx=find(tf);

target=target_cellArray(tf);
costall=zeros(numel(target),1);
for i=1:numel(target)
    [~, cost]=gethungdist(source_vectorMatrix,target{i});
    costall(i)=cost;
end
data=[pidx costall];
toc