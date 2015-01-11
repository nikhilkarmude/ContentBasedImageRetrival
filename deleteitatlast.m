Dir='D:\visionDB\';
disp(['For Filter: SIFT']);
disp('Category  Max_Avg_Precision  Img_No  Min_Avg_Precision  Img_No');

for category=1:10
    clear avg; 
    ptr=1;
   for i=0:1000:100
     inputImage=strcat(int2str(i),'.jpg');
     [ avgprec ] = SIFT( Dir,inputImage, category)
   end
    
end   

 [maxval, maxidx] = max(avg);
 [minval, minidx] = min(avg);
 X=[num2str(category),'  ', num2str(maxval),'  ', num2str(maxidx-1),'  ',num2str(minval),'  ',num2str(minidx-1)];
 disp(X);
 end