function [ f_desp ] = flatten( img, row, col, radius )

    no_f = length(row);
    f_desp = zeros(no_f, (2 * radius + 1)^2);

    p = zeros(2 * radius + 1); 
    p(radius + 1, radius + 1) = 1;

    p_img = imfilter(img, p, 'replicate', 'full');

    for i = 1 : no_f
        rr = row(i) : row(i) + 2 * radius;
        cc = col(i) : col(i) + 2 * radius;
        nhood = p_img(rr, cc);
        flat = nhood(:);
        f_desp(i,:) = flat;
    end
    f_desp = zscore(f_desp')';
end
