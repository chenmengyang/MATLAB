%%
%Function name: get_feature
%Input parameters: slots, img
%Description: To transform a img matrix to a one dimension vector
%Author: Chen Mengyang
%Date: 09.09.2015
%%
function f = get_feature2(img)
  Red=img(:,:,1);
  Green=img(:,:,2);
  Blue=img(:,:,3);
  %reshape all to one vector
  A1=reshape(Red.',1,[]);
  B1=reshape(Green.',1,[]);
  C1=reshape(Blue.',1,[]);
  %for each color pixel choose the biggest one
  f = zeros(length(A1),1);
  for i = 1:length(A1)
      v = [A1(i) B1(i) C1(i)];
      m = max(v);
      n = find(v == m);
      f(i) = n(1);
  end
end

