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

%-----FIND X2 SUCH THAT F1(X1) = F2(X2). METHOD FROM INTERNET------- 
corrVal = zeros(256, 1);
for i = 1:256   % i represents x1
    [val, pos] = min(abs(cdf1(i) - cdf2));
    corrVal(i) = pos - 1;
end

output1 = corrVal(double(img1) + 1);
figure, imshow(uint8(output1));
title('Histogram matched');
hist = imhist(rgb2gray(output1));

figure;
r = output1(:,:,1);
g = output1(:,:,2);
b = output1(:,:,3);
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

%--------MY METHOD---------
bright = 3;
for i = 1:h
    for j = 1:w
        r(i,j) = cdf2(r1(i,j)+1)*255*bright;
        g(i,j) = cdf2(g1(i,j)+1)*255*bright;
        b(i,j) = cdf2(b1(i,j)+1)*255*bright;
    end
end
output2(:,:,1) = r;
output2(:,:,2) = g;
output2(:,:,3) = b;
figure, imshow(uint8(output2));
title('My method');
hist = imhist(rgb2gray(output2));

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