function [comp] = combine(img1, img2, H)

    [h1, w1, n1] = size(img1);
    [h2, w2, n2] = size(img2);
    
    c = [ 1 1 1; w1 1 1; w1 h1 1; 1 h1 1];
            
    warp = homo_2_cart( c * H );
    X_min = min( min(warp(:,1)), 1);
    X_max = max( max(warp(:,1)), w2);
    Y_min = min( min(warp(:,2)), 1);
    Y_max = max( max(warp(:,2)), h2);

    
    x_range = X_min : X_max;
    y_range = Y_min : Y_max;

    [x,y] = meshgrid(x_range,y_range) ;
    H_inverse = inv(H);

    w = H_inverse(1,3) * x + H_inverse(2,3) * y + H_inverse(3,3);
    warpX = (H_inverse(1,1) * x + H_inverse(2,1) * y + H_inverse(3,1)) ./ w ;
    warpY = (H_inverse(1,2) * x + H_inverse(2,2) * y + H_inverse(3,2)) ./ w ;


    if n1 == 1
        
        b_1 = interp2( im2double(img1), warpX, warpY, 'cubic') ;
        b_2 = interp2( im2double(img2), x, y, 'cubic') ;
    else
        
        b_1 = zeros(length(y_range), length(x_range), 3);
        b_2 = zeros(length(y_range), length(x_range), 3);
        for i = 1:3
            b_1(:,:,i) = interp2( im2double( img1(:,:,i)), warpX, warpY, 'cubic');
            b_2(:,:,i) = interp2( im2double( img2(:,:,i)), x, y, 'cubic');
        end
    end
    
    b = ~isnan(b_1) + ~isnan(b_2) ;
    
    b_1(isnan(b_1)) = 0 ;
    b_2(isnan(b_2)) = 0 ;
    
    comp = (b_1 + b_2) ./ b ;

end