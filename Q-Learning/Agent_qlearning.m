classdef Agent_qlearning
    properties
        step_size (1,1) double
        action (1,1) int16
        discount_factor (1,1) double
        epsilon (1,1) double
        q_table
    end

    methods 
        function a = Agent_qlearning(row,col,step_size,action,discount_factor,epsilon)
            a.step_size = step_size;
            a.action = action;
            a.discount_factor = discount_factor;
            a.epsilon = epsilon;
            a.q_table = zeros(row,col,4);
        end

        function updated_q_table = learning(a,StateX,StateY,action,reward,next_StateX,next_StateY)
            arguments
                a Agent_qlearning
                StateX (1,1) int16
                StateY (1,1) int16
                action {mustBeMember(action,[1,2,3,4])}
                reward (1,1) double
                next_StateX (1,1) int16
                next_StateY (1,1) int16
            end

            %% solving Bellman optimal equation
            current_q = a.q_table(StateX,StateY,action);
            next_state_q_set = a.q_table(next_StateX,next_StateY,:);

            % using function 'max' for optimal q value(Max)
            max_q = max(next_state_q_set);
            max_idx = find(max_q == next_state_q_set);
            random_idx = randi(length(max_idx));
            next_state_q = a.q_table(next_StateX,next_StateY,random_idx);

            % Temporal Difference error
            td = reward + a.discount_factor*next_state_q-current_q;
            new_q = current_q + a.step_size * td;
            a.q_table(StateX,StateY,action) = new_q;
            updated_q_table = a.q_table;
        end

    end
end