
%水平边缘检测、垂直边缘检测实现直角弯边沿检测
clc;
clear all;
img_BMP = imread('2015.5.25_2.bmp','bmp');
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
edgeLineSlope = zeros(img_size(1)-1,2);
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

leftEdgeFind = 0;
leftEdgeMissCnt = 0;
leftEdgeBool = 1;

rightEdgeFind = 0;
rightEdgeMissCnt = 0;
rightEdgeBool = 1;

for i = img_size(1) : -1 : 1
    edgeLine(i,1) = 1;
    edgeLine(i,2) = img_size(2);
    
    img_Edge(i,leftJPStart) = 255;
    img_Edge(i,leftJPEnd) = 255;
    img_Edge(i,rightJPStart) = 255;
    img_Edge(i,rightJPEnd) = 255;
    
    if(leftEdgeBool)
        for j = leftJPStart : -1 : leftJPEnd
            if(img_BMP(i,j) == 0 && img_BMP(i,j+1) == 255)
                edgeLine(i,1) = j+1;
                img_Edge(i,j+1) = 255;
                leftEdgeFind = 1;
            end
            if(leftEdgeFind)
                break;
            end
        end
        if(leftEdgeFind == 0)
            leftEdgeMissCnt  = leftEdgeMissCnt + 1;
            if(leftEdgeMissCnt >= 5)
                i
                leftEdgeBool = 0;
            end
        else
            leftEdgeFind = 0;
        end
    end
    if(rightEdgeBool)
        for j = rightJPStart : 1 : rightJPEnd
            if(img_BMP(i,j) == 0 && img_BMP(i,j-1) == 255)
                edgeLine(i,2) = j-1;
                img_Edge(i,j-1) = 255;
                rightEdgeFind = 1;
            end
            if(rightEdgeFind)
                break;
            end
        end
        if(rightEdgeFind == 0)
            rightEdgeMissCnt  = rightEdgeMissCnt + 1;
            if(rightEdgeMissCnt >= 5)
                i
                rightEdgeBool = 0;
            end
        else
            rightEdgeFind = 0;
        end
    end
    if(edgeLine(i,1)~=1 && edgeLine(i,2) ~=img_size(2) )
        edgeLine(i,3) = uint16((edgeLine(i,1) + edgeLine(i,2))/2);
        img_Edge(i,edgeLine(i,3)) = 255;
        if(i<img_size(1)-1)
            edgeLineSlope(i,1) = uint16((edgeLine(i,1) - edgeLine(i+1,1))^2 + 1);
            edgeLineSlope(i,2) = uint16((edgeLine(i,2) - edgeLine(i+1,2))^2 + 1);
            
            leftJPStart = uint16(sqrt(edgeLineSlope(i,1)) * 8 + edgeLine(i,1));
            leftJPEnd = leftJPStart - 16;
            rightJPStart = uint16(edgeLine(i,2) - sqrt(edgeLineSlope(i,2)) * 8);
            rightJPEnd = rightJPStart + 16;
        if(leftJPStart>edgeLine(i,3))
            leftJPStart = edgeLine(i,3);
        end
        if(rightJPStart<edgeLine(i,3))
            rightJPStart = edgeLine(i,3);
        end
        end
    elseif(abs(edgeLine(i+1,1) - edgeLine(i,1))<10 && (abs(edgeLine(i+1,2) - edgeLine(i,2))>10 || edgeLine(i,2) == img_size(2) ))
        %disp(['i:',num2str(i),' ',num2str(abs(edgeLine(i+1,2) - edgeLine(i,2)))]);
        if(edgeLine(i,1)-8>1)
            leftJPStart = edgeLine(i,1) + 8;
            leftJPEnd = edgeLine(i,1) - 8;
        else
            leftJPStart = edgeLine(i,1)+8;
            leftJPEnd = 1;
        end
    elseif(abs(edgeLine(i+1,2) - edgeLine(i,2))<10 && (abs(edgeLine(i+1,1) - edgeLine(i,1))>10 || edgeLine(i,1) == 1 ))
        %disp(['i:',num2str(i),' ',num2str(abs(edgeLine(i+1,1) - edgeLine(i,1)))]);
        if(edgeLine(i,2)+8>img_size(2))
            rightJPStart = edgeLine(i,2) - 8;
            rightJPEnd = img_size(2);
        else
            rightJPStart = edgeLine(i,2)-8;
            rightJPEnd = edgeLine(i,2)+8;
        end
    else
        noEdgeCnt = noEdgeCnt + 1;
    end
    
end
edgeLine
edgeLineSlope
subplot(2,2,2),imshow(img_Edge);

