% Dir: parent directory location for images folder c1, c2, c3
% inputImage: \c1\1.ppm
% For example to get P-R curve execute: CBIR('D:\visionImages','\c2\1.ppm');
function [  ] = demoCBIR( Dir,inputImage)
% Dir='D:\visionImages';
% inputImage='\c3\1.ppm';
S=strcat(Dir,inputImage);
Inp1=imread(S);
num_red_bins = 8;
num_green_bins = 8;
num_blue_bins = 8;
num_bins = num_red_bins*num_green_bins*num_blue_bins;
A = imcolourhist(Inp1, num_red_bins, num_green_bins, num_blue_bins);%input image histogram
srcFiles = dir(strcat(Dir,'\*.jpg'));  
B = zeros(num_bins, 100); % hisogram of other 100 images in category 1

for i = 1 : length(srcFiles)
    filename = strcat(Dir,'\',srcFiles(i).name);
    I = imread(filename);
    B(:,i) = imcolourhist(I, num_red_bins, num_green_bins, num_blue_bins); 
                                                       
end

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
end 