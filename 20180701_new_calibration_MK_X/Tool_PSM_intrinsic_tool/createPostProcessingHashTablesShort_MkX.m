% RN@HMS Prince of Wales
% 16/02/18
% Notes.
% Each arm should create its own hash table for results. The following
% codes are not related with colour. If the new data is added (e.g. extra
% spheres, arcs, or small spehres), then the keys must get updated too.


function [result_map] = createPostProcessingHashTablesShort(pt_clds_map, pt_mats_map, joint_12_flag, plot_flag)

key_ = {'plane_1_param_1', 'plane_2_param_1', ...
    'portal_rotation_wrt_polaris', ...
    'sphere_param_1', ...
    'small_sphere_param_1', 'small_sphere_param_2', 'small_sphere_param_3', 'small_sphere_param_4', ...
    'portal_origin_wrt_polaris', 'small_origins_vec', 'distance_to_portal_vec', ...
    'actual_small_ori_increments', 'ave_actual_small_ori_increment', 'rms_Sphere_vec', 'rms_Small_Spheres_vec', ...
    'small_sphere_origins_line_param', 'small_sphere_origins_line_rms', ...
    'affine_portal_wrt_polaris', ...
    'joint_1_param', 'joint_2_param',...
    'small_origins_vec_wrt_portal',...
    'small_sphere_origins_line_param_wrt_portal', 'small_sphere_origins_line_rms_wrt_porta'};

%% Fittings

[plane_1_param_1, plane_2_param_1, fval_1, rot_mat_1] = davinci_planes_fit(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'));


% normalise plane params
plane_1_param_1 = plane_1_param_1/norm(plane_1_param_1(1:3));
plane_2_param_1 = plane_2_param_1/norm(plane_2_param_1(1:3));

portal_x_axis = plane_2_param_1(1:3);
portal_y_axis = plane_1_param_1(1:3);
portal_z_axis = cross(portal_x_axis, portal_y_axis);
portal_rotation_wrt_polaris = [transpose(portal_x_axis) transpose(portal_y_axis) transpose(portal_z_axis)];

% spheres
[sphere_param_1, residuals_1] = davinci_sphere_fit_least_square(pt_mats_map('BigSphere01'));


[small_sphere_param_1, small_residuals_1] = davinci_sphere_fit_least_square(pt_mats_map('SmallSphere01'));
[small_sphere_param_2, small_residuals_2] = davinci_sphere_fit_least_square(pt_mats_map('SmallSphere02'));
[small_sphere_param_3, small_residuals_3] = davinci_sphere_fit_least_square(pt_mats_map('SmallSphere03'));
[small_sphere_param_4, small_residuals_4] = davinci_sphere_fit_least_square(pt_mats_map('SmallSphere04'));


portal_origin_wrt_polaris = [sphere_param_1(1) 
    sphere_param_1(2)
    sphere_param_1(3)];

portal_origin_wrt_polaris = transpose(portal_origin_wrt_polaris);

small_origin_1 = small_sphere_param_1(:,1:3);
small_origin_2 = small_sphere_param_2(:,1:3);
small_origin_3 = small_sphere_param_3(:,1:3);
small_origin_4 = small_sphere_param_4(:,1:3);

small_origins_vec = [small_origin_1; small_origin_2; small_origin_3; small_origin_4];

distance_1_0 = sqrt( (portal_origin_wrt_polaris(1)-small_origin_1(1))^2 + (portal_origin_wrt_polaris(2)-small_origin_1(2))^2 + (portal_origin_wrt_polaris(3)-small_origin_1(3))^2 );
distance_2_0 = sqrt( (portal_origin_wrt_polaris(1)-small_origin_2(1))^2 + (portal_origin_wrt_polaris(2)-small_origin_2(2))^2 + (portal_origin_wrt_polaris(3)-small_origin_2(3))^2 );
distance_3_0 = sqrt( (portal_origin_wrt_polaris(1)-small_origin_3(1))^2 + (portal_origin_wrt_polaris(2)-small_origin_3(2))^2 + (portal_origin_wrt_polaris(3)-small_origin_3(3))^2 );
distance_4_0 = sqrt( (portal_origin_wrt_polaris(1)-small_origin_4(1))^2 + (portal_origin_wrt_polaris(2)-small_origin_4(2))^2 + (portal_origin_wrt_polaris(3)-small_origin_4(3))^2 );


distance_to_portal_vec = [distance_1_0 0.21; distance_2_0 0.19; distance_3_0 0.17; distance_4_0 0.15];

for n = 1 : 4
    distance_to_portal_vec(n,3) = distance_to_portal_vec(n,2) - distance_to_portal_vec(n,1);
end

distance_1_2 = sqrt( (small_origin_1(1)-small_origin_2(1))^2 + (small_origin_1(2)-small_origin_2(2))^2 + (small_origin_1(3)-small_origin_2(3))^2 );
distance_2_3 = sqrt( (small_origin_2(1)-small_origin_3(1))^2 + (small_origin_2(2)-small_origin_3(2))^2 + (small_origin_2(3)-small_origin_3(3))^2 );
distance_3_4 = sqrt( (small_origin_3(1)-small_origin_4(1))^2 + (small_origin_3(2)-small_origin_4(2))^2 + (small_origin_3(3)-small_origin_4(3))^2 );

actual_small_ori_increments = [distance_1_2; distance_2_3; distance_3_4];

ave_actual_small_ori_increment = (distance_1_2 + distance_2_3 + distance_3_4)/3;

[small_sphere_origins_line_param, small_sphere_origins_line_rms] = davinci_line_fit_svd(small_origins_vec);



% Affine 
affine_portal_wrt_polaris = zeros(4,4);
affine_portal_wrt_polaris(4,4) = 1;
affine_portal_wrt_polaris(1:3,1:3) = portal_rotation_wrt_polaris;
affine_portal_wrt_polaris(1:3,4) = transpose(portal_origin_wrt_polaris);

% Added on 18/06/18
% Considering the existance of j1_j2_dist, then we are not actully getting
% a perfect fitted circle with its centre to be on the J1 axis. Current
% adjustment based on experience would move the centre along the 'portal'
% frame z axis for 0.85*j1_j2_dist, which is approximately 0.0034. ~  0.005
adjustment = [0; 0;  0.005];
delta_portal_origin_wrt_polaris = 0.85*portal_rotation_wrt_polaris*adjustment
portal_origin_wrt_polaris = portal_origin_wrt_polaris + transpose(delta_portal_origin_wrt_polaris)
affine_portal_wrt_polaris(1:3,4) = transpose(portal_origin_wrt_polaris);



% Check direction
% When the Polaris is facing a PSM, the portal frame of that PSM should
% conform the following:
% 1. Portal frame x is roughly antiparallel to Polaris y;
% 2. Portal frame y is roughly parallel to Polaris z;
% 3. Portal frame z is roughly antiparallel to Polaris x.
if affine_portal_wrt_polaris(2,1)>0
    affine_portal_wrt_polaris(:,1) = -affine_portal_wrt_polaris(:,1);
end
if affine_portal_wrt_polaris(3,2)<0
    affine_portal_wrt_polaris(:,2) = -affine_portal_wrt_polaris(:,2);
end
if affine_portal_wrt_polaris(1,3)>0
    affine_portal_wrt_polaris(:,3) = -affine_portal_wrt_polaris(:,3);
end
% 4. Then make sure the roation matrix (another variable) is updated to the correct form as well.
portal_rotation_wrt_polaris = affine_portal_wrt_polaris(1:3,1:3);


%% Calculate small_origins_vec_wrt_portal

temp_vec = small_origins_vec;
temp_vec(:,4) = 1;
temp_vec = transpose(inv(affine_portal_wrt_polaris) * transpose(temp_vec));
small_origins_vec_wrt_portal = temp_vec(:,1:3);

[small_sphere_origins_line_param_wrt_portal, small_sphere_origins_line_rms_wrt_porta] = davinci_line_fit_svd(small_origins_vec_wrt_portal);

%% Joint 1 & 2 Params (From Independent Analysis)

if (joint_12_flag == 9)

    %%%joint_1_param
    % % format: fixed pt + vector + rms
    % % Because of the extremely slow speed, comment these line when not used.

    temp = pt_mats_map('J1Arc01');
    temp_x = temp(:,1);
    temp_y = temp(:,2);
    temp_z = temp(:,3);
    plane_1_param_1_independent = plane(temp_x, temp_y, temp_z);
    [j1_arc_01_circle_params, fval_j1_01, rms_j1_01] = davinciFit3dCircle(temp);
    joint_1_param.vector = plane_1_param_1_independent.Normal();
    joint_1_param.circle = j1_arc_01_circle_params;
    joint_1_param.circle_rms = rms_j1_01;

    %%% joint_2_param
    % % format: fixed pt + vector
    % % Because of the extremely slow speed, comment these line when not used.

    temp = pt_mats_map('J2Arc01');
    temp_x = temp(:,1);
    temp_y = temp(:,2);
    temp_z = temp(:,3);
    plane_2_param_1_independent = plane(temp_x, temp_y, temp_z);
    [j2_arc_01_circle_params, fval_j2_01, rms_j2_01] = davinciFit3dCircle(temp);
    joint_2_param.vector = plane_2_param_1_independent.Normal();
    joint_2_param.circle = j2_arc_01_circle_params;
    joint_2_param.circle_rms = rms_j2_01;

else
   % DO NOTHING 
   joint_1_param = 0; % Fake value
   joint_2_param = 0; % Fake value
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02/07/18
defineBaseFrameAndDhFrame0And1FromArcs(pt_mats_map('J1Arc01'), pt_mats_map('J2Arc01'));

openfig('processed_arcs.fig');
hold on;
    axis equal;
    scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
    scatter3(small_origin_2(1), small_origin_2(2), small_origin_2(3), 'filled');
    scatter3(small_origin_3(1), small_origin_3(2), small_origin_3(3), 'filled');
    scatter3(small_origin_4(1), small_origin_4(2), small_origin_4(3), 'filled');
        %%%%%%%%%%%%%
        % Plot small sphere origins fitted line
        scale = 0.12; %scale of the plotted section

        yx_0 = small_sphere_origins_line_param.p0(1) - small_sphere_origins_line_param.direction(1)*scale;
        yy_0 = small_sphere_origins_line_param.p0(2) - small_sphere_origins_line_param.direction(2)*scale;
        yz_0 = small_sphere_origins_line_param.p0(3) - small_sphere_origins_line_param.direction(3)*scale;

        yx_t = small_sphere_origins_line_param.p0(1) + small_sphere_origins_line_param.direction(1)*scale;
        yy_t = small_sphere_origins_line_param.p0(2) + small_sphere_origins_line_param.direction(2)*scale;
        yz_t = small_sphere_origins_line_param.p0(3) + small_sphere_origins_line_param.direction(3)*scale;
        v0_y= [yx_0 yy_0 yz_0];
        vz_y= [yx_t yy_t yz_t];
        v0z_y=[vz_y;v0_y];
        plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'y');
        %%%%%%%%%%%%% end
  
hold off;    
    
    
    
openfig('processed_arcs.fig');
hold on;
    axis equal;  
    scatter3(portal_origin_wrt_polaris(1), portal_origin_wrt_polaris(2), portal_origin_wrt_polaris(3), 'x', 'blue');
 hold off;     
    
    
    
    
    
    
    
    

%% RMS

rms_Sphere01 = calculate_sphere_rms(pt_mats_map('BigSphere01'), sphere_param_1(1:3), sphere_param_1(4))

rms_Sphere_vec = [rms_Sphere01];

rms_SmallSphere01 = calculate_sphere_rms(pt_mats_map('SmallSphere01'), small_sphere_param_1(1:3), small_sphere_param_1(4));
rms_SmallSphere02 = calculate_sphere_rms(pt_mats_map('SmallSphere02'), small_sphere_param_2(1:3), small_sphere_param_2(4));
rms_SmallSphere03 = calculate_sphere_rms(pt_mats_map('SmallSphere03'), small_sphere_param_3(1:3), small_sphere_param_3(4));
rms_SmallSphere04 = calculate_sphere_rms(pt_mats_map('SmallSphere04'), small_sphere_param_4(1:3), small_sphere_param_4(4));

rms_Small_Spheres_vec = [rms_SmallSphere01; rms_SmallSphere02; rms_SmallSphere03;
    rms_SmallSphere04];

%% Values

values_ = {plane_1_param_1, plane_2_param_1, ...
    portal_rotation_wrt_polaris, ...
    sphere_param_1, ...
    small_sphere_param_1, small_sphere_param_2, small_sphere_param_3, small_sphere_param_4, ...
    portal_origin_wrt_polaris, small_origins_vec, distance_to_portal_vec, ...
    actual_small_ori_increments, ave_actual_small_ori_increment, rms_Sphere_vec, rms_Small_Spheres_vec, ...
    small_sphere_origins_line_param, small_sphere_origins_line_rms, ...
    affine_portal_wrt_polaris, ...
    joint_1_param, joint_2_param, ...
    small_origins_vec_wrt_portal, ...
    small_sphere_origins_line_param_wrt_portal, small_sphere_origins_line_rms_wrt_porta};

%% Plotting
if plot_flag == 1
    
    figure('Name', 'Merged Raw and Result Visualisation');
    scatter3(portal_origin_wrt_polaris(1), portal_origin_wrt_polaris(2), portal_origin_wrt_polaris(3));
    hold on;
    axis equal;
    scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
    scatter3(small_origin_2(1), small_origin_2(2), small_origin_2(3), 'filled');
    scatter3(small_origin_3(1), small_origin_3(2), small_origin_3(3), 'filled');
    scatter3(small_origin_4(1), small_origin_4(2), small_origin_4(3), 'filled');
    pcshow(pt_clds_map('all'));
    
        %%%%%%%%%%%%%
        % Plot Portal Frame
        scale = 0.1; %scale of the axes
        % y axis
        % The norm of plane_1 should parallel to the y axis
        yx_0 = portal_origin_wrt_polaris(1) - plane_1_param_1(1)*scale;
        yy_0 = portal_origin_wrt_polaris(2) - plane_1_param_1(2)*scale;
        yz_0 = portal_origin_wrt_polaris(3) - plane_1_param_1(3)*scale;
        % the vector of yellow portal z axis (xz_y, yz_y, zz_y). _y: yellow PSM
        yx_t = portal_origin_wrt_polaris(1) + plane_1_param_1(1)*scale;
        yy_t = portal_origin_wrt_polaris(2) + plane_1_param_1(2)*scale;
        yz_t = portal_origin_wrt_polaris(3) + plane_1_param_1(3)*scale;
        v0_y= [yx_0 yy_0 yz_0];
        vz_y= [yx_t yy_t yz_t];
        v0z_y=[vz_y;v0_y];
        plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
        % x axis
        % The norm of plane_2 should parallel to the x axis
        % the vector of yellow portal x axis (xx_y, yx_y, zx_y). _y: yellow
        xx_0 = portal_origin_wrt_polaris(1) - plane_2_param_1(1)*scale;
        xy_0 = portal_origin_wrt_polaris(2) - plane_2_param_1(2)*scale;
        xz_0 = portal_origin_wrt_polaris(3) - plane_2_param_1(3)*scale;
        xx_t = portal_origin_wrt_polaris(1) + plane_2_param_1(1)*scale;
        xy_t = portal_origin_wrt_polaris(2) + plane_2_param_1(2)*scale;
        xz_t = portal_origin_wrt_polaris(3) + plane_2_param_1(3)*scale;
        v0_y= [xx_0 xy_0 xz_0];
        vx_y= [xx_t xy_t xz_t];
        v0x_y=[vx_y;v0_y];
        plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');
        % yellow z axis
        % the vector of yellow portal y axis (xy_y, yy_y, zy_y). _y: yellow
        plane_3_normal = cross(plane_1_param_1(1:3), plane_2_param_1(1:3));

        zx_0 = portal_origin_wrt_polaris(1) + plane_3_normal(1)*scale;
        zy_0 = portal_origin_wrt_polaris(2) + plane_3_normal(2)*scale;
        zz_0 = portal_origin_wrt_polaris(3) + plane_3_normal(3)*scale;
        zx_t = portal_origin_wrt_polaris(1) - plane_3_normal(1)*scale;
        zy_t = portal_origin_wrt_polaris(2) - plane_3_normal(2)*scale;
        zz_t = portal_origin_wrt_polaris(3) - plane_3_normal(3)*scale;
        v0_y= [zx_0 zy_0 zz_0];
        vy_y= [zx_t zy_t zz_t];
        v0y_y=[vy_y;v0_y];
        plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
        %%%%%%%%%%%%% end
        
        %%%%%%%%%%%%%
        % Plot small sphere origins fitted line
        scale = 0.12; %scale of the plotted section

        yx_0 = small_sphere_origins_line_param.p0(1) - small_sphere_origins_line_param.direction(1)*scale;
        yy_0 = small_sphere_origins_line_param.p0(2) - small_sphere_origins_line_param.direction(2)*scale;
        yz_0 = small_sphere_origins_line_param.p0(3) - small_sphere_origins_line_param.direction(3)*scale;

        yx_t = small_sphere_origins_line_param.p0(1) + small_sphere_origins_line_param.direction(1)*scale;
        yy_t = small_sphere_origins_line_param.p0(2) + small_sphere_origins_line_param.direction(2)*scale;
        yz_t = small_sphere_origins_line_param.p0(3) + small_sphere_origins_line_param.direction(3)*scale;
        v0_y= [yx_0 yy_0 yz_0];
        vz_y= [yx_t yy_t yz_t];
        v0z_y=[vz_y;v0_y];
        plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'y');
        %%%%%%%%%%%%% end
        
        
        
    hold off;

    figure('Name', 'Fitting Results Only');
    scatter3(portal_origin_wrt_polaris(1), portal_origin_wrt_polaris(2), portal_origin_wrt_polaris(3));
    hold on;
    axis equal;
    scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
    scatter3(small_origin_2(1), small_origin_2(2), small_origin_2(3), 'filled');
    scatter3(small_origin_3(1), small_origin_3(2), small_origin_3(3), 'filled');
    scatter3(small_origin_4(1), small_origin_4(2), small_origin_4(3), 'filled');

        %%%%%%%%%%%%%
        % Plot Portal Frame
        scale = 0.1; %scale of the axes
        % y axis
        % The norm of plane_1 should parallel to the y axis
        yx_0 = portal_origin_wrt_polaris(1) - plane_1_param_1(1)*scale;
        yy_0 = portal_origin_wrt_polaris(2) - plane_1_param_1(2)*scale;
        yz_0 = portal_origin_wrt_polaris(3) - plane_1_param_1(3)*scale;
        % the vector of yellow portal z axis (xz_y, yz_y, zz_y). _y: yellow PSM
        yx_t = portal_origin_wrt_polaris(1) + plane_1_param_1(1)*scale;
        yy_t = portal_origin_wrt_polaris(2) + plane_1_param_1(2)*scale;
        yz_t = portal_origin_wrt_polaris(3) + plane_1_param_1(3)*scale;
        v0_y= [yx_0 yy_0 yz_0];
        vz_y= [yx_t yy_t yz_t];
        v0z_y=[vz_y;v0_y];
        plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
        % x axis
        % The norm of plane_2 should parallel to the x axis
        % the vector of yellow portal x axis (xx_y, yx_y, zx_y). _y: yellow
        xx_0 = portal_origin_wrt_polaris(1) - plane_2_param_1(1)*scale;
        xy_0 = portal_origin_wrt_polaris(2) - plane_2_param_1(2)*scale;
        xz_0 = portal_origin_wrt_polaris(3) - plane_2_param_1(3)*scale;
        xx_t = portal_origin_wrt_polaris(1) + plane_2_param_1(1)*scale;
        xy_t = portal_origin_wrt_polaris(2) + plane_2_param_1(2)*scale;
        xz_t = portal_origin_wrt_polaris(3) + plane_2_param_1(3)*scale;
        v0_y= [xx_0 xy_0 xz_0];
        vx_y= [xx_t xy_t xz_t];
        v0x_y=[vx_y;v0_y];
        plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');
        % yellow z axis
        % the vector of yellow portal y axis (xy_y, yy_y, zy_y). _y: yellow
        plane_3_normal = cross(plane_1_param_1(1:3), plane_2_param_1(1:3));

        zx_0 = portal_origin_wrt_polaris(1) + plane_3_normal(1)*scale;
        zy_0 = portal_origin_wrt_polaris(2) + plane_3_normal(2)*scale;
        zz_0 = portal_origin_wrt_polaris(3) + plane_3_normal(3)*scale;
        zx_t = portal_origin_wrt_polaris(1) - plane_3_normal(1)*scale;
        zy_t = portal_origin_wrt_polaris(2) - plane_3_normal(2)*scale;
        zz_t = portal_origin_wrt_polaris(3) - plane_3_normal(3)*scale;
        v0_y= [zx_0 zy_0 zz_0];
        vy_y= [zx_t zy_t zz_t];
        v0y_y=[vy_y;v0_y];
        plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
        %%%%%%%%%%%%% end   
                
        %%%%%%%%%%%%%
        % Plot small sphere origins fitted line
        scale = 0.12; %scale of the plotted section

        yx_0 = small_sphere_origins_line_param.p0(1) - small_sphere_origins_line_param.direction(1)*scale;
        yy_0 = small_sphere_origins_line_param.p0(2) - small_sphere_origins_line_param.direction(2)*scale;
        yz_0 = small_sphere_origins_line_param.p0(3) - small_sphere_origins_line_param.direction(3)*scale;

        yx_t = small_sphere_origins_line_param.p0(1) + small_sphere_origins_line_param.direction(1)*scale;
        yy_t = small_sphere_origins_line_param.p0(2) + small_sphere_origins_line_param.direction(2)*scale;
        yz_t = small_sphere_origins_line_param.p0(3) + small_sphere_origins_line_param.direction(3)*scale;
        v0_y= [yx_0 yy_0 yz_0];
        vz_y= [yx_t yy_t yz_t];
        v0z_y=[vz_y;v0_y];
        plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'y');
        %%%%%%%%%%%%% end
  
    hold off;
         
   
    figure('Name', 'Small_Sphere_Sample(01)');
    pcshow(pt_clds_map('SmallSphere01'));
    hold on;
    axis equal;
    scatter3(small_origin_1(1), small_origin_1(2), small_origin_1(3), 'filled');
    [x y z] = sphere;
    a = [small_sphere_param_1(1), small_sphere_param_1(2), small_sphere_param_1(3),  small_sphere_param_1(4)];
    s1=surf(x*a(1,4)+a(1,1), y*a(1,4)+a(1,2), z*a(1,4)+a(1,3));
    hold off;
    
    
end

%% Return

result_map = containers.Map(key_, values_);
end