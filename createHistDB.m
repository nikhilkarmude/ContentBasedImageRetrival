function [] = createHistDB( num_bins,Dir,srcFiles,filter,h,num_red_bins,num_green_bins, num_blue_bins, B )

        for i = 1 : length(srcFiles)
            filename = strcat(Dir,'\',srcFiles(i).name);
            I = imread(filename);% filter image
            if(strcmpi(filter,'rgb')==0)
            I=imfilter(I,h);
            end
            
            B(:,i) = imcolourhist(I, num_red_bins, num_green_bins, num_blue_bins); 
        end
    save(strcat(filter,'DB.mat'),'B')
end

