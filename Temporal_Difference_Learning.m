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
step_size = 0.001; % alpha

k = 1000; % The number of iterations

% Episode Iterations : k times
for i = 1:k
    % Initialize environment coordinate
    env = env.reset();

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
        % Temporal-Difference Error
        td = reward + discount_factor * value_table(next_x,next_y);
        % Temporal-Difference Algorithm
        value_table(env.StateX,env.StateY) = value_table(env.StateX,env.StateY) + step_size * ...
        (td - value_table(env.StateX,env.StateY));
        % Update state x and y
        env.StateX = next_x; env.StateY = next_y;
    end

end

disp("              <A Value table>")
disp(value_table)

% Policy Improvement using Monte-Carlo Algorithm
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