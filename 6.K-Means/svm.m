clear;
%initialise data points
X_C1 = [ones(100,1),rand(100,2)];
X_C2 = [ones(100,1),bsxfun(@plus,rand(100,2), [0.2 1.2])];
figure;
plot(X_C1(:,2),X_C1(:,3),'kx','MarkerSize',7);
hold on;
plot(X_C2(:,2),X_C2(:,3),'r+','MarkerSize',7);
%
%
H = eye(3);
f = [0;0;0];
A = [-1*X_C1;X_C2];
b = [-1*ones(100,1);-1*ones(100,1)];
%lb = zeros(3,1);
%options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');

[x,fval,exitflag,output,lambda] = quadprog(H,f,A,b,[],[],[],[],[],[]);

% define the line of the result
x1=linspace(0,1.6);
y1 = -1*(x(2)/x(3))*x1 - x(1)/x(3);
% 
hold on; % keep previous plot visible
plot(x1, y1, '-');

%cycle the support vectors
dists = abs(A*x);
p1 = find(dists(1:100) == min(dists(1:100)));
p2 = find(dists(101:200) == min(dists(101:200)));

for i=1:length(p1)
    point = X_C1(p1(i),:);
    hold on;
    plot(point(:,2),point(:,3),'bO','MarkerSize',12);
    k1 = -1*(x(2)/x(3))*point(:,2) - point(:,3);
    y2 = -1*(x(2)/x(3))*x1 - k1;
    hold on; % keep previous plot visible
    plot(x1, y2, '-');
end

for i=1:length(p2)
    point = X_C2(p2(i),:);
    hold on;
    plot(point(:,2),point(:,3),'bO','MarkerSize',12);
    k2 = -1*(x(2)/x(3))*point(:,2) - point(:,3);
    y3 = -1*(x(2)/x(3))*x1 - k2;
    hold on; % keep previous plot visible
    plot(x1, y3, '-');
end