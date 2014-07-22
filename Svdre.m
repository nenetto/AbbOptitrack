function [x S r] = Svdre(a,b)
% Resolución ||Ax-b|| mediante la desc. en valores singulares de A
[m,n] = size(a); tol=sqrt(eps); tmp=zeros(m); x=zeros(n,1);
[U S V]=svd(a); S=diag(S);
r=0;
for j=1:n
    if S(j)>=tol
        r=r+1;
        tmp(r)=dot(U(:,j),b)/S(j);
    end
end
for j=1:r
    x=x+tmp(j)*(V(:,j));
end

end