clear
close all
clc

global row
global col

% Enter table size value
row = 4;
col = 4;

env = Environment(row,col,1,1,0);

policy = 0.25;
state_transition_prob = 1;
discount_factor = 1;
value_table = zeros(row,col);

% Episode iterations : 1000 times
for k = 1:1000
    % Initialize environment coordinate
    env = env.reset();
    
    % Policy Evaluation
    while ~(env.is_done)
        next_value_table = zeros(col,row);
        for i = 1:row
            for j = 1:col
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

                    % Policy Evaluation
                    next_value_table(i,j) = next_value_table(i,j) + policy*(reward + discount_factor*state_transition_prob ...
                         *value_table(next_x,next_y));
                end
            end
        end
        next_value_table(row,col) = 0;
        value_table = next_value_table;
    end
end

disp("              <A Value table>")
disp(value_table)

% Policy Improvement
policy_table = string(zeros(row,col)); % initialize a string matrix
for i = 1:row
    for j = 1:col
        % Prevent contradiction related to coordinate boundary
        if i == 1
            i_minus_one = 1;
        else
            i_minus_one = i-1;
        end

        if j == 1
            j_minus_one = 1;
        else
            j_minus_one = j-1;
        end

        if i == row
            i_plus_one = row;
        else
            i_plus_one = i+1;
        end

        if j == col
            j_plus_one = col;
        else
            j_plus_one = j+1;
        end

        % Greedy policy Improvement(solving Bellman optimallity equation)
        if value_table(i_minus_one,j) > value_table(i_plus_one,j)
            policy_table_row = 0; % mean up
            row_value_big = value_table(i_minus_one,j); 
        else
            policy_table_row = 1; % mean down
            row_value_big = value_table(i_plus_one,j);
        end
        
        if value_table(i,j_minus_one) > value_table(i,j_plus_one)
            policy_table_col = 0; % mean left
            col_value_big = value_table(i,j_minus_one);
        else
            policy_table_col = 1; % mean right
            col_value_big = value_table(i,j_plus_one);
        end
        
        % Visulaization
        if abs(row_value_big - col_value_big) < 10^(-10) % same as (row_value_big == col_value_big)
            policy_table(i,j) = "↓→";
        elseif row_value_big > col_value_big
            if policy_table_row == 0
                policy_table(i,j) = "↑";
            else
                policy_table(i,j) = "↓";
            end
        else
            if policy_table_col == 0
                policy_table(i,j) = "←";
            else
                policy_table(i,j) = "→";
            end
        end
    end
end

policy_table(row,col)  = "-";
disp("              <A Policy table>")
disp(policy_table)

