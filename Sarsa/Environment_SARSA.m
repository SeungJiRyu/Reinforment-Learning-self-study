classdef Environment_SARSA
    properties
        row (1,1) int16
        col (1,1) int16
        StateX (1,1) int16  = 1
        StateY (1,1) int16  = 1
        done (1,1) int16 = 0
        wall_table
        x_destination (1,1) int16
        y_destination (1,1) int16
    end

    methods
        % Constructor of Environment
        function e = Environment_SARSA(r,c,x,y,done,wall_table,x_destination,y_destination)
            e.row = r;
            e.col = c;
            e.StateX = x;
            e.StateY = y;
            e.done = done;
            e.wall_table = wall_table;
            e.x_destination = x_destination;
            e.y_destination = y_destination;
        end

        % move according to action 'a' and return next coordinates
        % agent can't go to state which has wall
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
            prev_StateX = e.StateX; prev_StateY = e.StateY;
            if e.StateX >= 2
                e.StateX = e.StateX - 1;
                breaker = false;
                % agent can move to state which has wall
                for i = 1:e.row
                    for j = 1:e.col
                        if e.wall_table(i,j) == 1
                            if i == e.StateX && j == e.StateY
                                e.StateX = prev_StateX; e.StateY = prev_StateY;
                                breaker = true;
                                break
                            end
                        end
                    end
                    if breaker == true
                        break
                    end
                end
            else
                e.StateX = 1;
            end

            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_down(e)
            prev_StateX = e.StateX; prev_StateY = e.StateY;
            if e.StateX <= e.row-1
                e.StateX = e.StateX + 1;
                breaker = false;
                % agent can move to state which has wall
                for i = 1:e.row
                    for j = 1:e.col
                        if e.wall_table(i,j) == 1
                            if i == e.StateX && j == e.StateY
                                e.StateX = prev_StateX; e.StateY = prev_StateY;
                                breaker = true;
                                break
                            end
                        end
                    end
                    if breaker == true
                        break
                    end
                end

            else
                e.StateX = e.row;
            end

            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_left(e)
            prev_StateX = e.StateX; prev_StateY = e.StateY;
            if e.StateY >= 2
                e.StateY = e.StateY - 1;
                breaker = false;
                % agent can move to state which has wall
                for i = 1:e.row
                    for j = 1:e.col
                        if e.wall_table(i,j) == 1
                            if i == e.StateX && j == e.StateY
                                e.StateX = prev_StateX; e.StateY = prev_StateY;
                                breaker = true;
                                break
                            end
                        end
                    end
                    if breaker == true
                        break
                    end
                end
            else
                e.StateY = 1;
            end
            x = e.StateX; y = e.StateY;
        end

        function [x,y] = move_right(e)
            prev_StateX = e.StateX; prev_StateY = e.StateY;
            if e.StateY <= e.col - 1
                e.StateY = e.StateY + 1;
                breaker = false;
                % agent can move to state which has wall
                for i = 1:e.row
                    for j = 1:e.col
                        if e.wall_table(i,j) == 1
                            if i == e.StateX && j == e.StateY
                                e.StateX = prev_StateX; e.StateY = prev_StateY;
                                breaker = true;
                                break
                            end
                        end
                    end
                    if breaker == true
                        break
                    end
                end
            else
                e.StateY = e.col;
            end

            x = e.StateX; y = e.StateY;
        end

        function bool = is_done(e)
            if (e.StateX == e.x_destination) && (e.StateY == e.y_destination)
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
