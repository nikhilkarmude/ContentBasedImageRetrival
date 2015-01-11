Dir='D:\visionDB\';
%filterarr='gaussian';
filterarr={'rgb','log','gaussian','laplacian','motion','unsharp','prewit','sobel'};
ptr=1;
tic;

for i=1:length(filterarr)
    filter=filterarr{i};
    disp(['For Filter: ', filter]);
    disp('Category  Max_Avg_Precision  Rank  image No     Min avg Prec   Img No');
    ptr1=1;
 for category=1:10
    clear avg; clear avgrank;
    ptr=1;
   for i=0:999
     inputImage=strcat(int2str(i),'.jpg');
     [ avgprec, rankvalue ] = SpatialCBIR( Dir,inputImage,filter,category);
     avg(ptr)=avgprec;
     avgrank(ptr)=rankvalue;
     ptr=ptr+1;
    
   end

 [maxval, maxidx] = max(avg);
 [minval, minidx] = min(avg);
  maxrank=avgrank(maxidx);
%   X=[num2str(category),'  ', num2str(maxval),'  ',num2str(maxrank),'  ', num2str(maxidx-1),'  ',num2str(minval),'  ',num2str(minidx-1)];
% X=[num2str(category),'       ', num2str(maxval),'       ',num2str(maxrank)];
%  disp(X);
avgp(ptr1)=maxval;
rank(ptr1)=maxrank;
imgno(ptr1)=maxidx-1;
ptr1=ptr+1;
 end
[v rind] =max(avgp);
myrank=rank(rind);
myimg=imgno(rind); 
X=[num2str(myimg),'   ', num2str(v),'   ',num2str(myrank)];
disp(X);
 
end
toc;