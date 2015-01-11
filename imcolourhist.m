function [out] = imcolourhist(im, num_red_bins, num_green_bins, num_blue_bins)

    im = double(im); 
    total_bins = num_red_bins*num_green_bins*num_blue_bins;
    red_level = 256 / num_red_bins;
    green_level = 256 / num_green_bins;
    blue_level = 256 / num_blue_bins;
    im_red_levels = floor(im(:,:,1) / red_level);
    im_green_levels = floor(im(:,:,2) / green_level);
    im_blue_levels = floor(im(:,:,3) / blue_level);
    ind = im_blue_levels*num_red_bins*num_green_bins + im_green_levels*num_red_bins + im_red_levels;
    ind = ind(:); 
    out = accumarray(ind+1, 1, [total_bins 1]);
end