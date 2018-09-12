function r = residual_error(H, homogeneous1, homogeneous2)
    t = homogeneous1 * H;
    l =  t(:,3);
    l_2 = homogeneous2(:,3);
    c_1 = t(:,1) ./ l - homogeneous2(:,1) ./ l_2;
    c_2 = t(:,2) ./ l - homogeneous2(:,2) ./ l_2;
    r = c_1 .* c_1 + c_2 .* c_2;
end