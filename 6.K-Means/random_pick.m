function [ cents ] = random_pick(data, K)
%RANDOM_PICK Summary of this function goes here
%   Detailed explanation goes here
  cents = [];
  n = size(data,2);
  for i=1:n
     min_i = min(data(:,i));
     range_i = max(data(:,i)) - min(data(:,i));
     cents(:,i) = min_i + range_i * rand(K,1);
  end
end