function visualize1(img1_c, img2_c,  match_rL, match_rR, match_cL, match_cR)
    %for dots common
    widthImg1 = size(img1_c,2);
    figure; imshow([img1_c img2_c]); hold on; title('Matched points');
    hold on; plot(match_cL, match_rL,'ys'); plot(match_cR + widthImg1, match_rR, 'ys'); 
end