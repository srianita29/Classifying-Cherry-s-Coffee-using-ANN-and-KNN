function [Width, Height] = image_area(Path, Extension)
    hApp = gcf;
    hWB = waitbar(0, strrep(strrep(Path, '\', '\\'), '_', '\_'), 'Name', 'Image Area');
    
    Width = 0;
    Height = 0;
    
    file = dir(fullfile(Path, strcat('*.', Extension)));
    count = numel(file);
    for index = 1 : count
        set(0, 'CurrentFigure', hWB);
        waitbar((index/count), hWB, strrep(file(index).name, '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        image = imread(strcat(Path, filesep, file(index).name));    
        buffer = size(image);

        if (Height == 0) || (Height > buffer(1))
            Height = buffer(1);
        end
        
        if (Width == 0) || (Width > buffer(2))
            Width = buffer(2);
        end        
    end
            
    close(hWB);
    set(0, 'CurrentFigure', hApp);
end