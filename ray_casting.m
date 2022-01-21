clear; clc; close all;

L = 10;
W = 10;

figure;
a = subplot(1,2,1);
hold on;
box on;
axis equal;
axis([0 L 0 W]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'color',[0 0 0]);

b = subplot(1,2,2);
hold on;
box on;
axis equal;
axis([0 L 0 W]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'color',[0 0 0]);

%%%%

wall_all = [ rand(1,2).*[ L L] , rand(1,2).*[ W W] ;
             rand(1,2).*[ L L] , rand(1,2).*[ W W] ;
             rand(1,2).*[ L L] , rand(1,2).*[ W W] ;
             0 L 0 0;
             0 L W W;
             0 0 0 W;
             L L 0 W];

%%%%

nr = 60;
all = (1:nr)';
campo = 45*(pi/180);
ang = rand(1,1)*2*pi;
foco = rand(1,2).*[L W];
r = norm([ L W ]);
dang = 10*pi/180;
davan = 0.33;
dx = L/nr;

cont = 0;
while cont >= 0

cont = cont + 1;

if cont >= 2
    k = waitforbuttonpress; 
    % 28 leftarrow
    % 29 rightarrow
    % 30 uparrow
    % 31 downarrow
    value = double(get(gcf,'CurrentCharacter'));
    switch value %%% 97 a , 115 s
        case 28, ang = ang + dang;
        case 29, ang = ang - dang;
        case 97, foco = foco + davan*[cos(ang+pi/2) sin(ang+pi/2) ]; 
        case 115, foco = foco - davan*[cos(ang+pi/2) sin(ang+pi/2) ];
        case 30, foco = head;
        case 31, foco = foco-head + foco;
    end
end

th = linspace(ang-campo/2,ang+campo/2,nr)';
x2 = foco(1) + r*cos(th);
y2 = foco(2) + r*sin(th);
cla(a);

for k = 1:size(wall_all,1)
    
wall = wall_all(k,:);

plot(a,wall(1:2),wall(3:4),'w');

den = (foco(1)-x2)*(wall(3)-wall(4))-(foco(2)-y2)*(wall(1)-wall(2));

t = ( (foco(1)-wall(1))*( wall(3)-wall(4) )-(foco(2)-wall(3))*(wall(1)-wall(2)) )./den;
u = ( (x2-foco(1))*(foco(2)-wall(3))-(y2-foco(2))*(foco(1)-wall(1)) )./den;

ids = (u>=0)+(u<=1)+(t>=0)==3;
ids = all(ids);
Px = foco(1)+t(ids).*(x2(ids)-foco(1));
Py = foco(2)+t(ids).*(y2(ids)-foco(2));
d2 = hypot(Px-foco(1),Py-foco(2));
d1 = hypot(x2(ids)-foco(1),y2(ids)-foco(2));

x2(ids(d2<d1)) = Px(d2<d1);
y2(ids(d2<d1)) = Py(d2<d1);

end

plot(a,[foco(1)*ones(nr,1) x2]',[foco(2)*ones(nr,1) y2]','color',[1 1 1]*0.6);
head = foco + davan*[cos(ang) sin(ang)];
plot(a,[foco(1) head(1)],[foco(2) head(2)],'-r');

cla(b);
d = hypot(x2-foco(1),y2-foco(2)).*cos(th-ang);
intensi = 1 - (d/r).^0.25 ;
alt = 1 - (d/r).^2 ;
alt = 0.97*W*alt + 1e-3;
for i = 1:nr
    rectangle('Position',[(nr-i)*1.005*dx (W-alt(i))/2 dx alt(i)],'FaceColor',[0 1 0]*intensi(i),'EdgeColor',[0 1 0]*intensi(i));
end

end



