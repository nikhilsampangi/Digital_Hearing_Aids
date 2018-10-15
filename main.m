% Main File
close all; 
clc;

%Taking input from the data-set
input = 'dataset/sample.wav';

%gain that has to be applied to the signal
g = ;

%
transitionV = ;

%Saturation Power
Psat= ;
%reading the input file
[ip,sf] = audioread(input);

%Applying a low-pass filter with frequency of 20,000Hz which is maximum
%frequency audible to normal human ears.
f_pass = 20000;
ip_f = lowpass(ip,f_pass,sf);

% Addition of gaussian noise to the input signal


