clc;
clear all;
img_BMP = imread('2015.5.25_1.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_size = size(img_BMP)%œ‘ æÕºœÒ¥Û–°
img_BarrelDistortion = zeros(img_size(1),img_size(2));

y = int32(img_size(1))/2
x = int32(img_size(2))/2
k1 = double(1);
%k2 = double(0.000002);
k2 = double(1.0/double(y^2 + x^2 ))*0.1
k2x = double(0.0000005);
k2y = double(0.000005);
i = int32(0);
j = int32(0);
data = double(0);
dataX = double(0);
dataY = double(0);
k1 * (1 + k2 * double( (1)^2 + (1)^2 ))
k1 * (1 + k2 * double( (y)^2 + (1)^2 ))
k1 * (1 + k2 * double( (1)^2 + (x)^2 ))
k1 * (1 + k2 * double( (y)^2 + (x)^2 ))
(y)^2 + (x)^2
1/k2
k2 * double( (1-y)^2 + (1-x)^2 )
for i = 1 : img_size(1)/2
    for j = 1 : img_size(2)/2
        data = k1 * (1 + k2 * double( (i-y)^2 + (j-x)^2 ));
        %dataX = k1 * (1 + k2x * double( (i-y)^2 + (j-x)^2 ));
        %dataY = k1 * (1 + k2y * double( (i-y)^2 + (j-x)^2 ));
        %img_BarrelDistortion(uint16(dataY*i),uint16(dataX*j)) = img_BMP(i,j);
        img_BarrelDistortion(uint16(data*(y+i)),uint16(data*(x+j))) = img_BMP(y+i,x+j);
        %{
        img_BarrelDistortion(uint16(data*(y+i)),uint16(data*(x-j))) = img_BMP(y+i,x-j);
        img_BarrelDistortion(uint16(data*(y-i)),uint16(data*(x+j))) = img_BMP(y-i,x+j);
        img_BarrelDistortion(uint16(data*(y-i)),uint16(data*(x-j))) = img_BMP(y-i,x-j);
        %}
    end
end
subplot(2,2,2),imshow(img_BarrelDistortion);