function [Width, Height] = data_area(DataTrain, DataTest, TrainClass, Extension)
    Width = 0;
    Height = 0;
            
    count = numel(TrainClass);
    for index = 1 : count
        [image_width, image_height] = image_area(strcat(DataTrain, filesep, char(TrainClass(index))), Extension);
        
        if (Width == 0) || (Width > image_width)
            Width = image_width;
        end        
        
        if (Height == 0) || (Height > image_height)
            Height = image_height;
        end
    end
    
    [image_width, image_height] = image_area(DataTest, Extension);

    if (Width == 0) || (Width > image_width)
        Width = image_width;
    end        

    if (Height == 0) || (Height > image_height)
        Height = image_height;
    end
end