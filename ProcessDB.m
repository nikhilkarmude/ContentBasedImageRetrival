function [  ] = ProcessDB( Dir )
num_red_bins = 8;
num_green_bins = 8;
num_blue_bins = 8;
num_bins = num_red_bins*num_green_bins*num_blue_bins;

srcFiles = dir(strcat(Dir,'\*.jpg'));  
hist1 = zeros(num_bins, length(srcFiles)); 
name1=[];
tic;

for i = 1 : length(srcFiles)
    filename = strcat(Dir,'\',srcFiles(i).name);
    name={srcFiles(i).name};
    name1=[name1;name];
    hist1(:,i) = imcolourhist(imread(filename), num_red_bins, num_green_bins, num_blue_bins); 
                                                       
end

save basicDB name1 hist1
toc;
end 