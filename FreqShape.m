%Frequency Shaping Filter

function y = FreqShape(x,g_max,tr_v,fsr)

% Creates the gain filter for a patient with ski slope hearing loss
% The maximum gain will be g and the minimum gain will be one.  The magnitude
% of gain function will be the concatenation of preset piecewise functions
% The transition frequencies from one piecewise function to another can
% be set by the user in the elements of the tr_v  
% The final frequency used will be fsr/2 since that's the highest frequency that the input signal will contain.
% The output will be the filtered signal

% x - an input sound signal
% g_max - the maximum gain that will be applied to the signal
% tr_v - 4 element vector that has the values of where the gain changes to the next piecewise function
% fs - the sampling frequency of the input signal


f1 = tr_v(1);
f2 = tr_v(2);
f3 = tr_v(3);
f4 = tr_v(4);

x_length = length(x);
n = nextpow2(x_length);
N = 2^n;
T = 1/fsr;
X = fft(x,N);
gain = zeros(N,1);

% Sets the gain for the first stage of frequencies
firstC = (.3*(g_max-1))/f1;
k=0;
while(k/N <= f1/fsr)
   gain(k+1) = firstC*k/(N*T) + 1;
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the second stage of frequencies
secondC = firstC*f1 +1;    
secondC2 = (f2-f1)/5;
while(k/N <= f2/fsr)
   gain(k+1) = 1 + (secondC-1)*exp(-((k/(N*T))-f1)/secondC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the third stage of frequencies
thirdC = 1 + (secondC-1)*exp(-f2/secondC2);  
thirdC2 = (f3-f2)/5;
while(k/N <= f3/fsr)
   gain(k+1) = g_max + (thirdC-g_max)*exp(-((k/(N*T)-f2))/thirdC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the fourth stage of frequencies
while(k/N <= f4/fsr)
   gain(k+1) = g_max;
   gain(N-k) = gain(k+1);
   k=k+1;
end;

% Sets the gain for the fifth stage of frequencies
fifthC = g_max;                
fifthC2 = (fsr/2-f4)/5;
while(k/N <= .5)
   gain(k+1) = 1 + (fifthC-1)*exp(-((k/(N*T))-f4)/fifthC2);
   gain(N-k) = gain(k+1);
   k=k+1;
end;
k_v = (0:N-1)/N;
plot(k_v,gain);
title('Gain');%entire filter transfer function
figure;%non-redundant filter transfer function

k_v = k_v*fsr;
k_v = k_v(1:N/2+1);
plot(k_v,gain(1:N/2+1));
title('Frequency Shaper Transfer Function');
xlabel('Frequency (Hertz)');
ylabel('Gain');
xlim([0 10000]);
Y = X+gain; % for X refer line no.27
y = real(ifft(Y,N));

y = y(1:x_length);
t=(0:1/fsr:(x_length-1)/fsr);
figure;
subplot(2,1,1);
plot(t,y,'r');
title('Signal after addition of gain');
subplot(2,1,2);
plot(t,x);
title('Adjusted Signal');