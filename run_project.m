clear
clc


%change image here
img1_file = 'e1.jpg';
img2_file = 'e1.jpg';


%img1_file1 = 'p1.jpg';
%img2_file1 = 'p1.jpg';



%img1_file2 = 'i1.jpg';
%img2_file2 = 'i2.jpg';


I1=imreadbw(img1_file) ; 
I2=imreadbw(img2_file) ;


%I11=imreadbw(img1_file1) ; 
%I21=imreadbw(img2_file1) ;


%I12=imreadbw(img1_file2) ; 
%I22=imreadbw(img2_file2) ;



I1=imresize(I1, [240 320]);
I2=imresize(I2, [240 320]);

%I11=imresize(I11, [240 320]);
%I21=imresize(I21, [240 320]);


%I12=imresize(I12, [240 320]);
%I22=imresize(I22, [240 320]);



I1_rgb = imread(img1_file) ; 
I2_rgb = imread(img2_file) ; 


%I1_rgb1 = imread(img1_file1) ; 
%I2_rgb1 = imread(img2_file1) ; 



%I1_rgb2 = imread(img1_file2) ; 
%I2_rgb2 = imread(img2_file2) ; 


I1_rgb =imresize(I1_rgb, [240 320]);
I2_rgb =imresize(I2_rgb, [240 320]);



%I1_rgb1 =imresize(I1_rgb1, [240 320]);
%I2_rgb1 =imresize(I2_rgb1, [240 320]);



%I1_rgb2 =imresize(I1_rgb2, [240 320]);
%I2_rgb2 =imresize(I2_rgb2, [240 320]);



I1=I1-min(I1(:)) ;
I1=I1/max(I1(:)) ;
I2=I2-min(I2(:)) ;
I2=I2/max(I2(:)) ;


%I11=I11-min(I11(:)) ;
%I11=I11/max(I11(:)) ;
%I21=I21-min(I21(:)) ;
%I21=I21/max(I21(:)) ;



%I12=I12-min(I12(:)) ;
%I12=I12/max(I12(:)) ;
%I22=I22-min(I22(:)) ;
%I22=I22/max(I22(:)) ;



[frames1,descr1,gss1,dogss1] = do_sift( I1, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; 
[frames2,descr2,gss2,dogss2] = do_sift( I2, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;





%[frames11,descr11,gss11,dogss11] = do_sift( I11, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; 
%[frames21,descr21,gss21,dogss21] = do_sift( I21, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;







%[frames12,descr12,gss12,dogss12] = do_sift( I12, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ; 
%[frames22,descr22,gss22,dogss22] = do_sift( I22, 'Verbosity', 1, 'NumOctaves', 4, 'Threshold',  0.1/3/2 ) ;









figure(1) ; clf ; plotss(dogss1) ; colormap gray ;
drawnow ;


figure(2) ; clf ; plotss(dogss2) ; colormap gray ;
drawnow ;


figure(3) ; clf ;
imshow(I1_rgb) ; axis image ;

hold on ;
h=plotsiftframe( frames1 ) ; set(h,'LineWidth',1,'Color','g') ;



figure(4) ; clf ;
imshow(I2_rgb) ; axis image ;

hold on ;
h=plotsiftframe( frames2 ) ; set(h,'LineWidth',1,'Color','g') ;









fprintf('No. of matches for Ear.\n') ;
descr1 = descr1';
descr2 = descr2';

tic ; 

m1=do_match(I1, descr1, frames1',I2, descr2, frames2' ) ;
fprintf('Matched in %.3f s\n', toc) ;



%fprintf('No. of matches for Palm.\n') ;
%descr11 = descr11';
%descr21 = descr21';

%tic ; 

%m2=do_match(I11, descr11, frames11',I21, descr21, frames21' ) ;
%fprintf('Matched in %.3f s\n', toc) ;







%fprintf('No. of matches for iris.\n') ;
%descr12 = descr12';
%descr22 = descr22';

%tic ; 

%m3=do_match(I12, descr12, frames12',I22, descr22, frames22' ) ;
%fprintf('Matched in %.3f s\n', toc) ;






%k1=size(frames1,2);
%k2=size(frames2,2);


%k11=size(frames11,2);
%k21=size(frames21,2);


%k12=size(frames12,2);
%k22=size(frames22,2);



%kk=min([k1,k2]');
%kk1=min([k11,k21]');
%kk2=min([k12,k22]');

%disp('Percentage match for Ear');
%p1=m1*100/kk;
%disp(p1);

%disp('Percentage match for Palm');
%p2=m2*100/kk1;
%disp(p2);


%disp('Percentage match for iris');
%p3=m3*100/kk2;
%disp(p3);




%disp('overall Percentage matching');
%per=(m1+m2+m3)*100/(kk+kk1+kk2);
%disp(per);
