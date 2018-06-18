% RN@HMS Queen Elizabeh
% 21/05/18

% Generate points in a sphere region of PSM1 frame, then convert the points to
% PSM2 frame. 

%%
clc
close all
clear all

%% FILL IN THE TF INFO HERE
% Update every time if added mannually
affine_psm2_wrt_psm1 = [
   -0.1888    0.6128   -0.7674   -0.1769
   -0.5612    0.5740    0.5964    0.0625
    0.8059    0.5432    0.2355   -0.0981
         0         0         0    1.0000
];

% Or load it from the global variable (generated bt dual_PSMs_match_CUBE.m)
load('affine_psm2_wrt_psm1.mat')

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

centre = [ -0.0760062 0.0248539 -0.184708];

psm2_pts_offset_in_psm1 = [-0.002 0 0]; % 2 mm apart

psm1_pts_prepose_offset_in_psm1 = [0.005 0 0];
psm2_pts_prepose_offset_in_psm2 = [-0.005 0 0];

% Use the following as actual trajectory
rng(0,'twister')
rvals = 2*rand(20,1)-1;
elevation = asin(rvals);
azimuth = 2*pi*rand(20,1);
radii = 0.05*(rand(20,1).^(1/3));
[x,y,z] = sph2cart(azimuth,elevation,radii);
psm1_pts = [x,y,z];
psm1_pts = psm1_pts + repmat(centre, 20 ,1);

psm1_pts_plus_offset = psm1_pts + repmat(psm2_pts_offset_in_psm1, 20 ,1); 

psm1_pts_plus_psm1_prepose_offset = psm1_pts + repmat(psm1_pts_prepose_offset_in_psm1, 20 ,1); 

figure
plot3(x,y,z,'.')
axis equal

for i = 1:20
    
   psm1_pt(1,1:3) =  psm1_pts(i,:);
   psm1_pt(1,4) = 1;
      

   %%%% 
   
   psm1_pt_plus_offset = psm1_pts_plus_offset(i,:);
   psm1_pt_plus_offset(1,4) = 1;
   
   psm2_pt = affine_psm1_wrt_psm2 * transpose(psm1_pt_plus_offset);
   psm2_pt = psm2_pt';
   psm2_pts(i,:) = psm2_pt(1,1:3);
   
   psm2_pt_plus_pms2_prepose_offset = psm2_pt(:,1:3) + psm2_pts_prepose_offset_in_psm2;
   psm2_pts_plus_pms2_prepose_offset (i,:) = psm2_pt_plus_pms2_prepose_offset;
    
end


%% Printing on Screen
time = 10;
count = 1;
for i = 1:20
     % prepose
     disp(strcat(num2str(psm1_pts_plus_psm1_prepose_offset(i,1)), ',  ',num2str(psm1_pts_plus_psm1_prepose_offset(i,2)), ',  ' ,num2str(psm1_pts_plus_psm1_prepose_offset(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         num2str(psm2_pts_plus_pms2_prepose_offset(i,1)) ,', ', num2str(psm2_pts_plus_pms2_prepose_offset(i,2)), ', ', num2str(psm2_pts_plus_pms2_prepose_offset(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time)));    
       
     % target
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 4)));    
     disp(strcat(num2str(psm1_pts(i,1)), ',  ',num2str(psm1_pts(i,2)), ',  ' ,num2str(psm1_pts(i,3)), ',0,1,0, 0, 0, -1, -1,', ...
         num2str(psm2_pts(i,1)) ,', ', num2str(psm2_pts(i,2)), ', ', num2str(psm2_pts(i,3)), ', 0,1,0,   0,0,-1,  0,',   num2str(time + 8)));     
     
     
     time = time + 12;

%      pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
     count = count + 1;
    
    
end
