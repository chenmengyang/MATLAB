function forest = random_forest_learn(traindata, trainclass, N)
%random_forest_learn constructs a forest using ID3_learn
% 
% Usage: 
% forest = random_forest_learn(traindata, trainclass, N)
%
%  Example:

% author: Chen Mengyang
%--------------------------------------------------------------------------
%how many rows and columns to extract
rows=round((2/(N+1))*size(traindata,1));
columns=round((2/(N+1))*size(traindata,2));
%Initialise the forest
%forest.trees = cell(N,3);
forest.features = NaN(N,columns);
%Initial the third parameter of ID3_learn
AttrVals = cell(1,columns);
AttrVals(:)= {[1,2,3]};
%class the ID3_learn N times to form the forest
for i = 1:N
    %randomly extract rows and features from origional training set
    r = sort(randperm(size(traindata,1),rows));
    f = sort(randperm(size(traindata,2),columns));
    %extract datas and save features for later's classification
    forest.features(i,:) = f;
    sub_traindata = traindata(r,:);
    sub_traindata = sub_traindata(:,f);
    %extract corresponding classes with the randomly selected rows
    sub_trainclass = trainclass(r,:);
    %
    forest.trees(i) = ID3_learn(sub_traindata, sub_trainclass, AttrVals);
end