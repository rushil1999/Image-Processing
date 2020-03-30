close all;
clear all;
A = imread('lenna.png');




A = rgb2gray(A);
figure;
imshow(A);
%disp(A);

quality = 50;

m = [16 11 10 16 24 40 51 61       
     12 12 14 19 26 58 60 55        
     14 13 16 24 40 57 69 56 
     14 17 22 29 51 87 80 62
     18 22 37 56 68 109 103 77
     24 35 55 64 81 104 113 92 
     49 64 78 87 103 121 120 101 
     72 92 95 98 112 100 103 99];
 
m = m*quality;

A = double(A) - 128;

dctMat = dctmtx(8);




%dctFuncHandle = @block_struct calcDCT(A, dctMat);  dctMat .* block.data

B_dct = blockproc(A, [8 8], @(block) dct2(block.data));
B = blockproc(B_dct, [8,8], @(block) round((block.data)./m));

[r,c] = size(B);

%disp(r);
%disp(c);


z=1;
for iterator=1:8:r-7
    for j=1:8:c-7
        for l=iterator:iterator+7
            for r=j:j+7
                mat(l-iterator+1,r-j+1) = B(l,r);
            end
        end
        
        y(z,:) = (zigzag(mat));
        %disp(y(i));
        z=z+1;
    end
end

[blocks, o] = size(y);

for iterator=1:blocks
    %disp(y(i,:));
    [freq, sym] = groupcounts(y(iterator,:)');
    %disp(sym);
    freq = freq./64;
    %disp(freq);
    %disp(length(sym));
    if(length(sym) == 1)
        sym = [sym 1];
        freq = [freq 0];
    end
    
    dict = huffmandict(sym,freq);
    hcode = huffmanenco(y(iterator,:),dict); % unequal sizes
    %disp(hcode);
    %hcode has the hoffman encoded string.....
    %Decode here....
    
    y_rev(iterator,:) = huffmandeco(hcode, dict);
    
    res = isequal(y_rev(iterator,:), y(iterator,:));
    %disp(res); 
end


z=1;
for iterator=1:8:r-7
    for j=1:8:c-7
        %y(z,:) = (zigzag(mat));
        mat_rev = reverseZigzag(y_rev(z,:));
        z=z+1;
        for l=iterator:iterator+7
            for r=j:j+7
                %mat(l-iterator+1,r-j+1) = B(l,r);
                B_rev(l,r) = mat_rev(l-iterator+1,r-j+1); 
            end
        end
    end
end


res = isequal(B,B_rev);
disp(res);

B_rev = blockproc(B_rev, [8,8], @(block) (block.data).*m);
B_rev = blockproc(B_rev, [8,8], @(block) idct2(block.data));
B_rev = double(B_rev) + 127;

figure;
imshow(mat2gray(B_rev));

