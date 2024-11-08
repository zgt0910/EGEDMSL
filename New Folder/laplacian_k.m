function [W]=laplacian_k(samples_train,sigm)

num_all=size(samples_train,2);%所有训练的样本个数
distance=squareform(pdist(samples_train'));
distance_one=zeros(num_all);
distance_two=zeros(num_all);
distance_sigm=zeros(num_all);
%相似参数设置SIGMOD
for i=1:num_all
    for j=1:num_all
        distance_sigm(i,j)=distance(i,j)/sum(distance(i,:));
    end
end
sigm_adjust=sqrt(sigm);

%求任意两点之间的相似权重
for i=1:num_all
    for j=1:num_all
        distance_one(i,j)=exp(-(distance(i,j)/sum(distance(i,:)))/(2*sigm_adjust^2));
    end
end
%求任一点与所有样本点之间的相似权重
for i=1:num_all
    for j=1:num_all
        distance_two(i,j)=sum(distance_one(i,:))/num_all;
    end
end
W=distance_one.*(distance_one>distance_two);


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

