function data_cluster(DataTrain, DataTest, DataExpect, CSVOutput, KNN, ANN, Bayesian)
    image_extension = 'jpg';
    
    instance_order_domain = 5;
    instance_order_s = 3;
    instance_graythresh_division = 2;
    
    perimeter_power = 2;
    area_multiplication = 4;
    
    knn_numneighbors = 5;
    knn_standardize = 1;
    
    ann_goal = 1e-6; % MSE
    ann_spread = 1;
    ann_mn = 5;
    ann_df = 20;    
    
    %~ ====================================================================

    clc;
    
    trainclass = train_class(DataTrain);
    [width, height] = data_area(DataTrain, DataTest, trainclass, image_extension);
    
    temp = tempname(tempdir)    
    data_normalize(DataTrain, DataTest, trainclass, width, height, temp, image_extension);
        
%     temp = 'C:\Users\Jani\AppData\Local\Temp\tp6e2f8215_3b07_4475_b49e_e8ce4ace7d3b';
    [trainset, testset] = data_instance( ...
        DataTrain, DataTest, DataExpect, ...
        trainclass, temp, image_extension, ...
        instance_order_domain, instance_order_s, instance_graythresh_division ...
    );    
    
    if (KNN == 1)
        testset = method_knn( ...
            trainset, testset, ...
            perimeter_power, area_multiplication, ...
            knn_numneighbors, knn_standardize ...
        );
    end
    
    if (ANN == 1)
        testset = method_ann( ...
            trainset, testset, trainclass, ...
            perimeter_power, area_multiplication, ...
            ann_goal, ann_spread, ann_mn, ann_df ...
        );
    end
    
    if (Bayesian == 1)
%         test = data_bayesian(train, test, image_extension);
    end

    data_csv(testset, CSVOutput);
%     rmdir(temp, 's'); % recursive

    close all;
    msgbox('Done!');
end