%keep change parameters(a and b) to get the minimun value of error
%the input a stands for learing rate
%you will use count times to caculate the final value
%error_history stores the error value for each try
%derivative term:(f(x)^2)'=2f(x)*f(x)'
function [error_history,p] = Gradient_descend(x,y,p,alpha,count)

m=length(x);
error_history=zeros(count,1);

  for i = 1:count
      q=(p(1)*x+p(2))-y;%q=y-f(x)=y-(ax+b)
      p1 = p(1)-alpha*sum(q.*x)/m;
      p2 = p(2)-alpha*sum(q)/m;
      p=[p1;p2];
      %store errors in the history list
      error_history(i)=Compute_error(x,y,p);
  end
end