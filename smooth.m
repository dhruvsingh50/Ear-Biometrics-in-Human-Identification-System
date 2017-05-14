function J = smooth(I,s)

h=fspecial('gaussian',ceil(4*s),s);
J=imfilter(I,h);

return;