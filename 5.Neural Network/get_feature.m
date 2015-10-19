%%
%Function name: get_feature
%Input parameters: slots, img
%Description: To transform a img matrix to a one dimension vector
%Author: Chen Mengyang
%Date: 04.09.2015
%%
function f = get_feature(slots,img)
  Red=img(:,:,1);
  Green=img(:,:,2);
  Blue=img(:,:,3);
  %reshape all to one vector
  A1=reshape(Red.',[],1)';
  B1=reshape(Green.',[],1)';
  C1=reshape(Blue.',[],1)';
  %set the range for histogram
  binranges=0:slots:255;
  %for each color make a histogram
  f1=histc(A1,binranges)';
  f2=histc(B1,binranges)';
  f3=histc(C1,binranges)';
  f=[f1;f2;f3];
  
end