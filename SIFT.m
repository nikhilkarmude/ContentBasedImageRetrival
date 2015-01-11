% Reference: http://www.vlfeat.org/overview/sift.html
% Dir: parent directory location for images like D:\visionDB
% inputImage: \0.jpg
% For example to get P-R curve execute:  SIFT('D:\visionDB','\0.jpg')
function [ avgprec] = SIFT( Dir,inputImage, category)

run('D:\Vision Lectures\VLFEATROOT\vlfeat-0.9.19\toolbox\vl_setup');
% tic;
peak_thresh=20;
S=strcat(Dir,inputImage);
Inp1=imread(S);
Inp1=single(rgb2gray(Inp1));
[fa,da] = vl_sift(Inp1,'PeakThresh', peak_thresh) ;
srcFiles = dir(strcat(Dir,'\*.jpg')); 
B=zeros(length(srcFiles));
%  if ~exist('siftDB.mat')
            
           
            for i = 1 : length(srcFiles)
                filename = strcat(Dir,'\',srcFiles(i).name);
                Inp2=imread(filename);
                Inp2=single(rgb2gray(Inp2));
                [fb, db] = vl_sift(Inp2,'PeakThresh', peak_thresh) ;
                [matches, scores] = vl_ubcmatch(da, db) ;
                B(i)= numel(scores);
                
            end
%         save('siftDB.mat','B')
%          else  load('siftDB.mat');
%  end

  %PR curve creation
 sims=B;
 relevant_IDs = (category - 1) * 100 + (1:100);
 num_relevant_images = numel(relevant_IDs);
 [sorted_sims, locs] = sort(sims, 'descend');
 locations_final = arrayfun(@(x) find(locs == x, 1), relevant_IDs);
 locations_sorted = sort(locations_final);
 precision = (1:num_relevant_images) ./ locations_sorted;
 recall = (1:num_relevant_images) / num_relevant_images;
%  plot(recall, precision, 'b.-');
%  xlabel('Recall');
%  ylabel('Precision');
%  title('Precision-Recall Graph');
%  axis([0 1 0 1.05]); 
%  grid;
 % generate average Precision
 % generate Avg precision
 avgprec=0;
 for k=1:numel(relevant_IDs)
     if(k==1)
     avgprec = avgprec+ (precision(k)* (recall(k)));
     else 
     avgprec = avgprec+ (precision(k)* (abs(recall(k-1)-recall(k))));
     end
 end
 plot(avgprec, 'b.-');
%  xlabel('Category ID');
%  ylabel('Average Precision');
%  title('Average Precision Plot');
%  axis([0 10 0 1.05]); 
%  grid;
%  toc;


end

