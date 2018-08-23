B = imread('C:\Users\JUGAL\Documents\MATLAB\CV\see.jpg');
[rows,columns] = size(B);
T=128;
BT = zeros(rows,columns);
C = zeros(rows,columns);
C1 = zeros(rows,columns);
C2 = zeros(rows,columns);
C3 = zeros(rows,columns);
C4 = zeros(rows,columns);
C5 = zeros(rows,columns);
for x=1:1:rows
    for y=1:1:columns
        if(B(x,y) < T)
            BT(x,y) = 0;
        else
            BT(x,y) = 255;
        end
    end
end
imshow(B);
figure, imshow(BT/256);

BT(x,y)>=BT(x+1,y-1) && BT(x,y)>=BT(x-1,y-1) && BT(x,y)>=BT(x+1,y+1) && BT(x,y)>=BT(x-1,y+1)

lab = 30;

%check for uppermost and leftmost boundary
for x=2:1:rows
    if(BT(1,x)==0)
        if(BT(1,x-1)~=0)
            C(1,x)=lab;
            lab=lab+0.5;
%            lab = round(lab);
        else
            C(1,x)=C(1,x-1);
        end 
    end
end
for y=2:1:columns
    if(BT(y,1)==0)
        if(BT(y-1,1)~=0)
            C(y,1)=lab;
            lab=lab+0.5;
 %           lab = round(lab);
        else
            C(y,1)=C(y-1,1);
        end 
    end
end

%check for remaining region: parse 1
for x=2:1:rows
    for y=2:1:columns
        if(BT(x,y)==0)
            if(BT(x-1,y) == 255 && BT(x,y-1) == 255)
                C(x,y) = lab;
                lab = lab+0.5;
  %              lab = round(lab);
            elseif(BT(x-1,y) == 0 || BT(x,y-1) == 0)
                    if(BT(x,y-1)==0)
                        C(x,y) = C(x,y-1);
                    else
                        C(x,y) = C(x-1,y);
                    end
            else
                            C(x,y) = BT(x-1,y);
            end
        end
    end
end
figure,imshow(C/256);

        for x=2:1:rows
            for y=2:1:columns
                if(C(x,y)~=0 && C(x-1,y)~=0 && C(x,y-1)~=0 && C(x-1,y)~=C(x,y-1))
                    L1 = C(x,y-1);
                    L2 = C(x-1,y);
                    for k=2:1:rows
                        for l=2:1:columns
                            if(C(k,l)==L1)
                                C(k,l)=L2;
                            end
                        end
                    end
                end
            end 
        end
for x=1:1:rows
    for y=1:1:columns
        C(x,y) = round(C(x,y));
    end
end        
figure,imshow(C/256);


H = zeros(256,2);
total = 0; total_c = 0; total_comp = 0;
for i=1:1:256
    H(i,2) = i;
end

for x=1:1:rows
    for y=1:1:columns
        H(C(x,y)+1) = H(C(x,y)+1) + 1;
    end
end

% removing
    for x=1:1:rows
        for y=1:1:columns
            if(H(C(x,y)+1) < 8000)
                C(x,y) = 0;
            end
        end
    end
figure,imshow(C/256);

%ind comp
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 31)
            C1(x,y) = 255;
        else
            C1(x,y) = 0;
        end
    end
end
for x=1:1:512
    C1(x,1) = 0;
end

for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 43)
            C2(x,y) = 255;
        else
            C2(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 56)
            C3(x,y) = 255;
        else
            C3(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 130)
            C4(x,y) = 255;
        else
            C4(x,y) = 0;
        end
    end
end
for x=1:1:rows
    for y=1:1:columns
        if(C(x,y) == 163)
            C5(x,y) = 255;
        else
            C5(x,y) = 0;
        end
    end
end


figure,subplot(2,3,1);
imshow(C1/256);
subplot(2,3,2);
imshow(C2/256);
subplot(2,3,3);
imshow(C3/256);
subplot(2,3,4);
imshow(C4/256);
subplot(2,3,5);
imshow(C5/256);
imwrite(C1,'cp1.png');
imwrite(C2,'cp2.png');
imwrite(C3,'cp3.png');
imwrite(C4,'cp4.png');
imwrite(C5,'cp5.png');

% Total area of the picture
for i=1:1:255
    total = H(i)+total;
end
fprintf('total area %d\n',total);

% Total area occupied by components
for i=2:1:255
    total_c = H(i)+total_c;
end
fprintf('covered by components %d\n',total_c);

% Area of components greater than 16000
for i=2:1:255
    if(H(i)>6000)
        total_comp = H(i)+total_comp;
    else
        H(i)=0;
    end
end
fprintf('Covered area by Components with area greater than 16000 %d\n',total_comp);

%Perimeter of the components 
peri = 0;
Perimeter = bwperim(BT,8);
figure,imshowpair(BT,Perimeter,'montage'); %code refered from 'https://www.mathworks.com/help/images/ref/bwperim.html'
for x=1:1:rows
    for y=1:1:columns
        if(Perimeter(x,y)==1)
            peri = peri+1;
        end
    end
end
imwrite(Perimeter,'perim.png');
fprintf('Perimeter covered by components %d\n',peri);
