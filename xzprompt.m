function [x, z]=xzprompt()

f=figure;
f.Position=[584   815   300   100];
Tx=uicontrol(f,'Style','Text','String','Voxel Size XY (um):','Position',[10 70 120 20]);
Cx=uicontrol(f,'Style','edit');
Cx.String='1';
Cx.Position=[150 70 120 20];

Tz=uicontrol(f,'Style','Text','String','Voxel Size Z (um):','Position',[10 40 120 20]);
Cz=uicontrol(f,'Style','edit');
Cz.String='1';
Cz.Position=[150 40 120 20];

P=uicontrol(f,'Style','Pushbutton','String','OK','Position',[130 5 40 30]);
P.Callback=@PB_callback;
uiwait;

function PB_callback(src,event)
        x=str2double(Cx.String);
        disp(x)
        z=str2double(Cz.String);
        disp(z)
        uiresume;
        close(f)

end

end
