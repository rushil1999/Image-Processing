close all;
A  = imread('lenna.png');

%Since the algorithm only works for gray-scale, colour image is converted
%to gray-scale
A = rgb2gray(A);

%Image is reduced to make rows and column divisible by 8 for further
%processing
%Here pre-processing losses are incurred, which CANNOT be recovered
A = img_reduction(A);

%Data is generated for various qualities factors
for i = 1:50
    [B, error] = ImgCompression(A, i);
    %disp([i,1/i,error]);
    result(i,1) = i;
    result(i,2) = 1/i;
    result(i,3) = error;
    
    %{
    figure;
    imshow(A);

    figure;
    imshow(B);
    %}

    
end

