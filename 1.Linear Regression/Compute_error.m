function error = Compute_error(x,y,p)
  m=length(x); %the number of input points
  q=y-(p(1)*x+p(2));%q=y-f(x)=y-(ax+b)
  error=sum(q.*q)/2*m;%average square error
end