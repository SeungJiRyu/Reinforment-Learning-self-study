clear
close all
clc

format long % Increase the number of significant figures

% Initialize initial environment model
row = 5;
col = 7;
step_size = 0.1; % alpha 
discount_factor = 0.9; % gamma
epsilon = 0.9;

% Define the grid world map making wall
wall_table = zeros(row,col);
wall = 1;

% Situation1
wall_table(1,3) = wall; 
wall_table(2,3) = wall;
wall_table(3,3) = wall;
wall_table(3,5) = wall;
wall_table(4,5) = wall;
wall_table(5,5) = wall;

% % Situation2
% wall_table(3,1) = wall; 
% wall_table(3,2) = wall;
% wall_table(3,3) = wall;
% wall_table(3,3) = wall;
% wall_table(1,6) = wall;
% wall_table(2,6) = wall;
% wall_table(3,6) = wall;
% wall_table(5,4) = wall;
% wall_table(5,5) = wall;

% % Check for the number of visiting
% num1 = 0; num2 = 0; num3 = 0;

destination = 10; % fix
x_destination = 5;
y_destination = 7;
reward_table(x_destination,y_destination) = destination;
wall_table(x_destination,y_destination) = destination;

env = Environment_qlearning(row,col,1,1,0,wall_table,x_destination,y_destination);
action = 0;
agent = Agent_qlearning(row,col,step_size,action,discount_factor,epsilon);


% Episode : 2000 times
k = 10000;
q_values_state_up = zeros(1,k);
q_values_state_down = zeros(1,k);
q_values_state_left = zeros(1,k);
q_values_state_right = zeros(1,k);
total_reward_table = zeros(1,k);

for episode = 1:k
    env = env.reset();
    agent.action = select_action();
    total_reward = 0;
    while ~(env.is_done)
        % % Check for the number of visiting
        % if env.StateX == 1 && env.StateY == 4
        %     num1 = num1 + 1;
        % end
        % if env.StateX == 5 && env.StateY == 3
        %     num2 = num2 + 1;
        % end
        % if env.StateX == 4 && env.StateY == 3
        %     num3 = num3 + 1;
        % end

        [next_StateX, next_StateY] = env.move_step(agent.action); % S'
        reward = -1; % R
        total_reward = total_reward + reward;
        total_reward_table(episode) = total_reward;
        
        % update q-functions with sample <S,A,R,S'>
        agent.q_table = agent.learning(env.StateX,env.StateY,agent.action,reward,next_StateX,next_StateY);
        env.StateX = next_StateX; env.StateY = next_StateY;
        
        % select action using epsilon-greedy policy
        next_action = epsilon_greedy_policy(env.StateX,env.StateY,agent,epsilon); % A'
        agent.action = next_action;
    end
    if epsilon > 0.2
        epsilon = epsilon - 0.001;
        agent.epsilon = epsilon;
    end

    % for debugging
    if rem(episode,30000) == 0
        Visualize_selected_policy_qlearning(agent,wall_table,wall,destination)
    end

    % Store Q-value for state (p,q,:)
    p = 3; q = 4;
    q_values_state_up(episode) = agent.q_table(p, q, 1);
    q_values_state_down(episode) = agent.q_table(p, q, 2);
    q_values_state_left(episode) = agent.q_table(p, q, 3);
    q_values_state_right(episode) = agent.q_table(p, q, 4);
end

% % Check for comparing Q-values of one state
% Plot Q-values for state (p,q,:) over episodes
% figure;
% plot(1:k, q_values_state_up, ...
%     1:k, q_values_state_down, ...
%     1:k, q_values_state_left, ...
%     1:k,q_values_state_right);
% xlabel('Episode');
% ylabel('Q-Value for state (p,q,:)');
% title('Q-Value for state (p,q,:) over Episodes');
% legend('Up','Down','Left','Right')

% % The nuumber of visiting plotting
% disp(agent.q_table)
% Visualize_selected_policy_qlearning(agent,wall_table,wall,destination)
% disp('(1,4):')
% disp(num1)
% disp('(5,3):')
% disp(num2)
% disp('(4,3):')
% disp(num3)

% Total reward plotting
figure;
plot(1:k,total_reward_table);
xlabel('Episode');
ylabel('Total reward');
title('Total reward over Episodes');


% Make random action(policy = 0.25)
function a = select_action()
    a = fix(rand*4)+1;
end

% Sampling with epsilon greedy policy
function a = epsilon_greedy_policy(StateX,StateY,agent,epsilon)
    arguments
        StateX (1,1) double
        StateY (1,1) double
        agent Agent_qlearning
        epsilon (1,1) double
    end
    r = rand;
    % return random action
    if r < epsilon
        a = fix(rand*4)+1;
    else
        % Select epsilon greedy policy
        q_table = agent.q_table(StateX,StateY,:);
        max_q = max(q_table);
        % prevent situation when same q-values exist
        max_idx = find(max_q == q_table);
        random_idx = randi(length(max_idx));
        a = max_idx(random_idx);
    end
end