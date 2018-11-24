% Main File

%Inputs
ip_path =input('Input file: ');
g_max = input('Max gain: ');
p_sat = input('Saturation power: ');
tr_v = input('Frequency Transition Vector: ');

%Reading Audio file
[ip,fsr] = audioread(ip_path);
ip = ip(:, 1);
figure;
plot(ip),title('Input Signal')

%Applying a low-pass filter with frequency of 20,000Hz which is maximum
%frequency audible to normal human ears.
f_pass = 20000;
ip2 = lowpass(ip,f_pass,fsr);

%figure;
%plot(ip2),title('Input Signal after low pass')

% Addition of white gaussian noise to the input signal
%
%Additive white Gaussian noise is a basic noise model used in 
%Information theory to mimic the effect of many random processes that occur in nature. 
%
%White Noise: A random process signal with a constant 
%power spectral density (PSD) function is a white noise process.

ip3 = awgn(ip2,30);
figure;
plot(ip3),title('Input Signal after addition of Noise')

% denoising filter

ip_de_n = Denoise(ip3);  
figure;
plot(ip_de_n),title('Input Signal after de-noising')

% frequency shaping filter

ip_f = FreqShape(ip_de_n,g_max,tr_v,fsr);
figure;
plot(ip_f),title('Input Signal after frequency shaping')

% amplitude compression filter

ip_a = AmplitudeFilter(ip_f,p_sat,fsr);     
figure;
plot(ip_a),title('Input Signal after amplification')

% analysis
ip_length = length(ip);
t=0:1/fsr:(ip_length-1)/fsr;

figure;
subplot(2,1,1);
plot(t,ip,'b');
axis tight;
xlabel('Time (sec)');
ylabel('Relative Magnitude');
title('Time Profile for Data in Signal 2');


subplot(2,1,2);
plot(t,ip_a,'r');
axis tight;
xlabel('Time (sec)');
ylabel('Relative Magnitude');
title('Time Profile for Data in Adjusted Signal 2');

figure;
subplot(2,1,1);
specgram(ip);
title('Spectrogram of Original Signal 2');

subplot(2,1,2);
specgram(ip_a);
title('Spectrogram of Adjusted Signal 2');


%soundsc(input, fs);
sound(ip_a,fsr);
%auwrite(y,fs,info.BitsPerSample,'linear',newfile);