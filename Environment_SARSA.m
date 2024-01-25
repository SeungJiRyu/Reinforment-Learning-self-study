classdef Environment_SARSA
    properties
        row (1,1) int16 = 4
        column (1,1) int16 = 4
        StateX (1,1) int16  = 1
        StateY (1,1) int16  = 1
        done (1,1) int16 = 0
    end
    
    methods
        % Constructor of Environment 
        function e = Environment_SARSA(r,c,x,y,done)
            e.row = r;
            e.column = c;
            e.StateX = x;
            e.StateY = y;
            e.done = done;
        end

        % move according to action 'a' and return next coordinates
        function [x,y] = move_step(e,a)
            arguments
                e Environment_SARSA
                a {mustBeMember(a,[0,1,2,3])}  % Represent up,down,left,right in order
            end
            if a == 0 % up
                [a,b] = e.move_up();
            elseif a == 1 % down
                [a,b] = e.move_down();
            elseif a == 2 % left
                [a,b] = e.move_left();
            else
                [a,b] = e.move_right();
            end
            x = a; y = b;
        end

        function [x,y] = move_up(e)
            e.StateX = e.StateX - 1;
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_down(e)
            e.StateX = e.StateX + 1;
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_left(e)
            e.StateY = e.StateY - 1;
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_right(e)
            e.StateY = e.StateY + 1;
            x = e.StateX; y = e.StateY;
        end

        function bool = is_done(e)
            if (e.StateX == e.row) && (e.StateY == e.column)
                e.done = 1;
            else
                e.done = 0;
            end
            bool = e.done;
        end
        
        % return present coordinates
        function [x,y] = get_state(e)
            x = e.StateX;
            y = e.StateY;
        end

        function e = reset(e)
            e.StateX = 1;
            e.StateY = 1;
            e.done = 0;
        end
    end
end
