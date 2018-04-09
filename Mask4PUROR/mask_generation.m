function [mask4unwrap, mask4supp, mask4stack] = mask_generation(complex_image,noise_threshold,unwrap_threshold,support_threshold,stack_threshold)
    
    matrix_size = size(complex_image);
    
    if length(matrix_size) == 2
        matrix_size(3) = 1;
    end
    
    H = fspecial('gaussian',3);
    
    mask4unwrap = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    mask4supp = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    mask4stack = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    
    for index_slice = 1:matrix_size(3)
        background_noise = noise_threshold(index_slice);
        
        complex_tmp = complex_image(:,:,index_slice);
        mag_original = abs(complex_tmp);
        mask_tmp = ones(matrix_size(1),matrix_size(2));
        mask_tmp(mag_original < background_noise*stack_threshold) = 0;
        mask4stack(:,:,index_slice) = mask_tmp;
        
        complex_tmp = imfilter(complex_tmp,H);
        complex_tmp(isnan(complex_tmp)) = 0;
        mag_original = abs(complex_tmp);
        mask_tmp_0 = ones(matrix_size(1),matrix_size(2));
        mask_tmp_0(mag_original < background_noise*unwrap_threshold) = 0;
        mask4unwrap(:,:,index_slice) = mask_tmp_0;
        
        mask_tmp = ones(matrix_size(1),matrix_size(2));
        mask_tmp(mag_original < background_noise*support_threshold) = 0;
        mask_tmp(mask_tmp_0 == 0) = 0;
        mask4supp(:,:,index_slice) = mask_tmp;
    end
end
