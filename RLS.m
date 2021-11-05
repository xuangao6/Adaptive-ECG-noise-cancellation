%%file RLS.m
function [d_hat,coe,error] = RLS(x,d,order,lambda)
% -------------------------------------------------------------------------
% This function implements RLS algorithm.
% Inputs:
% x: received signal (noisy input), x=[x(0),...,x(N)]^T
% d: desired signal / reference signal, d=[d(0),...,d(N)]^T
% order: if order = p, then there are p+1 filter coefficients 
% w(0),w(1),...,w(p)
% lambda: exponential forgetting factor
% Outputs:
% d_hat: estimated signal
% coe: the stack of filter coefficients vector of each iteration
% error: the error (d(k)-d_hat(k)) of each iteration
% -------------------------------------------------------------------------
% Make sure that x and d are column vectors
x=x(:);
d=d(:);
N=length(x)-1;
p=order;
d_hat=zeros(size(d));
error=zeros(size(d));
coe=zeros(N+1,p+1);
% Generates a convolution matrix
X=convmtx(x.',p+1);
delta=0.001;
theta=zeros(p+1,1);
P=1/delta*eye(p+1);
w=P*theta;
coe(1,:)=w;
d_hat(1)=w.'*X(:,1);
error(1)=d(1)-d_hat(1);
for k=2:N+1 
 P=1/lambda*P-lambda^(-2)*(P*conj(X(:,k))*X(:,k).'*P)/...
 (1+1/lambda*X(:,k).'*P*conj(X(:,k)));
 theta=lambda*theta+conj(X(:,k))*d(k);
 w=P*theta;
 coe(k,:)=w.';
 d_hat(k)=w.'*X(:,k);
 error(k)=d(k)-d_hat(k);
end
end