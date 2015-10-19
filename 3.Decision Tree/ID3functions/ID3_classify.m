function Classes = ID3_classify(testData,tree)

%ID3_classify uses ID3tree for classifying test data.
% 
% Usage: 
% Classes = ID3_classify(TestData, ID3tree)
%       The input argument 'TestData' is a matrix holding each test sample 
%    vector on one of it's rows. Each column of a matrix represents an
%    attribute. Another input argument 'ID3tree' is a tree structure 
%    constructed by 'ID3_learn' -function.
%       The output 'Classes' is a column vector of the same height as 
%    'TestData', and it returns a predicted class for each test data
%    vector.


Ndata = size(testData,1);

Classes = zeros(Ndata,1);
for n=1:Ndata,
   Classes(n) = ID3read(testData(n,:), tree);
end

end % ID3_classify

function Class = ID3read(testDatavec, tree)

% if there is only a leaf available in the tree
if tree.attrNr == 0,
   Class = [tree.values];
   return
end

% if the tree is bigger than just a leaf:
v = ( testDatavec(tree.attrNr) == tree.values );

if isempty(v)    % if this attribute value doesn't exist in the tree
    Class = NaN;
    return
else
    inds = ( (1:length(testDatavec)) ~= tree.attrNr  );
    Class = ID3read(testDatavec(inds),tree.nodes(v));
end
end % ID3reaad

