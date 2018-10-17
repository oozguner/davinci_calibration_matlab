% RN@HMS Prince of Wales
% 07/05/18

% Generate points in a sphere region of PSM1 frame, then convert the points to
% PSM2 frame. 

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%% FILL IN THE TF INFO HERE
% Update every time if added mannually

% affine_psm2_wrt_psm1 = [
%    -0.1888    0.6128   -0.7674   -0.1769
%    -0.5612    0.5740    0.5964    0.0625
%     0.8059    0.5432    0.2355   -0.0981
%          0         0         0    1.0000
% ];

% Or load it from the global variable (generated bt dual_PSMs_match_CUBE.m)
% @ UPDATE CHECKPOINT 1/2
data_folder = 'Data/20180626_02/';

load(strcat(data_folder,'affine_psm2_wrt_psm1.mat'))

affine_psm1_wrt_psm2 = inv(affine_psm2_wrt_psm1);

%%
% Save this as a show case
rng(0,'twister')
rvals = 2*rand(1000,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(1000,1);
radii = 0.1*(rand(1000,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
figure
plot3(x,y,z,'.')
axis equal

%% PSM 1 sphere (range)
% centre_x =  -0.0760062;
% centre_y = 0.0248539;
% centre_z = -0.184708;

% @ UPDATE CHECKPOINT 2/2
centre = [ 0.00738685371377 0.107339708973 -0.122803405732];

% Use the following as actual trajectory
rng(0,'twister')
rvals = 2*rand(20,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(20,1);
radii = 0.05*(rand(20,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
psm1_pts = [x,y,z];
psm1_pts = psm1_pts + repmat(centre, 20 ,1);
figure
plot3(x,y,z,'.')
axis equal

for i = 1:20
    
   psm1_pt(1,1:3) =  psm1_pts(i,:);
   psm1_pt(1,4) = 1;
    
   psm2_pt = affine_psm1_wrt_psm2 * transpose(psm1_pt);
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3);
    
end

%% Printing on Screen
time = 10;
count = 1;
for i = 1:20
    
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         '0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + 4)));     
     time = time + 8;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end

disp('==================================================================');
disp('==================================================================');
disp('==================================================================');
%% Printing on Screen
time = 10;
count = 1;
for i = 1:20
    
     disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time)));
     disp(strcat('0,0,-0.05,     0,1,0,    0,0,-1,  -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 4)));     
     time = time + 8;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end

