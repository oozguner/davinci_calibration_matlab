% RN@HMS Queen Elizabeth
% 04/06/18

%%
clc
close all
clear all

%%
% fill in the blank
file_path = '20180604_forzen_data_01/green_frozen_with_adjustments.csv'
csv = csvread(file_path);

% check if they are correctly numbered.
seq = csv(:, 1);
% should make it represent this much seconds
seq = ((seq - seq(1)) / 1000000000); % nanosecond to second

for n = 1:size(seq,1)
    
    last_digit_found = 0;
    
%     Check which digit has the first non-zero value
    for i = 0:size(csv(n,:),2)-1
    
        j = size(csv(n,:),2)-i;
        
        if (csv(n,j) ~= 0) & (last_digit_found == 0)
           
            raw_pose_x(n,1) = csv(n, j-2);
            raw_pose_y(n,1) = csv(n, j-1);
            raw_pose_z(n,1) = csv(n, j);
            
            last_digit_found = 1;
            
        end
        
    end
    
end

raw_points = [seq, raw_pose_x, raw_pose_y, raw_pose_z];
raw_size = size(raw_points,1);

figure('Name','Polaris Points full');
axis equal;
% axis([-0.3 -0.05 -0.1 0.1  -0.8 -0.7]);
scatter3(raw_points(:,2), raw_points(:,3), raw_points(:,4), 'filled');
% axis([-0.1 -0.04 -0.28 -0.18 -0.8 -0.7])
hold off;

%% 
% fill in start time (second) Needs adjustment each time
time_0 = 12.5; % Use 12.5 for some reason... Not 10
time_t = time_0 + 0.5; % take 1 sec of samples equvilent of 20 pts
peroid = 4; % 2 + 2 seconds

% Size of data: from a cube of 5x5x5
length = 7;
n_pts = length*length*length; 

for i = 0:(n_pts-1)
    
   mask_begin = time_0 + i*peroid;
   mask_end = time_t + i*peroid;
   mask = (raw_points(:,1) > mask_begin & raw_points(:,1) < mask_end);
   
   pt_mat_0 = [seq(mask), raw_pose_x(mask), raw_pose_y(mask), raw_pose_z(mask)];
   pt_mat_0(isnan(pt_mat_0(:,2)),:)= [];
   
   pt_mat = [pt_mat_0(:,2), pt_mat_0(:,3), pt_mat_0(:,4)];
   
   x_ave = mean(pt_mat_0(:,2));
   y_ave = mean(pt_mat_0(:,3));
   z_ave = mean(pt_mat_0(:,4));
   
   psm1_pts_Polaris_cube(i+1,:) = [x_ave y_ave z_ave];
    
    
end

save('psm1_pts_Polaris_cube.mat', 'psm1_pts_Polaris_cube');



%% Visualise the points

figure('Name','Polaris Points');
axis equal;
scatter3(psm1_pts_Polaris_cube(:,1), psm1_pts_Polaris_cube(:,2), psm1_pts_Polaris_cube(:,3), 'filled');
axis equal;
hold off;
% 




% figure('Name', 'Distribution of plane fitting errors');
% histfit(rms);
% hold off;