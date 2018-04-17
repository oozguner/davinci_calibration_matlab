% RN@HMS Prince of Wales
% 16/04/18

%%
clc
close all
clear all

%% 
% Change these initial values
x = 0;
y = 0;
z = -0.15;

time = 10;
count = 1;

for i = 0:5
    
   for j = 0:5
       
       for k = 0:5

          disp(strcat(num2str((x+i*0.01)), ',  ',num2str(y+j*0.01), ',  ' ,num2str(z+k*0.01), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
          disp(strcat(num2str((x+i*0.01)), ',  ',num2str(y+j*0.01), ',  ' ,num2str(z+k*0.01), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time + 2))); 

          time = time + 4;

          pts_generated_cube(count,:) = [(x+i*0.01) (y+j*0.01) (z+k*0.01)];
          count = count + 1;
      
       end
   end
    
end

save('pts_generated_cube.mat', 'pts_generated_cube');