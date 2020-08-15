# Image-Processing
* The project is a codec based on JPEG Image compression algorithm
* Seperate notebooks for compression and decompression are provided.
* The compression algorithm outputs a bin file (ci.bin in this case) which is the compressed version of the image file whose path needs to be given in the input
* The decompression algorithms taken the bin file (ci.bin in this case) and results in an image that is reconstructed version of the previous image.
* 3 Standatd quantization matrices are already pred-defined in the code ant quantizations actor needs to be given as input
* For encoding Huffmand Encoding scheme is implemented
* The algorithms perform majorly the following steps
  * DCT of 8x8 individual blocks
  * Quantization
  * Encoding
  * Storage in binary file
 
 ## Where to look
 * The master branch consists of MATAB version of the project with several bugs pertaining to high errors in decompressed image
 * The image-compression-python branch consists of python code that is more accurate and reliable. That's what you are looking for

## Future objective
* The python code is sequential which make the processing cubersome for large images. Work is being done to make the code distributive and parallelize the algorithm.
