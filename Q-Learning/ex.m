A = zeros(4,4,4)
A(1,1,1) = 1;
A(1,1,2) = 2;
A(1,1,3) = 1;
A(1,1,4) = 2;
B = A(1,1,:)
max_q = max(B)
max_idx = find(max_q==B)
random_idx = randi(length(max_idx))
next_state_q = A(1,1,max_idx(random_idx))


% max_q = max(next_state_q_set);
%             max_idx = find(max_q == next_state_q_set);
%             random_idx = randi(length(max_idx));
%             next_state_q = max_idx(random_idx);