           clc;
clear all;
img_gray = imread('2.bmp','bmp');
a = size(img_gray);
subplot(3,3,1),imshow(img_gray);title('原图像') ;
for i = 1:a(1)
    for j = 1:a(2)
        img_gray(i,j) = img_gray(i,j) * ((img_gray(i,j)/126).^2 ); 
    end
end

subplot(3,3,2),imshow(img_gray);title('加强对比度') ;
%b = rgb2gray(a);
%img_histeq = histeq(img_gray,255);
%subplot(3,3,2),imshow(img_histeq);title('直方图均衡') ;
img_sobel=sobel(img_gray) ;
subplot(3,3,3),imshow(img_sobel);title('边缘检测') ;

%kernel=[1;1;1;1;1;1;1;1;1] ;
img_erode=imerode(img_sobel,[1;1;1;1;1;1;1;1;1]) ;
img_dilate=imdilate(img_erode,[1;1;1;1;1;1;1;1]) ;
subplot(3,3,4),imshow(img_erode);title('imerode Image') ;
subplot(3,3,5),imshow(img_dilate);title('imdilate Image') ;

for i = 1:a(1)
    for j = 1:a(2)
        if(img_dilate(i,j) == 255)
            img_sobel(i,j) = 0;
        end
    end
end

subplot(3,3,6),imshow(img_sobel);title('imdilate Image') ;
theta = 0:179;
[R,xp] = radon(img_dilate,theta)