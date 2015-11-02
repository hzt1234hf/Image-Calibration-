clc ;%清屏
clear all ;%清内存

%读取原图像
img=imread('2015.5.28_13.bmp','bmp') ;

%转化为灰度图像
img_gray=rgb2gray(img) ;
figure(1) ;
imshow(img_gray) ;
title('Gray Image') ;

%直方图均衡
img_histeq=histeq(img_gray) ;
figure(2) ;
imshow(img_histeq,[]) ;
title('Histgram Equalization Image') ;
%sobel边缘检测
%  img_sobel=edge(img_histeq,'sobel') ;
img_sobel=sobel(img_histeq) ;
figure(3) ;
imshow(img_sobel,[]) ;
title('Sobel Edge Detection ') ;
kernel=[1;1;1;1;1;1;1;1] ;
img_erode=imerode(img_sobel,kernel) ;
img_dilate=imdilate(img_erode,kernel) ;
figure(4)
imshow(img_dilate) ;
title('Dilate Image') ;
%radon检测直线
theta = 0:179;
[R,xp] = radon(img_dilate,theta);
figure(5) ;
imagesc(theta, xp, R); colormap(hot);
xlabel('/theta (degrees)'); ylabel('x/prime');
title('R_{/theta} (x/prime)');
colorbar

%计算直线 注意radon变换的圆心在图像的中心
gray_max1=max(max(R(:,1:90))) ;
gray_max2=max(max(R(:,90:180))) ;
[len1,theta1]=find(R==gray_max1) ;
[len2,theta2]=find(R==gray_max2) ;
theta1=theta1+90-1 ;
theta2=theta2-90-1 ;
len1=len1-length(R)/2 ;
len2=len2-length(R)/2;
%斜率
k1=-cot(theta1*pi/180) ;%注意前面要带负号，因为y朝下
k2=-cot(theta2*pi/180) ;

%求原点到直线的垂足的坐标
[m,n]=size(img_dilate) ;
x1=n/2+len1*sin(theta1*pi/180);
y1=m/2-len1*cos(theta1*pi/180);
x2=n/2-len2*sin(theta2*pi/180);
y2=m/2-len2*cos(theta2*pi/180);

%在图像中画线，标出检测出来的直线,直线方程为x-x0=k(y-y0) ;
y1_1=0 ;
x1_1=k1*(y1_1-y1)+x1 ;
y1_2=m ;
x1_2=k1*(y1_2-y1)+x1 ;

y2_1=0 ;
x2_1=k2*(y2_1-y2)+x2 ;
y2_2=m ;
x2_2=k2*(y2_2-y2)+x2 ;
figure(4) ;
hold on ;
% line('xdata', [left right], 'ydata', [top bottom])
%标注垂足
markpoint(x2,y2,'g') ;
markpoint(x1,y1,'g') ;
%将检测出来的直线画出来
line([x1_1,x1_2],[y1_1,y1_2]) ;
line([x2_1,x2_2],[y2_1,y2_2]) ;


%寻找四个连接点
y11=m*3/4 ;
x11=k1*(y11-y1)+x1 ;
y111=m/4 ;
x111=x11 ;
x11_1=k1*(y111-y1)+x1 ;
y21=y11 ;
x21=k2*(y21-y2)+x2 ;
y211=y111 ;
x211=x21 ;
x21_1=k2*(y211-y2)+x2 ;

markpoint(x11,y11,'g') ;
markpoint(x111,y111,'g') ;
markpoint(x11_1,y111,'r') ;
markpoint(x21,y21,'g') ;
markpoint(x211,y211,'g') ;
markpoint(x21_1,y211,'r') ;
%校正
basepoints=[x11 y11;x21 y21;x111,y111;x211,y211] ;
inputpoints=[x11 y11;x21 y21;x11_1,y111;x21_1,y211] ;
cpt=cp2tform(inputpoints,basepoints,'projective') ;
figure(6) ;
img_correction=imtransform(img,cpt) ;
imshow(img_correction);
title('Distortion Correction Image') ;

 

%标点函数

function markpoint(x,y,color)
line([x-5,x+5],[y,y],'Color',color) ;
line([x,x],[y-5,y+5],'Color',color) ;
return;
%垂直边缘检测函数，不是sobel边缘检测

function img_sobel=sobel(img_test)
[m,n]=size(img_test) ;
img_sobel=zeros(m,n) ;
alpha=2 ;
for i=2:m-1
    for j=2:n-1
        temp=uint16(abs(int16(img_test(i-1,j-1))+alpha*int16(img_test(i,j-1))+int16(img_test(i+1,j-1))-int16(img_test(i-1,j+1))-alpha*int16(img_test(i,j+1))-int16(img_test(i+1,j+1)))) ;
        if(temp>125)
            temp=255 ;
        else
            temp=0 ;
        end
        img_sobel(i,j)=uint8(temp) ;
    end
end 
return ;