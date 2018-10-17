% RN@HMS Queen Elizabeth
% 15/10/18
% Description.
%
% Notes.
% READ THE CODE COMMENTS


function [affine_dh_03_wrt_polaris, dh_3] = defineDhFrame03FromDhFrame02(affine_dh_2_wrt_polaris, d_3, save_file_path)

% They should coincide.
affine_dh_03_wrt_polaris = affine_dh_2_wrt_polaris;

% d_3 here is bit confusing. The DH param for d_3 is 0. However, the sensor
% has an offset which is called d_3 (may be joint_3_sensor_offset would be a better name) here in this function. And it will be
% passed to the output file which will be read by the kinematic package.
% Because it is a sensor offset, we the real d_3 passed to do the
% calculation should be remapped by 
% d_3 = joint_3_sensor_offset + joint_3_scale_factor x passed_in_joint_3_value.

% Becuase we are currently following the kinematic package's naming
% convention, we are still exporting this sensor offset in the name of d_3.
% This should be clarified and fixed in the future. 

dh_3.theta = 0;
dh_3.d = d_3;
dh_3.a = 0;
dh_3.alpha = 0;
    



end