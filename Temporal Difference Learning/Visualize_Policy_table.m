function Visualize_Policy_table(row,col,value_table)
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

            % Using Greedy policy Improvement(solving Bellman expectation equation)
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
end