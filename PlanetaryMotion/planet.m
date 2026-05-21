clc;
clear;
close all;

% Constants
G = 1;
M = 100;
dt = 0.01;

% Initial position
x = 10;
y = 0;
z = 5;

% Initial velocity
vx = 0;
vy = 3.2;
vz = 1;

figure('Color','black');

axis equal;
grid on;
hold on;

xlabel('X');
ylabel('Y');
zlabel('Z');

xlim([-20 20]);
ylim([-20 20]);
zlim([-20 20]);

view(3);

% Star
plot3(0,0,0,'yo', ...
    'MarkerSize',30, ...
    'MarkerFaceColor','y');

% Planet
planet1 = plot3(x,y,z,'bo', ...
    'MarkerSize',10, ...
    'MarkerFaceColor','r');

% Trail
trail = animatedline( ...
    'Color','cyan', ...
    'LineWidth',1.5);

for k = 1:20000

    % Distance
    r = sqrt(x^2 + y^2 + z^2);

    % Gravity acceleration
    ax = -G*M*x/r^3;
    ay = -G*M*y/r^3;
    az = -G*M*z/r^3;

    % Velocity update
    vx = vx + ax*dt;
    vy = vy + ay*dt;
    vz = vz + az*dt;

    % Position update
    x = x + vx*dt;
    y = y + vy*dt;
    z = z + vz*dt;

    % Update animation
    set(planet1,'XData',x);
    set(planet1,'YData',y);
    set(planet1,'ZData',z);

    addpoints(trail,x,y,z);

    drawnow;
    view(k/50,30);
end
