function [cam,Pcam,Pworld] = calibrate(imfile);

% function [cam,Pcam,Pworld] = calibrate(imfile);
%
%  This function takes an image file name, loads in the image
%  and uses it for camera calibration.  The user clicks
%  on corner points of a grid (assumed to be a particular calibration
%  object).  These  points along with their true coordinates are used to 
%  optimize the camera parameters with respect to the reprojection
%  error.
%
%  Output: 
%     cam : a data structure describing the recovered camera
%     Pcam : the 2D coordinates of points in the image
%     Pworld : the 3D "ground truth" coordinates of the points in the image
%
I = im2double(rgb2gray(imread(imfile)));

% get the grid corner points
fprintf('click on the corners of each of the three faces\n');
fprintf('always start at the origin point and go around in a circle\n');
fprintf('XY plane  (9x8 squares) -> go along the 9 edge first  (CCW)\n');
XY = mapgrid(I,9,8);  
fprintf('XZ plane  (10x8 squares) -> go along the 10 edge first (CW)\n');
XZ = mapgrid(I,10,8);
fprintf('YZ plane  (8x10 squares) -> go along the 8 edge first (CCW)\n');
YZ = mapgrid(I,8,10);

% true 3D cooridnates (in cm) of the grid corners. this is only correct 
% assuming points were clicked in the order specified above
[yy,xx] = meshgrid( linspace(0,19.55,8), linspace(0,22.05,9));
zz = zeros(size(yy(:)));
XYworld = [xx(:) yy(:) zz(:)]';

[zz,xx] = meshgrid(linspace(0,19.55,8),linspace(0,25.2,10));
yy = zeros(size(xx(:)));
XZworld = [xx(:) yy(:) zz(:)]';

[zz,yy] = meshgrid(linspace(0,25.2,10),linspace(0,19.55,8));
xx = zeros(size(yy(:)));
YZworld = [xx(:) yy(:) zz(:)]';


% put all the points from the calibration object into a single array
Pcam = [XY XZ YZ];
Pworld = [XYworld XZworld YZworld];



% initial guesses of parameters.
cy = size(I,1) / 2;
cx = size(I,2) / 2;
f = 1000;
thx = 3*pi/2; thy = 3*pi/4; thz = 0; %no rotation
tx = 100; ty = 100; tz = 100; %make sure camera is away from origin

% initial parameter vector
paramsinit = [f,thx,thy,thz,tx,ty,tz];

% setup the optimization routine 
opts = optimset('maxfunevals',100000,'maxiter',10000);  %set the max number of iterations

% use an anonymous function to capture the fixed parameters: Pword,Pcam,cx and cy.  
%  The remaining parameters are optimized over
params_opt = lsqnonlin( @(params) project_error(params,Pworld,Pcam,cx,cy),paramsinit,[],[],opts);

% now unpack params_opt vector back into a cam struct.
%cam.f = ...
%  cam.f : focal length (scalar)
cam.f = params_opt(1);
%  cam.c : camera principal point [in pixels]  (2x1 vector)

%need to estimate these:
cam.c = [cx,cy];
%  cam.R : camera rotation matrix (3x3 matrix)
thx = params_opt(2);
thy = params_opt(3);
thz = params_opt(4);

Rx = [1 0 0; 0 cos(thx) -sin(thx); 0 sin(thx) cos(thx)];
Ry = [cos(thy) 0 -sin(thy); 0 1 0; sin(thy) 0 cos(thy)];
Rz = [cos(thz) sin(thz) 0; -sin(thz) cos(thz) 0; 0 0 1];
rotation = Rx * Ry * Rz;
cam.R = rotation;

%  cam.t : camera translation matrix (3x1 vector)
cam.t = [params_opt(5); params_opt(6); params_opt(7)];

cam.f


if (0)
    % here is a nice visualization.... plot projected locations of the 3D
    %  points on top of the 2D image so we can visualize the reprojection error
    Pest = project(Pworld,cam);
    figure(3); clf;
    imagesc(I); axis image; colormap gray
    hold on;
    plot(Pcam(1,:),Pcam(2,:),'b.')
    plot(Pest(1,:),Pest(2,:),'r.')
    hold off;
    title('reprojections after optimization');
end


