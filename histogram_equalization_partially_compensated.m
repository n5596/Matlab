clc;
clear all;
close all;

%--------READING IMAGES--------
img1 = imread('C:\CVIT\Practice\Pictures\sonam.jpg');
img2 = imread('C:\CVIT\Practice\Pictures\monalisa1.jpg');

figure, imshow(img1);
title('Original image');
figure, imshow(img2);
title('Desired image');

[h, w, s] = size(img1);
img2 = imresize(img2, [h w]);

%-----COMPUTING HISTOGRAMS--------
hist1 = imhist(rgb2gray(img1));
hist2 = imhist(rgb2gray(img2));
r1 = img1(:,:,1);
g1 = img1(:,:,2);
b1 = img1(:,:,3);
R1 = imhist(r1);
G1 = imhist(g1);
B1 = imhist(b1);
figure;
hold on;
plot(R1);
plot(G1);
plot(B1);
plot(hist1);
title('First Image');
legend('red','green','blue','all');
hold off;

r2 = img2(:,:,1);
g2 = img2(:,:,2);
b2 = img2(:,:,3);
R2 = imhist(r2);
G2 = imhist(g2);
B2 = imhist(b2);
figure;
hold on;
plot(R2);
plot(G2);
plot(B2);
plot(hist2);
title('Second Image');
legend('red','green','blue','all');
hold off;

%-----COMPUTE CDFs----------
cdf1 = cumsum(hist1)/numel(img1); % on using disp(cdf1) we can see the non-decreasing nature. don't use ecdf since it gives cdfs with different sizes
cdf2 = cumsum(hist2)/numel(img2);

%-----FIND X2 SUCH THAT F1(X1) = F2(X2)-------
I = eye(h,w);
alpha = 0.45;
% bright = 1.5;
for i = 1:h
    for j = 1:w
        r(i,j) = ((1-alpha)*eye+cdf2(r1(i,j)+1))*255;
        g(i,j) = ((1-alpha)*eye+cdf2(g1(i,j)+1))*255;
        b(i,j) = ((1-alpha)*eye+cdf2(b1(i,j)+1))*255;
    end
end
output(:,:,1) = r;
output(:,:,2) = g;
output(:,:,3) = b;
figure, imshow(uint8(output));
title('Histogram matched');
hist = imhist(rgb2gray(output));

figure;
R = imhist(r);
G = imhist(g);
B = imhist(b);
hold on;
plot(R);
plot(G);
plot(B);
plot(hist);
title('Equalized Image');
legend('red','green','blue','all');
hold off;

%------ADAPTHISTEQ------
matlabout = adapthisteq(rgb2gray(img1),'clipLimit',0.02,'Distribution','rayleigh');
figure, imshow(matlabout);
title('Matlab adapthisteq');