clc;
clear all;
close all;

%------READ IMAGES------
img1 = (imread('C:\CVIT\Practice\Pictures\jen.jpg'));
img2 = (imread('C:\CVIT\Practice\Pictures\monica.jpg'));
img1 = double(rgb2gray(img1));
img2 = double(rgb2gray(img2));
figure, imshow(uint8(img1));
figure, imshow(uint8(img2));

[height, width, scale] = size(img1);
img2 = imresize(img2, [height , width]);

%-------CREATE LOW PASS FILTER------
lpf = fspecial('gaussian', [height width]);

%------COMPUTE FFTs--------
I1 =fft(img1);
I2 = fft(img2);

%------LOW PASS FILTER FIRST IMAGE AND HIGH PASS FILTER SECOND IMAGE------
l = ifft(imfilter(I1,lpf));
h = ifft(imfilter(I2,lpf));
h = img2 - h; %high pass filtering is equivalent to subtracting the original image from its low pass filtered version

%------APPLY CIRCULAR SHIFT SINCE FACES IN BOTH IMAGES ARE NOT ALIGNED----
l = circshift(l,-20);

%-----ADD BOTH FILTERED VERSIONS-----
img = l+h;

figure, imshow(uint8(l));
figure, imshow(uint8(h));
figure, imshow(uint8(img));



