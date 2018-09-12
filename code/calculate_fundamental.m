function [F] = calculate_fundamentaal(matches,normalize)

        x1 = cart_2_homo( matches(:,1:2) );
        x2 = cart_2_homo( matches(:,3:4) );

        if normalize
            [t_1, x1_norm] = normalize_coordinates(x1);
            [t_2, x2_norm] = normalize_coordinates(x2);
            x1 = x1_norm;
            x2 = x2_norm;
        end

       u1 = x1(:,1);
       v1 = x1(:,2);
       u2 = x2(:,1);
       v2 = x2(:,2);

       temp = [ u2.*u1, u2.*v1, u2, v2.*u1, v2.*v1, v2, u1, v1, ones(size(matches,1), 1)];

       [~,~,V] = svd(temp);
       f_vec = V(:,9);

       F = reshape(f_vec, 3,3);
       F = rank_2_constraint(F);

       if normalize
           F = t_2' * F * t_1;
       end   
 end