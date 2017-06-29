clc;
clear all;
close all;

%------CROSS DISSOLVE------
img1 = imread('C:\CVIT\Practice\Pictures\sonam.jpg');
img2 = imread('C:\CVIT\Practice\Pictures\sonam1.jpg');
[h, w, s] = size(img1);
img2 = imresize(img2, [h, w]);
img2 = circshift(img2, 65);
img2 = circshift(img2, -20, 2);
alpha = 1;
time = 150;
figure;
for t = 1:time
    img = (1-alpha)*img1 + alpha*img2;
    imshow(img);
    alpha = alpha - 1/time;
end

%------ADDING CONSTANT VALUE TO EACH CHANNEL-----
constant = -40;
im = img;
im(:,:,1) = im(:,:,1) + constant;
im(:,:,2) = im(:,:,2) + constant;
im(:,:,3) = im(:,:,3) + constant;
figure, imshow(uint8(im));