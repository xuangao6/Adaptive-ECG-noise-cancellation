%%file LMS.m
function [y,coe,error] = LMS(x,d,order,beta)
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
    w = w + beta*error(k)*conj(X(:,k));
    coe(k,:) = w.';
end
end


% function [yn,W,en]=LMS(xn,dn,M,mu,itr)
% 
% %     xn   input data to the adaptive filter 
% %     dn   desired input
% %     M    number of filter coefficients
% %     mu   adaptive filtering update (step-size) parameter   
% %     itr  iteration M<itr<length(xn)
% %     W    filter coefficients
% %     en   error signal 
% %     yn   output of the adaptive filter
% 
% en = zeros(itr,1);             
% W  = zeros(M,itr);             
% 
% for k = M:itr                  
%     x = xn(k:-1:k-M+1);        
%     y = W(:,k-1).' * x;        
%     en(k) = dn(k) - y ;        
%     W(:,k) = W(:,k-1) + mu*en(k)*conj(x);
% end
% 
% yn = inf * ones(size(xn));
% for k = M:length(xn)
%     x = xn(k:-1:k-M+1);
%     yn(k) = W(:,end).'* x;
% end
