function visualize3(img1,img2,matches);
    figure; imshow([img1 img2]); hold on;
    plot(matches(:,1), matches(:,2), '+r');
    plot(matches(:,3)+size(img1,2), matches(:,4), '+r');
    line([matches(:,1) matches(:,3) + size(img1,2)]', matches(:,[2 4])', 'Color', 'r');
end