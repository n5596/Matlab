clc;
close all;
clear all;

img = imread('C:\CVIT\Practice\Pictures\barcode3.jpg');
type = input('How many digits are there in the barcode?');
if type == 13
    f = input('What is the first digit?');
end
[height, width, scale] = size(img);
if scale == 3
    img = rgb2gray(img);
end
figure, imshow(img);

%---CROP THE IMAGE--------
start = 0; stop = 0;
img = imadjust(img, [0; 0.75], [0:1]);
img = imsharpen(img);

[height, width, scale] = size(img);
for i = 1:width
    if img(ceil(0.5*height),i) == 0 
        start = i;
        break;
    end
end
for i = width:-1:1
    if img(ceil(0.5*height),i) == 0
        stop = i;
        break;
    end
end
w = stop - start;
img  = imcrop(img, [start 1 w height]);
figure, imshow(img);
img = imresize(img, [height 95]);
[height, width, scale] = size(img);

%-----GET THE BITS-------
number = '';
count = 0;
for i = 1:width
    if img(ceil(0.5*height),i) <= 90 %black means 1
        b = '1';
        number = strcat(number,b);
        s = ['black', num2str(i), ' ', num2str(img(ceil(0.5*height),i))];
%         disp(s);
    elseif img(ceil(0.5*height),i) > 90 %white means 0
        b = '0';
        number = strcat(number,b);
        s = ['white', num2str(i), ' ', num2str(img(ceil(0.5*height),i))];
%         disp(s);
    else 
        s = ['not sure', num2str(i), ' ' ,num2str(img(ceil(0.5*height),i))];
%         disp(s);
        count = count + 1;
    end
end
disp(number);
% disp(count);
barcode = '';

%----FIRST GUARD BAND------
if number(1:3) == '101'
    disp('pass 1');
end

%-----DECODE THE BITS------
% disp(img(ceil(0.5*height),12));
digit = '';
if type == 13
    if f == 0
        digit = 'LLLLLL';
        barcode = '0';
    elseif f == 1
        digit = 'LLGLGG';
        barcode = '1';
    elseif f == 2
        digit = 'LLGGLG';
        barcode = '2';
    elseif f == 3
        digit = 'LLGGGL';
        barcode = '3';
    elseif f == 4
        digit = 'LGLLGG';
        barcode = '4';
    elseif f == 5
        digit = 'LGGLLG';
        barcode = '5';
    elseif f == 6
        digit = 'LGGGLL';
        barcode = '6';
    elseif f == 7
        digit = 'LGLGLG';
        barcode = '7';
    elseif f == 8
        digit = 'LGLGGL';
        barcode = '8';
    elseif f == 9
        digit = 'LGGLGL';
        barcode = '9';
    end
elseif type == 12
    digit = 'LLLLLL';
    barcode = '';
end

%---k becomes 11 for 12 digit barcode and 4 for 13 digit. j starts from 2
%for 12 digit and 1 for 13 digit
k = 4; 
for j = 1:6
    if digit(j) == 'L'
        if number(k:k+6) == '0001101'
            b = '0';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0011001'
            b = '1';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0010011'
            b = '2';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0111101'
            b = '3';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0100011'
            b = '4';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0110001'
            b = '5';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0101111'
            b = '6';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0111011'
            b = '7';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0110111'
            b = '8';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0001011'
            b = '9';
            barcode = strcat(barcode,b);
        end
    elseif digit(j) == 'G'
        if number(k:k+6) == '0100111'
            b = '0';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0110011'
            b = '1';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0011011'
            b = '2';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0100001'
            b = '3';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0011101'
            b = '4';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0111001'
            b = '5';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0000101'
            b = '6';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0010001'
            b = '7';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0001001'
            b = '8';
            barcode = strcat(barcode,b);
        elseif number(k:k+6) == '0010111'
            b = '9';
            barcode = strcat(barcode,b);
        end
    end
    k = k + 7;
end
% disp(barcode);
% disp(k);
k = k + 5;
while k <= 95-6
%     disp(number(k:k+6));
    if number(k:k+6) == '1110010'
        b = '0';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1100110'
        b = '1';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1101100'
        b = '2';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1000010'
        b = '3';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1011100'
        b = '4';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1001110'
        b = '5';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1010000'
        b = '6';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1000100'
        b = '7';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1001000'
        b = '8';
        barcode = strcat(barcode,b);
    elseif number(k:k+6) == '1110100'
        b = '9';
        barcode = strcat(barcode,b);
    end
    k = k + 7;
end
disp(barcode);
% disp(k);

%-----LAST GUARD BAND-----
if number(93:95) == '101'
    disp('pass 2');
end
% disp(img(ceil(0.5*height),11));
% disp(img(ceil(0.5*height),12));