
%水平边缘检测、垂直边缘检测实现直角弯边沿检测
clc;
clear all;
img_BMP = imread('2015.5.28_13.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_size = size(img_BMP)%显示图像大小
img_Edge = zeros(img_size(1), img_size(2));%边线提取
img_EdgeCol = zeros(img_size(1),5);

leftJPStart = uint16(img_size(2)/2);
rightJPStart = uint16(leftJPStart + 1);
leftJPEnd = uint16(1);
rightJPEnd = uint16(img_size(2));
%{
for i = 1:30
    for j = 1 : img_size(2)
        img_Edge(i,j) = 255;
    end
end
subplot(2,2,3),imshow(img_Edge);
%}

leftEdgeFind = 0;
leftEdgeMissCnt = 0;
leftEdgeBool = 1;

rightEdgeFind = 0;
rightEdgeMissCnt = 0;
rightEdgeBool = 1;

centerLine = uint16(img_size(2)/2);
lastLine = uint16(img_size(2)/2);

rightLastLine = [img_size(1) img_size(2)];
leftLastLine = [img_size(1) 1];

maxEdgePoint = 0;
%默认0是直线，1是左上升，2是右上升
centerLineMode = 1;

for i = img_size(1) : -1 : 1
    
    disp([' ',num2str(i),' ',num2str(leftJPStart),' ',num2str(leftJPEnd),' ',num2str(rightJPStart),' ',num2str(rightJPEnd)]);
    img_EdgeCol(i,1) = 1;
    img_EdgeCol(i,2) = img_size(2);
    if(img_BMP(i,centerLine) == 0)
        disp(['break',num2str(i)]);
        img_EdgeCol(i,4) = 5;
        break;
    end
if 0
    img_Edge(i,leftJPStart) = 255;
    img_Edge(i,leftJPEnd) = 255;
    img_Edge(i,rightJPStart) = 255;
    img_Edge(i,rightJPEnd) = 255;
end

    for j = leftJPStart : -1 : leftJPEnd
        if(img_BMP(i,j) == 0 && img_BMP(i,j+1) == 255)
            %disp(['i:',num2str(i),' ',num2str(j),' ',num2str(leftJPEnd),' ',num2str(leftJPStart)]);
            img_Edge(i,j+1) = 255;
            img_EdgeCol(i,1) = j+1;
            
            leftLastLine(1) = i;
            leftLastLine(2) = j+1;
            
            leftEdgeFind = 1;
        end
        if(leftEdgeFind)
            break;
        end
    end
    for j = rightJPStart : 1 : rightJPEnd
        if(img_BMP(i,j) == 0 && img_BMP(i,j-1) == 255)
            img_Edge(i,j-1) = 255;
            img_EdgeCol(i,2) = j-1;
            
            rightLastLine(1) = i;
            rightLastLine(2) = j-1;
            
            rightEdgeFind = 1;
        end
        if(rightEdgeFind)
            break;
        end
    end
    if(leftEdgeFind&&rightEdgeFind)
        img_EdgeCol(i,3) = uint16((uint16(img_EdgeCol(i,1)) + img_EdgeCol(i,2))/2);
        img_Edge(i,img_EdgeCol(i,3)) = 255;
        centerLine = img_EdgeCol(i,3);
        lastLine = img_EdgeCol(i,3);
        %{
        leftJPStart = uint16(centerLine/2 + img_EdgeCol(i,1)/2);
        leftJPEnd = uint16(img_EdgeCol(i,1) - 5);
        rightJPStart = uint16(centerLine/2 + img_EdgeCol(i,2)/2);
        rightJPEnd = uint16(img_EdgeCol(i,2) + 5);
        %}
        
        leftJPStart = uint16(img_EdgeCol(i,1) + 5);
        leftJPEnd = uint16(img_EdgeCol(i,1) - 5);
        rightJPStart = uint16(img_EdgeCol(i,2) - 5);
        rightJPEnd = uint16(img_EdgeCol(i,2) + 5);
        
        leftEdgeFind = 0;
        rightEdgeFind = 0;
        
        centerLineMode = 1;%两边黑线都检测到状况
        img_EdgeCol(i,4) = 1;
    elseif(leftEdgeFind||rightEdgeFind)
        if(leftEdgeFind)
            leftJPStart = img_EdgeCol(i,1) + 5;
            leftJPEnd = img_EdgeCol(i,1) - 5;
            
            %img_EdgeCol(i,3) = uint16(abs( int16(img_EdgeCol(i,1)) + int16((rightLastLine(2)-img_EdgeCol(rightLastLine(1),1))/2 * (i / 120))));
            %i/120应该为一个图像坐标到世界坐标的比例关系
            img_EdgeCol(i,3) = uint16(abs( int16(((img_EdgeCol(i,1)) + rightLastLine(2))/2)));
            img_Edge(i,img_EdgeCol(i,3)) = 255;
            centerLine = img_EdgeCol(i,3);
            %img_Edge(i,centerLine) = 255;
            rightJPStart = centerLine;
            
            %rightJPEnd = img_size(2);
            %disp(['-i:',num2str(i),' ',num2str(img_EdgeCol(i,1)),' ',num2str(leftJPEnd),' ',num2str(leftJPStart)]);
            centerLineMode = 2;%左边黑线miss状况
            img_EdgeCol(i,4) = 2;
        elseif(rightEdgeFind)
            rightJPStart = img_EdgeCol(i,2) - 5;
            rightJPEnd = img_EdgeCol(i,2) + 5;
            
            %img_EdgeCol(i,3) = uint16(lastLine - (int16(img_EdgeCol(i,1)) - int16(rightLastLine))/2);
            img_EdgeCol(i,3) = uint16(abs(int16(img_EdgeCol(i,2)) - int16((leftLastLine(2) + img_EdgeCol(rightLastLine(1),1))/2*(i/120))));
            img_Edge(i,img_EdgeCol(i,3)) = 255;
            centerLine = img_EdgeCol(i,3);
            %img_Edge(i,centerLine) = 255;
            leftJPStart = centerLine;
            
            %leftJPEnd = 1;
            centerLineMode = 3;%右边黑线miss状况
            img_EdgeCol(i,4) = 3;
        end
        
        leftEdgeFind = 0;
        rightEdgeFind = 0;
        
    else
        if(img_BMP(i,centerLine) ~= 0)
            rightJPStart = centerLine+1;
            leftJPStart = centerLine;
        end
        centerLineMode = 4;%两边黑线miss状况
        img_EdgeCol(i,4) = 4;
    end
    if(leftJPStart > img_size(2)-1)
        leftJPStart = img_size(2)-1;
    end
    if(rightJPStart < 2)
        rightJPStart = 2;
    end
    %{
    if( leftJPEnd > leftJPStart)
        rightJPEnd = leftJPStart - 10;
    end
    if( rightJPEnd < rightJPStart)
        rightJPEnd = rightJPStart + 10;
    end
    %}
    if(leftJPEnd < 1)
        leftJPEnd = 1;
    end
    if(rightJPEnd > img_size(2))
        rightJPEnd = img_size(2);
    end
    if(i<119)
        if(img_EdgeCol(i,3)<img_EdgeCol(i+2,3))
                maxEdgePoint = 1;
        elseif(img_EdgeCol(i,3)>img_EdgeCol(i+2,3))
                maxEdgePoint = 2;
        end
                img_EdgeCol(i,5) = maxEdgePoint;
    end
end
aveA = double(0);
aveB = double(0);
for i = img_size(1)-6 : -1 : 1
    
    if(img_EdgeCol(i,4) == 5 )
        break;
    end
    if(img_EdgeCol(i+2,5) ~= img_EdgeCol(i+3,5))
        aveA = (img_EdgeCol(i,5) + img_EdgeCol(i+1,5) + img_EdgeCol(i+2,5))/3.0;
        aveB = (img_EdgeCol(i+3,5) + img_EdgeCol(i+4,5) + img_EdgeCol(i+5,5))/3.0;
        if(abs(aveA - aveB)>0.8)
            fprintf('i+3:%d,%5.3f\n',i+3,abs(aveA - aveB));
        end
    end
end
subplot(2,2,2),imshow(img_Edge);
%cftool


%cftool

img_Edge2 = zeros(img_size(1), img_size(2));%边线提取
sumX = double(0);
sumY = double(0);
aveX = double(0);
aveY = double(0);
for i = img_size(1) : -1 : 1
    if(img_EdgeCol(i,3) == 0 || img_EdgeCol(i,4) == 5 || img_EdgeCol(i,4) == 4 )
        break;
    end
    sumX = i + sumX;
    sumY = img_EdgeCol(i,3);
end
avbLine = double(img_size(1) - i + 1);
midLine = double((img_size(1) + i - 1)/2);
aveX = sumX / avbLine;
aveY = sumY / avbLine;

sumUp = double(0);
sumDown = double(0);
for i = img_size(1) : -1 : 50
    sumUp = sumUp + (double(img_EdgeCol(i,3)) - aveY)*(double(i) - aveX);
    sumDown = sumDown + (double(i) - aveX)^2;
end
if(sumDown == 0)
    B = 0.0;
else
    B = double(sumUp/sumDown);
end
A = double((double(sumY) - double(B*sumX))/double(avbLine));
fprintf('%.2f,%.2f,%.2f,%.2f,%.2f\n',sumX,sumY,avbLine,A,B);
if 0
for i = 61 : -1 : 46
    img_Edge(i,uint16(B*i + A)) = 255;
    uint16(B*i + A)
end
end
subplot(2,2,3),imshow(img_Edge2);

