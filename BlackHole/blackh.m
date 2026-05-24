clc;
clear;
close all;

figure('Color','black');
axis equal;
hold on;
grid off;
view(3);

xlim([-80 80]);
ylim([-80 80]);
zlim([-80 80]);
set(gca,'color','black');

lighting gouraud;
camlight headlight;
material dull;

numStars = 1500;
sx = (rand(1,numStars)-0.5)*300;
sy = (rand(1,numStars)-0.5)*300;
sz = (rand(1,numStars)-0.5)*300;

scatter3(sx,sy,sz,3,'White','filled')

[Xb,Yb,Zb] = sphere(100);
bhRadius = 5;
surf(bhRadius*Xb,bhRadius*Yb,bhRadius*Zb, ...
    'FaceColor','black','EdgeColor','none');

surf(6*Xb,6*Yb,6*Zb,'FaceAlpha','0.15','FaceColor',[0.5 0 1], ...
    'EdgeColor','none');

G = 10;
M = 5000;
dt = 0.005;
drag = 0.001;
N = 200;
particle = struct();
for i = 1:N
    r = 20 + rand()*40;
    theta = rand()*2*pi;
    particle(i).x = r*cos(theta);
    particle(i).y = r*sin(theta);
    particle(i).z = randn()*2;

    speed = sqrt(G*M/r);
    particle(i).vx = -speed*sin(theta);
    particle(i).vy = speed*cos(theta);
    particle(i).vz = 0;
end

for i = 1:N

    particle(i).obj = plot3( ...
        particle(i).x,...
        particle(i).y,...
        particle(i).z,...
        '.',...
        'Color',[1 0.5 0],...
        'MarkerSize',10);

    particle(i).trailX = [];
    particle(i).trailY = [];
    particle(i).trailZ = [];

    particle(i).trail = plot3( ...
        0,0,0,...
        'Color',[1 0.3 0],...
        'LineWidth',1);

end

for k = 1:100000
    for i = 1:N
        r = sqrt(particle(i).x^2 + ...
            particle(i).y^2 + ...
            particle(i).z^2);

        ax = -G*M*particle(i).x/r^3;
        ay = -G*M*particle(i).y/r^3;
        az = -G*M*particle(i).z/r^3;

        ax = ax - drag*particle(i).vx;
        ay = ay - drag*particle(i).vy;
        az = az - drag*particle(i).vz;

        particle(i).vx = particle(i).vx + ax*dt;
        particle(i).vy = particle(i).vy + ay*dt;
        particle(i).vz = particle(i).vz + az*dt;

        particle(i).x = particle(i).x + particle(i).vx*dt;
        particle(i).y = particle(i).y + particle(i).vy*dt;
        particle(i).z = particle(i).z + particle(i).vz*dt;

        particle(i).trailX(end+1) = particle(i).x;
        particle(i).trailY(end+1) = particle(i).y;
        particle(i).trailZ(end+1) = particle(i).z;

        set(particle(i).trail,...
            'XData',particle(i).trailX,...
            'YData',particle(i).trailY,...
            'ZData',particle(i).trailZ);

        maxTrail = 100;
        
        if length(particle(i).trailX) > maxTrail
        
            particle(i).trailX(1) = [];
            particle(i).trailY(1) = [];
            particle(i).trailZ(1) = [];
        
        end

        if r < bhRadius
            rnew = 40 + rand()*20;
            theta = rand()*2*pi;

            particle(i).x = rnew*cos(theta);
            particle(i).y = rnew*sin(theta);
            particle(i).z = randn()*2;

            speed = sqrt(G*M/rnew);

            particle(i).vx = -speed*sin(theta);
            particle(i).vy = speed*cos(theta);
            particle(i).vz = 0;
        end
        set(particle(i).obj, ...
            'XData',particle(i).x, ...
            'YData',particle(i).y, ...
            'ZData',particle(i).z);
    end
    camtarget([0 0 0]);
    camorbit(0.03,0,'camera');
    drawnow limitrate
end
