function [correct_x,correct_y] = correct_coordinate(x,y,row,col)
    if x > row
        x = x-1;
    elseif x == 0
        x = x + 1;
    end
    if y > col
        y = y-1;
    elseif y == 0
        y = y + 1;
    end
    correct_x = x; correct_y = y;
end