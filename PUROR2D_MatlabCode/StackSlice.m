function [ unwrapped_phase_x, unwrapped_phase_y ] = StackSlice(unwrapped_phase_x, unwrapped_phase_y,~, mask4stack)
    
    unwrapped_phase_x = StackSlice_int(unwrapped_phase_x, mask4stack);
    unwrapped_phase_y = StackSlice_int(unwrapped_phase_y, mask4stack);
    
end

function [phase] = StackSlice_int(phase, mask)
    
    nSlices     = size(phase,3);
    slice_means = zeros(1,nSlices);
    
    for index_slice = 1:nSlices
        
        slice_mask  = mask(:,:,index_slice);
        
        slice_phase = phase(:,:,index_slice);
        
        mean_phase  = mean(slice_phase(slice_mask==1));
        
        %Should be slice specific? left to keep agreement with original
        phase       = phase - mround(mean_phase);
        
        slice_means(index_slice) = mean_phase - mround(mean_phase);
        
    end
    
    slice_centre = round(nSlices/2);
    
    unwrapped_means = unwrap(slice_means);
    diff_means      = unwrapped_means - slice_means;
    diff_means      = diff_means-mround(unwrapped_means(slice_centre));
    
    for index_slice = 1:nSlices
        phase(:,:,index_slice) = phase(:,:,index_slice) + diff_means(index_slice);
    end
    
end


function [rounded] = mround(toround)
    rounded = 2*pi*round(toround/pi/2);
end
