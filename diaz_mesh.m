function [] = diaz_mesh(iteration,recon_dir)

% scan we are working on
 scandir = 'teapot/';

% threshold for pruning neighbors
nbrthresh = 0.25;
trithresh = 1;

% load in results of reconstruct 
loaddir = strcat(recon_dir,'/scandata',int2str(iteration),'.mat');
%load([scandir 'scandata1.mat']);
load([loaddir]);

%
% cleaning step 1: remove points outside known bounding box
%
%goodpoints = find( (X(1,:)>-140) & (X(1,:)<25) & (X(2,:)>-100) & (X(2,:)<100) & (X(3,:)>550) & (X(3,:)<800) );
goodpoints = find( (X(1,:)>-150) & (X(1,:)<30) & (X(2,:)>-100) & (X(2,:)<100) & (X(3,:)>525) & (X(3,:)<820) );
fprintf('dropping %2.2f %% of points from scan',100*(1 - (length(goodpoints)/size(X,2))));
X = X(:,goodpoints);
xR = xR(:,goodpoints);
xL = xL(:,goodpoints);
xColor = xColor(:,goodpoints);

fprintf('filtering right image neighbors\n');
[tri,pterrR] = nbr_error(xR,X);

fprintf('filtering left image neighbors\n');
[tri,pterrL] = nbr_error(xL,X);

goodpoints = find((pterrR<nbrthresh) & (pterrL<nbrthresh));
fprintf('dropping %2.2f %% of points from scan\n',100*(1-(length(goodpoints)/size(X,2))));
X = X(:,goodpoints);
xR = xR(:,goodpoints);
xL = xL(:,goodpoints);
xColor = xColor(:,goodpoints);

%
% cleaning step 3: remove triangles which have long edges
%
[tri,terr] = tri_error(xL,X);
subt = find(terr<trithresh);
tri = tri(subt,:);

%render temp results before smoothing
figure(1); clf;
h = trisurf(tri,X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
axis image; axis vis3d;
zlabel('Z');
xlabel('X');
ylabel('Y');
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting phong;
material dull;


%
% cleaning step 4: simple smoothing
%
Y = nbr_smooth(tri,X,3);

% visualize results of smooth with
% mesh edges visible
figure(2); clf;
h = trisurf(tri,Y(1,:),Y(2,:),Y(3,:));
set(h,'edgecolor','flat')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting flat;
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
set(h,'facevertexcdata',xColor'/255);
material dull

%save data
savedirstart = 'meshes/meshdata';
iteration_string = int2str(iteration);
savedirending = '.mat';
savedir = strcat(scandir,savedirstart,iteration_string,savedirending);
save([savedir]);



end