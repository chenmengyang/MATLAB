%%
%Function name: get_class
%Input parameters: training_set,training_result,validation_vector
%Description: To get the class by caculate the nearest distance in the
%             training set
%Author: Chen Mengyang
%Date: 04.09.2015
%%
function class = get_class(training_set,training_result,validation_vector)
  %m stands for how many rows in the training set
  m=size(training_set,1);
  %Initialise n and min
  n=1;
  min=dist(training_set(n,:),validation_vector');
  for i = 1:m
      x = training_set(i,:);
      %distance = dist(x,validation_vector');
      distance = sum((x-validation_vector).^2).^0.5;
      if distance < min
          min = distance;
          n = i;
      end
  end
  class = training_result(n);
end