

%% ImageNet - a tiny dataset
% This is a script that can be used to import and process images from 
% ImageNet-tiny dataset prepared for usage in SGN-1300/13006 course.

%% Definitions and preparations:

%__________________________________________________________________________
% It is a good manner in programming to include all the information about
% the used configuration - paths and parameters - in one place
% - here, a structure called 'conf'.
% Change paths if you are working somewhere else than on Lintula computer.

conf.root_dir = '/Users/cmy/Documents/Data/';%'/share/sgncourses/mlintro/Data/';
conf.orig_imgs_dir = 'ImageNet/ILSVR2014/CLS-LOC/';
conf.tiny_imgs_dir = 'ImageNet-tiny-8x8-sRGB-8bit';
conf.train_imgs_dir = [conf.tiny_imgs_dir '/ILSVR2014/CLS-LOC/ILSVRC2012_img_train/'];
conf.val_imgs_dir =   [conf.tiny_imgs_dir '/ILSVR2014/CLS-LOC/ILSVRC2012_img_val/'];

conf.info_dir = 'ILSVRC2014_devkit/data/';
conf.val_list_file = [ conf.info_dir 'ILSVRC2014-tiny-5-validation-filelist.txt'];
conf.val_true_classes_file = [ conf.info_dir '/ILSVRC2014_clsloc_validation_ground_truth-tiny-5.txt'];

%conf.predicted_classes_file =
%'WRITE_YOUR_OWN_PATH_HERE!/demo-tiny-5.val.pred.loc.txt'; Use this if you
%want to use the evaluation script from ILSVRC2014_devkit.
conf.selected_synsets = ...    % 'synset' = 'set of synonyms' = 'class'
    {'n02676566','n01773157','n01622779','n03452741','n01944390'};

conf.number_of_slots = 20;

%__________________________________________________________________________
% Collect the class ID numbers for the selected classes/synsets
% into 'class_IDs'. These are the same class ID numbers that are given
% in the 'ground truth class' -file.

classIDnumbers = nan(length(conf.selected_synsets),1);
NfoundSynsets = 0;
load(fullfile(conf.root_dir, conf.info_dir, ...
              'meta_clsloc.mat'));   % This loads 'synsets' -structure 
for classInd = 1:length(synsets)
    
  if ~isempty(strmatch(synsets(classInd).WNID,conf.selected_synsets))
    NfoundSynsets = NfoundSynsets+1;
    fprintf('Found %2d/%2d: %s\n', NfoundSynsets,length(conf.selected_synsets),...
            synsets(classInd).words);
    classIDnumbers(NfoundSynsets) = synsets(classInd).ILSVRC2014_ID;
    
  end;
end;

%__________________________________________________________________________
% Collect a file list of train images into 'trainFileNums'
% (as it is not given like the list of evaluation files)
% and 'trainFileClass'

train_file_nums = [];
train_classes = [];
NC = length(conf.selected_synsets);

for class = 1:NC
    imlist = dir([fullfile(conf.root_dir, conf.train_imgs_dir, ...
                           conf.selected_synsets{class}) '/*.bmp']);
    
    train_classes = [train_classes; class*ones(length(imlist),1)];
    
    N_train_files = length(train_file_nums);
    train_file_nums = [train_file_nums; zeros(length(imlist),1)]; % Preallocation
    for m = 1:length(imlist)
        underscore_inds = strfind(imlist(m).name,'_');
        im_ind = imlist(m).name(underscore_inds(1)+1:underscore_inds(2)-1);
        train_file_nums(N_train_files+m) = str2num(im_ind);
    end
end

N_train_files = length(train_file_nums);

%% Start processing by collecting information about the training data
Features_train=[];

for n = 1:N_train_files
   %if mod(n,100)==1
      %figure(n);
      synsetID = conf.selected_synsets{train_classes(n)};
      imPath = fullfile(conf.root_dir, conf.train_imgs_dir, synsetID);
      imFile = sprintf('%s_%d_tiny.bmp',synsetID,train_file_nums(n));

      img = imread(fullfile(imPath,imFile),'bmp');
      %subplot(1,2,1),imshow(img);
      %The original image can be found here:
      %origImPath = fullfile(conf.root_dir,'ImageNet/ILSVR2014/CLS-LOC',synsetID);
      %origImFile = sprintf('%s_%d.JPEG',synsetID,train_file_nums(n));
      %origImg = imread(fullfile(origImPath,origImFile),'jpg');
      %subplot(1,2,2),imshow(origImg);
      %------------------------------------------------------------------------
      % Here extract image features and save them for use in training phase. 
      fprintf('Extracting picture%d features\n',n);
      Features_train = [Features_train;get_feature(img)];
      %------------------------------------------------------------------------
      % imshow(
   %end
   
end

%% Do the classifier training here
% AttrVals = cell(1,size(Features_train,2));
% AttrVals(:)= {[1,2,3]};
% ID3tree = ID3_learn(Features_train, train_classes, AttrVals);
forest = random_forest_learn(Features_train, train_classes, 20);

%% Classification with evaluation data


% First import the list of file numbers of images that belong to the 5-class evaluation set.
validation_image_list_file = fullfile(conf.root_dir,  conf.val_list_file);
FID_val_list = fopen(validation_image_list_file,'r');
eval_file_nums =  fscanf(FID_val_list,'%d');
fclose(FID_val_list);
N_eval_files = length(eval_file_nums);

% Then, classify all the images of the evaluation set:
%predicted_classes = zeros(N_eval_files,1); % space allocation
Features_predicted = [];

 for n = 1:N_eval_files
  imFile = sprintf('ILSVRC2012_val_%08d_tiny.bmp',eval_file_nums(n));
  imPath = fullfile(conf.root_dir, conf.val_imgs_dir);
  img = imread(fullfile(imPath,imFile),'bmp');
  
  %------------------------------------------------------------------------
  % Here extract image features and use your trained classifier to
  % assign a class ID to the image.
  predicted_vector = get_feature(img);
  Features_predicted = [Features_predicted;predicted_vector];
  %fprintf('Predicting picture %d\n',n);
  %class = get_class(Features_train,train_classes,predicted_vector);
  %class = 1;
  %predicted_classes(n) = classIDnumbers(class); % Converting class number 1...5 to ImageNet class ID.
  
  %------------------------------------------------------------------------
end;

predicted_classes = random_forest_classify(Features_predicted, forest);
for n = 1:N_eval_files
  predicted_classes(n) = classIDnumbers(predicted_classes(n));
end
%% Get results

% First, load 
validation_image_GTclasses_file = fullfile(conf.root_dir, conf.val_true_classes_file );
FID_val_list = fopen(validation_image_GTclasses_file,'r');
eval_classes = fscanf(FID_val_list,'%d');
fclose(FID_val_list);



% Here calculate the error rate or however you want to analyze the classification result.
% n=0;
% for i=1:length(predicted_classes)
%    if  predicted_classes(i) == eval_classes(i)
%        n = n + 1;
%    end
% end
% accuracy = n/length(predicted_classes);

fprintf('Train Accuracy: %f\n', mean(double(predicted_classes == eval_classes)) * 100);
%% The END

