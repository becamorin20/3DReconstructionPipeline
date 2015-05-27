%Daniel Diaz 74393336

%load stereo_calib_results.mat

%get translation matrix
%R = rodrigues(om);
% directory where the scan data is stored
scandir = 'teapot/';

%create caml and camR based off our calibrations
camL.f = 1856.90593;
camL.c = [ 1403.64475   869.11654 ];
camL.t = [0 0 0];
camL.r = eye(3);

camR.f = 1844.49359;
camR.c = [ 1376.02168   942.95776 ];
camR.t = [ -438.85342   -5.70884  188.20991 ];
camR.r = [ 0.7273    0.0027    0.6863;
           0.0258    0.9992   -0.0313;
          -0.6858    0.0405    0.7266;];