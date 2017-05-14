function num = do_match(im1, des1, loc1, im2, des2, loc2)

distRatio = 0.75;                                                           
matched_points_img1 =[];
des2t = des2';            
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;
   [vals,indx] = sort(acos(dotprods));
      if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
      matched_points_img1 = [matched_points_img1; i];
   else
      match(i) = 0;
   end
end
dis_thres = 0.3;
orien_thres = 0.3;
num = sum(match > 0);
final_match = zeros(1,length(match));  
dis_img_1= zeros(num ,num);  
dis_img_2= zeros(num ,num);
orien_diff_img_1= zeros(num ,num);  
orien_diff_img_2= zeros(num ,num);
for k = 1: num
    dis_img_1(k, k)  = 0;
    dis_img_2(k, k)  = 0;     
    orien_diff_img_1(k,k) = 0;
    orien_diff_img_2(k,k) = 0;
     
    for j = k+ 1: num
           dis_img_1(k, j) = sqrt( (loc1(matched_points_img1(k), 1) - loc1(matched_points_img1(j), 1))^2 ... 
                    + (loc1(matched_points_img1(k), 2) - loc1(matched_points_img1(j), 2))^2 );
           dis_img_1(j, k) =  dis_img_1(k, j);           
           dis_img_2(k, j) = sqrt( ((loc2(match(matched_points_img1(k)), 1) - loc2(match(matched_points_img1(j)), 1))^2 + (loc2(match(matched_points_img1(k)), 2) - loc2(match(matched_points_img1(j)), 2))^2 ));
           dis_img_2(j, k) =  dis_img_2(k, j);              
           orien_diff_img_1(k, j) =  loc1(matched_points_img1(k), 4) - loc1(matched_points_img1(j), 4);
           orien_diff_img_1(j, k) =  orien_diff_img_1(k, j); 
           orien_diff_img_2(k, j) =  loc2(match(matched_points_img1(k)), 4) - loc2(match(matched_points_img1(j)), 4);
           orien_diff_img_2(j, k) =  orien_diff_img_2(k, j); 

           
    end
end

for ii =1: num
    dis_img_1(ii, :) = dis_img_1(ii, :) ./ norm(dis_img_1(ii, :) );
    dis_img_2(ii, :) = dis_img_2(ii, :) ./ norm(dis_img_2(ii, :) );
    
    orien_diff_img_1(ii,:) = orien_diff_img_1(ii,:) ./( eps + norm(orien_diff_img_1(ii,:)));
    orien_diff_img_2(ii,:) = orien_diff_img_2(ii,:) ./( eps +norm(orien_diff_img_2(ii,:)));

end

for m = 1: num
    dis_coherence = dot(dis_img_1(m,:), dis_img_2(m,:));
    orein_coh = dot(orien_diff_img_1(m,:), orien_diff_img_2(m,:));
    if dis_coherence > dis_thres && (orein_coh > orien_thres  || ( sum(orien_diff_img_1(m,:)>0) == 0 && sum(orien_diff_img_2(m,:)>0) == 0 ) )
        final_match(matched_points_img1(m)) = 1;
    end
end


num = sum(match > 0);
fprintf('Found %d matches.\n', num);

im3 = appendimages(im1,im2);

figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: size(des1,1)
  if (match(i) > 0)
    line([loc1(i,1) loc2(match(i),1)+cols1], ...
         [loc1(i,2) loc2(match(i),2)], 'Color', 'c');
  end
end
hold off;

