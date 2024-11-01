function L=SANcleanLabels()

%Shortkeys:
%a - stack up
%z - stack down
%w - zoom in
%s - zoom out
%e -increase contrast
%d - decrease contrast
%f - draw ROI and delete labels
%space - switch labelrgb on or off
%x - quit

close all;
clear;

[tiffile,path]=uigetfile('*.tif','choose tif file');
ftiffile=fullfile(path,tiffile);
[mpath, mfile]=fileparts(ftiffile);
mtiffile=fullfile(mpath,[mfile '.mat']);

I=bfopen(ftiffile);
IS=cat(3,I{1,1}{:,1});
SL=load(mtiffile);
fn=fieldnames(SL);
L=SL.(fn{1});
L=permute(L,[2 3 1]);

rgb3d=label2rgb3d(L,@jet,'k','shuffle');
ccol=rand(5000,3);
[a, b, c]=size(IS);
rgb_state=true;

hf=figure('WindowState','fullscreen');
hf.UserData{1}=L;
idx=1;

minv=min(IS(:));
maxv=max(IS(:));
hManager = uigetmodemanager(hf);
[hManager.WindowListenerHandles.Enabled] = deal(false);
%set(hf, 'WindowKeyPressFcn', []);

Lcurrgb=squeeze(rgb3d(:,:,idx,:));
hip=imshow(IS(:,:,idx),[minv 0.8*maxv]);
axg=gca;hold on;
axrgb=axg;
hrgb=imshow(Lcurrgb);
set(hrgb,'AlphaData',0.3);
hrgb.Parent=axrgb;
xx=get(gca,'XLim');
yy=get(gca,'YLim');
dx=diff(xx);
dy=diff(yy);
t=text(xx(1)+round(dx/100),yy(1)+round(dy/100),int2str(idx),'color','y');




set(hf,'KeyPressFcn',@KP);uiwait(hf);
L=hf.UserData{1};
sname=fullfile(mpath,[mfile 'curated.mat']);
save(sname,"L");
close;





    function KP(hf,event)


        switch event.Key


            case 'a'
                if idx<c
                    idx=idx+1;
                    hold off
                    t.String=[];
                    xx=get(gca,'XLim');
                    yy=get(gca,'YLim');
                    Lcurrgb=squeeze(rgb3d(:,:,idx,:));
                    hip.CData=IS(:,:,idx);
                    if rgb_state
                    hrgb.CData=Lcurrgb;
                    %set(hrgb,'AlphaData',0.3)
                    end
                    set(gca,'XLim',xx,'YLim',yy);
                    dx=diff(xx);
                    dy=diff(yy);
                    t.String=int2str(idx);
                else
                    
                    hold off
                    xx=get(gca,'XLim');
                    yy=get(gca,'YLim');

                    Lcurrgb=squeeze(rgb3d(:,:,idx,:));
                    hip.CData=IS(:,:,idx);
                    if rgb_state
                    hrgb.CData=Lcurrgb;
                    %set(hrgb,'AlphaData',0.3)
                    end
                    set(gca,'XLim',xx,'YLim',yy);
                    dx=diff(xx);
                    dy=diff(yy);
                    t.String=int2str(idx);
                end
            case 'z'
                if idx>1
                    idx=idx-1;
                    
                    hold off;
                    xx=get(gca,'XLim');
                    yy=get(gca,'YLim');

                    Lcurrgb=squeeze(rgb3d(:,:,idx,:));
                    hip.CData=IS(:,:,idx);
                    if rgb_state
                    hrgb.CData=Lcurrgb;
                    %set(hrgb,'AlphaData',0.3)
                    end
                    set(gca,'XLim',xx,'YLim',yy);
                    dx=diff(xx);
                    dy=diff(yy);
                    t.String=int2str(idx);
                else
                    
                    hold off;
                    xx=get(gca,'XLim');
                    yy=get(gca,'YLim');

                    Lcurrgb=squeeze(rgb3d(:,:,idx,:));
                    hip.CData=IS(:,:,idx);
                    if rgb_state
                    hrgb.CData=Lcurrgb;
                    %set(hrgb,'AlphaData',0.3)
                    end
                    set(gca,'XLim',xx,'YLim',yy);
                    dx=diff(xx);
                    dy=diff(yy);
                    t.String=int2str(idx);
                end

            case 'w'
                
                zoom(gcf,'on')
                zoom(gcf,2)
                xx=get(gca,'XLim');
                yy=get(gca,'YLim');
                hf.UserData{2}=[xx;yy];
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                zoom(gcf,'off')
            case 's'
                
                zoom(gcf,'on')
                zoom(gcf,0.5)
                xx=get(gca,'XLim');
                yy=get(gca,'YLim');
                hf.UserData{2}=[xx;yy];
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                zoom(gcf,'off')
            case 'leftarrow' %Left arrow key
                
                xx=get(gca,'XLim');
                xx=xx-20;
                yy=get(gca,'YLim');
                set(gca,'XLim',xx);
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                hf.UserData{2}=[xx;yy];
            case 'uparrow' %up arrow
                
                xx=get(gca,'XLim');
                yy=get(gca,'YLim');
                yy=yy-20;
                set(gca,'YLim',yy);
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                hf.UserData{2}=[xx;yy];
            case 'rightarrow' %right
                
                xx=get(gca,'XLim');
                xx=xx+20;
                yy=get(gca,'YLim');
                set(gca,'XLim',xx);
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                hf.UserData{2}=[xx;yy];
            case 'downarrow' %down
                
                xx=get(gca,'XLim');
                yy=get(gca,'YLim');
                yy=yy+20;
                set(gca,'YLim',yy);
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                hf.UserData{2}=[xx;yy];

            case 'f' % draw ROI to delete
                hold off;
                roi = drawfreehand(hf.CurrentAxes,'InteractionsAllowed','none');
                %get(gca);
                ROI=roi.createMask(hrgb);
                Lcur=L(:,:,idx);
                DROI=unique(Lcur(ROI));
                for kk=2:numel(DROI)
                    L(L==DROI(kk))=0;
                end
                rgb3d=label2rgb3d(L,@jet,'k','shuffle');
                xx=get(gca,'XLim');
                yy=get(gca,'YLim');

                Lcurrgb=squeeze(rgb3d(:,:,idx,:));
                hip.CData=IS(:,:,idx);
                if rgb_state
                hrgb.CData=Lcurrgb;
                %set(hrgb,'AlphaData',0.3);
                end
                delete(roi);
                set(gca,'XLim',xx,'YLim',yy);
                dx=diff(xx);
                dy=diff(yy);
                t.String=int2str(idx);
                hf.UserData{1}=L;uiwait(hf);

            case 'x'
                uiresume(hf);

            case 'space'
                if rgb_state
                    rgb_state=false;
                    hrgb.CData=[];
                else
                    rgb_state=true;
                    hrgb.CData=squeeze(rgb3d(:,:,idx,:));
                end

            case 'e'
                if 0.8*maxv>1000
                    maxv=maxv-10000/0.8;
                    axg.CLim=[minv 0.8*maxv];
                end
            case 'd'
                maxv=maxv+10000/0.8;
                axg.CLim=[minv maxv];


        end




    end
end

