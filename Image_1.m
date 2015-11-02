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
for i = img_size(1) : -1 : 1
    for j = leftJP : -1 : 1
        if(img_BMP(i,j) == 0 && img_BMP(i,j+1) == 255)
            img_Edge(i,j) = 255;
            img_Edge(i,leftJP) = 100;
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
            img_Edge(i,j) = 255;
            img_Edge(i,rightJP) = 200;
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
fuc_EdgeL;
sum_point;
x = 1:1:200;
y = 1:1:200;
for i = 1 : 200
    if( mod(i,3) == 1 )
        y(i) = fuc_EdgeL(1,250-i);
    else
        y(i) = fuc_EdgeR(1,250-i);
    end
end
%cftool
data = uint16(0);
pitch_max = uint16(0.2934 * (double(img_size(1)) ^ 1.169) + 18 );
pitch = double(0);
for i = img_size(1) : -1 : 1
    data = uint16(0.2934 * (double(i) ^ 1.169)+0.71)
    pitch = (img_size(2) - data * 2)/img_size(2);
    for j = 1 : uint16(img_size(2)/2)
%         uint16(j*pitch+1)
    img_Rebuild(i,uint16(j*pitch+1)+data) = img_BMP(i,j);
    end
    for j = uint16(img_size(2)/2) : img_size(2)
%         uint16(j*pitch+1)
    img_Rebuild(i,uint16(j*pitch+1+data-img_size(2)/2)) = img_BMP(i,j);
    end
end

subplot(2,2,4),imshow(img_Rebuild);
