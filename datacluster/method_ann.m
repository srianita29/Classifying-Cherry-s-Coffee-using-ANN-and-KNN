function ret = method_ann(TrainSet, TestSet, TrainClass, PerimeterPower, AreaMultiplication, Goal, Spread, MN, DF)    
    hApp = gcf;
    hWB = waitbar(0, 'Please Wait ...', 'Name', 'Artificial Neural Network');
    
    class_count = numel(TrainClass);  
        
    train_count = numel(TrainSet);        
    ann_p = zeros(9, train_count);
    ann_t = zeros(1, train_count);
    for train_index = 1 : train_count
        set(0, 'CurrentFigure', hWB);
        waitbar((train_index/train_count), hWB, strrep(strcat('TrainSet:', TrainSet(train_index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        area = TrainSet(train_index).regionprops.Area;
        perimeter = TrainSet(train_index).regionprops.Perimeter;

        ann_p(1, train_index) = (perimeter ^ PerimeterPower) / (AreaMultiplication * pi * area);
        ann_p(2, train_index) = TrainSet(train_index).regionprops.Eccentricity;

        ann_p(3, train_index) = TrainSet(train_index).graycoprops.Contrast;
        ann_p(4, train_index) = TrainSet(train_index).graycoprops.Correlation;
        ann_p(5, train_index) = TrainSet(train_index).graycoprops.Energy;
        ann_p(6, train_index) = TrainSet(train_index).graycoprops.Homogeneity;

        ann_p(7, train_index) = TrainSet(train_index).red_mean;
        ann_p(8, train_index) = TrainSet(train_index).green_mean;
        ann_p(9, train_index) = TrainSet(train_index).blue_mean;
        
        ann_class = 0;      
        for class_index = 1 : class_count
            if(strcmp(char(TrainClass(class_index)), TrainSet(train_index).group))  
                ann_class = class_index;
                class_index = class_count;
            end
        end        
        ann_t(:, train_index) = ann_class;        
    end
            
    net = newrb(ann_p, ann_t, Goal, Spread, MN, DF);
    net.trainFcn = 'traingdx';
    net.trainParam.showWindow = 0;
    net.trainParam.showCommandLine = false;
    model = train(net, ann_p, ann_t);  
    
    test_count = numel(TestSet);              
    for test_index = 1 : test_count
        set(0, 'CurrentFigure', hWB);
        waitbar((test_index/test_count), hWB, strrep(strcat('TestSet:', TestSet(test_index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        area = TestSet(test_index).regionprops.Area;
        perimeter = TestSet(test_index).regionprops.Perimeter;
        matrix = ((perimeter ^ PerimeterPower) / (AreaMultiplication * pi * area));
        try
            class_index = round(sim(model, [ ...
                matrix; ...
                TestSet(test_index).regionprops.Eccentricity; ...

                TestSet(test_index).graycoprops.Contrast; ...
                TestSet(test_index).graycoprops.Correlation; ...
                TestSet(test_index).graycoprops.Energy; ...
                TestSet(test_index).graycoprops.Homogeneity; ...

                TestSet(test_index).red_mean; ...
                TestSet(test_index).green_mean; ...
                TestSet(test_index).blue_mean ...
            ]));    
            if (class_index >= 1) && (class_index <= class_count)
                TestSet(test_index).ann = char(TrainClass(class_index));
            end        
        catch ME
            TestSet(test_index).ann = strcat('[', ME.identifier, ']');
        end
    end
    
    ret = TestSet;
    close(hWB);
    set(0, 'CurrentFigure', hApp);
end