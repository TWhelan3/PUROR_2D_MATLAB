function [noise_level] = NoiseEstimation(complex_image)
    
    noise_level = zeros(1, size(complex_image,3));
    
    %Record noise level as standard deviation of pixels in (0-5%] max range
    for index_slice = 1:length(noise_level)
        
        slice_mag = abs(complex_image(:,:,index_slice));
        
        mag_gray = mat2gray(slice_mag(:)); % NaN in slice_mag are 1 in mag_gray
        
        slice_mag(mag_gray > 0.05 | slice_mag(:) == 0) = [];
        
        noise_level(index_slice) = std(slice_mag);
        
    end
    
end
