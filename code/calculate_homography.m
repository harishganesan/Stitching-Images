function [model] = calculate_homography(x,y)
        Y = [];
        l = size(x,1);
        for i = 1:l
            pt1 = x(i,:);
            pt2 = y(i,:);
            Y_i = [ zeros(1,3)  ,   -pt1     ,   pt2(2)*pt1;
                        pt1      , zeros(1,3),   -pt2(1)*pt1];
            Y = [Y; Y_i];        
        end
        [~,~,e] = svd(Y);
        h = e(:,9);
        model = reshape(h, 3, 3);
        model = model ./ model(3,3);
end