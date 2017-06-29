clc;
clear all;
close all;

%-------SCAN VIDEO AND FILE------
fileId = fopen('C:\CVIT\Practice\Pictures\tracks\dos6\dos6-linda.txt','r');
data = fscanf(fileId, '%f %f %f %f');
fclose(fileId);
len = size(data);
len = len(1);

im1 = imageDatastore(fullfile('C:','CVIT','Practice','Pictures','dos6_images'), 'LabelSource', 'foldernames');
numImages = length(im1.Files);
aspectratio = 1.778;
a = 1;
b = 2;
c = 3;
d = 4;

x = zeros(numImages, 1);
y = zeros(numImages, 1);
slength = zeros(numImages, 1);
margin = 20;
count = 0;

%------FIND THE x, y AND s VECTORS-------
for i = 1:numImages - 1
    img = readimage(im1, i);
    [h, w, s] = size(img);
    x1 = data(a);
    y1 = data(b);
    x2 = data(c);
    y2 = data(d);
    a = a + 4;
    b = b + 4;
    c = c + 4;
    d = d + 4;
    width = abs(x2 - x1);
    height = abs(y2 - y1);
    cheight = 2*height;
    if mod(cheight, 2) == 1
        cheight = cheight + 1;
    end
    cwidth = aspectratio*cheight;
    if mod(cwidth, 2) == 1
        cwidth = cwidth + 1;
    end
    crop = imcrop(img, [x1-margin/2-0.25*cwidth y1-margin/2 cwidth+1 cheight+1]);
    pos1 = [x1 y1];
    pos2 = [x2 y2];
    centerx = (x1+x2)/2;
    centery = (y1+y1)/2;
    x(i) = centerx;
    y(i) = centery;
    slength(i) = sqrt(y2^2 - y1^2)/2;
    if x1>w || x2>w || y1>h || y2>h
        count = count + 1;
    end
    test = insertMarker(img, pos1, 'Color', 'red', 'size', 30);
    test = insertMarker(test, pos2, 'Color', 'blue', 'size', 30);
    crop = imresize(crop, 3);
    crop = imsharpen(crop);
    noise = insertShape(img,'Rectangle',[x1-margin/2-0.25*cwidth-randn(1)*margin/2 y1-margin/2-randn(1)*margin/2 cwidth cheight], 'Color', 'blue');
    imwrite(crop,['C:\CVIT\Practice\Pictures\Linda\unopt\img',num2str(i, '%04d'),'.png']); 
    rect1 = insertShape(noise,'Rectangle',[x1-margin/2-0.25*cwidth y1-margin/2 cwidth cheight], 'Color', 'green');
    imwrite(rect1,['C:\CVIT\Practice\Pictures\Linda\rect1\img',num2str(i, '%04d'),'.png']); 
end
figure, plot(x);
title('x');
figure, plot(y);
title('y');
figure, plot(slength);
title('slength');

%---------OPTIMIZATION-------
N = numImages;
e = ones(N,1);
lambda1 = 1000;
lambda2 = 1000;
lambda3 = 1000;
D1 = spdiags([-e e], 0:1, N-1, N);
D2 = spdiags([e -2*e e], 0:2, N-2, N);
D3 = spdiags([-e 3*e -3*e e], 0:3, N-3, N);

Ya = x;
Yb = y;
Yc = slength;
cvx_begin
    variable X1(1*N)
    variable Y1(1*N)
    variable S1(1*N)
    minimize(0.5*sum_square(Ya(1:N)-X1) +  ...
    + lambda1*norm(D1*X1,1) + lambda2*norm(D2*X1,1) + lambda3*norm(D3*X1,1) + ...
    + 0.5*sum_square(Yb(1:N)-Y1) + lambda1*norm(D1*Y1,1) + lambda2*norm(D2*Y1,1) + lambda3*norm(D3*Y1,1) + ...
    + 0.5*sum_square(Yc(1:N)-S1) + lambda1*norm(D1*S1,1) + lambda2*norm(D2*S1,1) + lambda3*norm(D3*S1,1)...
    )
cvx_end
figure, plot(X1);
title('x optimized');
diff1 = 0.5*sum_square(Ya(1:N)-X1) + lambda1*norm(D1*X1,1) + lambda2*norm(D2*X1,1) + lambda3*norm(D3*X1,1);
figure, plot(Y1);
title('y optimized');
diff2 = 0.5*sum_square(Yb(1:N)-Y1) + lambda1*norm(D1*Y1,1) + lambda2*norm(D2*Y1,1) + lambda3*norm(D3*Y1,1);
figure, plot(S1);
title('s optimized');
diff3 = 0.5*sum_square(Yc(1:N)-S1) + lambda1*norm(D1*S1,1) + lambda2*norm(D2*S1,1) + lambda3*norm(D3*S1,1);
disp(diff1);
disp(diff2);
disp(diff3);

%------MODIFY THE VIDEO-------
for i = 1:numImages - 1
    img = readimage(im1, i);
    opcenter_x = X1(i);
    opcenter_y = Y1(i);
    opslength = S1(i);
    pos1 = [opcenter_x-0.5*opslength opcenter_y-0.25*opslength];
    pos2 = [opcenter_x+opslength opcenter_y+opslength];
    fheight = opslength;
    fwidth = aspectratio*fheight;
    if mod(fheight, 2) == 1
        fheight = fheight + 1;
    end
    if mod(fwidth ,2) == 1
        fwidth = fwidth + 1;
    end
    crop = imcrop(img, [opcenter_x-margin-0.35*fwidth opcenter_y-margin fwidth fheight]);
    crop = imresize(crop, 2);
    crop = imsharpen(crop);
    test = insertMarker(img, pos1, 'Color', 'red', 'size', 30);
    test = insertMarker(test, pos2, 'Color', 'blue', 'size', 30);
    imwrite(crop,['C:\CVIT\Practice\Pictures\Linda\opt\img',num2str(i, '%04d'),'.png']); 
    img1 = imread(['C:\CVIT\Practice\Pictures\Linda\rect1\img',num2str(i, '%04d'),'.png']);
    rect2 = insertShape(img1,'Rectangle',[opcenter_x-margin-0.35*fwidth opcenter_y-margin fwidth fheight]);
    imwrite(rect2,['C:\CVIT\Practice\Pictures\Linda\rect2\img',num2str(i, '%04d'),'.png']); 
end