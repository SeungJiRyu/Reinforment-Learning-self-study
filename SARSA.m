clear
close all
clc

% Initialize initial environment model
row = 5;
col = 7;
step_size = 0.01;
discount_factor = 1;
epsilon = 0.9;

% Define the gril world map
reward_table = ones(row,col) * -1;
wall = -10000;
reward_table(1,3) = wall; 
reward_table(2,3) = wall;
reward_table(3,3) = wall;
reward_table(3,5) = wall;
reward_table(4,5) = wall;
reward_table(5,5) = wall;
% reward_table(1,3) = wall;
% reward_table(1,4) = wall;
% reward_table(1,5) = wall;
% reward_table(5,3) = wall;
% reward_table(5,4) = wall; 
% reward_table(5,5) = wall;
destination = 0;
reward_table(5,7) = destination; % destination

env = Environment_SARSA(row,col,1,1,0);
action = 0;
agent = SARSA_Agent(row,col,step_size,action,discount_factor,epsilon);

% Episode : 1000 times
for episode = 1:1000
    env = env.reset();
    agent.action = select_action();
    while ~(env.is_done)
        [next_StateX,next_StateY] = move_step(env,agent.action); % S'
        % make the boundary of grid world into a wall
        if next_StateX == 0 | next_StateY == 0 | next_StateX >= row | next_StateY >= col
            reward = wall;
        else
            reward = reward_table(next_StateX,next_StateY); % R
        end
        [next_StateX_correct,next_StateY_correct] = correct_coordinate(next_StateX,next_StateY,row,col);
        next_action = epsilon_greedy_policy(env.StateX,env.StateY,agent,epsilon); % A'

        % update q-functions with sample <S,A,R,S',A'>
        agent.q_table = agent.learning(env.StateX,env.StateY,agent.action,reward,next_StateX_correct,next_StateY_correct,next_action);
        env.StateX = next_StateX_correct; env.StateY = next_StateY_correct;
        agent.action = next_action;
    end
    % if epsilon > 0.1
    %     epsilon = epsilon - 0.03;
    %     agent.epsilon = epsilon;
    % end
end
disp(agent.q_table)
Visualize_selected_policy_SARSA(agent,reward_table,wall)

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
        agent SARSA_Agent
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
        q_table = [agent.q_table(StateX,StateY,1) ; agent.q_table(StateX,StateY,2); agent.q_table(StateX,StateY,3); agent.q_table(StateX,StateY,4)];
        max_q = max(q_table);
        max_idx = find(max_q == q_table);
        random_dix = randi(length(max_idx));
        q_idx = max_idx(random_dix);
        a = q_idx - 1;
    end
end