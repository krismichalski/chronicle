function [C] = cc(img,N)
  C = zeros(N);

  [m,n] = size(img);
  fromL = img(:,1:n-1);
  toL = img(:,2:n);

  fromT = img(1:n-1,:);
  toT = img(2:n,:);

  for i = 1:N
    for j = 1:N
      % pick one direction
      C(i, j) = sum(sum(fromL == i & toL == j));
      % C(i, j) = sum(sum(toL == i & fromL == j));
      % C(i, j) = sum(sum(fromT == i & toT == j));
      % C(i, j) = sum(sum(toT == i & fromT == j));
    end
  end

end
