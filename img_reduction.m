function A_rev = img_reduction(A)
    %A = imread('compress.jpeg');


    %figure;
    %imshow(A);
    
    [row col z] = size(A);
    
    col_extra = mod(col,8);
    row_extra = mod(row, 8);
    
    %disp(col_extra);
    
    zero_mat = zeros(row, 8-col_extra, z);
    zero_mat_2 = zeros(8-row_extra, col+8-col_extra, z);
    
    A_add = [A zero_mat];
    A_add = [A_add ; zero_mat_2];
    %disp(A_new);
    
    
    
    A_rev = A(:,1:col-col_extra,:);
    A_rev = A_rev(1:row-row_extra,:,:);
    
    %figure;
    %imshow((A_rev));
end