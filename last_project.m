% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023
% trecw = ( 86400 * 3 ) + 17250 = 276450 sec

function [mers_station_coor,ground_truth] = last_project(C1,SP3,doy,trec,trecw,rec,alpha,beta,TGD)

format longG

state = input(" 1 is excluding delays and 2 is including delays:  " );

c = 299792458; % Velocity of light (m/s)
mu = 3.986005 * 10^14; %Earth's gravitational constant (WGS84) (𝑚^3/𝑠^2)
we = 7.2921151467 * 10^-5; %Earth's rotation rate (WGS84) (𝑟𝑎𝑑/s)

row_len = size(SP3, 1);
% Lists for Append
satellites_position = [];
state_list = [];

for i=1:row_len
    dt = C1(i,:)/c; % dt is t_reception - t_emission - pc = P
    sat_t_emist = trec - dt; % time of signal transmission (satellite clock) trec = treception

    clk =SP3(:,:,i); % satellite clock errors in SP3 matrices
    clk(:,5) =clk(:,5)*10^-6; % 10^-6 convertion for satellite clock correction
    
    % 𝛿𝑡_𝑠𝑎t - (Reception time and satellite clock corrections)
    sat_clock_correction = lagrange(sat_t_emist,clk(:, [1, 5]));
    % Satellite coordinates in ECEF at Reception Time 
    [fpos] =sat_pos(trec, C1(i,:), SP3(:,:,i), rec);
    satellites_position(i,:)= fpos; % For All Satellites
    % last homework parameters for delays (atmos) 
    [az, zen, slantd, IonD, TrD, TrW] = atmos(doy, trec, trecw, C1(i,:), rec, SP3(:,:,i),alpha,beta);
   
    while true
        if state == 1
            state_list(i,:) = -c *sat_clock_correction;
            break
        elseif state == 2
            state_list(i,:) = -c *sat_clock_correction +IonD +TrD +TrW+ TGD(i)*c;
            break
        else
            disp("Please select 1st (without delays) or 2nd (with delays) number for result");
            break
        end
    end
end
% Final Satellite Coordinates in ECEF For Related Satellites
sats_x_coor = satellites_position(:,1);
sats_y_coor = satellites_position(:,2);
sats_z_coor = satellites_position(:,3);
sats_coor_list = [sats_x_coor, sats_y_coor, sats_z_coor];

%initial receiver coordinates as zero
X = 0;
Y = 0;
Z = 0;
while true % starting Least Squares Method.
    % Geometric range linearization, reference slides10
    pj_0 = sqrt((sats_coor_list(:, 1) - X).^2+(sats_coor_list(:, 2) - Y).^2+((sats_coor_list(:, 3) - Z).^2));
    % reduced obserbation vector, reference slides10
    l = C1 -pj_0-state_list ;
    % design matrix, reference slides10
    A=[(X -sats_coor_list(:, 1))./pj_0,(Y -sats_coor_list(:, 2))./pj_0,(Z -sats_coor_list(:, 3))./pj_0 ,ones(row_len,1)];
    % vector of unknown parameters, reference slides10
    transpose_X= A\l;
    % Vector of unkown parameters, corrections to approx receiver coor
    dx = transpose_X(1,1);
    dy = transpose_X(2,1);
    dz = transpose_X(3,1);
    % correction time, reference slides10
    T_delta = transpose_X(4,1)/c;
    %(X=0, Y=0, Z=0) and break the iterations when the 
    %differences in each component (dX, dY, dZ) is less than 1-mm. 
    if abs(dx) < (10^-3) && abs(dy) < (10^-3) && abs(dz) < (10^-3)
        break
    else        
        % Current station coordinates
        X = X +dx; 
        Y = Y +dy; 
        Z = Z +dz;
    end
end
% STATION COORDINATES IN ECEF
mers_station_coor = [X; Y; Z];

output_text = sprintf('STATION COORDINATES IN ECEF', mers_station_coor);
fprintf('%s\n', output_text);

% For accuracy, IGS Coordinates, given project assignment
IGS=[ 4239149.205; 2886968.037; 3778877.204];
ground_truth = sqrt((mers_station_coor(1) - IGS(1))^2+ (mers_station_coor(2) - IGS(2))^2 + (mers_station_coor(3) - IGS(3))^2)

% Command Window For Results;
%last_project(C1,SP3,doy,trec,trecw,rec,alpha,beta,TGD)