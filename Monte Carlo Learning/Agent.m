classdef Agent
    properties
        x
        y
    end

    methods
        function a = Agent(x,y)
            a.x = x;
            a.y = y;
        end
        function a = x_plus(a,k)
            a.x = a.x + k;
            a = a;

        end
    end
end