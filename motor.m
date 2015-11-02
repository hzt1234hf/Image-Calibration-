clc;
clear all;
l = 3.059;
l1 = 0.059;
l2 = 0.6;
aef = 11;
x = 5.5;
pi = 3.1415926;
temp = zeros(60,1);
for a = 1 : 60
    temp(a) = atan(sqrt(x^2 - (l - cos((a+aef)*pi/180) * l - l1)^2) + sin((a+aef)*pi/180) * l - l2 - x)*180/pi;
    
    fprintf('%.2f,',temp(a));
end
atan(1)*180/pi
a = 1:60;
plot(temp);
sftool