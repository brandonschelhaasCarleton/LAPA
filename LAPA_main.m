set(0, 'DefaultFigureWindowStyle', 'Docked')

clc
clear
close all

% ELEC 4700 - PA4: Laplace
% Brandon Schelhaas
% 101036851

% Initialize Variables
% Greater number = better precision (larger mesh)
cols = 100; % columns
rows = 100; % rows
V = zeros(rows, cols);
numSteps = 5000; % Increase to get better solution

% Boundary Conditions:
% Left = 1V, Right = 0 V
% Top/Bottom = free/insulating
V(:,1) = 1; % left side = 1
V(:,cols) = 0; % right side = 0

% Top and bottom are free nodes (insulating)
figure
for i = 1:numSteps
    for r = 2:(rows-1) % leave top and bottom row for later to force BC derivative
        for c = 2:(cols-1) % left and right boundaries already set
            V(r, c) = ( V(r+1, c) + V(r-1,c) + V(r,c+1) + V(r,c-1) ) / 4;
        end
    end
    
    % Boundary Conditions for Free Nodes
    V(1, 2:(cols-1)) = V(2, 2:(cols-1)); % set top row equal to second row (derivative = 0)
    V(rows, 2:(cols-1)) = V((rows-1), 2:(cols-1)); % set bottom row equal to second last row (deriv = 0)
    
    % Plot every 50 steps
    if(mod(i,50)==0)
        surf(V')
        title('Voltage FDM (Insulating Nodes)')
        xlabel('rows'); ylabel('column'); zlabel('Voltage [V]');
        pause(0.001)
    end
end

% Calculate E field as -gradient of voltage (-ve in plot)
[Ex, Ey] = gradient(V);

% Plot E field as vectors
figure
quiver(-Ex, -Ey)
title('E-field in solution (Insulating Nodes)');

% Use image filtering function on voltage, and plot
filt = imboxfilt(V,3);
figure
surf(filt);
title('Image Filtered Voltage (Insulating Nodes)');
xlabel('rows'); ylabel('column'); zlabel('Voltage [V]');

% New BC's: (Part 2vi.)
% Left/Right = 1V
% Top/Bottom = 0V
V(:,1) = 1; % left side = 1
V(:,cols) = 1; % right side = 1
V(1,:) = 0; % top = 0
V(rows,:) = 0; % Bottom = 0

% Solve and plot new solution with new BC's
figure
for i = 1:numSteps
    for r = 2:(rows-1) % leave top and bottom row for later to force BC derivative
        for c = 2:(cols-1) % left and right boundaries already set
            V(r, c) = ( V(r+1, c) + V(r-1,c) + V(r,c+1) + V(r,c-1) ) / 4;
        end
    end
    
    if(mod(i,50)==0)
        surf(V')
        title('Voltage FDM (All BC''s fixed)')
        xlabel('rows'); ylabel('column'); zlabel('Voltage [V]');
        pause(0.001)
    end   
end

% Calculate E field as -gradient of voltage (-ve in plot)
[Ex, Ey] = gradient(V);

% Plot E field as vectors
figure
quiver(-Ex, -Ey, 10)
title('E-field in solution (All BC''s fixed)');

% Use image filtering function on voltage, and plot
filt = imboxfilt(V,3);
figure
surf(filt);
title('Image Filtered Voltage (All BC''s fixed)');
xlabel('rows'); ylabel('column'); zlabel('Voltage [V]');