function [mask4unwrap, mask4supp, mask4stack] = mask_generation(complex_image,noise_threshold,unwrap_threshold,support_threshold,stack_threshold)
    
    matrix_size = size(complex_image);
    
    if length(matrix_size) == 2
        matrix_size(3) = 1;
    end
    
    H = fspecial('gaussian',3);
    
    mask4unwrap = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    mask4supp   = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    mask4stack  = zeros(matrix_size(1),matrix_size(2),matrix_size(3));
    
    mag_original = abs(complex_image);
    
    filtered_complex = imfilter(complex_image,H);
    filtered_mag     = abs(filtered_complex);
    
    for index_slice = 1:matrix_size(3)
        
        background_noise = noise_threshold(index_slice);
        mask4unwrap(:,:,index_slice) = filtered_mag(:,:,index_slice) >= background_noise*unwrap_threshold;
        mask4supp(:,:,index_slice)   = filtered_mag(:,:,index_slice) >= background_noise*support_threshold;
        mask4stack(:,:,index_slice)  = mag_original(:,:,index_slice) >= background_noise*stack_threshold;
        
    end
    
    if unwrap_threshold > support_threshold
        warning('Unwrap threshold should not be higher than support threshold. Removing pixels from support mask.')
        mask4supp(mask4unwrap==0)=0;
    end
    
end
