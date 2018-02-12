% RN@HMS Prince of Wales
% 19/01/18
% Notes.
% This function is for GREEN arm (PSM1) only. 


function [path_map, pt_clds_map, pt_mats_map] = createGreenRawDataHashTables(csv_folder, plot_flag)
% global newMap

%% Shared Keys 
key_ = {'greenSphere01', 'greenJ1Arc01', 'greenJ2Arc01', ...
    'greenSphere02', 'greenJ1Arc02', 'greenJ2Arc02', ...
    'greenSphere03', 'greenJ1Arc03', 'greenJ2Arc03', ...
    'greenJ3Line', 'greenJ3Cylinder', ...
    'greenSmallSphere01', 'greenSmallSphere02', 'greenSmallSphere03', 'greenSmallSphere04', ...
    'greenSmallSphere05', 'greenSmallSphere06', 'greenSmallSphere07', 'greenSmallSphere08', 'greenSmallSphere09', 'all'};

%% Path Map Values
path_val_ = {strcat(csv_folder, '02_green_sphere_01.csv'), ...
    strcat(csv_folder, '03_green_j1_arc_01.csv'), ...
    strcat(csv_folder, '04_green_j2_arc_01.csv'), ...
    strcat(csv_folder, '06_green_sphere_02.csv'), ...
    strcat(csv_folder, '07_green_j1_arc_02.csv'), ...
    strcat(csv_folder, '08_green_j2_arc_02.csv'), ...
    strcat(csv_folder, '10_green_sphere_03.csv'), ...
    strcat(csv_folder, '11_green_j1_arc_03.csv'), ...
    strcat(csv_folder, '12_green_j2_arc_03.csv'), ...
    strcat(csv_folder, '13_green_j3_line.csv'), ...
    strcat(csv_folder, '14_green_j3_cylinder.csv'), ...
    strcat(csv_folder, '15_green_small_sphere_01.csv'), ...
    strcat(csv_folder, '16_green_small_sphere_02.csv'), ...
    strcat(csv_folder, '17_green_small_sphere_03.csv'), ...
    strcat(csv_folder, '18_green_small_sphere_04.csv'), ...
    strcat(csv_folder, '19_green_small_sphere_05.csv'), ...
    strcat(csv_folder, '20_green_small_sphere_06.csv'), ...
    strcat(csv_folder, '21_green_small_sphere_07.csv'), ...
    strcat(csv_folder, '22_green_small_sphere_08.csv'), ...
    strcat(csv_folder, '23_green_small_sphere_09.csv'), ''};

path_map_ = containers.Map(key_, path_val_);
path_map = path_map_;

%% Point Cloud Map and Point Matrix Map 

[pt_cld_greenSphere01, pt_mat_greenSphere01] = load_csv_data(path_map_('greenSphere01'));
[pt_cld_greenJ1Arc01, pt_mat_greenJ1Arc01] = load_csv_data(path_map_('greenJ1Arc01'));
[pt_cld_greenJ2Arc01, pt_mat_greenJ2Arc01] = load_csv_data(path_map_('greenJ2Arc01'));
[pt_cld_greenSphere02, pt_mat_greenSphere02] = load_csv_data(path_map_('greenSphere02'));
[pt_cld_greenJ1Arc02, pt_mat_greenJ1Arc02] = load_csv_data(path_map_('greenJ1Arc02'));
[pt_cld_greenJ2Arc02, pt_mat_greenJ2Arc02] = load_csv_data(path_map_('greenJ2Arc02'));
[pt_cld_greenSphere03, pt_mat_greenSphere03] = load_csv_data(path_map_('greenSphere03'));
[pt_cld_greenJ1Arc03, pt_mat_greenJ1Arc03] = load_csv_data(path_map_('greenJ1Arc03'));
[pt_cld_greenJ2Arc03, pt_mat_greenJ2Arc03] = load_csv_data(path_map_('greenJ2Arc03'));
[pt_cld_greenJ3Line, pt_mat_greenJ3Line] = load_csv_data(path_map_('greenJ3Line'));
[pt_cld_greenJ3Cylinder, pt_mat_greenJ3Cylinder] = load_csv_data(path_map_('greenJ3Cylinder'));
[pt_cld_greenSmallSphere01, pt_mat_greenSmallSphere01] = load_csv_data(path_map_('greenSmallSphere01'));
[pt_cld_greenSmallSphere02, pt_mat_greenSmallSphere02] = load_csv_data(path_map_('greenSmallSphere02'));
[pt_cld_greenSmallSphere03, pt_mat_greenSmallSphere03] = load_csv_data(path_map_('greenSmallSphere03'));
[pt_cld_greenSmallSphere04, pt_mat_greenSmallSphere04] = load_csv_data(path_map_('greenSmallSphere04'));
[pt_cld_greenSmallSphere05, pt_mat_greenSmallSphere05] = load_csv_data(path_map_('greenSmallSphere05'));
[pt_cld_greenSmallSphere06, pt_mat_greenSmallSphere06] = load_csv_data(path_map_('greenSmallSphere06'));
[pt_cld_greenSmallSphere07, pt_mat_greenSmallSphere07] = load_csv_data(path_map_('greenSmallSphere07'));
[pt_cld_greenSmallSphere08, pt_mat_greenSmallSphere08] = load_csv_data(path_map_('greenSmallSphere08'));
[pt_cld_greenSmallSphere09, pt_mat_greenSmallSphere09] = load_csv_data(path_map_('greenSmallSphere09'));

all_green_Pts_Mat_ = [pt_mat_greenSphere01;
    pt_mat_greenJ1Arc01;
    pt_mat_greenJ2Arc01;
    pt_mat_greenSphere02;
    pt_mat_greenJ2Arc02;
    pt_mat_greenJ1Arc02;
    pt_mat_greenSphere03;
    pt_mat_greenJ1Arc03;
    pt_mat_greenJ2Arc03;
    pt_mat_greenJ3Line;
    pt_mat_greenSmallSphere01;
    pt_mat_greenSmallSphere02;
    pt_mat_greenSmallSphere03;
    pt_mat_greenSmallSphere04;
    pt_mat_greenSmallSphere05;
    pt_mat_greenSmallSphere06;
    pt_mat_greenSmallSphere07;
    pt_mat_greenSmallSphere08;
    pt_mat_greenSmallSphere09];

all_green_Pt_Clouds_ = pointCloud([all_green_Pts_Mat_(:,1), all_green_Pts_Mat_(:,2), all_green_Pts_Mat_(:,3)]);

pt_clds_val_ = {pt_cld_greenSphere01, pt_cld_greenJ1Arc01, pt_cld_greenJ2Arc01, ...
    pt_cld_greenSphere02, pt_cld_greenJ1Arc02, pt_cld_greenJ2Arc02, ...
    pt_cld_greenSphere03, pt_cld_greenJ1Arc03, pt_cld_greenJ2Arc03, ...
    pt_cld_greenJ3Line, pt_cld_greenJ3Cylinder, ...
    pt_cld_greenSmallSphere01, pt_cld_greenSmallSphere02, pt_cld_greenSmallSphere03, pt_cld_greenSmallSphere04, ...
    pt_cld_greenSmallSphere05, pt_cld_greenSmallSphere06, pt_cld_greenSmallSphere07, pt_cld_greenSmallSphere08, ...
    pt_cld_greenSmallSphere09, all_green_Pt_Clouds_};

pt_mats_val_ = {pt_mat_greenSphere01, pt_mat_greenJ1Arc01, pt_mat_greenJ2Arc01, ...
    pt_mat_greenSphere02, pt_mat_greenJ1Arc02, pt_mat_greenJ2Arc02, ...
    pt_mat_greenSphere03, pt_mat_greenJ1Arc03, pt_mat_greenJ2Arc03, ...
    pt_mat_greenJ3Line, pt_mat_greenJ3Cylinder, ...
    pt_mat_greenSmallSphere01, pt_mat_greenSmallSphere02, pt_mat_greenSmallSphere03, pt_mat_greenSmallSphere04, ...
    pt_mat_greenSmallSphere05, pt_mat_greenSmallSphere06, pt_mat_greenSmallSphere07, pt_mat_greenSmallSphere08, ...
    pt_mat_greenSmallSphere09, all_green_Pts_Mat_};

pt_clds_map_ = containers.Map(key_, pt_clds_val_);
pt_mats_map_ = containers.Map(key_, pt_mats_val_);

%% Plotting
if plot_flag == 1
   figure('Name', 'CONFIG - All Point Clouds');
   pcshow(all_green_Pt_Clouds_);
   hold off;  
end


%% Return

pt_clds_map = pt_clds_map_;
pt_mats_map = pt_mats_map_;
end