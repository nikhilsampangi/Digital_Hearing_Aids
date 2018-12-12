%   Denoising filter using Wavelet Toolbox
%   A wavelet is a mathematical function useful in digital signal processing and image compression

function y = Denoise(x)

%   ddencmp returns default values for denoising or compression for the critically-sampled 
%   discrete wavelet or wavelet packet transform.
%   Example: [THR,SORH,KEEPAPP,CRIT] = ddencmp(IN1,IN2,X)
%   THR is the threshold, SORH is for soft or hard thresholding, KEEPAPP allows you to keep 
%   approximation coefficients
%   IN1 is 'den' for denoising
%   IN2 is 'wv' for wavelet
%   X : input signal
[thr,sorh,keepapp]=ddencmp( 'den' , 'wv' ,x);  

% wdencmp does De-noising of the audio signal
% returns a de-noised version y of input signal x (our one-dimensional speech signal)
% [XC,CXC,LXC,PERF0,PERFL2] = wdencmp('gbl',X,'wname',N,THR,SORH,KEEPAPP)
% 'wname' is a character vector containing wavelet name, db stands for
% 'Daubechies wavelets'

[y, ~, ~, ~, ~]=wdencmp( 'gbl' ,x, 'db3' ,2,thr,sorh,keepapp);

figure;
plot(y),title('Input Signal after de-noising')


