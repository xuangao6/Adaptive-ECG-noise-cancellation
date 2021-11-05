% RLS ALGOTITHM
function [output, coe, error] = RLS(input, des, order, lambda)

input = input(:);
des = des(:);
N = length(input);
% P(:)=0;
% theta(:) = 0;
% w(:) = 0;
coe=zeros(N+1,order+1);

%-------------------------initialization-------------------------------%
%----------------reset--------------%
 output = zeros(size(des));
 error = zeros (size(des));
 theta = zeros (order+1,1);
%------------initialization---------%
delta = 0.001;
inputX=convmtx(input.',order+1);
%p=order;
P=1/delta*eye(order+1);
% theta= input(1)*des(1);
w = P*theta;
output(1)=w.'*inputX(:,1);
error(1)=des(1)-output(1);
coe(1,:)=w;
%-----------start the algorithm---------%
for k=2:N
% P(k) = P(k-1) - P(k-1)*conj(input(k))*input(k).'*P(k-1)/1+input(k-1).'*P(k-1)*conj(input(k-1));
% P= 1/lambda*P - lambda^(-2)*P*conj(inputX(:,k))*inputX(:,k).'*P/1+inputX(:,k).'*P*conj(inputX(:,k));
% theta(k)=lambda*theta(k-1)+conj(input(k))*des(k);
P=1/lambda*P-lambda^(-2)*P*conj(inputX(:,k))*inputX(:,k).'*P/(1+1/lambda*inputX(:,k).'*P*conj(inputX(:,k))); %update value of Pn
theta=lambda*theta+conj(inputX(:,k))*des(k); %update value of theta
w=P*theta;
coe(k,:)=w.'; %coefficient..taps
output(k)=w.'*inputX(:,k); %find output
error(k)=des(k)-output(k); %calculate error
end
end