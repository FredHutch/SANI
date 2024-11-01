
function Lcomb=SANcombineLabels(LG, LR)




ng=numel(unique(LG(:)));
nr=numel(unique(LR(:)));

if ng>nr
    Lcomb=LG;
    ml=max(unique(LG(:)))+1;
    ug=unique(LR(:));
    GW=LG>0;
    for i=1:nr
        M=LR==ug(i);
        DW=M & ~GW;

        if (sum(DW(:))/sum(M(:)))==1
            
            Lcomb(M)=ml;
            ml=ml+1;
        end
    end

else
    Lcomb=LR;
    ml=max(unique(LR(:)))+1;
    ug=unique(LG(:));
    GW=LR>0;
    for i=1:ng
        M=LG==ug(i);
        DW=M & ~GW;

        if (sum(DW(:))/sum(M(:)))==1
            Lcomb(M)=ml;
            ml=ml+1;
        end
    end

end

