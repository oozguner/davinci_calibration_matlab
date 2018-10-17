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

% To be added
% affine_dh_3_wrt_polaris
% affine_dh_4_wrt_polaris
% affine_dh_5_wrt_polaris


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
       

    
    if (small_sphere_origins_line_rms > 0.001)
        warning('Excessive small_sphere_origins_line_rms:%f',small_sphere_origins_line_rms);
    end



%% Define DH frames 0, 1 and 2.
% The recommendation of DH parameter adjustments will be put into a text
% file.

    virtual_flag = 0;

    [affine_dh_0_wrt_polaris, affine_dh_1_wrt_polaris, affine_base_wrt_polaris] = ...
        defineBaseFrameAndDhFrame0And1FromArcs(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'), save_file_path);

    [affine_dh_2_wrt_polaris] = ...
        defineDhFrame02FromSmallSpheres(affine_dh_1_wrt_polaris, small_sphere_origins_line_param, save_file_path, virtual_flag);

    % Get Joint 3 (prismatic) quliaty here. Joint 2's encoder quality test
    % is done in a standalone programme in the same package. 
    [d_3, j3_scale_factor] = calculateDhD2OffsetAndPrismaticScalingFactor(small_sphere_origins_vec, affine_dh_2_wrt_polaris, save_file_path);
    
    
    % This is related to the shaft rotation. affine_dh_03_wrt_polaris
    % shares the same rotation matrix of affine_dh_02_wrt_polaris, but the
    % translation is different due to the dh param of d3. 
    [affine_dh_03_wrt_polaris] = defineDhFrame03FromDhFrame02(affine_dh_2_wrt_polaris, save_file_path);
    
    % Corresponding the the playfile (14 cm)
    j3_offset = 0.14;
    
    [affine_dh_04_wrt_polaris, affine_dh_05_wrt_polaris] = ... 
        defineDhFrame04And05FromArcsWithJ3Offset(pt_mats_map('J5Arc01'), pt_mats_map('J6Arc01'), ...
        affine_dh_03_wrt_polaris, j3_offset, d_3, j3_scale_factor, save_file_path);
    
    
%% RMS

    rms_SmallSphere01 = calculateSphereRms(pt_mats_map('SmallSphere01'), small_sphere_param_1(1:3), small_sphere_param_1(4));
    rms_SmallSphere02 = calculateSphereRms(pt_mats_map('SmallSphere02'), small_sphere_param_2(1:3), small_sphere_param_2(4));
    rms_SmallSphere03 = calculateSphereRms(pt_mats_map('SmallSphere03'), small_sphere_param_3(1:3), small_sphere_param_3(4));
    rms_SmallSphere04 = calculateSphereRms(pt_mats_map('SmallSphere04'), small_sphere_param_4(1:3), small_sphere_param_4(4));

    rms_Small_Spheres_vec = [rms_SmallSphere01; rms_SmallSphere02; rms_SmallSphere03;
        rms_SmallSphere04];
    
    if (rms_SmallSphere01 > 0.001)
        warning('Excessive rms_SmallSphere01:%f',rms_SmallSphere01);
    end    
    if (rms_SmallSphere02 > 0.001)
        warning('Excessive rms_SmallSphere02:%f',rms_SmallSphere02);
    end    
    if (rms_SmallSphere03 > 0.001)
        warning('Excessive rms_SmallSphere03:%f',rms_SmallSphere03);
    end    
    if (rms_SmallSphere04 > 0.001)
        warning('Excessive rms_SmallSphere04:%f',rms_SmallSphere04);
    end    
    

%% Output files

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

% This file is generated by function
% defineBaseFrameAndDhFrame0And1FromArcs()
fileID = fopen( strcat(save_file_path, 'Fitting_rms_summary.txt'), 'a');

fprintf(fileID, 'small_sphere_origins_line_rms: %f\n', small_sphere_origins_line_rms);
fprintf(fileID, 'rms_Small_Spheres_vec(1): %f\n', rms_Small_Spheres_vec(1) );
fprintf(fileID, 'rms_Small_Spheres_vec(2): %f\n', rms_Small_Spheres_vec(2) );
fprintf(fileID, 'rms_Small_Spheres_vec(3): %f\n', rms_Small_Spheres_vec(3) );
fprintf(fileID, 'rms_Small_Spheres_vec(4): %f\n', rms_Small_Spheres_vec(4) );
fclose(fileID);

%% Figures

try 
    openfig(strcat(save_file_path,'J1_2_3.fig'));
    hold on; 
    
    scatter3(0, 0, 0, 'filled', 'black');
    text(0, 0, 0,'  Polaris Origin', 'Color', 'black');
    
    scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3),'o','black');
    scatter3(small_origin_2(1), small_origin_2(2), small_origin_2(3),'o','black');
    scatter3(small_origin_3(1), small_origin_3(2), small_origin_3(3),'o','black');
    scatter3(small_origin_4(1), small_origin_4(2), small_origin_4(3),'o','black');
    
%     text(small_origin_1(1), small_origin_1(2), small_origin_1(3),'  small centre 1', 'Color', 'black');
%     text(small_origin_2(1), small_origin_2(2), small_origin_2(3),'  small centre 2', 'Color', 'black');
%     text(small_origin_3(1), small_origin_3(2), small_origin_3(3),'  small centre 3', 'Color', 'black');
%     text(small_origin_4(1), small_origin_4(2), small_origin_4(3),'  small centre 4', 'Color', 'black');
    
    hold off;
    savefig( strcat(save_file_path,'J1_2_3_with_small_centres.fig'));
    

catch
    warning('Could not find J1_2_3.fig .');    
end



plotDavinciDHFrames(affine_dh_0_wrt_polaris, ...
    affine_dh_1_wrt_polaris, ...
    affine_dh_2_wrt_polaris, ...
    affine_dh_03_wrt_polaris, ...
    affine_dh_04_wrt_polaris, ...
    affine_dh_05_wrt_polaris);


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