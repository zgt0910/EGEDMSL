clear all;clc;close all;warning off;
load('ORL.mat');
load('label.mat');
acc=[];
nmi=[];
acc_parm=[];
nmi_parm=[];
parm_all=[0.001,0.01,0.1,1,10,100,1000];
for i=1:length(rand_train)%随机次数
    X=ORL(:,cell2mat(rand_train(1)));
    num_class=length(unique(label_train));
    for l = 1 : size(X,2)
        X(:,l) = X(:,l)/norm(X(:,l));
    end
    samples_train=X;
     k=5;
     for parm=parm_all
         [Z,G] = DMSLEGE(samples_train,k,parm,label_train);
         label_pre = SpectralClustering((abs(G)+abs(G'))/2,num_class,3);
         results= getFourMetrics(label_pre,label_train);
         acc_parm=[acc_parm results(1)];
         nmi_parm=[acc_parm results(2)];
     end
     %% find the ACC NMI correspond to the best parm
     acc=[acc max(acc_parm)];
     nmi=[nmi max(nmi_parm)]; 
end
fprintf('acc= %f \n',mean(acc));
fprintf('nmi= %f \n',mean(nmi));