function [W]=laplacian_k(samples_train,sigm)

num_all=size(samples_train,2);%����ѵ������������
distance=squareform(pdist(samples_train'));
distance_one=zeros(num_all);
distance_two=zeros(num_all);
distance_sigm=zeros(num_all);
%���Ʋ�������SIGMOD
for i=1:num_all
    for j=1:num_all
        distance_sigm(i,j)=distance(i,j)/sum(distance(i,:));
    end
end
sigm_adjust=sqrt(sigm);

%����������֮�������Ȩ��
for i=1:num_all
    for j=1:num_all
        distance_one(i,j)=exp(-(distance(i,j)/sum(distance(i,:)))/(2*sigm_adjust^2));
    end
end
%����һ��������������֮�������Ȩ��
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

% % %��Ⱦ���D
% D=diag(sum(W,2));
% % 
% % %���ڽ�ͼ�ı�׼��������˹����
% % L=eye(num_all)-sqrt(inv(D))*W*sqrt(inv(D));
% W=sqrt(inv(D))*W*sqrt(inv(D));
end

