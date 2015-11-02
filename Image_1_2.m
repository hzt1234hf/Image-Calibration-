clc;
clear all;
img_BMP = imread('2015.5.28_30.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_size = size(img_BMP)%显示图像大小
img_Edge = zeros(img_size(1), img_size(2));%边线提取
fuc_EdgeL = zeros(1,img_size(1));          %左边线函数计算
fuc_EdgeR = zeros(1,img_size(1));          %右边线函数计算
fuc_EdgeRow = zeros(1,img_size(1));

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
            fuc_EdgeL(i) = img_size(2)/2 - j;
            sum_point = sum_point + 1;
            leftJP = uint16(j/8) * 8 + 8*2;
        end
    end
    for j = rightJP : 1 : img_size(2)
        if(img_BMP(i,j) == 0 && img_BMP(i,j-1) == 255)
            img_Edge(i,j) = 255;
            img_Edge(i,rightJP) = 200;
            fuc_EdgeR(i) = j - img_size(2)/2;
            rightJP = uint16(j/8) * 8 - 8*2;
        end
    end
    fuc_EdgeRow(i) = i;
end
subplot(2,2,2),imshow(img_Edge);
%cftool
for i = img_size(1) : -1 : 1
    img_ReEdge(i,uint16(fuc_EdgeL(i) - uint16(0.4774*i+22.81) + uint16(img_size(2)/4))) = 255;
    img_ReEdge(i,uint16(fuc_EdgeR(i)+ uint16(img_size(2)*3/4) - uint16(0.5088*i+22.19))) = 255;
end

subplot(2,2,3),imshow(img_ReEdge);
if 0
    for i =1 : img_size(1)
        for j = 1 : img_size(2)
            img_BMP(i,j) = 255;
        end
    end
end
aa1 = double(1);
aa2 = double(1);

h = 0;
d = 0;
l = 0;  %

a = 120;%
o = 0;
r = 0;%

u = 0;%
v = 0;%
ry = 0;
rx = 0;

x = 0;
y = 0;

for i = img_size(1) : -1 :1
    for j = 1 : img_size(2)
        %img_Rebuild(i,j) = 2;
        %img_Rebuild(i,uint16(0.47*i + ( j * (((80 - 0.47*i)+1)/80) )+1)) = img_BMP(i,j);
if 0
        img_Rebuild(i,uint16(100/159*(((160 - j)*(1+5 * (160 - i)/120)) - 80))+1 + i) = img_BMP(i,j);
elseif 1
        if(j < img_size(2)/2)
            %aa1 = aa1 * uint16(80 - (80 - j) * ((0.5708*(120 - i) + 12.7) / 80)+1 );
            %img_Rebuild(i,aa1) = img_BMP(i,j);
            img_Rebuild(i,uint16(80 - (80 - j) * ((0.5708*(120 - i) + 12.7) / 80)+1 )) = img_BMP(i,j);
        else
            %aa2 = aa2 * uint16((j - 80) * ((0.5708*(120 - i) + 12.7) / 80)+1 + 80 );
            %img_Rebuild(i,aa2) = img_BMP(i,j);
            img_Rebuild(i,uint16((j - 80) * ((0.5708*(120 - i) + 12.7) / 80)+1 + 80 )) = img_BMP(i,j);
        end
elseif 0
    %img_Rebuild(uint16(120 - (120 - i)/(120/137.5838)),uint16(j + (j - (160/2)*25.4/137.5838*(121-i)/120))+1) = img_BMP(i,j);
    
    %img_Rebuild(i,uint16(160 - (160 - j)/0.8722) + 0.5) = img_BMP(i,j);
    %img_Rebuild(i,uint16(160 - (160 - j)/0.8722) + 0.5) = img_BMP(i,j);
    %img_Rebuild(uint16(120 - (120 - i)/0.8722) + 0.5,j) = img_BMP(i,j);
    img_Rebuild(i,uint16(160 - (160 - j)/0.8722) + 0.5) = img_BMP(i,j);
elseif 0
    x = h * cot(2*a/(ry - 1)*u - a + o) * sin(2*a/(rx-1)*v -a +r) +d;
    y = h * cot(2*a/(ry - 1)*u - a + o) * cos(2*a/(rx-1)*v -a +r) +l;
end    
        %img_Rebuild(i,uint16((j + 0.47*i))) = img_BMP(i,j);
    end
if 0
    for j = img_size(2)/2+1 :  img_size(2)
        %img_Rebuild(i,j) = 2;
        img_Rebuild(i,uint16(j * (double(160 - 0.4774*i)/80) + i /2)) = img_BMP(i,j);
    end
end
end
img_TS1 = zeros(120,160);
img_TS2 = zeros(120,160);
img_l1 = zeros(120,1);
l1 = 0;
l2 = 0;
a = 50;
a1 = 0;
a2 = 0;
offset_a = 40;
h = 31;
if 0
for i = 1 : 120
    l1 = tan(90 - offset_a + (a - i/120*2*a));
    img_l1(i) = l1;
    for j = 1 : 160
        l2 = cos(90 - offset_a + (a - i/120*2*a)) * h * tan(a - j/160*2*a);
        img_TS1(i,j) = l1;
        img_TS2(i,j) = l2;
    end
end
elseif 1
for i = 1 : 120
    for j = 1 : 160
        l1 = h * cot(2*a/120*i - a + offset_a) * sin(2*a/160*j - a);
        l2 = h * cot(2*a/120*i - a + offset_a) * cos(2*a/160*j - a);
        img_l1(i) = l1;
        img_TS1(i,j) = l1;
        img_TS2(i,j) = l2;
    end
end
end
plot(img_l1);
subplot(2,2,4),imshow(img_Rebuild);
