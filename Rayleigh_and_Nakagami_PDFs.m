x_genChannel=[0:0.01:2];        
b=0.5;
PDP=raylpdf(x_genChannel,b);
mu=10;
omega=0.5;
PDP1=pdf('Nakagami',x_genChannel,mu,omega);
figure,
plot(x_genChannel,PDP,'r');
hold on
plot(x_genChannel,PDP1,'b');
title('Rayleigh and Nakagami PDFs');
legend('Rayleigh','Nakagami')
ylabel('PDF(x)')
xlabel('x')
grid on