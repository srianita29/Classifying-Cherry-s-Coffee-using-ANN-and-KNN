function [TrainSet, TestSet] = data_instance(DataTrain, DataTest, DataExpect, TrainClass, TempDirectory, Extension, OrderDomain, OrderS, GraythreshDivision)    
    hApp = gcf;
    hWB = waitbar(0, 'Please Wait ...', 'Name', 'Instance');

    train_pointer = 1;
    class_count = numel(TrainClass);
    for class_index = 1 : class_count
        path = strcat(TempDirectory, filesep, 'data-train', filesep, char(TrainClass(class_index)));    
        file = dir(fullfile(path, strcat('*.', Extension)));
        file_count = numel(file);
        for file_index = 1 : file_count
            set(0, 'CurrentFigure', hWB);
            waitbar((file_index/file_count), hWB, strrep(strcat('TrainSet(', char(TrainClass(class_index)), '):', file(file_index).name), '_', '\_'));
            set(0, 'CurrentFigure', hApp);
            
            instance = data_instance_struct( ...
                file(file_index).name, ...
                DataTrain, path, ...
                OrderDomain, OrderS, GraythreshDivision ...
            );
 
            instance.group = char(TrainClass(class_index));

            TrainSet(train_pointer) = instance;
            train_pointer = train_pointer + 1;
        end        
    end
    
    
    path = char(strcat(TempDirectory, filesep, 'data-test'));    
    file = dir(fullfile(path, strcat('*.', Extension)));
    test_count = numel(file);
    for test_index = 1 : test_count
        set(0, 'CurrentFigure', hWB);
        waitbar((test_index/test_count), hWB, strrep(strcat('TestSet:', file(test_index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        instance = data_instance_struct( ...
            file(test_index).name, ...
            DataTest, path, ...
            OrderDomain, OrderS, GraythreshDivision ...
        );
    
        instance.expect = '-';
        for class_index = 1 : class_count
            expect_path = char(strcat(DataExpect, filesep, TrainClass(class_index)));
            if exist(expect_path, 'dir')
                expect_file = dir(fullfile(expect_path, strcat('*.', Extension)));
                expect_count = numel(expect_file);
                for expect_index = 1 : expect_count
                    if (instance.name == expect_file(expect_index).name)
                        instance.expect = char(TrainClass(class_index));                        
                        expect_index = expect_count;
                        class_index = class_count;
                    end
                end
            end
        end

        instance.knn = '-';
        instance.ann = '-';
        instance.bayesian = '-';
        
        TestSet(test_index) = instance;
    end
            
    close(hWB);
    set(0, 'CurrentFigure', hApp);
end

function ret = data_instance_struct(Name, Origin, Temporary, OrderDomain, OrderS, GraythreshDivision)    
    ret.name = Name;
    ret.origin = char(strcat(Origin, filesep, Name));
    ret.temporary = char(strcat(Temporary, filesep, Name));

    image_read = imread(ret.temporary);                    
    image_grayscale = rgb2gray(image_read);
    image_double = im2double(image_read);

    noise = ordfilt2(image_grayscale, OrderDomain, true(OrderS));
    median = medfilt2(noise);
    level = graythresh(median) / GraythreshDivision;
    bw = im2bw(image_read, level);   
    convhull = bwconvhull(bw, 'objects');
    ret.regionprops = regionprops(convhull, 'all');

    glcm = graycomatrix(image_grayscale);
    ret.graycoprops = graycoprops(glcm, 'all');
    
    ret.red_mean = mean2(image_double(:,:,1));
    ret.green_mean = mean2(image_double(:,:,2));
    ret.blue_mean = mean2(image_double(:,:,3));
end