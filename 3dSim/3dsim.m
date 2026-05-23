clc;
clear;
close all;


% Use OpenGL renderer
set(gcf,'Renderer','opengl');

%% Figure Window
figure('Color','black');

axis equal;
hold on;
grid off;

xlim([-80 80]);
ylim([-80 80]);
zlim([-80 80]);

view(3);

xlabel('X');
ylabel('Y');
zlabel('Z');

set(gca,'Color','black');
set(gca,'XColor','white');
set(gca,'YColor','white');
set(gca,'ZColor','white');

%% Lighting
lighting gouraud;
camlight headlight;
material dull;

%%
% STAR BACKGROUND

numStars = 1000;

starX = (rand(1,numStars)-0.5)*200;
starY = (rand(1,numStars)-0.5)*200;
starZ = (rand(1,numStars)-0.5)*200;

scatter3(starX,starY,starZ, ...
    5,'white','filled');

%%
% SUN

[Xs,Ys,Zs] = sphere(100);

sunRadius = 10;

surf( sunRadius*Xs,...
      sunRadius*Ys,...
      sunRadius*Zs,...
      'FaceColor','yellow',...
      'EdgeColor','none');

%%
% PHYSICS CONSTANTS

G = 1;
M = 500;

dt = 0.01;

%%
% PLANET INITIAL CONDITIONS

x = 20;
y = 0;
z = 5;

% Circular orbit speed approx:
% v = sqrt(G*M/r)

vx = 0;
vy = 4.8;
vz = 0.5;

%%
% PLANET SPHERE

[Xp,Yp,Zp] = sphere(40);

planetRadius = 2;

planet = surf( ...
    planetRadius*Xp + x,...
    planetRadius*Yp + y,...
    planetRadius*Zp + z,...
    'FaceColor','red',...
    'EdgeColor','none');

%%
% ORBIT TRAIL

xTrail = [];
yTrail = [];
zTrail = [];

trailPlot = plot3( ...
    0,0,0,...
    'Color',[0 1 1],...
    'LineWidth',2);

%%
% MAIN SIMULATION LOOP

for k = 1:50000

    %% Distance from Sun
    
    r = sqrt(x^2 + y^2 + z^2);

    %% Gravity Acceleration
    
    ax = -G*M*x/r^3;
    ay = -G*M*y/r^3;
    az = -G*M*z/r^3;

    %% Update Velocity
    
    vx = vx + ax*dt;
    vy = vy + ay*dt;
    vz = vz + az*dt;

    %% Update Position
    
    x = x + vx*dt;
    y = y + vy*dt;
    z = z + vz*dt;

    %% Move Planet
    
    set(planet,...
        'XData', planetRadius*Xp + x,...
        'YData', planetRadius*Yp + y,...
        'ZData', planetRadius*Zp + z);

    %% Store Trail Points
    
    xTrail(end+1) = x;
    yTrail(end+1) = y;
    zTrail(end+1) = z;

    %% Optional Trail Length Limit
    
    maxTrail = 2000;

    if length(xTrail) > maxTrail
        
        xTrail(1) = [];
        yTrail(1) = [];
        zTrail(1) = [];
        
    end

    %% Update Trail
    
    set(trailPlot,...
        'XData',xTrail,...
        'YData',yTrail,...
        'ZData',zTrail);

    %% Rotate Camera
    
    camorbit(0.08,0,'camera');

    %% Render Frame
    
    drawnow limitrate

end
