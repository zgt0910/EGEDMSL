function X_noisy = addnoisetodata(X, noiseType, params, noiseRatio)
    % ADDNOISETOMATRIX Adds specified noise to a data matrix.
    % 
    % Inputs:
    %   X          - Original data matrix.
    %   noiseType  - Type of noise to add ('gaussian', 'uniform', 'poisson', 'salt & pepper', 'mask').
    %   params     - Parameters for the noise. 
    %               For 'gaussian': params = [mean, std_dev][0,0.1]
    %               For 'uniform':  params = [low, high][-0.1,0.1]
    %               For 'poisson':  params = lambda[1.0]
    %               For 'salt & pepper': params = [salt_prob, pepper_prob][0.05, 0.05] 表示5%的元素将变为1（盐噪声），5%的元素将变为0（椒噪声）。
    %               For 'mask': params = mask_prob [0.1] 表示10%的元素将被遮挡，即这些元素将被设置为0。
    %   noiseRatio - A value between 0 and 1 indicating the proportion of the matrix to which noise is applied.
    % 
    % Output:
    %   X_noisy    - Data matrix with added noise.

    % Initialize noisy matrix
    X_noisy = X;

    % Determine the number of elements to add noise to
    numElements = numel(X);
    numNoisyElements = round(noiseRatio * numElements);

    % Generate a linear index of elements to be noised
    indices = randperm(numElements, numNoisyElements);
    
    switch noiseType
        case 1  % Gaussian noise
            mean = params(1);
            std_dev = params(2);
            noise = std_dev * randn(size(X)) + mean;
            X_noisy(indices) = X(indices) + noise(indices);
            
        case 2  % Uniform noise
            low = params(1);
            high = params(2);
            noise = (high-low) * rand(size(X)) + low;
            X_noisy(indices) = X(indices) + noise(indices);
            
        case 3  % Poisson noise
            lambda = params(1);
            noise = poissrnd(lambda, size(X));
            X_noisy(indices) = X(indices) + noise(indices);
            
        case 4  % Salt & Pepper noise
            salt_prob = params(1);
            pepper_prob = params(2);
            % X = mat2gray(X);  % 将数据归一化到 [0, 1] 范围内
            % X_noisy = X;
            % Create salt & pepper noise only on selected indices
            numSalt = round(salt_prob * numNoisyElements);
            numPepper = round(pepper_prob * numNoisyElements);
            saltIndices = indices(1:numSalt);
            pepperIndices = indices(end-numPepper+1:end);
            X_noisy(saltIndices) = 255;   % Salt noise (maximum value)
            X_noisy(pepperIndices) = 0; % Pepper noise (minimum value)
            % X_noisy(saltIndices) = max(X(:));   % 盐噪声（最大值）
            % X_noisy(pepperIndices) = min(X(:)); % 胡椒噪声（最小值）
            
        case 5  % Mask noise
            mask_prob = params(1);
            mask = rand(size(X)) < mask_prob;
            noisyMask = false(size(X));
            noisyMask(indices) = true;
            X_noisy(mask & noisyMask) = 0;  % 将掩膜中对应的元素设为0
            
        otherwise
            error('Unsupported noise type.');
    end
end
