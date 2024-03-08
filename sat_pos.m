% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023

function [fpos]=sat_pos(trec,pc,sp3,r_apr)
format longG

sp3(:,5) = sp3(:,5)*10^-6; % 10^-6 printing in second for satellite clock correction
tems = emist(trec, pc, sp3(:, [1, 5]));
spos = cal_sp3(tems,sp3);
r_sat = spos(1:3); % Satellite coordinates in ECEF at Emission Time

c = 299792458; %  Velocity of light (m/s)

% Differentation between Satellite position at Emission and Approx position
diff_x = r_sat(1,1)-r_apr(1,1);
diff_y = r_sat(2,1)-r_apr(2,1);
diff_z = r_sat(3,1)-r_apr(3,1);
% approximate position of the receiver
dt =sqrt((diff_x)^2+(diff_y)^2+(diff_z)^2) / (c);

we = 7.2921151467*10^(-5); % Earth's rotation rate in WGS84 (rad/s)

angle = we * dt;
R3 = [cos(angle),sin(angle),0; % Transformation Matrix
     -sin(angle),cos(angle),0; 
     0,0,1];

% Satellite coordinates in ECEF at Reception Time
rsat_final_coordinates = R3*r_sat;

% Emission time result with microsecond correction
%signal_emist = ['The signal emission time (Seconds of the day): ', num2str(tems)];
%fprintf('%s\n', signal_emist);

% Final Satellite Coordinates in ECEF with Units
fpos = rsat_final_coordinates(1:3, 1);
%output_text = sprintf('Final satellite "X" coordinates in ECEF = %.6f meters\nFinal satellite "Y" coordinates in ECEF = %.6f meters\nFinal satellite "Z" coordinates in ECEF = %.6f meters', fpos);
%fprintf('%s\n', output_text);
end