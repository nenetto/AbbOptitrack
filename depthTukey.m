
function[depth] = depthTukey(x,data,n)
%tic;
%data:are the data
%n: number of random direction.
%x: point where we want to find the depht.
[nf nc]=size(data);
u=randn(nc,n);
%u=dir';
%scalar:matrix(nfXn) represent the iiner product, first column is the inner product of
%each data in the first directio, i-ésima columna is the inner product of
%each data in the i´´esima direction

scalar=data*u;
%scalar2: matrix(1Xnc) is the inner product of the point x in all direction
scalar2=x*u;
replic=ones(nf,1)*scalar2;
% replic = repmat(scalar2,[nf,1]);
dif=scalar-replic;
difindicator=(dif>0);
M=mean(difindicator);
depth=min(M);
%toc;
end





