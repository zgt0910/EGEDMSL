function [Z,G] = DMSLEGE(X,k,lambda,label) 
%%%% % Input:
    %       - x: the data matrix of size m n, where each columns is a sample
    %               point
    %       - k: the Neighbourhood range
    %       - lambda: contral the Z_k norm
    %        - afa: contral the Z_f
    %        - beta: contral the e_f
    %           The following parameters are effective ONLY in mode 'kmeans'
    %           - kmNumRep: the number of replicates for initial kmeans (default 1)
    %           - kmMaxIter: the maximum number of iterations for initial kmeans (default 5)
    % Output:
    %       - Z G:Self-expression coefficient matrix
    %% ---------- Initilization -------- %
      %% parm
  
    [m,n] = size(X);
    maxIter=20;
    afa=0.0001;% match lamuda in paper 
    beta=0.0001;% match afa in paper

    gama=lambda;% match beta in paper
    miu = 0.01;
    invmiu=1/miu;
    rho = 1.1;
    max_miu = 1e8;
    tol  = 1e-5;
    tol2  = 1e-2;
    iter = 0;
    A1 = zeros(m,n);
    A2 = zeros(m,n);
    A3 = zeros(m,m);
    A4 = zeros(n,n);
    LE=elasticgraph(X,label);
    SE=X*LE*X';
    %% 矩阵
 
    % Calculate the K-nearest neighbour plot of the sample matrix
    [idx, ~] = knnsearch(X', X', 'k', k+1);%
    idx = idx(:, 2:end);
    adjacency_matrix = zeros(n);
    for i = 1:n
        adjacency_matrix(i, idx(i, :)) = 1;
    end
%% initialisation 
    Z  = adjacency_matrix;
    G  = Z;
    Y  = Z;
    E1  = zeros(m,n);
    E2  = zeros(m,n);
    E  = [E1;E2];
    P  = zeros(m,m);
    W=P;
   %%    迭代计算
 while iter < maxIter
    iter = iter + 1;        
 %% update P
    Pk=P;
    L1=X-E1+invmiu*A1;
    L2=W-invmiu*A3;
    IM=eye(m);

    LZ=diag(Z*ones(n,1))-(Z);
    P=(X*LZ*X'+SE+miu*X*Z*Z'*X'+miu*IM)\(miu*X*Z*L1'+miu*L2);
    %% update Z
    Zk = Z;
    L3=G-invmiu*A4;
    I = eye(n);
    PX=P'*X;
    DPX=squareform(pdist(PX'));
%     Z = pinv(RPX'*RPX+2*I)*(RPX'*M1+M2+M3);
     Z = (miu*X'*P*P'*X+miu*I+2*afa*I)\(miu*L3+miu*X'*P*L1-DPX);%pinv(A)B=A\B
%     Z = (I/(RPX'*RPX+2*I))*(RPX'*M1+M2+M3);
for ic = 1:n
    idx    = 1:n;
    idx(ic) = [];
    Z(ic,idx) = EProjSimplex_new(Z(ic,idx));          %
end
    Z=max(Z,0);
    Z=Z-diag(diag(Z));
%%  update S
    Gk = G;
    L4=Z+invmiu*A4;
    Dy=diag(Y)*ones(n,1)'-Y;
    G=L4-invmiu*gama*Dy;
    % S=S-diag(diag(S));
    % S = max(S,0); 
 
    %% update Y
    % LG = diag(G*ones(n,1)+S'*ones(n,1))-(S+S')/2;  
    LG = diag(G*ones(n,1)+G'*ones(n,1))-(G+G')/2; 
    [S_v, S_d] = eig(LG);
    S_d = diag(S_d);
    [~, ind] = sort(S_d);    
    Y = S_v(:,ind(1:k))*S_v(:,ind(1:k))';%k为number for cluster
 %% update E
    Ek = E;
    L5=[X-P'*X*Z+invmiu*A1;X-W*W'*X+invmiu*A2];
    % l5=[];
    % for i=1:n
    %     l5=[l5;norm(L5(:,i))];
    % end
    % lm=beta*invmiu;
    % for i=1:n
    %     if l5(i)>lm
    %         E(:,i)=(1-lm/l5(i))*L5(:,i);
    %     else 
    %         E(:,i)=zeros(2*m,1);
    %     end
    % end  
    E=(miu/(2*beta+miu))*L5;
    E1=E(1:m,:);
    E2=E(m+1:end,:);
%%  update U
   L6=X-E2+invmiu*A2;
   L7=P+invmiu*A3;
   W = gds(X, L6, L7, 1, 1, W,maxIter);
%% update others
   AA1=X-P'*X*Z-E1;
   AA2=X-W*W'*X-E2;
   AA3=P-W;
   AA4=Z-G;
   A1=A1+miu*AA1;
   A2=A2+miu*AA2;
   A3=A3+miu*AA3;
   A4=A4+miu*AA4;
    miu=min(max_miu,rho*miu);
%%  stop
    % % diff1 = max(max(abs(Z-G)));
    % % diff2 = max(max(abs(P-W)));    
    % % diff3 = max(max(abs(XRPXZE)));
    % % diff4 = max(max(abs(XRPXZE))); 
    % % stopC = max([diff1,diff2,diff3,diff4]);
    LL1 = norm(P-Pk,'fro');
    LL2 = norm(Z-Zk,'fro');
    LL3 = norm(G-Gk,'fro');
    LL4 = norm(E-Ek,'fro');
    SLSL = max(max(max(LL1,LL2),LL3),LL4)/norm(X,'fro');
    % if miu*SLSL < tol2
    %     miu = min(rho*miu,max_miu);
    % end
     stopC = (norm(AA1,'fro')+norm(AA2,'fro')+norm(AA3,'fro')+norm(AA4,'fro'))/norm(X,'fro');
    if stopC < tol 
        break;
    end   
 end
end
