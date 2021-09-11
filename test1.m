function spec =test1(y,fs)
yLeft = y(:,1);
yrmsenvLeft = sqrt(conv(yLeft.^2,ones(200,1)/200,'same'));
plot([yLeft yrmsenvLeft]);