function [ homogeneous_coordinates ] = cart_2_homo( cartesian_coordinates )
    [n, d] = size(cartesian_coordinates);
    homogeneous_coordinates = ones(n, d+1);
    homogeneous_coordinates(:,1 : d) = cartesian_coordinates(:,1:d);
    
end