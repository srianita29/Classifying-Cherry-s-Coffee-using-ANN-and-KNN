function data_csv(TestSet, CSVOutput)    
    hApp = gcf;
    hWB = waitbar(0, strrep(strrep(CSVOutput, '\', '\\'), '_', '\_'), 'Name', 'Data CSV');
%     
    data = {};
    test_count = numel(TestSet);
    for test_index = 1 : test_count
        set(0, 'CurrentFigure', hWB);
        waitbar((test_index/test_count), hWB, strrep(TestSet(test_index).name, '_', '\_'));
        set(0, 'CurrentFigure', hApp);
        
        data(test_index).Filename = TestSet(test_index).origin;
        data(test_index).Expect = TestSet(test_index).expect;
        data(test_index).KNN = TestSet(test_index).knn;
        data(test_index).ANN = TestSet(test_index).ann;        
        data(test_index).Bayesian = TestSet(test_index).bayesian;     
    end
    
    writetable(struct2table(data), CSVOutput);
            
    close(hWB);
    set(0, 'CurrentFigure', hApp);
end