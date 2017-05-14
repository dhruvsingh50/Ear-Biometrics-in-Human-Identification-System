function L = do_gaussian(I,sigman,O,S,omin,smin,smax,sigma0)


if(nargin<7) 
   sigma0=1.6*k;
end

if omin<0
   for o=1:-omin
	I=doubleSize(I);
   end
elseif omin>0
   for o=1:-omin
	I=halveSize(I);
   end
end
[M,N] = size(I);          

k = 2^(1/S);              
sigma0=1.6*k;
dsigma0 = sigma0*sqrt(1-1/k^2);  
sigmaN=0.5;                      
so=-smin+1;                      


L.O = O;
L.S = S;
L.sigma0 = sigma0;
L.omin = omin;
L.smin = smin;
L.smax = smax;

L.octave{1} = zeros(M,N,smax-smin+1); 

sig=sqrt( (sigma0*k^smin)^2 - (sigmaN/2^omin)^2 );
L.octave{1}(:,:,1) = smooth(I,sig);

for s=smin+1:smax
    dsigma = k^s * dsigma0;
    L.octave{1}(:,:,s+so) = smooth( squeeze(L.octave{1}(:,:,s-1+so)) ,dsigma);
end

for o=2:O
    
    sbest = min(smin+S,smax);
    TMP = halvesize( squeeze(L.octave{o-1}(:,:,sbest+so)) );
    sigma_next = sigma0*k^smin;
    sigma_prev = sigma0*k^(sbest-S);
    
    if (sigma_next>sigma_prev)
       sig=sqrt(sigma_next^2-sigma_prev^2);
       TMP= smooth( TMP,sig);
    end
    
    [M,N] = size(TMP);
    L.octave{o} = zeros(M,N,smax-smin+1); 
    L.octave{o}(:,:,1) = TMP;
    
    for s=smin+1:smax
        dsigma = k^s * dsigma0;
        L.octave{o}(:,:,s+so) = smooth( squeeze(L.octave{o}(:,:,s-1+so)) ,dsigma);
    end

end




function J = halvesize(I)
J=I(1:2:end,1:2:end);

function J = doubleSize(I)
[M,N]=size(I) ;
J = zeros(2*M,2*N) ;
J(1:2:end,1:2:end) = I ;
J(2:2:end-1,2:2:end-1) = ...
	0.25*I(1:end-1,1:end-1) + ...
	0.25*I(2:end,1:end-1) + ...
	0.25*I(1:end-1,2:end) + ...
	0.25*I(2:end,2:end) ;
J(2:2:end-1,1:2:end) = ...
	0.5*I(1:end-1,:) + ...
    0.5*I(2:end,:) ;
J(1:2:end,2:2:end-1) = ...
	0.5*I(:,1:end-1) + ...
    0.5*I(:,2:end) ;


