from HuffmanCoding import HuffmanCoding

#input file path
path = "/home/rushil/Documents/Python/Image Processing/Compression/sample.txt"

h = HuffmanCoding(path)

output_path = h.compress()
h.decompress(output_path)