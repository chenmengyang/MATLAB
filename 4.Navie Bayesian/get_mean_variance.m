%%
%Function name: get_mean_variance
%Input parameters: training_set, train_classes
%Description: To caculate the mean and variance values for each type in
%             the training set
%Author: Chen Mengyang
%Date: 15.09.2015
%%
function [train_mean, train_variance] = get_mean_variance(training_set, train_classes)
  num_types = length(unique(train_classes));
  for i = 1:num_types
      %caculate the mean values for type i
      index = find(train_classes == i);
      red = training_set(index,1);
      green = training_set(index,2);
      blue = training_set(index,3);
      mean_r = mean(red);
      mean_g = mean(green);
      mean_b = mean(blue);
      train_mean(i,:) = [mean_r mean_g mean_b];
      %caculate the variance values for type i
      variance_r = sum((red-mean_r).^2)/(length(red)-1);
      variance_g = sum((green-mean_g).^2)/(length(green)-1);
      variance_b = sum((blue-mean_b).^2)/(length(blue)-1);
      train_variance(i,:) = [variance_r variance_g variance_b];
  end
  %
end