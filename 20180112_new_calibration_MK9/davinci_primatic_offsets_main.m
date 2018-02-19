% RN@HMS Queen Elizabeth
% 16/02/18
% Notes.
% 1. Remember to update data patha and G_N_Md each time you use this code.

clc
close all
clear all

%% Reference

% angle = atan2(norm(cross(a,b)), dot(a,b))

% Keys
% key_ = {'plane_1_param_1', 'plane_2_param_1', ...
%     'portal_rotation_wrt_polaris', ...
%     'sphere_param_1', ...
%     'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
%     'portal_origin_wrt_polaris', 'small_origins_vec', 'distance_to_portal_vec', ...
%     'actual_small_ori_increments', 'ave_actual_small_ori_increment', 'rms_Sphere_vec', 'rms_Small_Spheres_vec', ...
%     'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
%     'affine_portal_wrt_polaris', ...
%     'joint_1_param', 'joint_2_param',...
%     'small_origins_vec_wrt_portal',...
%     'small_sphere_origins_line_param_wrt_portal', 'small_sphere_origins_line_rms_wrt_porta'};

%% Update this everytime you do the test

% G_N_Md
affine_Md_wrt_polaris =[-0.9988502024073657, -0.03988837238448927, -0.02659306111151736, 0.1332499980926514;
 -0.03928800706476091, 0.9989693950997349, -0.02272883971849295, 0.02177999913692474;
 0.0274722705949814, -0.02165791778047834, -0.9993879171501775, -0.8265900015830994;
 0, 0, 0, 1];


% G_N_Mg
affine_Mg_wrt_polaris =[0.04603747211624454, -0.027710971422254, -0.9985552830083975, 0.1237900033593178;
 0.09141306052402291, 0.9955377928578698, -0.02341271785402627, -0.1216100007295609;
 0.9947483116481159, -0.09020313217685924, 0.04836518808716379, -1.1458899974823;
 0, 0, 0, 1];

% G_Mg_Md
affine_Md_wrt_Mg =[-0.04236681568176687, -0.9669071094799431, 0.251586356081024, 0.2926427609124402;
 -0.02407618297455795, -0.2507512786928744, -0.967752103406272, 0.07680221448903546;
 0.9988119894866915, -0.04705781413356479, -0.01265589928089181, 0.02613060270224771;
 0, 0, 0, 1];

% G_Mg_Mc
affine_Mc_wrt_Mg = [0.2952790233294461, 0.9554037217435692, -0.003745245004632872, 0.4231785780551462;
 -0.9486162120071466, 0.2927100689272258, -0.1202002407062117, 0.02008079125591733;
 -0.1137434864017322, 0.03904540980902808, 0.9927426027294405, 0.3860468782445587;
 0, 0, 0, 1];

% G_Mc_C
affine_cam_wrt_Mc =   [ -0.0377,    0.9992,    0.0157,   -0.0263;
    0.9635,    0.0406,   -0.2646,   -0.0004;
   -0.2650,    0.0052,   -0.9642,   -0.0809;
         0,         0,         0,   1.0000]

% G_C_D_l{i}
affine_board_0_0_wrt_l_cam= [0.9556381888033338, -0.1084893843511532, 0.273835179594937, 0.03766894387912491;
 0.08578523034745042, 0.9919069585826652, 0.09360277650541052, -0.02287606745939376;
 -0.2817739277415824, -0.06595937384780662, 0.9572109561881783, 0.290484589431916;
 0, 0, 0, 1];


%% Load and Process Data

% Update the path
csv_folder_1 = '20180219_offset_data_01/';

plot_flag = 1;

[path_map_1, pt_clds_map_1, pt_mats_map_1] = createGreenRawDataHashTablesShort(csv_folder_1, plot_flag);

[result_map_1] = createPostProcessingHashTablesShort(pt_clds_map_1, pt_mats_map_1, plot_flag);


%% Fitting Qulitiy Summary
disp('rms_Sphere_vec: ');[result_map_1('rms_Sphere_vec')]
disp('rms_Small_Spheres_vec: ');[result_map_1('rms_Small_Spheres_vec')]
disp('small_sphere_origins_line_rms: ');[result_map_1('small_sphere_origins_line_rms')]

%% Distance Portal Origin -> Small sphere orgin fitted line

small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
p0 = small_sphere_origins_line_param_1.p0;
direction = small_sphere_origins_line_param_1.direction;
dist_1 = fcn_line_pt_dist(p0, direction, result_map_1('portal_origin_wrt_polaris'));

dist_portal_s_sphere_ori_line = [dist_1];

disp('transpose(small_sphere_origins_line_param_1.direction):');
[transpose(small_sphere_origins_line_param_1.direction)]

%% Offset

% function [dist] = lines_dist(a, b, c, d)

result_map_1('portal_rotation_wrt_polaris');

portal_1 = result_map_1('portal_origin_wrt_polaris');
portal_1 = transpose(portal_1);
rot_mat_1 = result_map_1('portal_rotation_wrt_polaris');
x_vec_1 = rot_mat_1(:,1);
y_vec_1 = rot_mat_1(:,2);
small_sphere_origins_line_param_1 = result_map_1('small_sphere_origins_line_param');
small_sphere_line_vec_1 = small_sphere_origins_line_param_1.direction;
small_sphere_pt_1 = small_sphere_origins_line_param_1.p0;
small_sphere_pt_1 =  transpose(small_sphere_pt_1);

dist_x_1 = lines_dist(portal_1, x_vec_1, small_sphere_pt_1, small_sphere_line_vec_1);
dist_y_1 = lines_dist(portal_1, y_vec_1, small_sphere_pt_1, small_sphere_line_vec_1);

small_sphere_origins_line_wrt_poratl_param_1 = result_map_1('small_sphere_origins_line_param_wrt_portal');
small_sphere_line_vec_1 = small_sphere_origins_line_wrt_poratl_param_1.direction;
portal_z = [0; 0; 1]
small_spheres_vec_portal_z_angle = atan2(norm(cross(small_sphere_line_vec_1,portal_z)), dot(small_sphere_line_vec_1,portal_z));

if small_spheres_vec_portal_z_angle > pi/2
    small_spheres_vec_portal_z_angle = pi - small_spheres_vec_portal_z_angle;
end

%%%%%%%%%
disp('dist_portal_s_sphere_ori_line:');
dist = [dist_1];
sprintf('%f', dist)

disp('dist_x_1:');
dist_x = [dist_x_1]; 
sprintf('%f', dist_x)

disp('dist_y_1:');
dist_y = [dist_y_1];
sprintf('%f', dist_y_1)

small_spheres_vec_portal_z_angle
disp('small_spheres_vec_portal_z_angle in degrees:');
sprintf('%f', rad2deg(small_spheres_vec_portal_z_angle))

%% Prismatic/DH2 Frame Rotation Mat (TODO: put into fnc.)

z_temp = small_sphere_line_vec_1/norm(small_sphere_line_vec_1);
dh1_z = [-1; 0; 0]; % is portal -x direction
x_temp = cross(dh1_z,z_temp);
x_temp = x_temp/norm(x_temp);

y_temp = cross(z_temp, x_temp);
DH2_frame_rot_mat_wrt_portal = [(x_temp) (y_temp) (z_temp)];


%% Joint 1 & 2 Circles

% temp_1 = result_map_1('joint_1_param');
% j1_vec = temp_1.vector();
% j1_pt = temp_1.circle(1:3)
% 
% temp_2 = result_map_1('joint_2_param');
% j2_vec = temp_2.vector();
% j2_pt = temp_2.circle(1:3);
% 
% dist_j1_2 = lines_dist(j1_pt, j1_vec, j2_pt, j2_vec)
% 
% angle_j1_2 = atan2(norm(cross(j1_vec, j2_vec)), dot(j1_vec, j2_vec))



%% Generate DH2 param adjustment recommendation

temp_ = result_map_1('small_sphere_origins_line_param_wrt_portal');
DH_d2 = - dist_y_1
DH_theta2 = 0.5*pi - (temp_.direction(2))
DH_a2 = dist_x_1
DH_alpha2 = 0.5*pi -abs(temp_.direction(1))



%% Generate Test Trajectory based on Portal Calibration

output_folder_path = 'test_output/';
affine_portal_wrt_polaris = result_map_1('affine_portal_wrt_polaris');
generateTestTrajectory(output_folder_path, affine_Md_wrt_polaris, affine_portal_wrt_polaris);

affine_Md_wrt_board_0_0 =  [0, -1,  0,    -0.08;
                        0,  0,  1,        0;
                       -1,  0,  0, -0.00877;
                        0,  0,  0,     1];


% This should be const once calibratied no matter how you move the Mg
% later on, meaning you should NOT update the affine_Mg_wrt_polaris!
affine_Mg_wrt_portal = inv(affine_portal_wrt_polaris)*affine_Mg_wrt_polaris; % Mg is Marker on Green base

% G_Pg_Md:
affine_Md_wrt_portal_via_base = affine_Mg_wrt_portal * affine_Md_wrt_Mg * inv(affine_Md_wrt_board_0_0)

goal = affine_Mg_wrt_portal*affine_Mc_wrt_Mg*affine_cam_wrt_Mc*affine_board_0_0_wrt_l_cam*[0;0;0;1]
