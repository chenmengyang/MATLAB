function ID3tree = test(varargin)

%--------------------------------------------------------------------------

% if nargin < 2,  error('Training data and classes are needed for training!'); 
% end
% 
% trainData = varargin{1};
% trainClass = varargin{2};
% 
% 
% if     nargin < 5,           maxDepth = inf;
% elseif isempty(varargin(5)), maxDepth = Inf;
% else                         maxDepth = varargin{5};
% end
% 
% if     nargin < 4,           minNodeSz = 0; 
% elseif isempty(varargin(4)), minNodeSz = 0;
% else                         minNodeSz = varargin{4};
% end
% 
% if nargin < 3,
%     Nattr = size(trainData,2);
%     attrVals = cell(1,Nattr);
%     for a = 1:Nattr
%         attrVals{a} = unique(trainData(:,a));
%     end
% else
%     attrVals = varargin{3};
% end
% 
% NclassVals = length(unique(trainClass));

ID3tree = nargin;

%ID3tree = makeTree(trainData, attrVals, trainClass, NclassVals, minNodeSz,0,maxDepth);

end % ID3_learn

%--------------------------------------------------------------------------
function [tree] = makeTree(trainData,attrVals,trainClass,NclassVals, minNodeSz,depth,maxDepth)

%If there are only instances from one class left in the trainData;
Cvals = unique(trainClass);
if length(Cvals) == 1,
    tree = makeLeaf(Cvals);
    return
end

[Ndata,Nattr] = size(trainData);

% If there are no attributes left, or maximum depth has been reached
if  Ndata == 0 || Nattr == 0 || depth >= maxDepth
    tree = makeLeaf(mode(trainClass));
    return
end

% If there are still some training data from multiple classes left,
% calculate the entropy of each attribute and choose the smallest -
% i.e the the information gain is largest:

avalEntropy = zeros(1,Nattr);
for a = 1:Nattr,
    Avals = unique(trainData(:,a));
    for v = 1:length(Avals),
        aval = Avals(v);
        avalinds = ( trainData(:,a) == aval );
        cvalEntropy = 0;
        avalClasses = unique(trainClass(avalinds));
        for c = 1:length(avalClasses),            
            Pavalcval = sum( trainClass(avalinds) == avalClasses(c) ) / sum(avalinds);
            cvalEntropy = cvalEntropy - Pavalcval * log2(Pavalcval);
        end % classes within a value
        avalEntropy(a) = avalEntropy(a) + sum(avalinds)/Ndata * cvalEntropy;
    end % values within an attribute   
 end % attributes

 [~,Attribute] = min(avalEntropy);

% Make nodes out of each value of the chosen attribute:

tree = struct( 'attrNr',Attribute, 'values',attrVals(Attribute), 'nodes',[] );

%Avals = unique(trainData(:,Attribute));

for a = 1: length(tree.values),
    aval = tree.values(a);
    avalinds = ( trainData(:,Attribute) == aval );
    if sum(avalinds) == 0,
        if isnumeric(trainClass)
            leafClass = mode(trainClass);
        elseif ischar(trainClass)
            leafClass = char(mode(double(trainClass)));
        else error('Unknown datatype!')
        end
        tree.nodes = [tree.nodes, makeLeaf(leafClass)];
    else
        % collect data belonging to this aval
        avalData = trainData( avalinds, (1:end)~=Attribute );
        avalClass = trainClass(avalinds);
        avalAttrVals = attrVals((1:end)~=Attribute);
        if size(avalData,1) <= minNodeSz,
             if isnumeric(trainClass)
                 leafClass = mode(trainClass);
             elseif ischar(trainClass)
                 leafClass = char(mode(double(trainClass)));
             else error('Unknown datatype!')
             end
            tree.nodes = [tree.nodes, makeLeaf(leafClass)];
        else
            tree.nodes = [tree.nodes, makeTree(avalData,avalAttrVals,avalClass,NclassVals,minNodeSz,depth+1,maxDepth)];
        end
    end
end
end % function makeTree

%--------------------------------------------------------------------------
function leaf = makeLeaf(value)

leaf.attrNr = 0;
leaf.values = value;
leaf.nodes = {};

end 
%--------------------------------------------------------------------------
% The END
