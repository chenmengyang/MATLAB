function classes = random_forest_classify(data, forest)
%x stands for how many trees the forest has, y is the number of data's rows
x = length(forest.trees);
y = size(data,1);
classes = zeros(y,x);
for i = 1:x
    %extract the features useful with the tree(i)
    sub_date = data(:,forest.features(i,:));
    classes(:,i) = ID3_classify(sub_date,forest.trees(i));
end

%vote, the majority wins
classes = mode(classes,2);

end
