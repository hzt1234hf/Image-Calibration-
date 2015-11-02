clc;
clear all;
img_BMP = imread('7.bmp','bmp');
subplot(2,3,1),imshow(img_BMP);
img_size = size(img_BMP)%显示图像大小
img_2Value = zeros(img_size(1), img_size(2));%二值化图像数组
img_Edge = zeros(img_size(1), img_size(2));     %边缘检测图像数组
img_Contrast = zeros(img_size(1), img_size(2)); %锐化图像数组
img_histeq = histeq(img_BMP,255);                %直方图规定化
subplot(2,3,2),imshow(img_histeq);
img_BMP(3,6)
sum = 0.0;

%*****求出原图像平均灰度值*****%
for i=1:480
    for j=1:640
        sum = sum + double(img_BMP(i,j));
    end
end
ave_SrcGray = sum/(640*480)     %计算原图像平均灰度值
incre_Gray = 300.0 / ave_SrcGray%计算需要增强对比度的值

%*****原图像对比度增强*****%
for i=1:480
    for j=1:640
       %img_Contrast(i,j) = double(img_BMP(i,j)) * incre_Gray;%对比度增强
       img_Contrast(i,j) = (double(img_BMP(i,j)) - 127.5 * (1 - 0.1)) * 1.558287 +127.5 * ( 1 +0.1);%对比度增强
       if( img_Contrast(i,j) > 255)
           img_Contrast(i,j) = 255;%
       else if(img_Contrast(i,j) < 0)
               img_Contrast(i,j) = 0;
           end
       end
    end
end
subplot(2,3,3),imshow(img_Contrast,[0,255]);

%*****求出对比度增强后图像平均灰度值*****%
sum = 0.0;
for i=1:480
    for j=1:640
        sum = sum + double(img_Contrast(i,j));
    end
end
ave_CntrastGray = sum/(640*480)%计算处理后图像平均灰度值

%*****二值化图像*****%
for i=1:480
    for j=1:640
        if(img_Contrast(i,j) >ave_CntrastGray)
            img_2Value(i,j) = 255;
        else
            img_2Value(i,j) = 0;
        end
    end
end
subplot(2,3,4),imshow(img_2Value);

%边缘检测，模拟出赛道边界
side_Left = 320;
side_Right = 320;
for i=479:-1:2
    leftCnt = side_Left;
    rightCnt = side_Right;
    for j=leftCnt:-1:3
        if( (img_Contrast(i,j+1) - img_Contrast(i,j-1)) > 20 && img_Contrast(i,j-1) < 170 || img_Contrast(i+1,j) - img_Contrast(i-1,j) > 25)
            img_Edge(i,j) = 255;
            if(abs(j - side_Left) > 40)
                side_Left = 320;
            else
                side_Left = j + 10;
            end
            %continue;
        end
    end

    for j=rightCnt:1:638
        if( (img_Contrast(i,j+1) - img_Contrast(i,j-1))  > 20 && img_Contrast(i,j+1) < 170 || img_Contrast(i-1,j) - img_Contrast(i+1,j) > 25)
            img_Edge(i,j) = 255;
            if(abs(j - side_Right) > 40)
                side_Right = 320;
            else
                side_Right = j - 10;
            end
            %continue;
        end
    end
end
subplot(2,3,5),imshow(img_Edge);
%{
for i=1:480
    for j=1:639
        if( abs( (img_Contrast(i,j) - img_Contrast(i,j+1)))  > 30 && (img_Contrast(i,j+1) - img_Contrast(i,j+2)) < 10)
            img_Edge(i,j) = 255;
        end
    end
end
%}
%{
subplot(2,3,5),imshow(img_Edge);
side_Left = 320;
side_Right = 320;
side_LeftDot = 0;
side_RightDot = 0;
for i=479:-1:2
    leftCnt = side_Left;
    rightCnt = side_Right;
	for j = 2:639
        
    end
end
%}
side_LeftDot = 0;
side_RightDot = 0;
side_Left = 320;
side_Right = 320;
for i=479:-1:2
    for j= 2:639
        if(img_Edge(i+1,j) > 200 && (img_Edge(i-1,j-1) > 200 || img_Edge(i-1,j+1) > 200))
            img_Edge(i,j) = 255;
            break;
        end
        if(img_Edge(i-1,j) > 200 && (img_Edge(i+1,j-1) > 200 || img_Edge(i+1,j+1) > 200))
            img_Edge(i,j) = 255;
            break;
        end
    end
    for j= 3:638
        if(img_Edge(i,j+1) > 200 && (img_Edge(i-1,j-1) > 200 || img_Edge(i+1,j-1) > 200 ||  img_Edge(i,j-1) > 200))
            img_Edge(i,j) = 255;
        end
        if(img_Edge(i,j-1) > 200 && (img_Edge(i-1,j+1) > 200 || img_Edge(i+1,j+1) > 200 ||  img_Edge(i,j+1) > 200))
            img_Edge(i,j) = 255;
        end
    end
end
for i=1:480
    for j= side_Left:-1:1
        if(img_Edge(i,j) > 200)
            side_LeftDot = j;
            break;
        else
            side_LeftDot = 0;
        end
    end
    for j= side_Right:640
        if(img_Edge(i,j) > 200)
            side_RightDot = j;
            break;
        else
            side_RightDot = 0;
        end
    end
    if(side_RightDot ~= 0 && side_LeftDot ~= 0)
        img_Edge(i,int16((side_RightDot + side_LeftDot)/2)) = 255;
        sideLeft = int16((side_RightDot + side_LeftDot)/2);
        side_Right = sideLeft;
    end
end
subplot(2,3,6),imshow(img_Edge);

img_small = zeros(60,170); %
for i=1:60
    leftCnt = side_Left;
    rightCnt = side_Right;
	for j = 1:170
        img_small(i,j) = img_Edge(int16(i) * (8-((61-i)/60 * 8)) + 1,int16(3.764 * j));
    end
end
figure(2);imshow(img_small,[0,255]);
%