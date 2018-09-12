clear;
clc;
img1 = imread('../data/part2/house1.jpg');
img2 = imread('../data/part2/house2.jpg');
c1 = load('../data/part2/house1_camera.txt');
c2 = load('../data/part2/house2_camera.txt');
matches = load('../data/part2/house_matches.txt'); 

number_matches = size(matches,1);
normalize = true;
ground_truth = true;

visualize1(img1, img2,  matches(:,2), matches(:,4), matches(:,1), matches(:,3));

visualize3(img1, img2, matches);

n = 1000;
rand_pix = 8;
dist_inlier = 35;
ratio_min_inlier = 20/size(matches,1);

if (ground_truth)  
    display('Assuming matches are true');
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

else
    display('Calculating fundamental matrix');
    [F, indices_inlier] = ransac_2(n, rand_pix, dist_inlier, ratio_min_inlier, normalize, matches);
    display(['No. of inliers is: ', num2str(length(indices_inlier))]);
    display('Mean Residual of Inliers:');
    display(mean(calc_residuals(F,matches(indices_inlier,:))));
end

residuals = calc_residuals(F,matches);
display(['Mean residual: ' , num2str(mean(residuals))]);


L = (F * [matches(:,1:2) ones(number_matches,1)]')'; 

L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3);
pt_line_dist = sum(L .* [matches(:,3:4) ones(number_matches,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);


p1 = closest_pt - [L(:,2) -L(:,1)] * 10;
p2 = closest_pt + [L(:,2) -L(:,1)] * 10;

figure;
imshow(img2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([p1(:,1) p2(:,1)]', [p1(:,2) p2(:,2)]', 'Color', 'g');

[~, ~, V1] = svd(c1);
cc = V1(:,end);
c3 = homo_2_cart(cc');

[~, ~, V2] = svd(c2);
cc = V2(:,end);
c4 = homo_2_cart(cc');
 
x1 = cart_2_homo(matches(:,1:2));
x2 = cart_2_homo(matches(:,3:4));
number_matches = size(x1,1);
t_points = zeros(number_matches, 3);
proj_1 = zeros(number_matches, 2);
proj_2 = zeros(number_matches, 2);

for i = 1:number_matches
    p1 = x1(i,:);
    p2 = x2(i,:);
    c_mat1 = [  0   -p1(3)  p1(2); p1(3)   0   -p1(1); -p1(2)  p1(1)   0  ];
    c_mat2 = [  0   -p2(3)  p2(2); p2(3)   0   -p2(1); -p2(2)  p2(1)   0  ];    
    e = [ c_mat1*c1; c_mat2*c2 ];
    
    [~,~,V] = svd(e);
    t = V(:,end)'; 
    t_points(i,:) = homo_2_cart(t);
    proj_1(i,:) = homo_2_cart((c1 * t')');
    proj_2(i,:) = homo_2_cart((c2 * t')'); 
end

figure; axis equal;  hold on; 
plot3(-t_points(:,1), t_points(:,2), t_points(:,3), '.r');
plot3(-c3(1), c3(2), c3(3),'*g');
plot3(-c4(1), c4(2), c4(3),'*b');
grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;


d1 = diag(dist2(matches(:,1:2), proj_1));
d2 = diag(dist2(matches(:,3:4), proj_2));
display(['Mean Residual 1: ', num2str(mean(d1))]);
display(['Mean Residual 2: ', num2str(mean(d2))]);
