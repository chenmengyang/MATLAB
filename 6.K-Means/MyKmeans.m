function [means, inds] = MyKmeans(data,K,D)
%MYKMEANS Summary of this function goes here
%   Detailed explanation goes here
  means = random_pick(data, K);
  m = length(data);
  inds = zeros(m,2);
  change_flag = true;
  while change_flag == true
     change_flag = false;
     for i=1:m
         minDistance = inf;
         minIndex = -1;
         for j=1:K
            distance = D(data(i,:),means(j,:),3);
            if distance < minDistance
                minDistance = distance;
                minIndex = j;
            end
         end
         if inds(i,1) ~= minIndex
             change_flag = true;
             inds(i,1) = minIndex;
             inds(i,2) = minDistance^2;
         end
     end
     %update the value of centriods
     for i=1:K
         means(i,:) = mean(data(find(inds(:,1)==i),:)); 
     end
  end
end
