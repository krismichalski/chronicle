function [V, W] = MLP(D, K, T, eta)
    [m, n] = size(D);
    n = n - 1;
    
    V = (rand(K, n + 1) * 2 - 1) * 10 ^ (-4);
    W = (rand(1, K + 1) * 2 - 1) * 10 ^ (-4);
    
    for t = 1:T
        i = randi([1, m]);
        x = D(i, 1:n);
        y = D(i, n+1);
        s = V * [1; x'];

        neurons = 1 ./ (1 + exp(-s));
        yMLP = W * [1; neurons];

        dW = (yMLP - y) * [1 neurons'];
        dV = (yMLP - y) * W(2:K+1)' .* neurons .* (1 - neurons) * [1 x];

        W = W - eta * dW;
        V = V - eta * dV;
        
        if(mod(t, floor(T/100)) == 0)
            disp(['Progress: ', num2str(t/T * 100), '%']);
        end
    end
end
