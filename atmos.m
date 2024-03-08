% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023
% trecw = ( 86400 * 3 ) + 17250 = 276450 sec
function [az, zen, slantd, IonD, TrD, TrW] = atmos(doy, trec, trecw, C1, rec, sp3, alpha, beta)
format longG

ellp = xyz2plh(rec);
lat = ellp(1,1); % output of ellipsoidal latitude in radian in xyz2blh
lat_r = deg2rad(lat); % Ellipsoidal Latitude in Radian
lon = ellp(2,1); % output of ellipsoidal longitude in radian in xyz2blh
lon_r = deg2rad(lon); % Ellipsoidal Longitude in Radian
H = ellp(3,1); % output of ellipsoidal height in xyz2blh

sat = sat_pos(trec,C1,sp3,rec);
[az, zen, slantd] = local(rec,sat);
azm = deg2rad(az); % Azimuth in Radian
elv = 90 - zen;
elv_r = deg2rad(elv); % Elevation in Radian

% IonD : ionospheric slant delay (meter) for the observation
% "tgps in ıon_klobuchar = trecw" gps time (seconds of week) for the observation
% "iond = dion in ıon_klobuchar"
IonD = Ion_Klobuchar(lat_r,lon_r,elv_r,azm,alpha,beta,trecw);
% ME: Mapping function for both dry and wet delays
% Trzw: Zenith wet delay [m]
% Trzd: Zenith dry (hydrostatic) delay [m]
[Trzd,Trzw,ME] = trop_SPP(lat,doy,H,elv_r);

% ! total tropospheric delay Tr(E) = (Trd + Trw) . ME is available as such, but dry and wet are required separately.

% Trzd: Zenith dry (hydrostatic) delay [m]
TrD = Trzd * ME; % ME: Mapping function for both dry and wet delays
% Trzw: Zenith wet delay [m]
TrW = Trzw * ME; % ME: Mapping function for both dry and wet delays
end