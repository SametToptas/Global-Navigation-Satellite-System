% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023

function [ellp] = xyz2plh(cart)
format longG

X=cart(1,:); % X Coordinates in Meter (r_apr X coor)
Y=cart(2,:); % Y Coordinates in Meter (r_apr Y coor)
Z=cart(3,:); % Z Coordinates in Meter (r_apr Z coor)

% the data is referenced from the 3rd assignment
a = 6378137.0; % Semi-major axis of the ellipsoid (WGS84)(meter)
f = 1/298.257223563; % Flattening Factor (WGS84)
square_e = (2*f)-(f^2); % Eccentricity

phi = 0; % phi_k
phi_2 = 1; % phi_k+1 - ellipsoidal latitude
N = 1; % geoid geight
h = 0; % ellipsoidal geight
threshold = 10^(-12); % tolerance, given in the assignment 3
% I created a while loop for the conversion
% it returns the absolute value of the difference between both 'Phi' values until they drop below 10^-12 degrees
while abs(phi_2 - phi) > threshold
    % "φ - ellipsoidal latitude", in other words phi,'formula' -> 8rd slide referenced
    phi_2 = atand( Z / sqrt(X^2+Y^2) * (1-(square_e) * ( N / N+h ))^-1);
    phi = phi_2;
    % N is radius of curvature in the prime vertical,'formula' -> 8rd slide referenced
    N = ((a) / (sqrt(1- square_e * (sind(phi)^2))));
    % h is "h - ellipsoidal height",'formula' -> 8rd slide referenced
    h = (sqrt(X^2 + Y^2) / cosd(phi))- (N);
    height = h; % ellipsoida height
    latitude = phi; % phi is ellipsoidal latitude
end

% lambda is "λ - ellipsoidal longitude", in other words lambda.'formula' -> 8rd slide referenced
% atand(Y,X) - returns the inverse tangent (tan-1) of the elements of coordinates in degrees
lambda = atand(Y/X);
longitude = lambda;

% ellp = (ellipsoidal latitude, longitude and height) - (Degree, Degree, Meter)
ellp = [latitude;longitude;height];


%output_text = sprintf('Ellipsoidal Latitude in degree = %.6f meters\nEllipsoidal Longitude in degree = %.6f meters\nEllipsoidal Height in degree in meter = %.6f meters', ellp);
%fprintf('%s\n', output_text);
end