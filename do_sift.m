function [frames,descriptors,scalespace,difofg]=sift(I,varargin)
[M,N,C] = size(I) ;
S=3 ;
omin= 0 ;
O = 4;
sigma0=1.6*2^(1/S) ;
sigman=0.5 ;
thresh = 0.2 / S / 2 ; % 0.04 / S / 2 ;
r = 18 ;
NBP = 4 ;
NBO = 8 ;
magnif = 3.0 ;
compute_descriptor = 0 ;
discard_boundary_points = 1 ;
verb = 0 ;
if C > 1
  error('I should be a grayscale image') ;
end

frames = [] ;
descriptors = [] ;



scalespace = do_gaussian(I,sigman,O,S,omin,-1,S+1,sigma0) ;
difofg = do_diffofg(scalespace) ;

for o=1:scalespace.O 
%	fprintf('computing octave %d\n', o-1+omin) ;
                tic ;
    oframes1 = do_localmax(  difofg.octave{o}, 0.8*thresh, difofg.smin  ) ;
	oframes = [oframes1 , do_localmax( - difofg.octave{o}, 0.8*thresh, difofg.smin)] ; 
    
    
 %   fprintf('initial keypoints # %d.  \n',size(oframes, 2)) ;
 %   fprintf('                Time (%.3f s)\n',toc) ;
    tic ;
	
    if size(oframes, 2) == 0
        continue;
    end
    rad = magnif * scalespace.sigma0 * 2.^(oframes(3,:)/scalespace.S) * NBP / 2 ;
    sel=find(...
      oframes(1,:)-rad >= 1                     & ...
      oframes(1,:)+rad <= size(scalespace.octave{o},2) & ...
      oframes(2,:)-rad >= 1                     & ...
      oframes(2,:)+rad <= size(scalespace.octave{o},1)     ) ;
    oframes=oframes(:,sel) ;
		
%	fprintf('keypoints # %d after discarding from boundary\n', size(oframes,2)) ;
      tic ;
  	oframes = do_extrefine(oframes, difofg.octave{o},difofg.smin,thresh,r) ;
   
  % 	fprintf(' keypoints # %d after discarding from low constrast and edges\n',size(oframes,2)) ;
  %  fprintf('                Time (%.3f s)\n',  toc) ;
    tic ;
  
 %   fprintf('compute orientations of keypoints\n');
	oframes = do_orientation(oframes,scalespace.octave{o},scalespace.S,scalespace.smin,scalespace.sigma0 ) ;
%	fprintf('                time: (%.3f s)\n', toc);tic;
		
	x     = 2^(o-1+scalespace.omin) * oframes(1,:) ;
	y     = 2^(o-1+scalespace.omin) * oframes(2,:) ;
	sigma = 2^(o-1+scalespace.omin) * scalespace.sigma0 * 2.^(oframes(3,:)/scalespace.S) ;		
	frames = [frames, [x(:)' ; y(:)' ; sigma(:)' ; oframes(4,:)] ] ;

%	fprintf('keypoints # %d after orientation computation \n', size(frames,2)) ;
 %   fprintf('compute descriptors...\n') ;
    tic ;
		
	sh = do_descriptor(scalespace.octave{o},oframes,scalespace.sigma0,scalespace.S,scalespace.smin,'Magnif', magnif,'NumSpatialBins', NBP,'NumOrientBins', NBO) ;
    
    descriptors = [descriptors, sh] ;
    
 %   fprintf('                time: (%.3f s)\n\n\n',toc) ; 
    
      
    
end 

fprintf(' total keypoints: %d \n\n\n', size(frames,2)) ;
