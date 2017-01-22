function Error = MLPError(V, W, D)
    [m, n] = size(D);
    n = n - 1;
    
    Error = 0;
    
    for i = 1:m
        x = D(i, 1:n);
        y = D(i, n+1);
        s = V * [1; x'];

        neurons = 1 ./ (1 + exp(-s));
        yMLP = W * [1; neurons];
        
        Error = Error + abs(yMLP - y);
    end
    
    Error = Error/m;
end