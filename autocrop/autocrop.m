% https://www.mathworks.com/matlabcentral/answers/397432-auto-crop-the-image
function autocrop(Input, OutputBlack, OutputWhite)    
    origin.image = imread(Input);    
    buffer = size(origin.image);
    origin.height = buffer(1);
    origin.width = buffer(2);
%     disp(origin);
    
    origin.grayscale = rgb2gray(origin.image);
    origin.noise = ordfilt2(origin.grayscale, 5, true(3));
    origin.median = medfilt2(origin.noise);
    origin.level = graythresh(origin.median) / 2;
    
    blackwhite.image = im2bw(origin.image, origin.level);  
    blackwhite.data = double(blackwhite.image);    
%     disp(blackwhite);
    
%     imshowpair(origin.image, blackwhite.image, "montage");
    
    white.top = -1; white.bottom = -1; white.left = -1; white.right = -1;
    black.top = -1; black.bottom = -1; black.left = -1; black.right = -1;
    
%     disp(blackwhite.data)
    for pixel_y = 10 : (origin.height - 10)
        for pixel_x = 10 : (origin.width - 10)
            if (blackwhite.data(pixel_y, pixel_x) == 0) % black pixel                
                if (black.left == -1) || (black.left > pixel_x)
                    black.left = pixel_x;
                end
                
                if (black.right < pixel_x)
                    black.right = pixel_x;
                end
                
                if (black.top == -1)
                    black.top = pixel_y;
                end
                
                if (black.bottom < pixel_y)
                    black.bottom = pixel_y;
                end            
            else % white pixel   
                if (white.left == -1) || (white.left > pixel_x)
                    white.left = pixel_x;
                end
                
                if (white.right < pixel_x)
                    white.right = pixel_x;
                end
                
                if (white.top == -1)
                    white.top = pixel_y;
                end
                
                if (white.bottom < pixel_y)
                    white.bottom = pixel_y;
                end            
            end
        end
    end
    
    black.width = black.right - black.left;
    black.height = black.bottom - black.top;
    black.image = imcrop(origin.image, [black.left black.top black.width black.height]);
    imwrite(black.image, OutputBlack);
    
    white.width = white.right - white.left;
    white.height = white.bottom - white.top;
    white.image = imcrop(origin.image, [white.left white.top white.width white.height]);
    imwrite(white.image, OutputWhite);
    
%     
%     disp(black)    
%     disp(white)    
%     imshowpair(black.image, white.image, "montage");
end