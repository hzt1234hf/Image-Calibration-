
%水平边缘检测、垂直边缘检测实现直角弯边沿检测
clc;
clear all;
img_BMP = imread('2015.5.28_5.bmp','bmp');
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
endLine = uint16(img_size(1));

rightLastLine = [img_size(1) img_size(2)];
leftLastLine = [img_size(1) 1];


centerLineMode = 1;

way2ModeCnt = 0;
way3ModeCnt = 0;
way4ModeCnt = 0;
max2Mode = 0;
max3Mode = 0;
max4Mode = 0;
wayMode = 0;

maxEdgePoint = 0;
%默认0是直线，1是左上升，2是右上升
aveEdgePoint = double(0);

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
%%%%%%%%%%%左边沿检测
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
%%%%%%%%%%%右边沿检测
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
        %img_Edge(i,img_EdgeCol(i,3)) = 255;
        centerLine = img_EdgeCol(i,3);
        lastLine = img_EdgeCol(i,3);
        %{
        leftJPStart = uint16(centerLine/2 + img_EdgeCol(i,1)/2);
        leftJPEnd = uint16(img_EdgeCol(i,1) - 5);
        rightJPStart = uint16(centerLine/2 + img_EdgeCol(i,2)/2);
        rightJPEnd = uint16(img_EdgeCol(i,2) + 5);
        %}
        
        leftJPStart = uint16(img_EdgeCol(i,1) + 8);
        leftJPEnd = uint16(img_EdgeCol(i,1) - 8);
        rightJPStart = uint16(img_EdgeCol(i,2) - 8);
        rightJPEnd = uint16(img_EdgeCol(i,2) + 8);
        
        leftEdgeFind = 0;
        rightEdgeFind = 0;
        
        centerLineMode = 1;%两边黑线都检测到状况
        img_EdgeCol(i,4) = 1;
        
    elseif(leftEdgeFind||rightEdgeFind)
        if(leftEdgeFind)
            leftJPStart = img_EdgeCol(i,1) + 8;
            leftJPEnd = img_EdgeCol(i,1) - 8;
            
            %img_EdgeCol(i,3) = uint16(abs( int16(img_EdgeCol(i,1)) + int16((rightLastLine(2)-img_EdgeCol(rightLastLine(1),1))/2 * (i / 120))));
            %i/120应该为一个图像坐标到世界坐标的比例关系
            if 0
            img_EdgeCol(i,3) = uint16(abs(int16(((img_EdgeCol(i,1)) + rightLastLine(2))/2)));
            img_Edge(i,img_EdgeCol(i,3)) = 255;
            centerLine = img_EdgeCol(i,3);
            %img_Edge(i,centerLine) = 255;
            rightJPStart = centerLine;
            end
            %rightJPEnd = img_size(2);
            %disp(['-i:',num2str(i),' ',num2str(img_EdgeCol(i,1)),' ',num2str(leftJPEnd),' ',num2str(leftJPStart)]);
            centerLineMode = 2;%左边黑线miss状况
            img_EdgeCol(i,4) = 2;
        elseif(rightEdgeFind)
            rightJPStart = img_EdgeCol(i,2) - 8;
            rightJPEnd = img_EdgeCol(i,2) + 8;
            
            %img_EdgeCol(i,3) = uint16(lastLine - (int16(img_EdgeCol(i,1)) - int16(rightLastLine))/2);
            if 0
            img_EdgeCol(i,3) = uint16(abs(int16(((img_EdgeCol(i,2)) - leftLastLine(2))/2)));
            img_Edge(i,img_EdgeCol(i,3)) = 255;
            centerLine = img_EdgeCol(i,3);
            %img_Edge(i,centerLine) = 255;
            leftJPStart = centerLine;
            end
            
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
    
    %%%%%左右边界界线定义%%%%%
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
    
    %%%%左右极值点分析%%%%%
    if(i<119)
        if(img_EdgeCol(i,3)<img_EdgeCol(i+2,3))
                maxEdgePoint = 1;
        elseif(img_EdgeCol(i,3)>img_EdgeCol(i+2,3))
                maxEdgePoint = 2;
        end
                img_EdgeCol(i,5) = maxEdgePoint;
    end
    endLine = i;%最后一行赋值
end

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%赛道信息转换为赛道类型%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

for i = img_size(1) : -1 : endLine
    if(img_EdgeCol(i,5) ~= 0)
        aveEdgePoint = aveEdgePoint + img_EdgeCol(i,5);
    end
    switch img_EdgeCol(i,4)
        case 2 
            way2ModeCnt = way2ModeCnt + 1;
        case 3 
            way3ModeCnt = way3ModeCnt + 1;
        case 4 
            way4ModeCnt = way4ModeCnt + 1;
    end
    if(img_EdgeCol(i-1,4) ~= img_EdgeCol(i,4))
        if(way2ModeCnt > max2Mode)
            max2Mode = way2ModeCnt;
            way2ModeCnt = 0;
        elseif(way3ModeCnt > max3Mode)
            max3Mode = way3ModeCnt;
            way3ModeCnt = 0;
        elseif(way4ModeCnt > max4Mode)
            max4Mode = way4ModeCnt;
            way4ModeCnt = 0;
        end
    end
end

aveEdgePoint = double(aveEdgePoint / (img_size(1) - endLine));
aveEdgePoint
if(max4Mode > 6)
    wayMode = 4;
    fprintf('十字弯\n');
elseif(max2Mode > 5)
    wayMode = 3;
    fprintf('右直角弯\n');
elseif(max3Mode > 5)
    wayMode = 2;
    fprintf('左直角弯\n');
else
    wayMode = 1;
    fprintf('直道\n');
end


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%赛道中线分析滤波%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

for i = img_size(1)-1 : -1 : endLine +1
    if(img_EdgeCol(i,4)==1 )
        if(abs(img_EdgeCol(i-1,3) - img_EdgeCol(i,3))<10 &&abs(img_EdgeCol(i+1,3) - img_EdgeCol(i,3))>10)
            img_EdgeCol(i+1,3) = img_EdgeCol(i,3) - img_EdgeCol(i-1,3) + img_EdgeCol(i,3);
            img_Edge(i,img_EdgeCol(i+1,3)) = 255;
        elseif(abs(img_EdgeCol(i+1,3) - img_EdgeCol(i,3))<10 && abs(img_EdgeCol(i-1,3) - img_EdgeCol(i,3))>10)
            img_EdgeCol(i-1,3) = img_EdgeCol(i,3) - img_EdgeCol(i+1,3) + img_EdgeCol(i,3);
            img_Edge(i,img_EdgeCol(i-1,3)) = 255;
        else
            img_EdgeCol(i,3) = uint16((img_EdgeCol(i,3) + img_EdgeCol(i+1,3))/2);
            img_Edge(i,img_EdgeCol(i,3)) = 255;
        end
    elseif(img_EdgeCol(i,4)==2 || img_EdgeCol(i,4)==3 || img_EdgeCol(i,4)==4 )
        
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
if 0%最小二乘法应用
    img_min2 = zeros(120,1);
    for abc = 1 : 100
    sumX = 0;
    sumY = 0;
    %abc = 10;
    for i = img_size(1) : -1 : img_size(1)-abc+1
        sumX = sumX + i;
        sumY = sumY + img_EdgeCol(i,3);
    end
    aveX = sumX / abc;
    aveY = sumY / abc;
    sumUp = 0;
    sumDown = 0;
    for i = img_size(1) : -1 : img_size(1)-abc+1
        sumUp = sumUp + ((img_EdgeCol(i,3) - aveY)*(i-aveX));
        sumDown = sumDown + ((i - aveX)*(i-aveX));
    end
    B = 0;
    if(sumDown == 0)
        B = 0;
    else B = (sumUp/sumDown);
    end
    A = (sumY - B * sumX)/abc;
    img_min2(abc) = A;
    %fprintf('%d,%.2f,%.2f,%.2f\n',abc,(sumY - B * sumX),sumUp,sumDown);
    fprintf('%.2f,%.2f\n',A,B);
    end
    x = 1:120;
    y = 1:10;

    subplot(2,2,3);

    plot(img_min2);
    %hold on
    subplot(2,2,4);
    axis ij 
    plot(img_EdgeCol(x,3),x);
end
if 1
    
end
%cftool

