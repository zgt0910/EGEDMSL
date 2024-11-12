clc;
clear;
close all;

% algorithm score:acc or nmi
scores = [45.53	46.11	44.20	51.25	47.62	49.00	41.47	49.47	51.68];
methods = {'LRR', 'SSC', 'BDR', 'DLRRDP', 'AWNLRR', 'KBDR', 'LRRAGR', 'SASC','OURS'};

% Assumed standard deviation
sigma = 2;  % 

n = length(scores);
prob_matrix = zeros(n, n);

% Calculate the probability of winning for each pair of algorithms
for i = 1:n
    for j = 1:n
        if i ~= j
            % Cumulative Distribution Function (CDF) for the difference of normal distributions
            prob_matrix(i, j) = normcdf(scores(i) - scores(j), 0, sqrt(2) * sigma);
        else
            prob_matrix(i, j) = 0; % The diagonal line denotes self to self, set to 1
        end
    end
end


figure;
imagesc(prob_matrix);  

colormap(slanCM(53:100));       
colorbar;             

% Setting the axes
xticks(1:n);
yticks(1:n);
xticklabels(methods);
yticklabels(methods);

% Add title and tags
title('the Bayesian signed rank test on the Semeion');
 %xlabel('(a) ACC');
xlabel('(b) NMI');

% Adjusting the colour range
clim([0, 1]);

% 在热图上显示具体的数值
for i = 1:n
    for j = 1:n
        % 判断字体颜色
        if prob_matrix(i, j) > 0.5
            textColor = 'white'; % 大于0.5使用白色
        else
            textColor = 'black'; % 小于或等于0.5使用黑色
        end
        
        % 显示每个网格的概率数值
        text(j, i, sprintf('%.2f', prob_matrix(i, j)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', textColor);
    end
end
% 设置保存路径
savePath = 'C:\Users\zgt\Desktop\DMSLEGE\byss2'; % 修改此路径

% 保存为600 DPI的图像
print(savePath, '-dpng', '-r600'); % 保存为PNG格式，600 DPI