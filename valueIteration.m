clear
close all
clc

global row
global col

% Enter table size value
row = 4;
col = 4;

env = Environment(row,col,1,1,0);

state_transition_prob = 1;
discount_factor = 1;
value_table = zeros(row,col);

% Episode iterations
for k = 1:6
    % Initialize environment coordinate
    env = env.reset();
    
    % Value Iteration
    while ~(env.is_done)
        next_value_table = zeros(col,row);
        for i = 1:row
            for j = 1:col
                % Value_function_list for max
                value_function_list = [-99999];
                % Policy Evaluation
                for action = [0,1,2,3]
                    env.StateX = i;
                    env.StateY = j;
                    [next_x,next_y] = env.move_step(action);

                    % Calculate reward
                    if (i == row) && (j == col)
                        reward = 0;
                    else
                        reward = -1;
                    end

                    value_function_list = [value_function_list, (reward + discount_factor*state_transition_prob ...
                         *value_table(next_x,next_y))];
                end

                % Value Iteration : Solving 'Bellman Optimality Equation'
                next_value_table(i,j) = max(value_function_list) ;
            end
        end
        next_value_table(row,col) = 0;
        value_table = next_value_table;
    end
end
disp("              <A Value table>")
disp(value_table)



% function a = select_action()
%     x = rand;
%     if x < 0.25
%         a = 0;
%     elseif (x >= 0.25) && (x < 0.5)
%         a = 1;
%     elseif (x >= 0.5) && (x < 0.75)
%         a = 2;
%     else
%         a = 3;
%     end
% end