function visualize2 (img1_c,img2_c,match_rL, match_rR, match_cR, match_cL)
    % for lines to connect dots
    widthImg1 = size(img1_c,2);
    number_matches = 150;
    plot_r = [match_rL, match_rR];
    plot_c = [match_cL, match_cR + widthImg1];
    figure; imshow([img1_c img2_c]); hold on; title('Mapping');
    hold on; 
    plot(match_cL, match_rL,'ys');
    plot(match_cR + widthImg1, match_rR, 'ys');
    for i = 1:number_matches
        plot(plot_c(i,:), plot_r(i,:));
    end

end