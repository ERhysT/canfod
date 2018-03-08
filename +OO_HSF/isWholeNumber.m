function whole_p = isWholeNumber(x)
% ISWHOLENUMBER - Check that the variable x (of class double) is a
% mathematical integer; that is that it is real and whole. Return is of class
% boolean.
    
    if ~isnumeric(x)

        error('Variable should be of class double');
    end

    if isreal(x) && rem(x, 1) == 0

        whole_p = true;
    else
        
        whole_p = false;
    end
end
