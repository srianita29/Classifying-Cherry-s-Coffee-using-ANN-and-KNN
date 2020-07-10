function data_normalize(DataTrain, DataTest, TrainClass, Width, Height, TempDirectory, Extension)
    train = char(strcat(TempDirectory, filesep, 'data-train'));
    test = char(strcat(TempDirectory, filesep, 'data-test'));
            
    mkdir(TempDirectory);
    mkdir(train);
    
    count = numel(TrainClass);
    for index = 1 : count
        source = char(strcat(DataTrain, filesep, TrainClass(index)));  
        destination = char(strcat(train, filesep, TrainClass(index)));  
        mkdir(destination);
        
        image_normalize(source, destination, Width, Height, Extension);
    end
    
    mkdir(test);
    image_normalize(DataTest, test, Width, Height, Extension);
end