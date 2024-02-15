imag=dlmread('man1024.img');
imag=dlmread('output1024convert_cpu.img');
imag0=(reshape(imag,1024,1024));
imwrite(uint8(imag0), 'man1024.bmp','bmp');