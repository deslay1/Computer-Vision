function [new_x] = pflat(x);
%Divides last entry of homogeneous coordinates for points of any
%dimensionality.
% last = x(end ,:);
% new_x = x(1:(end-1), :)./last;
new_x = x./repmat(x(end,:),[size(x,1) 1]);

end

