run('D:\Vision Lectures\VLFEATROOT\vlfeat-0.9.19\toolbox\vl_setup');
tic;

Dir='D:\visionDB';
inputImage='\0.jpg';
S=strcat(Dir,inputImage);
Inp1=imread(S);
Inp1=single(rgb2gray(Inp1));
[fa,da] = vl_sift(Inp1) ;

 if ~exist('siftDB.mat')
            srcFiles = dir(strcat(Dir,'\*.jpg')); 
            B=zeros(length(srcFiles));
            img=zeros(length(srcFiles));
            for i = 1 : length(srcFiles)
                filename = strcat(Dir,'\',srcFiles(i).name);
                Inp2=imread(filename);
                Inp2=single(rgb2gray(Inp2));
                [fb, db] = vl_sift(Inp2) ;
                [matches, scores] = vl_ubcmatch(da, db) ;
                B(i)= numel(scores);
                img(i)=i-1;
            end
        save siftDB img B;
  else  load('siftDB.mat');
 end

  %PR curve creation
 sims=B;
  for i=1: 100 % number of relevant images for dir 1
     relevant_IDs(i) = i;
  end
 
 
 num_relevant_images = numel(relevant_IDs);

 [sorted_sims, locs] = sort(sims, 'descend');
 locations_final = arrayfun(@(x) find(locs == x, 1), relevant_IDs);
 locations_sorted = sort(locations_final);
 precision = (1:num_relevant_images) ./ locations_sorted;
 recall = (1:num_relevant_images) / num_relevant_images;
 plot(recall, precision, 'b.-');
 xlabel('Recall');
 ylabel('Precision');
 title('Precision-Recall Graph');
 axis([0 1 0 1.05]); 
 grid;
 
toc;
