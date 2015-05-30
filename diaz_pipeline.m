%step 1, get camera calib
addpath('TOOLBOX_calib/');

%step 2 generate reconstructions
% for n = 1:10
%     fprintf('Triangulating set ');
%     fprintf(int2str(n));
%     fprintf('\n');
%     diaz_reconstruct(n);
% end

%step 3 generate meshes
recon_dir = 'teapot/reconstructions';
for n = 2:10
    fprintf('Creating Mesh ');
    fprintf(int2str(n));
    fprintf('\n');
    diaz_mesh(n,recon_dir);
end
    