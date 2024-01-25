classdef SARSA_Agent
    properties
        step_size (1,1) double = 0.01;
        action (1,1) int16
        discount_factor (1,1) double = 1;
        epsilon (1,1) double = 0.9;
        q_table
    end

    methods 
        function a = SARSA_Agent(row,col,step_size,action,discount_factor,epsilon)
            a.step_size = step_size;
            a.action = action;
            a.discount_factor = discount_factor;
            a.epsilon = epsilon;
            a.q_table = zeros(row,col,4);
        end

        function updated_q_table = learning(a,StateX,StateY,action,reward,next_StateX,next_StateY,next_action)
            arguments
                a SARSA_Agent
                StateX (1,1) int16
                StateY (1,1) int16
                action {mustBeMember(action,[0,1,2,3])}
                reward (1,1) double
                next_StateX (1,1) int16
                next_StateY (1,1) int16
                next_action {mustBeMember(next_action,[0,1,2,3])}
            end
            current_q = a.q_table(StateX,StateY,(action+1));
            next_state_q = a.q_table(next_StateX,next_StateY,(next_action+1));
            
            % Temporal Difference error
            td = reward + a.discount_factor*(next_state_q-current_q);
            new_q = current_q + a.step_size * td;
            a.q_table(StateX,StateY,(action+1)) = new_q;
            updated_q_table = a.q_table;
        end

    end
end