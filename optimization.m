clc;
clear all;
close all;

start = 0;
stop = 20;
t = (start:0.01:stop);
curve = dsigmf(t, [5 2 5 7]);
sigma = 0.05;
noise = sigma*randn(size(curve));
signal = curve + noise;
figure, plot(t, signal);
title('Signal');

signal = transpose(signal);
N= size(signal);
N = N(1);
y = signal;
e = ones(N,1);
lambda1 = 4;
lambda2 = 40;
lambda3 = 10;
D1 = spdiags([-e e], 0:1, N-1, N);
D2 = spdiags([e -2*e e], 0:2, N-2, N);
D3 = spdiags([-e 3*e -3*e e], 0:3, N-3, N);
cost = ones(N,1);

cvx_begin
    variable x1(1*N)
    minimize(0.5*sum_square(y(1:N)-x1) +  ...
    + lambda1*norm(D1*x1,1) + lambda2*norm(D2*x1,1) + lambda3*norm(D3*x1,1)...
    )
cvx_end
disp('By using the entire expression');
disp( [ '   x     = [ ', sprintf( '%7.4f ', x1 ), ']' ] );
final1 = 0.5*sum_square(y(1:N)-x1) + lambda1*norm(D1*x1,1) + lambda2*norm(D2*x1,1) + lambda3*norm(D3*x1,1);
disp( [ '   Expression = [ ', sprintf( '%7.4f ', final1 ), ']' ] );
figure, plot(t, x1);
title('Entire expression');

cvx_begin
    variable x2(1*N)
    minimize(0.5*sum_square(y(1:N)-x2) +  ...
    + lambda1*norm(D1*x2,1))
cvx_end
disp('By using the first two terms');
disp( [ '   x     = [ ', sprintf( '%7.4f ', x2 ), ']' ] );
final2 = 0.5*sum_square(y(1:N)-x2) + lambda1*norm(D1*x2,1);
disp( [ '   Expression = [ ', sprintf( '%7.4f ', final2 ), ']' ] );
figure, plot(t, x2);
title('First two terms only');

cvx_begin
    variable x3(1*N)
    minimize(0.5*sum_square(y(1:N)-x3) +  ...
    + lambda1*norm(D1*x3,1)+ lambda2*norm(D2*x3,1))
cvx_end
disp('By using the first three terms');
disp( [ '   x     = [ ', sprintf( '%7.4f ', x3 ), ']' ] );
final3 = 0.5*sum_square(y(1:N)-x3) + lambda1*norm(D1*x3,1);
disp( [ '   Expression = [ ', sprintf( '%7.4f ', final3 ), ']' ] );
figure, plot(t, x3);
title('First three terms only');

cvx_begin
    variable x4(1*N)
    minimize(0.5*sum_square(y(1:N)-x4) +  ...
    + lambda1*norm(D1*x4,2))
cvx_end
disp('By using the first two terms (second one is L2)');
disp( [ '   x     = [ ', sprintf( '%7.4f ', x4 ), ']' ] );
final4 = 0.5*sum_square(y(1:N)-x4) + lambda1*norm(D1*x4,1);
disp( [ '   Expression = [ ', sprintf( '%7.4f ', final4 ), ']' ] );
figure, plot(t, x4);
title('First two terms only (second one is L2)');