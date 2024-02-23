clear
close all
clc

% Initialize initial environment model
row = 5;
col = 7;
step_size = 0.01; % alpha
discount_factor = 1; % gamma
epsilon = 0.9;

% Define the grid world map making wall
wall_table = zeros(row,col);
wall = 1;
% % Situation1
% wall_table(1,3) = wall; 
% wall_table(2,3) = wall;
% wall_table(3,3) = wall;
% wall_table(3,5) = wall;
% wall_table(4,5) = wall;
% wall_table(5,5) = wall;

% Situation2
wall_table(3,1) = wall; 
wall_table(3,2) = wall;
wall_table(3,3) = wall;
wall_table(3,3) = wall;
wall_table(1,6) = wall;
wall_table(2,6) = wall;
wall_table(3,6) = wall;
wall_table(5,4) = wall;
wall_table(5,5) = wall;

reward_table = ones(row,col) * -1;
destination = 100; % fix
x_destination = 5;
y_destination = 2;
reward_table(x_destination,y_destination) = destination;
wall_table(x_destination,y_destination) = destination;

env = Environment_SARSA(row,col,1,1,0,wall_table,x_destination,y_destination);
action = 0;
agent = Agent_SARSA(row,col,step_size,action,discount_factor,epsilon);

% Episode : 2000 times
for episode = 1:3000
    env = env.reset();
    agent.action = select_action();
    while ~(env.is_done)
        [next_StateX,next_StateY] = move_step(env,agent.action); % S'
        reward = reward_table(next_StateX,next_StateY); % R
        next_action = epsilon_greedy_policy(env.StateX,env.StateY,agent,epsilon); % A'

        % update q-functions with sample <S,A,R,S',A'>
        agent.q_table = agent.learning(env.StateX,env.StateY,agent.action,reward,next_StateX,next_StateY,next_action);
        env.StateX = next_StateX; env.StateY = next_StateY;
        agent.action = next_action;
    end
    if epsilon > 0.1
        epsilon = epsilon - 0.0003;
        agent.epsilon = epsilon;
    end
end
disp(agent.q_table)
Visualize_selected_policy_SARSA(agent,wall_table,wall,destination)

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

% Sampling with epsilon greedy policy
function a = epsilon_greedy_policy(StateX,StateY,agent,epsilon)
    arguments
        StateX (1,1) double
        StateY (1,1) double
        agent Agent_SARSA
        epsilon (1,1) double
    end
    r = rand;
    % return random action
    if r < epsilon
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
    else
        % Select epsilon greedy policy
        q_table = agent.q_table(StateX,StateY,:);
        max_q = max(q_table);
        % prevent situation when same q values exist
        max_idx = find(max_q == q_table);
        random_dix = randi(length(max_idx));
        q_idx = max_idx(random_dix);

        a = q_idx - 1; % convert index for matching action(0,1,2,3)
    end
end