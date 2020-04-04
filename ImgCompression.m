function [B_rev, error] = ImgCompression(A_pre, quality)


    %The function is for gray scale 2-d images only
    
    %A_pre = imread('download.jpg');
    %quality = input('Enter the compression raio(Eg: 1, 10, 25, 50)');
    %figure;
    %imshow(A_pre);
    %disp(A);


    %Standardized matrix
    m = [16 11 10 16 24 40 51 61       
         12 12 14 19 26 58 60 55        
         14 13 16 24 40 57 69 56 
         14 17 22 29 51 87 80 62
         18 22 37 56 68 109 103 77
         24 35 55 64 81 104 113 92 
         49 64 78 87 103 121 120 101 
         72 92 95 98 112 100 103 99];
    
    %Multiplying the matrix with quality
    m = m*quality;

    %Adjusting the values for Discreet Cosine Transform
    A = double(A_pre) - 128;
    
    %Processing 8x8 bocks
    %Applying DCT on each block
    B_dct = blockproc(A, [8 8], @(block) dct2(block.data));
    
    %Quantizing each block using the standardized matrix
    B = blockproc(B_dct, [8 8], @(block) round((block.data)./m));

    %Obtaining the size of Matrix B
    [row,col] = size(B);
       
    %Now each block is taken and a vector of elements in zig-zag fashion is
    %generated 
    z=1;
    for iterator=1:8:row-7
        for j=1:8:col-7
            for l=iterator:iterator+7
                for r=j:j+7
                    mat(l-iterator+1,r-j+1) = B(l,r); %Seperarting blocks
                end
            end
            %Applying zig-zag reordering
            y(z,:) = (zigzag(mat));
            %disp(y(i));
            z=z+1;
        end
    end

    %Calculating the number of vectors obtained
    [blocks, o] = size(y);

    %Each vector is then encoded using huffman encoding scheme to get a
    %variable length encoded bit string
    for iterator=1:blocks
        %disp(y(i,:));
        %[freq, sym] = groupcounts(y(iterator,:)');
        sym = unique(y(iterator,:)');
        freq = histc(y(iterator,:)', sym);
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
        %At this point the image is stored in form of variable encoded bit
        %vectors. The storage space is less than the original image.
        %Here the image compression terminates
        
        %Now the image is again decoded to look for losses.
        %The huffman encoded bit vectors are decoded to get original
        %vectors
        y_rev(iterator,:) = huffmandeco(hcode, dict);

        res = isequal(y_rev(iterator,:), y(iterator,:));
        %disp(res); 
    end

    %Now the original vectors are converted to matrix forms using reverse
    %zig-zag fashion and concatenated to get matrix
    z=1;
    for iterator=1:8:row-7
        for j=1:8:col-7
            %y(z,:) = (zigzag(mat));
            mat_rev = reverseZigzag(y_rev(z,:)); %Reverse zig-zag for matrix
            z=z+1;
            for l=iterator:iterator+7
                for r=j:j+7
                    %mat(l-iterator+1,r-j+1) = B(l,r);
                    %Concatenating for original matrix
                    B_rev(l,r) = mat_rev(l-iterator+1,r-j+1); 
                end
            end
        end
    end


    res = isequal(B,B_rev);
    %disp(res);

    %Now inverse DCT is applied to 8x8 blocks
    B_rev = blockproc(B_rev, [8 8], @(block) (block.data).*m);
    
    %Inverse Quantization is acheived
    B_rev = blockproc(B_rev, [8 8], @(block) idct2(block.data));
    
    %Values are updated to fit in gray-scale range
    B_rev = double(B_rev) + 128;
    

    %Integer values are formed from double for gray0-scale image
    d=linspace(min(B_rev(:)),max(B_rev(:)),256);
    B_rev=uint8(arrayfun(@(x) find(abs(d(:)-x)==min(abs(d(:)-x))),B_rev));

    %Mea squred error is calculated between de-compressed image and
    %original gray-scale image.
    error = immse(A_pre,uint8(B_rev));
end
