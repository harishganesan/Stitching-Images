function [ F, indices_inlier ] = ransac_2(n, rand_pix, dist_inlier, ratio_min_inlier, normalize, matches)

    [number_matches, ~] = size(matches);
    n_inliers = zeros(n,1);
    s = {};
    
    for i = 1 : n;

        samp = randsample(number_matches, rand_pix);
        matches_subset = matches(samp, :);
        model = calculate_fundamental(matches_subset,normalize);
            
       r_error = calc_residuals(model, matches);
       indices_inlier = find(r_error < dist_inlier);      
       n_inliers(i) = length(indices_inlier);
       c_ratio = n_inliers(i)/number_matches;
       
       if c_ratio >=  ratio_min_inlier
            matches_inliers = matches(indices_inlier, :);
            s{i} = calculate_fundamental(matches_inliers,normalize);
    end
    
    max_val = find(n_inliers == max(n_inliers));
    max_val = max_val(1);
    F = s{max_val};
    

    r_error = calc_residuals(F, matches);
    indices_inlier = find(r_error < dist_inlier);
end