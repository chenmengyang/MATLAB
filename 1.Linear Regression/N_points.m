%%Introduction to PR and ML-excise1
%Programme name: N_points.m
%Author: Chen Mengyang
%Date: 30.08.2015
%Description: The programme is to caculate the so-called square error for
%            given times, using gradient descend algorithm, and find the
%            parameters of polynomial which can set a minimun error value.

%%
%make plot,input 5 points by clicking on the figure platform 5 times
figure;
axis([0 5 0 5]);
points=ginput();
X=points(:,1);
Y=points(:,2);
plot(X,Y,'rx','MarkerSize',10);

%%
%caculate average square error (sum((y-f(x))^2)/m), f(x)=ax+b
%set original value (0,0) as parameters
parameters=zeros(2,1);
%error=Compute_error(X,Y,parameters);
[H,parameters]=Gradient_descend(X,Y,parameters,0.01,1000);


%%
%draw the line with the parameters
hold on; % keep previous plot visible
plot(X, X*parameters(1)+parameters(2), '-')
legend('Training data', 'Linear regression')
axis([0 5 0 5]);
hold off
%%
fprintf('Finally we get the function: y=%.1fx+(%.2f)',parameters(1),parameters(2));