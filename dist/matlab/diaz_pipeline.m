%step 1, get camera calib
addpath('TOOLBOX_calib/');

path = 'teapot/';

%step 2 generate reconstructions
% for n = 1:10
%     fprintf('Triangulating set ');
%     fprintf(int2str(n));
%     fprintf('\n');
%     diaz_reconstruct(n);
% end

%step 3 generate meshes
% recon_dir = 'teapot/reconstructions';
% for n = 1:10
%     fprintf('Creating Mesh ');
%     fprintf(int2str(n));
%     fprintf('\n');
%     diaz_mesh(n,recon_dir);
% end

%view meshes
% figure(2); clf;
% h = trisurf(tri,Y(1,:),Y(2,:),Y(3,:));
% set(h,'edgecolor','flat')
% axis image; axis vis3d;
% zlabel('Z');
% xlabel('X');
% ylabel('Y');
% camorbit(120,0); camlight left;
% camorbit(120,0); camlight left;
% lighting flat;
% set(gca,'projection','perspective')
% set(gcf,'renderer','opengl')
% set(h,'facevertexcdata',xColor'/255);
% material dull

%generate ply files
%convert trimeshes to ply
% for n = 1:10
%     %load mesh
%     fileload = strcat('/Users/danieldiaz/Documents/MATLAB/CS117Final-Project/teapot/meshes/meshdata',int2str(n),'.mat');
%     load (fileload);
%     filepath = strcat('teapot/plyFiles/set',int2str(n),'.ply');
%     mesh = pointCloud2mesh(Y');
%     makePly(mesh,filepath);
% end
