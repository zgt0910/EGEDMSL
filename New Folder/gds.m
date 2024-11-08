function W = gds(X, E1, E2, a, b, max_iter,W )
    % 初始化参数
    initial_learning_rate = 0.01;
    min_lr = 1e-6;     % 最小学习率
    max_lr = 1e-2;     % 最大学习率
    learning_rate = initial_learning_rate;
    
    for iter = 1:max_iter
        % 计算梯度
        grad1 = 2 * a * (W * (W' * X) - E1) * X' * W;
        grad2 = 2 * b * (W - E2);
        grad = grad1 + grad2;
        
        % 计算梯度的范数
        grad_norm = norm(grad, 'fro');
        
        % 根据梯度范数调整学习率
        if grad_norm > 1
            learning_rate = max(min_lr, learning_rate * 0.5); % 减小学习率
        else
            learning_rate = min(max_lr, learning_rate * 1.05); % 增大学习率
        end
        
        % 更新 W
        W = W - learning_rate * grad;
        
        % 检查收敛条件
        if grad_norm < 1e-6
            % disp(['Converged at iteration ', num2str(iter)]);
            break;
        end
    end
end
