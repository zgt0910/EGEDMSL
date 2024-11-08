function [LE] = elasticgraph(samples_train,label_train)
[~,n]=size(samples_train);
I=eye(n);
sigm=gauss(samples_train,label_train);
Wlocal=laplacian_k(samples_train,sigm);
Wglobal=laplacian_global(samples_train,sigm);
W=(I-Wlocal)'*(I-Wlocal);
M=diag(sum(Wglobal,2))-Wglobal;
nL=max(abs(eig(W)));
nG=max(abs(eig(M)));

m=nL/(nG+nL);
LE=m*W-(1-m)*M;
end
