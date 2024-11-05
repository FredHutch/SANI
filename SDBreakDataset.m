function SDBreakDataset(huygensfile)

[reader, omem, sinfo]=bfGetInfo(huygensfile);
if strcmp(sinfo.PixelType,'float')
    sinfo.PixelType='double';
end




if sinfo.C==2
    GBlock=zeros(sinfo.Y,sinfo.X,sinfo.Z,sinfo.PixelType);
    RBlock=zeros(sinfo.Y,sinfo.X,sinfo.Z,sinfo.PixelType);
elseif sinfo.C==3
    GBlock=zeros(sinfo.Y,sinfo.X,sinfo.Z,sinfo.PixelType);
    RBlock=zeros(sinfo.Y,sinfo.X,sinfo.Z,sinfo.PixelType);
    BBlock=zeros(sinfo.Y,sinfo.X,sinfo.Z,sinfo.PixelType);
else
    error('At least 2 channels are required!')
end

sp=split(huygensfile,'.');
imsfold=join(sp(1:end-1),'_');
imsfold=imsfold{1};
mkdir(imsfold);
cd(['./' imsfold]);

T=sinfo.T;
C=sinfo.C;
Z=sinfo.Z;
reader.setSeries(0);

metadataG = createMinimalOMEXMLMetadata(GBlock);
metadataR = createMinimalOMEXMLMetadata(RBlock);
metadataB = createMinimalOMEXMLMetadata(BBlock);
pixelSizeXY = omem.getPixelsPhysicalSizeX(0);
pixelSizeZ = omem.getPixelsPhysicalSizeX(0);
metadataG.setPixelsPhysicalSizeX(pixelSizeXY, 0);
metadataR.setPixelsPhysicalSizeX(pixelSizeXY, 0);
metadataB.setPixelsPhysicalSizeX(pixelSizeXY, 0);

metadataG.setPixelsPhysicalSizeY(pixelSizeXY, 0);
metadataR.setPixelsPhysicalSizeY(pixelSizeXY, 0);
metadataB.setPixelsPhysicalSizeY(pixelSizeXY, 0);

metadataG.setPixelsPhysicalSizeZ(pixelSizeZ, 0);
metadataR.setPixelsPhysicalSizeZ(pixelSizeZ, 0);
metadataB.setPixelsPhysicalSizeZ(pixelSizeZ, 0);




for iT=1:T
    for iC=1:C
        for iZ=1:Z

            iPlane = reader.getIndex(iZ - 1, iC -1, iT - 1) + 1;
            I = bfGetPlane(reader, iPlane);
            if iC==1
                GBlock(:,:,iZ)=I;
            elseif iC==2
                RBlock(:,:,iZ)=I;
            elseif iC==3
                BBlock(:,:,iZ)=I;
            end
            disp([int2str(iT) ' | ' int2str(iC) ' | ' int2str(iZ)]);
        end
    end


    if C==2
        outG=['G_' pad(int2str(iT),3,'left','0') 'sd.tif'];
        outR=['R_' pad(int2str(iT),3,'left','0') 'sd.tif'];
        bfsave(GBlock,outG);
        bfsave(RBlock,outR);
    elseif C==3
        outG=['G_' pad(int2str(iT),3,'left','0') 'sd.tif'];
        outR=['R_' pad(int2str(iT),3,'left','0') 'sd.tif'];
        outB=['B_' pad(int2str(iT),3,'left','0') '.tif'];
        bfsave(GBlock,outG);
        bfsave(RBlock,outR);
        bfsave(BBlock,outB);
    end
end