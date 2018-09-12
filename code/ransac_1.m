function [ H, indices_inlier ] = ransac_1(n, rand_pix, dist_inlier, ratio_min_inlier, x, y)

    [number_matches, ~] = size(x);
    n_inliers = zeros(n,1);

    s1 = {};
    for i = 1 : n
        samp = randsample(number_matches, rand_pix);
        x_subset = x(samp, :);
        y_subset = y(samp, :);
        
        model = calculate_homography(x_subset,y_subset);
        
        r_error = residual_error(model, x, y);
        
        indices_inlier = find(r_error < dist_inlier);      


        n_inliers(i) = length(indices_inlier);
      
        c_ratio = n_inliers(i)/number_matches;
        if c_ratio >=  ratio_min_inlier
            x_inliers = x(indices_inlier, :);
            y_inliers = y(indices_inlier, :);
            s1{i} = calculate_homography(x_inliers,y_inliers);
        end
        
    end    %end for
    
    max_val = find(n_inliers == max(n_inliers));
    max_val = max_val(1);
    H = s1{max_val};

    r_error = residual_error(H, x, y);
    indices_inlier = find(r_error < dist_inlier);
end