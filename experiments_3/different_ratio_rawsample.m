clear all;
clc;
close all;

a = imread('coil20.png');
a = im2double(a);
[m, n, ~] = size(a); % Getting the size of an image
parms = [0, 0.5];
b = [];

% 文字标签
text_labels = {'0%', '5%', '10%', '15%', '20%'};

for i = 1:5
    switch i
        case 1
            b1 = [a; ones(4, n ,'double') ]; % 添加白色
        case 2
            b1 = [addnoisetodata(a, 1, parms, 0.05); ones(4, n, 'double') ];
        case 3
            b1 = [addnoisetodata(a, 1, parms, 0.10); ones(4, n,'double') ];
        case 4
            b1 = [addnoisetodata(a, 1, parms, 0.15); ones(4, n, 'double') ];
        case 5
            b1 = [addnoisetodata(a, 1, parms, 0.20); ones(4, n, 'double') ];
    end
    b = [b; b1]; % Add it to the final image
end


figure;

% Left subfigure: image combination
subplot('Position', [0.05, 0.1, 0.2, 0.8]); % 左侧子图占 40% 宽度
imshow(b, 'Border', 'tight'); % 去除边框
% title('带文字的图像', 'FontWeight', 'bold');

% Add a text label to the top left corner of each image
% y_pos = linspace(20, size(b, 1), 6); % 计算每个图像的垂直位置
y_pos = [20, m + 50, 2 * m + 60, 3 * m + 70, 4 * m + 50]; % 手动调整各标签的 y 坐标
for i = 1:5
    text(5, y_pos(i) + 10, text_labels{i}, 'FontSize', 12, 'Color', 'black', 'FontName', 'Times New Roman', 'HorizontalAlignment', 'left');
end

% Right subfigure: line graph
subplot('Position', [0.5, 0.1, 0.45, 0.8]); % 右侧子图占 45% 宽度

% 

% x = [0, 0.05, 0.10, 0.15, 0.20];
% Ours = [78.41 72.44 68.31 60.09 58.33];
% LRR = [61.81 49.69 43.94 39.25 33.85];
% SSC = [64.75 67.66 54.00 38.50 29.50];
% BDR = [73.44 66.16 58.66 54.88 47.53 ];
% DLRRDP = [71.91 65.75 59.00 50.47 46.26];
% AWNLRR = [75.00 62.34 57.31 52.72 50.41];
% KBDR = [65.66 56.69 60.56 54.00 52.78];
% LRRAGR = [74.84 70.41 65.16  57.41 54.84 ];
% SASC = [68.69, 62.75, 57.22, 52.75 50.53 ];%ORL
x = [0, 0.05, 0.10, 0.15, 0.20];
Ours = [72.17 70.50 68.42 69.67 65.50 ];
LRR = [55.67 48.08 44.25 41.25 41.17];
SSC = [59.83 50.75 42.58 41.58 36.17];
BDR = [69.42 67.08 65.75 66.33 63.42  ];
DLRRDP = [64.67 56.25 52.08 49.58 47.17];
AWNLRR = [68.17 60.42 58.48 53.50 46.42];
KBDR = [64.17 63.92 60.32 58.92 56.58];
LRRAGR = [68.25 66.25 63.00 61.50 59.83 ];
SASC = [68.58 66.92 64.00 61.67 58.83  ];%COIL20

hold on;
plot(x, LRR, '-s', 'DisplayName', 'LRR');
plot(x, SSC, '-d', 'DisplayName', 'SSC');
plot(x, BDR, '-^', 'DisplayName', 'BDR');
plot(x, DLRRDP, '-p', 'DisplayName', 'DLRRDP');
plot(x, AWNLRR, '-v', 'DisplayName', 'AWNLRR');
plot(x, KBDR, '-*', 'DisplayName', 'KBDR');
plot(x, LRRAGR, '-+', 'DisplayName', 'LRRAGR');
plot(x, SASC, '-x', 'DisplayName', 'SASC');
plot(x, Ours, '-o', 'DisplayName', 'OURS');
hold off;
set(gca, 'XTick', [ 0, 0.05, 0.10, 0.15, 0.20]);

legend('show');
xlabel('Noise ratio (%)');
ylabel('ACC');
title('Coil20-Noise');
set(gcf, 'Position', [500, 500, 700, 450])