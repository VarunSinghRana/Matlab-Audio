function Capture =spec(y,fs)
window=hamming(512);
noverlap=256; % no of points for repetation
nfft=1024; % size of fft

[S,F,T,P]=spectrogram(y,window,noverlap,nfft,fs,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none');
axis tight;
view(0,90);
cs=circshift(S,[0,-1]);
P=((S-cs)>0);

colormap(1-gray);
