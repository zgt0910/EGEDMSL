function [sigm] = gauss(samples_train,label_train)

num_all=size(samples_train,2);%所有训练的样本个数
distance_one=squareform(pdist(samples_train'));%任意两点之间的距离
distance_two=sum(distance_one,2)';%任意一点到其他所有点的距离
label_train=label_train';

D_one=0;
D_two=0;
conter_one=0;
conter_two=0;
for i=1:num_all
    for j=1:num_all
        if label_train(:,i)==label_train(:,j)
         D_one=D_one+distance_one(i,j)/distance_two(:,i);
         conter_one=conter_one+1;
        else
        D_two=D_two+distance_one(i,j)/distance_two(:,i) ;
        conter_two=conter_two+1;
        end
    end
end
a=(log10(D_one/conter_one)-log10(D_two/conter_two))/(D_one-D_two);
sigm=1/(2*sqrt(a));
end
