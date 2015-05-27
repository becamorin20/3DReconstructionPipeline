% scan we are working on
 scandir = 'teapot/';

% threshold for pruning neighbors
nbrthresh = 0.25;
trithresh = 1;

% load in results of reconstruct 
load([scandir 'scandata1.mat']);

% goodpoints = find( (X(1,:)>-500) & (X(1,:)<500) & (X(2,:)>-500) & (X(2,:)<500) & (X(3,:)>-500) & (X(3,:)<500) );
% fprintf('dropping %2.2f %% of points from scan',100*(1 - (length(goodpoints)/size(X,2))));
% X = X(:,goodpoints);
% xR = xR(:,goodpoints);
% xL = xL(:,goodpoints);
% xColor = xColor(:,goodpoints);

tri = delaunay(xL(1,:),xL(2,:));

figure(1); clf;
h = trisurf(tri,X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting phong;
material dull;