%%
%Function name: get_feature
%Input parameters: slots, img
%Description: To transform a img matrix to a one dimension vector
%Author: Chen Mengyang
%Date: 04.09.2015
%%
function f = get_feature(img)
  Red=img(:,:,1);
  Green=img(:,:,2);
  Blue=img(:,:,3);
  %
  f=[mean(Red(:)),mean(Green(:)),mean(Blue(:))];
  
end