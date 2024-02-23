clear
close all
clc

% Find value of pi using Monte-Carlo approximation(x^2 + y^2 = 1)
format long

% The number of iteration
total_num = 10000000;
sample_num = 0;

% Monte-Carlo approximation
for i = 1:total_num
    % Coordinate components
    x = rand;
    y = rand;
    sample = x^2 + y^2;
    if (sample <= 1)
        sample_num = sample_num + 1;
    end
end

pi = sample_num/total_num * 4;

disp("if the number of total iteration is")
disp(total_num)
disp(", pi is ")
disp(pi)