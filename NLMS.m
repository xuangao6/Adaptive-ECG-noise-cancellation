% NLMS ALGOTITHEM
function [y,coe,error] = NLMS(input,des,order,beta)

input=input(:); % received corrupted ECG signal 
des=des(:); % reference signal
N=length(input)-1;
p=order;
y=zeros(size(des));
error=zeros(size(des));
coe=zeros(N+1,p+1);

% Generates a convolution matrix
X=convmtx(input.',p+1);
w=zeros(p+1,1); 

%-----------start the algorithm---------%
for k=1:N+1
    y(k) = w.'*X(:,k); % output signal
    error(k) = des(k) - y(k); % the error signal of each iteration
    DEN = X(:,k).'*X(:,k)+1e-6;
    w = w + beta/DEN*error(k)*conj(X(:,k)); % filter coefficients vector of each iteration
    coe(k,:) = w.';
end
end


