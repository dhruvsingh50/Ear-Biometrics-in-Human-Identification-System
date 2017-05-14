function J = do_localmax(octave, thresh,smin)

[N,M,S]=size(octave); 
nb=1;
k=0.0002;
J = [];
for s=2:S-1
    for j=20:M-20
        for i=20:N-20
            a=octave(i,j,s);
         
            if a>thresh+k ...
                    && a>octave(i-1,j-1,s-1)+k && a>octave(i-1,j,s-1)+k && a>octave(i-1,j+1,s-1)+k ...
                    && a>octave(i,j-1,s-1)+k && a>octave(i,j+1,s-1)+k && a>octave(i+1,j-1,s-1)+k ...
                    && a>octave(i+1,j,s-1)+k && a>octave(i+1,j+1,s-1)+k && a>octave(i-1,j-1,s)+k ...
                    && a>octave(i-1,j,s)+k && a>octave(i-1,j+1,s)+k && a>octave(i,j-1,s)+k ...
                    && a>octave(i,j+1,s)+k && a>octave(i+1,j-1,s)+k && a>octave(i+1,j,s)+k ...
                    && a>octave(i+1,j+1,s)+k && a>octave(i-1,j-1,s+1)+k && a>octave(i-1,j,s+1)+k ...
                    && a>octave(i-1,j+1,s+1)+k && a>octave(i,j-1,s+1)+k && a>octave(i,j+1,s+1)+k ...
                    && a>octave(i+1,j-1,s+1)+k && a>octave(i+1,j,s+1)+k && a>octave(i+1,j+1,s+1)+k
                J(1,nb)=j-1;
                J(2,nb)=i-1;
                J(3,nb)=s+smin-1;
                nb=nb+1;
            end
        end
    end
end