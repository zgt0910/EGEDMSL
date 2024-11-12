function [LE] = elasticgraph(samples_train,label_train)
%%% to get the essential graph
%%%% % Input:
    %       - samples_train: the data matrix of size m n, where each columns is a sample
    %               point
    % Output:
    %       - get the essential graph
[~,n]=size(samples_train);
I=eye(n);
sigm=gauss(samples_train,label_train);%compute the Gaussian kernel
Wlocal=laplacian_k(samples_train,sigm);%get a local graph 
Wglobal=laplacian_global(samples_train,sigm);%get a global graph 
W=(I-Wlocal)'*(I-Wlocal);
M=diag(sum(Wglobal,2))-Wglobal;
% trace ratio
nL=max(abs(eig(W)));
nG=max(abs(eig(M)));

m=nL/(nG+nL);
LE=m*W-(1-m)*M;
end
