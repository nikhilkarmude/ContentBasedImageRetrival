Dir='D:\visionDB\';
disp(['For Filter: SIFT']);
disp('Category   Img_No  Avg_Precision');
tic;
for category=1:10
   for i=0:100:999
     inputImage=strcat(int2str(i),'.jpg');
     [ avgprec ] = SIFT( Dir,inputImage, category);
   X=[num2str(category),' ',num2str(inputImage),' ', num2str(avgprec)];
   disp(X);
   end
end
toc;