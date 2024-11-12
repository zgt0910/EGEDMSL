function [W]=laplacian_global(samples_train,sigm)
%%% to get the essential graph
%%%% % Input:
    %       - samples_train: the data matrix of size m n, where each columns is a sample
    %               point
    %       - sigm:Gaussian kernel
    % Output:
    %       - W:global similarity
num_all=size(samples_train,2);
distance=squareform(pdist(samples_train'));
distance_one=zeros(num_all);
distance_two=zeros(num_all);
distance_sigm=zeros(num_all);

for i=1:num_all
    for j=1:num_all
        distance_sigm(i,j)=distance(i,j)/sum(distance(i,:));
    end
end
sigm_adjust=sqrt(sigm);


%Find the similarity weight between any two points
for i=1:num_all
    for j=1:num_all
        distance_one(i,j)=exp(-(distance(i,j)/sum(distance(i,:)))/(2*sigm_adjust^2));
    end
end
%Find the similarity weight between any point and all sample points
for i=1:num_all
    for j=1:num_all
        distance_two(i,j)=sum(distance_one(i,:))/num_all;
    end
end
W=distance.*distance_one;
W=W-diag(diag(W));

% for i=1:num_all
%     W(i,i)=0;
% end
    
%L=diag(sum(W,2))-W;

% % %求度矩阵D
% D=diag(sum(W,2));
% % 
% % %求邻近图的标准的拉普拉斯矩阵
% % L=eye(num_all)-sqrt(inv(D))*W*sqrt(inv(D));
% W=sqrt(inv(D))*W*sqrt(inv(D));
end

