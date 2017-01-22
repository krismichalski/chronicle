function [] = plotMLP(V, W)
    [X1, X2] = meshgrid(0:pi/20:pi);
    Y = zeros(size(X1));
    
    phi = inline('1 ./ (1 + exp(-s))');
    
    for i = 1:size(X1, 1)
        for j = 1:size(X1, 2)
            x1 = X1(i,j);
            x2 = X2(i,j);
            x = [x1 x2];
            
            s = V * [1; x'];
            neurons = phi(s);
            Y(i,j) = W * [1; neurons];
        end
    end
    
    figure;
    surf(X1, X2, Y);
end