classdef Environment
    properties
        row (1,1) int16 
        column (1,1) int16
        StateX (1,1) int16  = 1
        StateY (1,1) int16  = 1
        done (1,1) int16 = 0
    end
    
    methods
        % Constructor of Environment 
        function e = Environment(r,c,x,y,done)
            e.row = r;
            e.column = c;
            e.StateX = x;
            e.StateY = y;
            e.done = done;
        end

        % move according to action 'a' and return next coordinates
        function [x,y] = move_step(e,a)
            arguments
                e Environment
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
            if e.StateX >= 2
                e.StateX = e.StateX - 1;
            else
                e.StateX = 1;
            end
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_down(e)
            if e.StateX <= e.row-1
                e.StateX = e.StateX + 1;
            else
                e.StateX = e.row;
            end
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_left(e)
            if e.StateY >= 2
                e.StateY = e.StateY - 1;
            else
                e.StateY = 1;
            end
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_right(e)
            if e.StateY <= e.column - 1
                e.StateY = e.StateY + 1;
            else
                e.StateY = e.column;
            end
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
