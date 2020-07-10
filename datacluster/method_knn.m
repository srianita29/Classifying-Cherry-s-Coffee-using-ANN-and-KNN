function ret = method_knn(TrainSet, TestSet, PerimeterPower, AreaMultiplication, NumNeighbors, Standardize)    
    hApp = gcf;
    hWB = waitbar(0, 'Please Wait ...', 'Name', 'K-Nearest Neighbor');
    
    train_count = numel(TrainSet);    
    train_matrix = zeros(1, train_count);
    train_eccentricity = zeros(1, train_count);
    
    train_contrast = zeros(1, train_count);
    train_correlation = zeros(1, train_count);
    train_energy = zeros(1, train_count);
    train_homogeneity = zeros(1, train_count);
    
    train_red = zeros(1, train_count);
    train_green = zeros(1, train_count);
    train_blue = zeros(1, train_count);
    
    train_group = cell(train_count, 1);

    for index = 1 : train_count
        set(0, 'CurrentFigure', hWB);
        waitbar((index/train_count), hWB, strrep(strcat('TrainSet(', TrainSet(index).group, '):', TrainSet(index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        area = TrainSet(index).regionprops.Area;
        perimeter = TrainSet(index).regionprops.Perimeter;
        train_matrix(index) = (perimeter ^ PerimeterPower) / (AreaMultiplication * pi * area);
        train_eccentricity(index) = TrainSet(index).regionprops.Eccentricity;
        
        train_contrast(index) = TrainSet(index).graycoprops.Contrast;
        train_correlation(index) = TrainSet(index).graycoprops.Correlation;
        train_energy(index) = TrainSet(index).graycoprops.Energy;
        train_homogeneity(index) = TrainSet(index).graycoprops.Homogeneity;

        train_red(index) = TrainSet(index).red_mean;
        train_green(index) = TrainSet(index).green_mean;
        train_blue(index) = TrainSet(index).blue_mean;
        
        train_group(index, 1) = {TrainSet(index).group};
    end    
        
    train_model = [ ...
        train_matrix; ...
        train_eccentricity; ...
        
        train_contrast; ...
        train_correlation; ...
        train_energy; ...
        train_homogeneity; ...
        
        train_red; ...
        train_green; ...
        train_blue ...
    ]';
    
    
    test_count = numel(TestSet);    
    test_matrix = zeros(1, test_count);
    test_eccentricity = zeros(1, test_count);
    
    test_contrast = zeros(1, test_count);
    test_correlation = zeros(1, test_count);
    test_energy = zeros(1, test_count);
    test_homogeneity = zeros(1, test_count);
    
    test_red = zeros(1, test_count);
    test_green = zeros(1, test_count);
    test_blue = zeros(1, test_count);

    for index = 1 : test_count
        set(0, 'CurrentFigure', hWB);
        waitbar((index/test_count), hWB, strrep(strcat('TestSet:', TestSet(index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        area = TestSet(index).regionprops.Area;
        perimeter = TestSet(index).regionprops.Perimeter;
        test_matrix(index) = (perimeter ^ PerimeterPower) / (AreaMultiplication * pi * area);
        test_eccentricity(index) = TestSet(index).regionprops.Eccentricity;
        
        test_contrast(index) = TestSet(index).graycoprops.Contrast;
        test_correlation(index) = TestSet(index).graycoprops.Correlation;
        test_energy(index) = TestSet(index).graycoprops.Energy;
        test_homogeneity(index) = TestSet(index).graycoprops.Homogeneity;

        test_red(index) = TestSet(index).red_mean;
        test_green(index) = TestSet(index).green_mean;
        test_blue(index) = TestSet(index).blue_mean;
    end

    test_model = [ ...
        test_matrix; ...
        test_eccentricity; ...
        
        test_contrast; ...
        test_correlation; ...
        test_energy; ...
        test_homogeneity; ...
        
        test_red; ...
        test_green; ...
        test_blue ...
    ]';

    result = predict(fitcknn( ...
        train_model, train_group, ...
        'NumNeighbors', NumNeighbors, ...
        'Standardize', Standardize ...
    ), test_model);
    
    result_count = numel(result);
    for index = 1 : result_count
        set(0, 'CurrentFigure', hWB);
        waitbar((index/result_count), hWB, strrep(strcat('ResultSet(', result(index), '):', TestSet(index).name), '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        TestSet(index).knn = char(result(index));
    end
    
    ret = TestSet;
    close(hWB);
    set(0, 'CurrentFigure', hApp);
end