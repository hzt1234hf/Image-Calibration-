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
antLine = zeros(2,2);

i = uint16(0);
j = uint16(0);
antLine(1,1) = uint16(img_size(1));
antLine(1,2) = uint16(img_size(2)/2);
antLine(2,1) = uint16(0);
antLine(2,2) = uint16(0);
antStart = 0;
antDirect = 2;
while 1
    if(antStart == 0)
        if( img_BMP(antLine(1,1),antLine(1,2)) == 255 && img_BMP(antLine(1,1),antLine(1,2)-1) == 255)
            if(antLine(1,2) == 1)
                antLine(1,1) = img_size(1) - 1;
                antLine(1,2) = uint16(img_size(2)/2)
                continue;
            end
            antLine(1,2) = antLine(1,2) - 1;
        elseif( img_BMP(antLine(1,1),antLine(1,2)) == 255 && img_BMP(antLine(1,1),antLine(1,2)-1) == 0)
            antLine(2,1) = antLine(1,1);
            antLine(2,2) = antLine(1,2)-1;
            
            edgeLine(antLine(1,1),1) = antLine(2,2);
            img_Edge(antLine(1,1),antLine(2,2)) = 255;
            
            antDirect = 2;
            antStart = 1;
        end
    end
    if(antStart)
        switch antDirect
            case 1
                if(img_BMP(antLine(1,1)-1,antLine(1,2)) == 0)
                    antLine(2,1) = antLine(1,1)-1;
                    antLine(2,2) = antLine(1,2);
                    antDirect = 4;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 2
                if(img_BMP(antLine(1,1)-1,antLine(1,2)) == 0)
                    antLine(2,1) = antLine(1,1)-1;
                    antLine(2,2) = antLine(1,2);
                    antDirect = 4;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 3
                if(img_BMP(antLine(1,1),antLine(1,2)+1) == 0)
                    antLine(2,1) = antLine(1,1);
                    antLine(2,2) = antLine(1,2)+1;
                    antDirect = 1;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(1,1),antLine(1,2)-1) == 0)
                    antLine(2,1) = antLine(1,1);
                    antLine(2,2) = antLine(1,2)-1;
                    antDirect = 2;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 4
                if(img_BMP(antLine(1,1),antLine(1,2)+1) == 0)
                    antLine(2,1) = antLine(1,1);
                    antLine(2,2) = antLine(1,2)+1;
                    antDirect = 1;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(1,1),antLine(1,2)-1) == 0)
                    antLine(2,1) = antLine(1,1);
                    antLine(2,2) = antLine(1,2)-1;
                    antDirect = 2;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
        end
        switch antDirect
            case 1
                if(img_BMP(antLine(2,1)-1,antLine(2,2)) == 255)
                    antLine(1,1) = antLine(2,1)-1;
                    antLine(1,2) = antLine(2,2);
                    antDirect = 3;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1)+1,antLine(2,2)) == 0)
                    antLine(1,1) = antLine(1,1)+1;
                    antLine(1,2) = antLine(1,2);
                    antLine(2,1) = antLine(2,1)+1;
                    antLine(2,2) = antLine(2,2);
                    antDirect = 1;

                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 2
                if(img_BMP(antLine(2,1)-1,antLine(2,2)) == 255)
                    antLine(1,1) = antLine(2,1)-1;
                    antLine(1,2) = antLine(2,2);
                    antDirect = 3;

                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1)+1,antLine(2,2)) == 0)
                    antLine(1,1) = antLine(1,1)+1;
                    antLine(1,2) = antLine(1,2);
                    antLine(2,1) = antLine(2,1)+1;
                    antLine(2,2) = antLine(2,2);
                    antDirect = 2;

                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 3
                if(img_BMP(antLine(2,1),antLine(2,2)+1) == 255)
                    antLine(1,1) = antLine(2,1);
                    antLine(1,2) = antLine(2,2)+1;
                    antDirect = 2;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)-1) == 255)
                    antLine(1,1) = antLine(2,1);
                    antLine(1,2) = antLine(2,2)-1;
                    antDirect = 1;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)+1) == 0)
                    antLine(1,1) = antLine(1,1);
                    antLine(1,2) = antLine(1,2)+1;
                    antLine(2,1) = antLine(2,1);
                    antLine(2,2) = antLine(2,2)+1;
                    antDirect = 3;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)-1) == 0)
                    antLine(1,1) = antLine(1,1);
                    antLine(1,2) = antLine(1,2)-1;
                    antLine(2,1) = antLine(2,1);
                    antLine(2,2) = antLine(2,2)-1;
                    antDirect = 3;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
            case 4
                if(img_BMP(antLine(2,1),antLine(2,2)+1) == 255)
                    antLine(1,1) = antLine(2,1);
                    antLine(1,2) = antLine(2,2)+1;
                    antDirect = 2;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)-1) == 255)
                    antLine(1,1) = antLine(2,1);
                    antLine(1,2) = antLine(2,2)-1;
                    antDirect = 1;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)+1) == 0)
                    antLine(1,1) = antLine(1,1);
                    antLine(1,2) = antLine(1,2)+1;
                    antLine(2,1) = antLine(2,1);
                    antLine(2,2) = antLine(2,2)+1;
                    antDirect = 4;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                elseif(img_BMP(antLine(2,1),antLine(2,2)-1) == 0)
                    antLine(1,1) = antLine(1,1);
                    antLine(1,2) = antLine(1,2)-1;
                    antLine(2,1) = antLine(2,1);
                    antLine(2,2) = antLine(2,2)-1;
                    antDirect = 4;
                    
                    img_Edge(antLine(1,1),antLine(1,2)) = 255;
                    break;
                end
                break;
        end
        %break;
    end
end
subplot(2,2,2),imshow(img_Edge);

