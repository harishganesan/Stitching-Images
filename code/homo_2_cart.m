function [cartesian_coordinates] = homo_2_cart(h)
    d = size(h, 2) - 1;
    normal_coordinates = bsxfun(@rdivide,h,h(:,end));
    cartesian_coordinates = normal_coordinates(:,1:d);
end
