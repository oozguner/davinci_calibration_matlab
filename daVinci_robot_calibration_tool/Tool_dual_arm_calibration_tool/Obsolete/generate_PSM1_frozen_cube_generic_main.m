% RN@HMS Queen Elizabeth
% 01/08/18
% Descriptions.
% 
% Notes.
%

%% THERE ARE 6 UPDATE POINTS THAT YOU NEED TO CHECK EVERYTIME YOU RUN THIS PROGRAMME TO GENREATE A NEW CUBE TRAJECTORY FOR PMS1.
% Search for 'checkpoint' to locate them. 
%%
clc
close all
clear all

%% Main Programme
% Change these initial values
% centre of the cube

% @ UPDATE CHECKPOINT 1/6
centre_x = -0.00302805656706;
centre_y = 0.0417731450507;
centre_z = -0.13409265241;

% @ UPDATE CHECKPOINT 2/6
data_seq = '01';

t = datetime('now');
formatOut = 'yyyymmdd';
DateString = datestr(t,formatOut);

fileDir = 'Data/';
folderName = strcat(DateString, '_generic_', data_seq);

mkdir(strcat(fileDir, folderName));

% @ UPDATE CHECKPOINT 3/6 
travel_speed = 0.06; % m/sec

% @ UPDATE CHECKPOINT 4/6 
vertex_dist = 0.03; % m

% @ UPDATE CHECKPOINT 5/6 
cube_dimension = 3; % cube_dimension^3 points in total

travel_time = vertex_dist/travel_speed; % From one point to another

% @ UPDATE CHECKPOINT 6/6 
still_time = 5;

% @ *OPTIONAL* UPDATE CHECKPOINT 1/1
custom_file_affix = "spd_006";

% ---

increment = vertex_dist;

psm_x = [1 0 0];

axis_vec = [centre_x centre_y centre_z];
cube_z = axis_vec/norm(axis_vec);
cube_x = cross(psm_x, cube_z)/norm(cross(psm_x, cube_z));
cube_y = cross(cube_z, cube_x)/norm(cross(cube_z, cube_x));

rot_cube_wrt_psm = transpose([cube_x; cube_y; cube_z]);

corner = [centre_x centre_y centre_z] - (fix(cube_dimension/2)+1)*increment*(cube_x + cube_y + cube_z); % Because it is 7x7 the centre is #4. 

time = 10;

count = 1;
k_cycle_count = 0;
j_cycle_count = 0;
playfile_row_count = 1;
for i = 0:(cube_dimension-1) 

        point_i = corner + i*increment*cube_x;

   for j = 0:(cube_dimension-1)
       
        if mod(j_cycle_count,2) == 0 % j = 0, 2, 4,...
            point_ij = point_i + j*increment*cube_y;
        else
            point_ij = point_i + ((cube_dimension-1)-j)*increment*cube_y;
        end       
       
       
       for k = 0:(cube_dimension-1)

            if mod(k_cycle_count,2) == 0 % j = 0, 2, 4,...
                point_ijk = point_ij + k*increment*cube_z;
            else
                point_ijk = point_ij + ((cube_dimension-1)-k)*increment*cube_z;
            end             
                      
            playfile_mat(playfile_row_count,:) = ...
                [point_ijk(1), point_ijk(2), point_ijk(3), 0,1,0, 0, 0, -1, -1,  0, 0, -0.05, 0,1,0, 0, 0, -1, 0, time];
            playfile_row_count = playfile_row_count + 1;
            
            playfile_mat(playfile_row_count,:) = ...
                [point_ijk(1), point_ijk(2), point_ijk(3), 0,1,0, 0, 0, -1, -1,  0, 0, -0.05, 0,1,0, 0, 0, -1, 0, time + still_time];
            playfile_row_count = playfile_row_count + 1;
            
%             disp( strcat(num2str(point_ijk(1)), ',  ', num2str(point_ijk(2)), ',  ' , num2str(point_ijk(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
%             disp( strcat(num2str(point_ijk(1)), ',  ', num2str(point_ijk(2)), ',  ' , num2str(point_ijk(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + still_time))); 

            time = time + still_time + travel_time;
            psm1_pts_generated_cube(count,:) = [point_ijk(1) point_ijk(2) point_ijk(3)];
            count = count + 1;
      
       end
       
       k_cycle_count = k_cycle_count + 1;
              
   end
   
   j_cycle_count = j_cycle_count + 1;
    
end

% Now do the reverse
count = 1;
k_cycle_count = 0;
j_cycle_count = 0;
for i = (cube_dimension-1):-1:0

        point_i = corner + i*increment*cube_x;

   for j = (cube_dimension-1):-1:0
       
        if mod(j_cycle_count,2) == 0 % j = 0, 2, 4,...
            point_ij = point_i + j*increment*cube_y;
        else
            point_ij = point_i + ((cube_dimension-1)-j)*increment*cube_y;
        end       
       
       
       for k = (cube_dimension-1):-1:0

            if mod(k_cycle_count,2) == 0 % j = 0, 2, 4,...
                point_ijk = point_ij + k*increment*cube_z;
            else
                point_ijk = point_ij + ((cube_dimension-1)-k)*increment*cube_z;
            end             
                      

            disp( strcat(num2str(point_ijk(1)), ',  ', num2str(point_ijk(2)), ',  ' , num2str(point_ijk(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
            disp( strcat(num2str(point_ijk(1)), ',  ', num2str(point_ijk(2)), ',  ' , num2str(point_ijk(3)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.05, 0,1,0, 0, 0, -1, 0,',   num2str(time + still_time))); 

            time = time + still_time + travel_time;
            psm1_pts_generated_cube_2(count,:) = [point_ijk(1) point_ijk(2) point_ijk(3)];
            count = count + 1;
      
       end
       
       k_cycle_count = k_cycle_count + 1;
              
   end
   
   j_cycle_count = j_cycle_count + 1;
    
end

save_file_name = strcat(fileDir, folderName, '/psm1_pts_generated_cube.mat');
save(save_file_name, 'psm1_pts_generated_cube');
playfile_name = strcat(fileDir, folderName, '/psm1_pts_generated_cube','_',custom_file_affix,'.psp');
csvwrite(playfile_name,playfile_mat);