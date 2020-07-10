function ret = train_class(DataTrain)
    ret = {};
    
    data = dir(DataTrain);
    temp = data([data(:).isdir]);
    buffer = temp(~ismember({temp(:).name}, {'.', '..'}));
    
    count = numel(buffer);
    for index = 1 : count
        ret = [ret; buffer(index).name];
    end    
end