img1_c = imread('../data/part1/uttower/left.jpg');
img2_c = imread('../data/part1/uttower/right.jpg');

img1 = rgb2gray(img1_c);
img2 = rgb2gray(img2_c);

img1 = im2double(img1);
img2 = im2double(img2);


[~ , widthImg1] = size(img1);
[~ , widthImg2] = size(img2);

[feat_1, r1, c1] = harris(img1,2,0.0035,1,1);
[feat_2, r2, c2] = harris(img2,2,0.0035,1,1);

r=20;
n = 150;
rand_pix = 4;
dist_inlier = 10;
ratio_min_inlier = 0.3;

flat_1 = flatten(img1, r1, c1, r);
flat_2 = flatten(img2, r2, c2, r);

dist = dist2(flat_1, flat_2);

[~,distance_id] = sort(dist(:), 'ascend');
number_matches = 150;
top_150 = distance_id(1:number_matches);

[img1_indices, img2_indices] = ind2sub(size(dist), top_150);

match_rL = r1(img1_indices);
match_cL = c1(img1_indices);
match_rR = r2(img2_indices);
match_cR = c2(img2_indices);

homo_1 = [match_cL, match_rL, ones(150,1)];
homo_2 = [match_cR, match_rR, ones(150,1)];

visualize1(img1_c, img2_c,  match_rL, match_rR, match_cL, match_cR);

visualize2(img1_c,img2_c,match_rL, match_rR, match_cR, match_cL);

[H, indices_inlier] = ransac_1(n, rand_pix, dist_inlier,ratio_min_inlier, homo_1, homo_2);

display('No. of inliers:');
display(length(indices_inlier));
display('Avg residual for inliers:')
display(mean(residual_error(H, homo_1(indices_inlier,:), homo_2(indices_inlier,:))));


% For warping first image
H_t = maketform('projective', H);
img11 = imtransform(img1_c, H_t);
figure, imshow(img11);title('Image upon warping');

% For stitching images
combined_img = combine(img1_c, img2_c, H);
figure, imshow(combined_img);
title('Combined picture after stitching');