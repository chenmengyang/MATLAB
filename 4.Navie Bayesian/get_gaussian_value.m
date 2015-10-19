%%
%Function name: get_gaussian_value
%Input parameters: validation_set, train_mean, train_variance
%Description: 
%Author: Chen Mengyang
%Date: 15.09.2015
%%

function gaussian_values = get_gaussian_value(validation_set, train_mean, train_variance, prior_probabilities)
  gaussian_values = zeros(length(validation_set),length(train_mean));
  for j = 1:size(gaussian_values,2)
      Pj = prior_probabilities(j);
      Pk = 1;
      for k = 1:size(validation_set,2)
          Pk = Pk.*mvnpdf(validation_set(:,k),train_mean(j,k),train_variance(j,k));
      end
      gaussian_values(:,j) = Pj*Pk; 
  end
end

