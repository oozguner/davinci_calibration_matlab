% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
% 1. 'Big sphere' has been removed from Mark X.



function [path_map, pt_clds_map, pt_mats_map] = createRawDataHashTables(csv_folder, plot_flag)

%% Keys 
% Keys are shared by all 3 maps.

key_ = {'J1Arc01', 'J2Arc01', ...
    'SmallSphere01', 'SmallSphere02', 'SmallSphere03', 'SmallSphere04', ...
    'all'};



%% Set Path Map Values and Load csv data

% Use try catch statement to deal with 2 possible sets of names. 
try
    
    path_val_ = {...
        strcat(csv_folder, '03_green_j1_arc_01.csv'), ...
        strcat(csv_folder, '04_green_j2_arc_01.csv'), ...
        strcat(csv_folder, '05_green_small_sphere_5cm.csv'), ...
        strcat(csv_folder, '06_green_small_sphere_11cm.csv'), ...
        strcat(csv_folder, '07_green_small_sphere_17cm.csv'), ...
        strcat(csv_folder, '08_green_small_sphere_23cm.csv'), ...
    ''};

    path_map_ = containers.Map(key_, path_val_);
    path_map = path_map_;  

    [pt_cld_J1Arc01, pt_mat_J1Arc01] = loadCsvFileToPointCloudAndMat(path_map_('J1Arc01'));
    [pt_cld_J2Arc01, pt_mat_J2Arc01] = loadCsvFileToPointCloudAndMat(path_map_('J2Arc01'));

    [pt_cld_SmallSphere01, pt_mat_SmallSphere01] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere01'));
    [pt_cld_SmallSphere02, pt_mat_SmallSphere02] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere02'));
    [pt_cld_SmallSphere03, pt_mat_SmallSphere03] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere03'));
    [pt_cld_SmallSphere04, pt_mat_SmallSphere04] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere04'));

catch
    
    path_val_ = {...
        strcat(csv_folder, '03_yellow_j1_arc_01.csv'), ...
        strcat(csv_folder, '04_yellow_j2_arc_01.csv'), ...
        strcat(csv_folder, '05_yellow_small_sphere_5cm.csv'), ...
        strcat(csv_folder, '06_yellow_small_sphere_11cm.csv'), ...
        strcat(csv_folder, '07_yellow_small_sphere_17cm.csv'), ...
        strcat(csv_folder, '08_yellow_small_sphere_23cm.csv'), ...
    ''};

    path_map_ = containers.Map(key_, path_val_);
    path_map = path_map_;

    [pt_cld_J1Arc01, pt_mat_J1Arc01] = loadCsvFileToPointCloudAndMat(path_map_('J1Arc01'));
    [pt_cld_J2Arc01, pt_mat_J2Arc01] = loadCsvFileToPointCloudAndMat(path_map_('J2Arc01'));

    [pt_cld_SmallSphere01, pt_mat_SmallSphere01] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere01'));
    [pt_cld_SmallSphere02, pt_mat_SmallSphere02] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere02'));
    [pt_cld_SmallSphere03, pt_mat_SmallSphere03] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere03'));
    [pt_cld_SmallSphere04, pt_mat_SmallSphere04] = loadCsvFileToPointCloudAndMat(path_map_('SmallSphere04'));

end


%% Point Cloud Map and Point Matrix Map 

all_Pts_Mat_ = [...
    pt_mat_J1Arc01;
    pt_mat_J2Arc01;
    pt_mat_SmallSphere01;
    pt_mat_SmallSphere02;
    pt_mat_SmallSphere03;
    pt_mat_SmallSphere04
    ];


all_Pt_Clouds_ = pointCloud([all_Pts_Mat_(:,1), all_Pts_Mat_(:,2), all_Pts_Mat_(:,3)]);

pt_clds_val_ = {pt_cld_J1Arc01, pt_cld_J2Arc01, ...
    pt_cld_SmallSphere01, pt_cld_SmallSphere02, pt_cld_SmallSphere03, pt_cld_SmallSphere04, ...
    all_Pt_Clouds_};

pt_mats_val_ = {pt_mat_J1Arc01, pt_mat_J2Arc01, ...
    pt_mat_SmallSphere01, pt_mat_SmallSphere02, pt_mat_SmallSphere03, pt_mat_SmallSphere04, ...
    all_Pts_Mat_};

pt_clds_map_ = containers.Map(key_, pt_clds_val_);
pt_mats_map_ = containers.Map(key_, pt_mats_val_);


%% Plotting

if plot_flag == 1
   figure('Name', 'Raw_data_total_point_clouds');
   pcshow(all_Pt_Clouds_);
   hold off;  
   savefig(strcat(csv_folder, 'Raw_data_total_point_clouds.fig'));
end

%% Return

pt_clds_map = pt_clds_map_;
pt_mats_map = pt_mats_map_;



end