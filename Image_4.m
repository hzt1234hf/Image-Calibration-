
%水平边缘检测、垂直边缘检测实现直角弯边沿检测
clc;
clear all;
img_BMP = imread('2015.5.25_1.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_size = size(img_BMP)%显示图像大小
img_Edge = zeros(img_size(1), img_size(2));%边线提取
fuc_EdgeL = zeros(1,img_size(1));          %左边线函数计算
fuc_EdgeR = zeros(1,img_size(1));          %右边线函数计算

img_ReEdge = zeros(img_size(1), img_size(2));%图像复原数组
img_Rebuild = zeros(img_size(1), img_size(2));%图像复原数组

leftJPStart = uint16(img_size(2)/2);
rightJPStart = uint16(leftJPStart + 1);
leftJPEnd = uint16(2);
rightJPEnd = uint16(img_size(2));
edgeLine = zeros(img_size(1),3);
colEdgeLine = zeros(3,1);
%{
for i = 1:30
    for j = 1 : img_size(2)
        img_Edge(i,j) = 255;
    end
end
subplot(2,2,3),imshow(img_Edge);
%}
sum_point = 0;
offset_j = 0;
new_j = 0;
i = uint16(0);
j = uint16(0);
k = uint16(0);
noEdgeCnt = 0;
colEdgeLine(1) = 0;
colEdgeLine(2) = 0;
colEdgeLine(3) = 0;
for i = img_size(1) : -1 : 1
    edgeLine(i,1) = 1;
    edgeLine(i,2) = img_size(2);
    for j = leftJPStart : -1 : leftJPEnd
        if(img_BMP(i,j) == 0 && img_BMP(i,j+1) == 255)
            edgeLine(i,1) = j+1;
            img_Edge(i,j+1) = 255;
            if(j-8>1)
                leftJPStart = j + 8;
                leftJPEnd = j - 8;
            else
                leftJPStart = j+8;
                leftJPEnd = 1;
            end
        end
    end
    for j = rightJPStart : 1 : rightJPEnd
        if(img_BMP(i,j) == 0 && img_BMP(i,j-1) == 255)
            edgeLine(i,2) = j-1;
            img_Edge(i,j-1) = 255;
            if(j+8>img_size(2))
                rightJPStart = j - 8;
                rightJPEnd = img_size(2);
            else
                rightJPStart = j-8;
                rightJPEnd = j+8;
            end
        end
    end
    if(edgeLine(i,1)~=1 && edgeLine(i,2) ~=img_size(2) )
        edgeLine(i,3) = uint16((edgeLine(i,1) + edgeLine(i,2))/2);
        img_Edge(i,edgeLine(i,3)) = 255;
    elseif(abs(edgeLine(i+1,1) - edgeLine(i,1))<10 && (abs(edgeLine(i+1,2) - edgeLine(i,2))>10 || edgeLine(i,2) == img_size(2) ))
        disp(['i:',num2str(i),' ',num2str(abs(edgeLine(i+1,2) - edgeLine(i,2)))]);
        noEdgeCnt = noEdgeCnt + 1;
        if(~colEdgeLine(2))
            colEdgeLine(2) = i
        end
    elseif(abs(edgeLine(i+1,2) - edgeLine(i,2))<10 && (abs(edgeLine(i+1,1) - edgeLine(i,1))>10 || edgeLine(i,1) == 1 ))
        disp(['i:',num2str(i),' ',num2str(abs(edgeLine(i+1,1) - edgeLine(i,1)))]);
        noEdgeCnt = noEdgeCnt + 1;
        if(~colEdgeLine(1))
            colEdgeLine(1) = i
        end
    else
        noEdgeCnt = noEdgeCnt + 1;
    end
    if(colEdgeLine(1)&&colEdgeLine(2))
        i
        break;
    end
end
leftJPStart = uint16((colEdgeLine(1)+colEdgeLine(2))/2)
rightJPStart = uint16(leftJPStart + 1)
leftJPEnd = uint16(colEdgeLine(1)-15)
rightJPEnd = uint16(colEdgeLine(2)+15)
for i = img_size(2) : -1 : 2
    for j = leftJPStart : -1 : leftJPEnd
        if(img_BMP(j,i) == 0 && img_BMP(j+1,i) == 255)
            img_Edge(j+1,i) = 255;
            break;
        end
    end
    for j = rightJPStart : 1 : rightJPEnd
        if(img_BMP(j,i) == 0 && img_BMP(j-1,i) == 255)
            img_Edge(j-1,i) = 255;
            break;
        end
    end
end

subplot(2,2,2),imshow(img_Edge);

