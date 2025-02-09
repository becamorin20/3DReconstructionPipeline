%Daniel Diaz 2015
%Demo Script
%Note: By this point all relevant reconstructions and 
% meshes have been generated by running the file 
% diaz_pipeline.m
%re reun the file to regenerate the reconstructions and meshes

%generate ply files
%convert trimeshes to ply
for n = 1:10
%     %load mesh
    fileload = strcat('/Users/danieldiaz/Documents/MATLAB/CS117Final-Project/dist/matlab/teapot/meshes/meshdata',int2str(n),'.mat');
    load (fileload);
    filepath = strcat('teapot/plyFiles/set',int2str(n),'.ply');
    mesh = pointCloud2mesh(Y');
    makePly(mesh,filepath);
end