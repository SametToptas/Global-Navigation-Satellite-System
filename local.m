% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023

function [az, zen, slantd] = local(rec, sat)
format longG

ellp = xyz2plh(rec);
latitude = ellp(1,1); % output of ellipsoidal latitude in xyz2blh
longitude = ellp(2,1); % output of ellipsoidal longitude in xyz2blh

% Transformation from local Cartesian to global Cartesian coordinates;
A = [-sind(latitude)*cosd(longitude), -sind(longitude), cosd(latitude)*cosd(longitude);
     -sind(latitude)*sind(longitude), cosd(longitude), cosd(latitude)*sind(longitude);
     cosd(latitude), 0, sind(latitude)];

dx = sat - rec;

% Transformation from global Cartesian to local Cartesian coordinates
dx_prime =transpose(A) * dx;

az = atan2d(dx_prime(2,1), dx_prime(1,1));% Azimuth Calculation (in degrees)
zen = atan2d(sqrt(dx_prime(1,1)^2 + dx_prime(2,1)^2), dx_prime(3,1));% Zenith Calculation (in degrees)
% Slant Distance Calculation (in meters)
% norm(vector) returns the Euclidean norm (magnitude) of the vector
slantd = norm(dx_prime) * 10^(-3); % 10 ^ (-3) in km

end