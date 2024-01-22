clear
close all
clc

% Enter table size value
row = 4;
col = 4;

env = Environment(row,col,1,1,0);

state_transition_prob = 1;
discount_factor = 0.8;
value_table = zeros(row,col);
step_size = 0.001; % alpha
history = []; % matrix for calculating return Gt

k = 1000; % The number of iterations

% Episode Iterations : k times
for i = 1:k
    % Initialize environment coordinate
    env = env.reset();

    % Sampling
    while ~(env.is_done)
        % Take random action
        random_action = select_action();
        [next_x, next_y] = env.move_step(random_action);
        % Determine reward function
        if (next_x == col) && (next_y == row)
            reward = 0;
        else
            reward = -1;
        end
        % Store episodes
        history = [history ; [next_x, next_y, reward]];
        % Update state x and y
        env.StateX = next_x; env.StateY = next_y;
    end
    
    % Monte-Carlo Algorithm
    [row_num,col_num] = size(history);
    cum_reward = 0;
    for j = 1:row_num
        x = history(row_num-j+1,1); y = history(row_num-j+1,2);
        if ~((x == row)&&(y == col))
            value_table(x,y) = value_table(x,y) + step_size * (cum_reward - value_table(x,y));
        else
            value_table(x,y) = 0;
        end

        % Determine reward function
        if (x == col) && (y == row)
            reward = 0;
        else
            reward = -1;
        end
        cum_reward = cum_reward + discount_factor * reward;
    end
end

disp("              <A Value table>")
disp(value_table)

% Policy Improvement using Monte-Carlo Algorithm
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

        % Greedy policy Improvement(solving Bellman expectation equation)
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

Visualize_Policy_table(row,col,value_table);

% Make random action(policy = 0.25)
function a = select_action()
    x = rand;
    if x < 0.25
        a = 0;
    elseif (x >= 0.25) && (x < 0.5)
        a = 1;
    elseif (x >= 0.5) && (x < 0.75)
        a = 2;
    else
        a = 3;
    end
end



