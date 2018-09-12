function [ rank2_mat ] = rank_2_constraint( mat )
    [U, S, V] = svd(mat);
    S(end) = 0;
    rank2_mat = U*S*V';
end