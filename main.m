originalLM=GetLandmark('JACOB.jpg');
targetLM=GetLandmark('RICHARD.jpg');
originalG=imread('JACOB.jpg');
targetG=imread('RICHARD.jpg');
TRI = delaunay(originalLM(: , 1), originalLM(: , 2));  
num = size(originalLM, 1);
medLM = zeros(num, 2);
P = 0.1 : 0.1 : 0.9;  
for j = 1: 9  
    for i = 1: num  
        medLM(i, 1) = P(j)*(targetLM(i, 1) - originalLM(i, 1)) + originalLM(i, 1);  
        medLM(i, 2) = P(j)*(targetLM(i, 2) - originalLM(i, 2)) + originalLM(i, 2);  
    end  
    medG = zeros(256,256, 3); 
     for x = 1: 256
        for y = 1: 256  
            for k = 1: size(TRI, 1)  
                mX = medLM(TRI(k, :), 1);  %某个三角形3个定点的x值  
                mY = medLM(TRI(k, :), 2);  
        %判断点是否在三角形内  
                [IN, ON] = inpolygon(x, y, mX, mY);  
                if ON == 1 || IN == 1  
                    m0 = [mX, mY, ones(3, 1)]';  
                    m1 = [originalLM(TRI(k, :), 1), originalLM(TRI(k, :), 2), ones(3, 1)]';  %向原图转换  
                    tran1 = m1 * m0^-1;  
                    pos1 = tran1 * [x; y; 1];  
                    m2 = [targetLM(TRI(k, :), 1), targetLM(TRI(k, :), 2), ones(3, 1)]';  %向目标图转换  
                    tran2 = m2 * m0^-1;  
                    pos2 = tran2 * [x; y; 1];  
                    p1x=round(pos1(1,1));
                    p1y=round(pos1(2,1));
                    p2x=round(pos2(1,1));
                    p2y=round(pos2(2,1));
                    if p1x>256
                        p1x=256;
                    end
                    if p1x>256
                        p1x=256;
                    end
                    if p1y>256
                        p1y=256;
                    end
                    if p2x>256
                        p2x=256;
                    end
                    if p2y>256
                        p2y=256;
                    end
                    medG(x, y, :) = (1-P(j)) * originalG(p1x,p1y , :) + P(j) * targetG(p2x, p2y, :);  
                    break;  
                end  
            end  
        end  
    end  
      
    %画图  
    filename = ['result', num2str(j), '.jpg'];  
    imwrite(uint8(medG), filename, 'jpg');  
end  
