% RN@HMS Queen Elizabeth 
% 18/06/18

%% NOTE.
% A better way to illustrate the effect of the offset --
% Simulated_j1_and_j2_offset_effect_main.m

%%
clc
close all
clear all

%% Generate a standard half sphere
n_step = 50;

r_sphere = 0.2388;
j1_j2_dist = 0.034;

pt_mat = [0 0 0];
phi_0 = -pi/2.4;
phi_t = pi/2.4;
delta_angle = (phi_t - phi_0)/n_step;

n_row = 1;

for j = 0:(n_step-1) % represent da Vinci J2
    
    phi_j2 = phi_0 + j*delta_angle;
    r_circle = cos(phi_j2)*r_sphere;
    
    y = sin(phi_j2)*r_sphere;
    
    for i = 0:(n_step-1) % represent da Vinci J1
        
        phi_j1 = phi_0 + i*delta_angle;

        x = r_circle*sin(phi_j1);
        z = -r_circle*cos(phi_j1);

        pt_mat(n_row,:) = [x y z];
        n_row = n_row + 1;

    end
    
end

n_row = n_row - 1; % one step back to reflect the size of pt_mat

% Try to fit a sphere
[sphere_param_1, residuals_1] = davinci_sphere_fit_least_square(pt_mat);
rms_Sphere01 = calculate_sphere_rms(pt_mat, sphere_param_1(1:3), sphere_param_1(4));

% Reference frame auxiliary
t3 = (-5:10)/200;
x_axis_x = t3; x_axis_y = 0*t3; x_axis_z = 0*t3;
y_axis_x = 0*t3; y_axis_y = t3; y_axis_z = 0*t3;
z_axis_x = 0*t3; z_axis_y = 0*t3; z_axis_z = t3;

        figure('Name', 'Original Sphere');
        scatter3(pt_mat(:,1), pt_mat(:,2), pt_mat(:,3));
        hold on;
        [x y z] = sphere;
        a = [sphere_param_1(1), sphere_param_1(2), sphere_param_1(3),  sphere_param_1(4)];
        s1=surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
        scatter3(sphere_param_1(1), sphere_param_1(2), sphere_param_1(3), 'filled');
        plot3(x_axis_x,x_axis_y,x_axis_z);
        plot3(y_axis_x,y_axis_y,y_axis_z);
        plot3(z_axis_x,z_axis_y,z_axis_z);
        hold off;
        axis equal;


%% Squeeze the sphere along x and y axes

ratio =  1 - j1_j2_dist/r_sphere;

sacle = [ratio ratio 1];
scaling_mat = repmat(sacle, n_row, 1);
pt_mat_2 = pt_mat .* scaling_mat;

        figure('Name', 'Squeezed Sphere/Ellipsoid & Original Sphere');
        scatter3(pt_mat_2(:,1), pt_mat_2(:,2), pt_mat_2(:,3),'.');
        hold on;
        scatter3(pt_mat(:,1), pt_mat(:,2), pt_mat(:,3),'.');
        hold off;
        axis equal;

% Try to fit a sphere
[sphere_param_2, residuals_2] = davinci_sphere_fit_least_square(pt_mat_2);
rms_Sphere02 = calculate_sphere_rms(pt_mat_2, sphere_param_2(1:3), sphere_param_2(4));


        figure('Name', 'Ellipsoid & its fitted sphere');
        scatter3(pt_mat_2(:,1), pt_mat_2(:,2), pt_mat_2(:,3),'.');
        hold on;
        [x y z] = sphere;
        a = [sphere_param_2(1), sphere_param_2(2), sphere_param_2(3),  sphere_param_2(4)];
        s1=surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
        scatter3(sphere_param_2(1), sphere_param_2(2), sphere_param_2(3), 'filled');
        plot3(x_axis_x,x_axis_y,x_axis_z);
        plot3(y_axis_x,y_axis_y,y_axis_z);
        plot3(z_axis_x,z_axis_y,z_axis_z);
        axis equal;
        
contribution = (sphere_param_2(3)/r_sphere)/(1-ratio)

