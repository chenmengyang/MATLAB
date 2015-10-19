function [means, inds] = BiKmeans(data,K,D)
%BIKMEANS Summary of this function goes here
%   Detailed explanation goes here
  means = mean(data);
  m = size(data,1);
  inds = ones(m,2);
  for x=1:m
     inds(x,2) = D(data(x,:),means,2)^2; 
  end
  while size(means,1) < K
      lowest_sse = inf;
      for i=1:max(inds(:,1))
         sub_data = data(find(inds==i),:);
         [sub_means, sub_inds] = MyKmeans(sub_data,2,D);
         sub_sse = sum(sub_inds(:,2));
         other_sse = sum(inds(find(inds(:,1)~=i),2));
         
         if sub_sse+other_sse < lowest_sse
             lowest_sse = sub_sse+other_sse;
             best_to_split = i;
             best_means = sub_means;
             best_inds = sub_inds;
         end
      end
      sub_inds(find(sub_inds(:,1)==1),1) = best_to_split;
      sub_inds(find(sub_inds(:,1)==2),1) = size(means,1)+1;
      means(size(means,1),:) = best_means(1,:);
      means(size(means,1)+1,:) = best_means(2,:);
      inds(find(inds(:,1)==best_to_split),:) = best_inds;
  end
end