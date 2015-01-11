% Dir: parent directory location for images like D:\visionDB
% inputImage: \0.jpg
% filter: 'rgb', 'Gaussian', 'Motion', 'Prewit', 'Log', 'Laplacian','Unsharp', 'Sobel'.
% For example to get P-R curve execute:  SpatialCBIR('D:\visionDB','\0.jpg','Gaussian')
function [ avgprec, rankvalue ] = SpatialCBIR( Dir,inputImage,filter,category)
% Dir='D:\visionDB';
% inputImage='\0.jpg';
% setup VLFeat for SIFT
% run('D:\Vision Lectures\VLFEATROOT\vlfeat-0.9.19\toolbox\vl_setup');

user_filter=filter;
S=strcat(Dir,inputImage);
Inp1=imread(S);
num_red_bins = 8;
num_green_bins = 8;
num_blue_bins = 8;
num_bins = num_red_bins*num_green_bins*num_blue_bins;
global h;
srcFiles = dir(strcat(Dir,'\*.jpg'));  
B = zeros(num_bins, 1000); % histogram of other 1000 images in category 1

if (strcmpi(user_filter,'rgb')==1)% normal rgb process
      if ~exist('rgbDB.mat')
              createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load('rgbDB.mat');% ++
    end
end
if(strcmpi(user_filter,'gaussian')==1)
     h = fspecial('gaussian', [3 3], 1);% gauss filter
     if ~exist('gaussianDB.mat')
          createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
     else  load('gaussianDB.mat');% ++
     end
end

if(strcmpi(user_filter,'motion')==1)% motion filter
  h=fspecial('motion', 20, 45);
  if ~exist('motionDB.mat')
          createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins, B );
   else  load('motionDB.mat');% ++
  end
end

if (strcmpi(user_filter,'unsharp')==1)% sharp filter
  h=fspecial('unsharp');
  if ~exist('unsharpDB.mat')
          createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
   else  load('unsharpDB.mat');% ++
  end
end

if (strcmpi(user_filter,'sobel')==1)% sobel filter
  h=fspecial('sobel');
  if ~exist('sobelDB.mat')
        createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins, B );
  else  load ('sobelDB.mat');% ++
  end
end

if (strcmpi(user_filter,'log')==1)% log filter
  h = fspecial('log',[5 5], 0.5);
    if ~exist('logDB.mat')
          createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load ('logDB.mat');% ++
    end
end

if (strcmpi(user_filter,'laplacian')==1)% laplace filter
  h = fspecial('laplacian', 0.2);                        
    if ~exist('laplacianDB.mat')
          createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
     else  load ('laplacianDB.mat') ;% ++
    end
end

if (strcmpi(user_filter,'prewit')==1)% prewit filter
  h = fspecial('prewit');
    if ~exist('prewitDB.mat')
              createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load('prewitDB.mat');% ++
    end
end

if(strcmpi(user_filter,'sift')==1)
    %perform extrcation for input image
    [fa,da] = vl_sift(single(rgb2gray(Inp1))) ;
    hold on ;
    perm = randperm(size(fa,2)) ;
    sel  = perm(1:50) ;
    h1   = vl_plotframe(fa(:,sel)) ; set(h1,'color','k','linewidth',3) ;
    h2   = vl_plotframe(fa(:,sel)) ; set(h2,'color','y','linewidth',2) ;
   % perform extrcation for database images and store them.
    if ~exist('siftDB.mat')
              createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load('siftDB.mat');% ++
    end
end
if(strcmpi(filter,'rgb')==0)
Inp1=imfilter(Inp1,h);%filter image
end
A = imcolourhist(Inp1, num_red_bins, num_green_bins, num_blue_bins);%input image histogram


%normal histogram intersection
a = size(A,2); b = size(B,2); 
K = zeros(a, b);
for i = 1:a
  Va = repmat(A(:,i),1,b);
  K(i,:) = 0.5*sum(Va + B - abs(Va - B));
end


%PR curve creation
 sims=K;
  
 relevant_IDs = (category - 1) * 100 + (1:100);
  
 num_relevant_images = numel(relevant_IDs);

 [sorted_sims, locs] = sort(sims, 'descend');
 
 locations_final = arrayfun(@(x) find(locs == x, 1),relevant_IDs);
 locations_sorted = sort(locations_final);
 precision = (1:num_relevant_images) ./ locations_sorted;
 recall = (1:num_relevant_images) / num_relevant_images;
%  plot(recall, precision, 'b.-');
%  xlabel('Recall');
%  ylabel('Precision');
%  title('Precision-Recall Graph');
%  axis([0 1 0 1.05]); 
 ptr=1;
 %get avg rank
 ranka=[];
 for j=1:numel(locs)
     if(locs(j)>= min(relevant_IDs)&&(locs(j)<= max(relevant_IDs)))
     ranka(ptr)=j;
     ptr=ptr+1;
     end
 end
rankvalue=sum(ranka)/numel(relevant_IDs);
 
% generate Avg precision
  avgprec=0;
%  for k=1:numel(relevant_IDs)
%      if(k==1)
%      avgprec = avgprec+ (precision(k)* (recall(k)));
%      else 
%      avgprec = avgprec+ (precision(k)* (abs(recall(k-1)-recall(k))));
%      end
%  end
 % calculate ranks
 avgprec=sum(precision)/numel(relevant_IDs);
%  plot(avgprec, 'b.-');
%  xlabel('Category ID');
%  ylabel('Average Precision');
%  title('Average Precision Plot');
%  axis([0 10 0 1.05]); 
% %  grid;
  

end 