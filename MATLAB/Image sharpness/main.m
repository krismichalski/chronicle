% Krzysztof Michalski

close;
clear;
clc;

a = imread('pic1-298x300.png');
b = imread('pic2-300x300.png');

a = double(a);
b = double(b);

a = a(:, :, 1);
b = b(:, :, 1);

subplot(2,2,1);
imshow(uint8(a));
title('pic1-298x300.png');
axis equal;

subplot(2,2,2);
C = cc(a,256);
C = C/max(max(C))*255;
imshow(uint8(C));
title('pic1 - sharpness')
axis equal;

subplot(2,2,3);
imshow(uint8(b));
title('pic2-300x300.png');
axis equal;

subplot(2,2,4);
C = cc(b,256);
C = C/max(max(C))*255;
imshow(uint8(C));
title('pic2 - sharpness')
axis equal;
