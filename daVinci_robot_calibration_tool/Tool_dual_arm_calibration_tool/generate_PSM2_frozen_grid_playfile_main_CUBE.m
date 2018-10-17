% RN@HMS Prince of Wales
% 07/05/18

%% THERE ARE 2 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME TO GENREATE A NEW CUBE TRAJECTORY FOR PMS2.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%% 
% Change these initial values
% centre of the 7x7 cube

% % % % If you want to use the same centre as PSM1's, input the tf info

% affine_psm2_wrt_psm1 = [
%     0.6671    0.7449    0.0112   -0.1679
%    -0.7450    0.6670    0.0125    0.0925
%     0.0019   -0.0167    0.9999    0.0058
%          0         0         0    1.0000
% ];
% 
% psm1_centre_x = -0.12;
% psm1_centre_y = 0.12;
% psm1_centre_z = -0.12;
% 
% psm1_pt = [psm1_centre_x;psm1_centre_y;psm1_centre_z;1];
% psm2_pt = inv(affine_psm2_wrt_psm1)*psm1_pt;


% @ UPDATE CHECKPOINT 1/2
centre_x = -0.0187724840732;
centre_y =  0.0733559310573;
centre_z = -0.104543657857;

% @ UPDATE CHECKPOINT 2/2
data_seq = '03';

t = datetime('now');
formatOut = 'yyyymmdd';
DateString = datestr(t,formatOut);

fileDir = 'Data/';
folderName = strcat(DateString, '_', data_seq);

mkdir(strcat(fileDir, folderName));

% @ OPTIONAL UPDATE CHECKPOINT 1/1
increment = 0.01;

psm_x = [1 0 0];

axis_vec = [centre_x centre_y centre_z];
cube_z = axis_vec/norm(axis_vec);
cube_x = cross(psm_x, cube_z)/norm(cross(psm_x, cube_z));
cube_y = cross(cube_z, cube_x)/norm(cross(cube_z, cube_x));

rot_cube_wrt_psm = transpose([cube_x; cube_y; cube_z]);

corner = [centre_x centre_y centre_z] - 4*increment*(cube_x + cube_y + cube_z);

time = 10;
count = 1;

for i = 0:6
    
   for j = 0:6
       
       for k = 0:6
           
          point = corner + i*increment*cube_x + j*increment*cube_y + k*increment*cube_z;

          disp( strcat('0, 0, -0.05, 0,1,0, 0, 0, -1, 0,', num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,', num2str(time)));
          disp( strcat('0, 0, -0.05, 0,1,0, 0, 0, -1, 0,', num2str(point(1)), ',  ', num2str(point(2)), ',  ' , num2str(point(3)), ',0,1,0, 0, 0, -1, -1,', num2str(time + 2))); 

          time = time + 4;

          psm2_pts_generated_cube(count,:) = [point(1) point(2) point(3)];
          count = count + 1;
      
       end
   end
    
end


save_file_name = strcat(fileDir, folderName, '/psm2_pts_generated_cube.mat');
save(save_file_name, 'psm2_pts_generated_cube');
