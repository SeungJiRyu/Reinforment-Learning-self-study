function Visualize_selected_policy_SARSA(agent,wall_table,wall,destination)
    [xidx,yidx,~] = size(agent.q_table);
    policy_table = string(zeros(xidx,yidx));
    for i = 1:xidx
        for j = 1:yidx
            if wall_table(i,j) == wall
                policy_table(i,j) = "◼";
            elseif wall_table(i,j) == destination
                policy_table(i,j) = "★";
            else
                if agent.q_table(i,j,1) > agent.q_table(i,j,2)
                    policy_col = 0; % mean up
                    col_value_big = agent.q_table(i,j,1);
                else 
                    policy_col = 1; % mean down
                    col_value_big = agent.q_table(i,j,2);
                end

                if agent.q_table(i,j,3) > agent.q_table(i,j,4)
                    policy_row = 0; % mean left
                    row_value_big = agent.q_table(i,j,3);
                else
                    policy_row = 1; % mean right\
                    row_value_big = agent.q_table(i,j,4);
                end

                if col_value_big == row_value_big
                    if (policy_col == 0) && (policy_row == 0)
                        policy_table(i,j) = "↑←";
                    elseif (policy_col == 0) && (policy_row == 1)
                        policy_table(i,j) = "↑→";
                    elseif (policy_col == 1) && (policy_row == 0)
                        policy_table(i,j) = "↓←";
                    else
                        policy_table(i,j) = "↓→";
                    end
                elseif col_value_big > row_value_big
                    if policy_col == 0
                        policy_table(i,j) = "↑";
                    else
                        policy_table(i,j) = "↓";
                    end
                else
                    if policy_row == 0
                        policy_table(i,j) = "←";
                    else
                        policy_table(i,j) = "→";
                    end
                end
            end
        end
    end
    disp("              <A Policy table>")
    disp(policy_table)
end



% 
%                 q_table_sample = [agent.q_table(i,4*j-3) ; agent.q_table(i,4*j-2); agent.q_table(i,4*j-1); agent.q_table(i,4*j)];
%                 [~,max_idx] = max(q_table_sample);
%                 if max_idx == 1 % up
%                     policy_table(i,j) = "↑";
%                 elseif max_idx == 2 % down
%                     policy_table(i,j) = "↓";
%                 elseif max_idx == 3 % left
%                     policy_table(i,j) = "←";
%                 else
%                     policy_table(i,j) = "→";
%                 end
%             end
%         end
%     end
%     policy_table(xidx,yidx)  = "★";
%     disp("              <A Policy table>")
%     disp(policy_table)
% end