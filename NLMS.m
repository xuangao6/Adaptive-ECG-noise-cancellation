%%file NLMS.m
function [y,coe,error] = NLMS(x,d,order,beta)
x=x(:);
d=d(:);
N=length(x)-1;
p=order;
y=zeros(size(d));
error=zeros(size(d));
coe=zeros(N+1,p+1);
% Generates a convolution matrix
X=convmtx(x.',p+1);
w=zeros(p+1,1); % initial guess
for k=1:N+1
    y(k) = w.'*X(:,k);
    error(k) = d(k) - y(k);
    DEN = X(:,k).'*X(:,k)+1e-6;
    w = w + beta/DEN*error(k)*conj(X(:,k));
    coe(k,:) = w.';
end
end
% -------------------------------------------------------------------------
% This function implements NLMS algorithm.
% Inputs:
% x: received signal (noisy input), x=[x(0),...,x(N)]^T
% d: desired signal / reference signal, d=[d(0),...,d(N)]^T
% order: if order = p, then there are p+1 filter coefficients
% w(0),w(1),...,w(p)
% beta: step-sizez (mu)
% Outputs:
% y: output signal
% coe: the stack of filter coefficients vector of each iteration
% error: the error (d(k)-y(k)) of each iteration
% -------------------------------------------------------------------------
% Make sure that x and d are column vectors

