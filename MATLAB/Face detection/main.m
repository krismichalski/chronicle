clc;

for i = {'presenter1', 'presenter2', 'presenter3'}
    im = imread([i{1} '.jpg']);
    img = rgb2hsv(im);
    [w, h, k] = size(img);
    mask = zeros(w, h);
    
    for x = 1:1:w
        for y = 1:1:h
            if(((0.1 >= img(x,y,1)) || (0.9 < img(x,y,1))) && (0.2 <= img(x,y,2)) && (0.6 > img(x,y,2)) && (0.4 <= img(x,y,3))) 
                mask(x,y) = 255;
            else
                mask(x,y) = 0;
            end
        end
    end
    
    for scale = {0.1, 0.2, 0.4}
        m = imresize(mask, scale{1});
        m = medfilt2(m);
        m = imresize(m, [w h]);
        
        for k = 1:1:w
           for l = 1:1:h
              if(m(k,l) < 180)
                  m(k,l) = 0;
              end
           end
        end
        
        result = im;
        
        for k = 1:1:w
           for l = 1:1:h
              if(m(k,l) == 0)
                  result(k,l,1) = 0;
                  result(k,l,2) = 0;
                  result(k,l,3) = 0;
              end
           end
        end
        
        imwrite(result, [i{1} '_' num2str(scale{1} * 100) '%.jpg']);
    end
end
