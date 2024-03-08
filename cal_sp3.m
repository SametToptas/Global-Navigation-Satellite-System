% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023
function [spos]=cal_sp3(eph,sp3)
format longG

x=lagrange(eph,sp3(:,[1,2]));
y=lagrange(eph,sp3(:,[1,3]));
z=lagrange(eph,sp3(:,[1,4]));

spos = [x;y;z]*(1000);
end