function [ dis ] = cal_distance(vec1,vec2,p)
%CAL_DISTANCE Summary of this function goes here
%Detailed explanation goes here
  %Minkowski distance
  dis = (sum(abs(vec1 - vec2).^p))^(1/p);
  %Manhattan distance
  %dis = sum(abs(vec1-vec2));
  %Cosine distance
  %dis = sum(vec1.*vec2)/(sum(vec1.^2)^0.5+ sum(vec2.^2)^0.5);
end