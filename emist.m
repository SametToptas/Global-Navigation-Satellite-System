% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023

function [tems] = emist(trec,pc,clk)

c = 299792458; % Velocity of light (m/s)
dt = pc/c; % dt is t_reception - t_emission - pc = P

sat_t_emist = trec - dt; % time of signal transmission (satellite clock) trec = treception
sat_clock_correction = lagrange(sat_t_emist,clk); % 𝛿𝑡_𝑠𝑎t - (Reception time and satellite clock corrections)

tems = sat_t_emist - sat_clock_correction; % The signal emission time (Seconds of the day)
end