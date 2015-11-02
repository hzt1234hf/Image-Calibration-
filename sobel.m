function img_sobel = sobel(img_test)
[m,n]=size(img_test) ;
img_sobel = zeros(m,n) ;
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