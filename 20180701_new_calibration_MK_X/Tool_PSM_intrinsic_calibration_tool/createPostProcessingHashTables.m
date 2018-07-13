% RN@HMS Prince of Wales
% 12/07/18
% Descriptions.
% 
% Notes.
% 1. Joint 1 and 2 sphere fitting has been removed from Mark X due to the
% fact that there is an a offset between DH_0 and DH_1 frames.

function [result_map] = createPostProcessingHashTables(pt_clds_map, pt_mats_map, plot_flag, save_file_path)

%% Keys.

key_ = {...
    'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
    'small_sphere_origins_vec', 'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
    'affine_dh_0_wrt_polaris', 'affine_dh_1_wrt_polaris', 'affine_dh_2_wrt_polaris', ...
    'affine_base_wrt_polaris', ...
    'rms_Small_Spheres_vec' 

    }


%% Fitting.

    % Small spheres fitting
    [small_sphere_param_1, small_residuals_1] = fitSphereLeastSquare(pt_mats_map('SmallSphere01'));
    [small_sphere_param_2, small_residuals_2] = fitSphereLeastSquare(pt_mats_map('SmallSphere02'));
    [small_sphere_param_3, small_residuals_3] = fitSphereLeastSquare(pt_mats_map('SmallSphere03'));
    [small_sphere_param_4, small_residuals_4] = fitSphereLeastSquare(pt_mats_map('SmallSphere04'));

    small_origin_1 = small_sphere_param_1(:,1:3);
    small_origin_2 = small_sphere_param_2(:,1:3);
    small_origin_3 = small_sphere_param_3(:,1:3);
    small_origin_4 = small_sphere_param_4(:,1:3);

    small_sphere_origins_vec = [small_origin_1; small_origin_2; small_origin_3; small_origin_4];

    % Small sphere centres line fitting
    [small_sphere_origins_line_param, small_sphere_origins_line_rms] = fitLineSvd(small_sphere_origins_vec);



%% Define DH frames 0, 1 and 2.
% The recommendation of DH parameter adjustments will be put into a text
% file.

    [affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_base_wrt_polaris] = ...
        defineBaseFrameAndDhFrame0And1FromArcs(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'), save_file_path);

    [affine_dh_2_wrt_polaris] = ...
        defineDhFrame02FromSmallSpheres(affine_dh_1_wrt_polaris, small_sphere_origins_line_param, save_file_path);

    calculateDhD2OffsetAndPrismaticScalingFactor(small_sphere_origins_vec, affine_dh_2_wrt_polaris, save_file_path);
    
    
%% RMS

    rms_SmallSphere01 = calculateSphereRms(pt_mats_map('SmallSphere01'), small_sphere_param_1(1:3), small_sphere_param_1(4));
    rms_SmallSphere02 = calculateSphereRms(pt_mats_map('SmallSphere02'), small_sphere_param_2(1:3), small_sphere_param_2(4));
    rms_SmallSphere03 = calculateSphereRms(pt_mats_map('SmallSphere03'), small_sphere_param_3(1:3), small_sphere_param_3(4));
    rms_SmallSphere04 = calculateSphereRms(pt_mats_map('SmallSphere04'), small_sphere_param_4(1:3), small_sphere_param_4(4));

    rms_Small_Spheres_vec = [rms_SmallSphere01; rms_SmallSphere02; rms_SmallSphere03;
        rms_SmallSphere04];

%% Values



%% Figures


%% Output file

fileID = fopen( strcat(save_file_path,'DH_frames_info.txt'), 'wt' );
fprintf(fileID, 'DH FRAMES INFORMATION\n');
fprintf(fileID, '---\n');

fprintf(fileID, 'affine_base_wrt_polaris: \n');
fprintf(fileID, '%f %f %f %f \n', affine_base_wrt_polaris(1,1), affine_base_wrt_polaris(1,2), ...
    affine_base_wrt_polaris(1,3), affine_base_wrt_polaris(1,4) );
fprintf(fileID, '%f %f %f %f \n', affine_base_wrt_polaris(2,1), affine_base_wrt_polaris(2,2), ...
    affine_base_wrt_polaris(2,3), affine_base_wrt_polaris(2,4) );
fprintf(fileID, '%f %f %f %f \n', affine_base_wrt_polaris(3,1), affine_base_wrt_polaris(3,2), ...
    affine_base_wrt_polaris(3,3), affine_base_wrt_polaris(3,4) );
fprintf(fileID, '%f %f %f %f \n', affine_base_wrt_polaris(4,1), affine_base_wrt_polaris(4,2), ...
    affine_base_wrt_polaris(4,3), affine_base_wrt_polaris(4,4) );


fclose(fileID);




%% Values and Return

values_ = {...
    small_sphere_param_1, small_sphere_param_2, small_sphere_param_3, small_sphere_param_4, ...
    small_sphere_origins_vec, small_sphere_origins_line_param, small_sphere_origins_line_rms, ...
    affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_dh_2_wrt_polaris, ...
    affine_base_wrt_polaris, ...
    rms_Small_Spheres_vec 

    }

result_map = containers.Map(key_, values_);

end