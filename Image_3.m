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
img_LineEdge = zeros(img_size(1), img_size(2));%线循法提取边线

leftJP = uint16(img_size(2)/2);
rightJP = uint16(leftJP + 1);

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
EdgeStart = zeros(2,2);
leftEdgeStart = 0;
rightEdgeStart = 0;
for i = img_size(1)-1 : -1 : 1
    for j = leftJP : -1 : 1
        if(img_BMP(i,j) == 0 && img_BMP(i,j+1) == 255)
            if(leftEdgeStart == 0)
                EdgeStart(1,1) = i;
                EdgeStart(1,2) = j;
                leftEdgeStart = 1;
            end
            img_Edge(i,j) = 255;
%             img_Edge(i,leftJP) = 100;
            fuc_EdgeL(i) = j ;
            sum_point = sum_point + 1;
            leftJP = uint16(j/8) * 8 + 8*2;
            offset_j = uint16(0.3057 * (double(img_size(1)-i) ^ 1.16));
%             img_ReEdge(i,offset_j) = 255;
            if(40 + j - offset_j > 0)
                new_j = 40 + j - offset_j;
            else
                new_j = 1;
            end
            if(new_j >= 0 && new_j <= img_size(2))
                img_ReEdge(i,new_j) = 255;
            end
            break;
        end
    end
    for j = rightJP : 1 : img_size(2)
        if(img_BMP(i,j) == 0 && img_BMP(i,j-1) == 255)
            if(rightEdgeStart == 0)
                EdgeStart(2,1) = i;
                EdgeStart(2,2) = j;
                rightEdgeStart = 1;
            end
            img_Edge(i,j) = 255;
%             img_Edge(i,rightJP) = 200;
            fuc_EdgeR(i) = img_size(2) - j;
            rightJP = uint16(j/8) * 8 - 8*2;
            offset_j = uint16(0.2934 * (double(img_size(1)-i) ^ 1.169));
%             img_ReEdge(i,offset_j) = 255;
            new_j = j - 220 + offset_j;
            if(new_j >= 0 && new_j <= img_size(2))
                img_ReEdge(i,new_j) = 255;
            end
            break;
        end
    end
end
subplot(2,2,2),imshow(img_Edge);
subplot(2,2,3),imshow(img_ReEdge);
EdgeStart(1,1)
EdgeStart(1,2)
EdgeStart(2,1)
EdgeStart(2,2)
i = EdgeStart(1,1) - 1;
j = EdgeStart(1,2);
lineMode = 0;
while 0
    if(i <= 0 || i >= img_size(1))
        break;
    end
    if(j<=0 || j >= img_size(2))
        break;
    end
    if(img_BMP(i,j) == 255)
        if(img_BMP(i,j-1) == 255 && img_BMP(i,j+1) == 255&&img_BMP(i+1,j) == 255 && img_BMP(i-1,j) == 255)
            j--;
        elseif(img_BMP(i,j-1) == 255 && img_BMP(i,j+1) == 0)
            if(img_BMP(i+1,j) == 255 && img_BMP(i-1,j) == 0)
                img_LineEdge(i,j) = 0;
                lineMode = 1;
                i--;
            elseif(img_BMP(i+1,j) == 0 && img_BMP(i-1,j) == 255)
                img_LineEdge(i,j) = 0;
                lineMode = 2;
                i--;
            elseif(img_BMP(i+1,j) == 255 && img_BMP(i-1,j) == 255)
                img_LineEdge(i,j) = 0;
                lineMode = 3;
                i--;
            end
        elseif(img_BMP(i,j-1) == 0 && img_BMP(i,j+1) == 255)
            if(img_BMP(i+1,j) == 255 && img_BMP(i-1,j) == 0)
                img_LineEdge(i,j) = 0;
                lineMode = 4;
                i--;
            elseif(img_BMP(i+1,j) == 0 && img_BMP(i-1,j) == 255)
                img_LineEdge(i,j) = 0;
                lineMode = 5;
                i--;
            elseif(img_BMP(i+1,j) == 255 && img_BMP(i-1,j) == 255)
                img_LineEdge(i,j) = 0;
                lineMode = 6;
                i--;
            end
        elseif(img_BMP(i,j-1) == 255 && img_BMP(i,j+1) == 255)
            if(img_BMP(i+1,j) == 255 && img_BMP(i+1,j) == 0)
                img_LineEdge(i,j) = 0;
                lineMode = 7;
                j++;
            elseif(img_BMP(i+1,j) == 0 && img_BMP(i+1,j) == 255)
                img_LineEdge(i,j) = 0;
                lineMode = 8;
                j++;
            end
        end
    else
        j--;
    end
end
subplot(2,2,4),imshow(img_LineEdge);

