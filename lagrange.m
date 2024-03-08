% Abdulsamet Toptaş (21905024)
% Epoch = (2 + 1 + 9 + 0 + 5 + 0 + 2 + 4)*750 s = 17250 s = 4 hrs 47 min 30sec
% for March 1, 2023
function [out] = lagrange(eph, dat)
    x = dat(:, 1); % Time Tags
    y = dat(:, 2); % X, Y, Z Coordinates at Reference Time
    n = numel(x); % Number of Data Points
    out = 0; % Initial value to hold the Interpolation result
    
    for i = 1:n
        term = 1; % Initial value to calculate each term
        
        for j = 1:n
            if i == j
                continue; % If i and j are equal, there is no need to calculate because the difference is zero
            else
                % Calculate the term of the Lagrangian polynomial
                term = term * (eph - x(j)) / (x(i) - x(j));
            end
        end
        
        % Multiply the calculated term by the y value at the reference point and add to the result
        out = out + term * y(i);
    end
end
