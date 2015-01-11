% Dir: parent directory location for images folder c1, c2, c3
% inputImage: \c1\1.ppm
% filter: 'Gaussian', 'Motion', 'Prewit', 'Log'.
% For example to get P-R curve execute:  SpatialCBIR('D:\visionDB','\0.jpg','Gaussian')

 Dir='D:\visionDB';
 inputImage='\0.jpg';
 filter='prewit';
tic;

user_filter=filter;
S=strcat(Dir,inputImage);
Inp1=imread(S);
num_red_bins = 8;
num_green_bins = 8;
num_blue_bins = 8;
num_bins = num_red_bins*num_green_bins*num_blue_bins;
global h;
srcFiles = dir(strcat(Dir,'\*.jpg'));  
B = zeros(num_bins, 1000); % hisogram of other 100 images in category 1

if(strcmpi(user_filter,'gaussian')==1)
     h = fspecial('gaussian', [3 3], 1);% gauss filter
     if ~exist('gaussianDB.mat')
          createHistDB( Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
     else  load('gaussianDB.mat',);% ++
     end
end

if(strcmpi(user_filter,'motion')==1)% motion filter
  h=fspecial('motion', 20, 45);
  if ~exist('motionDB.mat')
          createHistDB(Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins, B );
   else  load('motionDB.mat');% ++
  end
end

if (strcmp(user_filter,'unsharp')==1)% sharp filter
  h=fspecial('unsharp');
  if ~exist('unsharpDB.mat')
          createHistDB(Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
   else  load('unsharpDB.mat');% ++
  end
end

if (strcmp(user_filter,'sobel')==1)% sobel filter
  h=fspecial('sobel');
  if ~exist('sobelDB.mat')
        createHistDB( Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins, B );
  else  load ('sobelDB.mat');% ++
  end
end

if (strcmp(user_filter,'log')==1)% log filter
  h = fspecial('log',[5 5], 0.5);
    if ~exist('logDB.mat')
          createHistDB( Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load ('logDB.mat');% ++
    end
end

if (strcmp(user_filter,'laplacian')==1)% laplace filter
  h = fspecial('laplacian', 0.2);                        
    if ~exist('laplacianDB.mat')
          createHistDB(Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
     else  load ('laplacianDB.mat') ;% ++
    end
end

if (strcmp(user_filter,'prewit')==1)% prewit filter
  h = fspecial('prewit');
    if ~exist('prewitDB.mat')
              createHistDB(Dir,srcFiles,filter,h,num_red_bins,num_green_bins,num_blue_bins,B );
    else  load('prewitDB.mat');% ++
    end
end
    
Inp1=imfilter(Inp1,h);%filter image
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
 