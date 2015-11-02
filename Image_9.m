clc;
clear all;
img_BMP = imread('2015.6.2_1.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_TS1 = zeros(120,160);
img_TS2 = zeros(120,160);
img_l1 = zeros(120,1);
img_test = zeros(120,160);

l1 = 0.0;   %还原后X轴
l2 = 0.0;   %还原后Y轴
pi = 3.1415926; %圆周率

a = 25;       %摄像头视角
offset_a = 40;  %摄像头偏移角度
h = 30;         %摄像头高度
X = 30;        %图像宽度
Y = 120;         %图像长度
for i = 1 : Y
    for j = 1 : X
        img_test(i,j) = 255;
    end
end
if 0
for i = 1 : Y
    for j = 1 : X
        l1 = h * cot((2.0*a/Y*i - a + offset_a)*pi/180) * sin((2*a/X*j - a)*pi/180);
        l2 = h * cot((2.0*a/Y*i - a + offset_a)*pi/180) * cos((2*a/X*j - a)*pi/180);
        img_reb(int16(-l2+319),int16(l1+142)) = img_BMP(i,j);
        %img_reb(int16(l1+1659),int16(l2+1)) = 255;
        img_l1(i) = l1;
        img_TS1(i,j) = l1;
        img_TS2(i,j) = l2;
    end
end
elseif 1
for i = 1 : Y
    for j = 1 : X
        l1 = h * cos((2.0*a/Y*i - a + 90 - offset_a - a)*pi/180) * tan((2*a/X*j - a)*pi/180);
        l2 = h * tan((2.0*a/Y*i - a - 90 + offset_a + a)*pi/180);
        img_reb(int16(l2*10 + 810),int16(l1*10+150)) = img_BMP(i,j);
        %img_reb(int16(l1+1659),int16(l2+1)) = 255;
        img_l1(i) = cos((2.0*a/Y*i - a + 90 - offset_a - a)*pi/180);
        img_TS1(i,j) = l1;
        img_TS2(i,j) = l2;
    end
end
end
if 0
subplot(4,1,1);plot(img_l1);
subplot(4,1,2);plot(img_TS1,img_TS2);
subplot(4,1,3),imshow(img_BMP);
subplot(4,1,4),imshow(img_reb);
else
subplot(1,1,1),imshow(img_reb);
end
