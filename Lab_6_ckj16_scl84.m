%% Lab 6: Sampling, FFTs, IFFTs, & Spectral Analysis
%scl84 & ckj16
%Shreeya Lingam & Cole Judson 
%November 8,2023
%% PART 1: CONTINUOUS AND DISCRETE FOURIER TRANSFORMS 
clear
clc

syms f(t);
syms w;

f(t) = 3*exp(-0.4*t)*heaviside(t) + 0.6*cos(8*pi*t);
SR = 2000; %defining the Sampling rate 
dt = 1/SR;
t = 0:dt:9;% creating an initial time vector 
sig = eval(f);

figure(1);
plot(t,sig);% plotting the ft over 9 seconds 
ylabel('Amplitude');
xlabel('Time (s)');
title('Function vs. time');
%% PART 1 Figure 2 

clc
figure(2);

Tnot = [9 45 90];% T0 vector defined 

for i = 1:3% using for loop for creation of sub plots later on
    t = 0:dt:Tnot(i);
    sig = eval(f);
    frequency = -1000:1/Tnot(i):1000;% frequency vector for graphing 
    syms t
    cont(w) = fourier(f,t,w);% the fourier transform for ft
    conttrans = abs(eval(cont(frequency*2*pi)));% the absolte value of ft and conversion to w 
    disctrans = abs(fftshift(fft(sig*dt)));%  discrete transform, the absolte value of ft and conversion to w 
   
    %Continuous Fourier Transform Plotted 
    subplot(2,3,i);

    infind = find(isinf(conttrans));
    conttrans(infind) = 1;

    plot(frequency,conttrans);
    drawnow;
    hold on;
    stem(frequency(infind),conttrans(infind),'^');
    xlabel('Frequency');
    ylabel('Amplitude');
    titleplot = sprintf('Continuous Fourier Transform: T0 = %d', Tnot(i)); % indexing the Tnot variable for the subplot 
    title(titleplot);
    xlim([-10 10]);

    %Discrete Fourier Transform
    subplot(2,3,i + 3);

    plot(frequency,disctrans);% plotting 
    drawnow;
    xlabel('Frequency');
    ylabel('Amplitude');
    titleplot = sprintf('Discrete Fourier Transform: T0 = %d', Tnot(i));
    title(titleplot);
    xlim([-10 10]);
    ylim([0 45]);% using this to show all of the values and different amplitudes of the graphs 
end



%% PART 2: PRACTICAL APPLICATION:EEG PROCESSING

%Question 1
figure(3)
load('ArtificialEEG.mat');
SR = 1000;
dt = 1/SR;
Tnot = length(EEG)*dt;
t = 0:dt:Tnot-dt;
plot(t/60, EEG)
xlabel('time (min)')
ylabel('amplitude')

figure(4)

hold on

for i=1:15
   
    frequency = -500:1/Tnot*15:500;
    disctrans = abs(fftshift(fft(EEG(1 + ((i-1)*60000) : 1 + (i*60000)))));
    
    [row, col] = find(disctrans>500);
    frequency(col)
    
    %Discrete Fourier Transform

    subplot(5,3,i)
    
    plot(frequency,disctrans,'b-');
    xlabel('Frequency');
    ylabel('Amplitude');
    titleplot = sprintf('Discrete Fourier Transform for Minute %d to %d', i-1, i);
    title(titleplot);
    xlim([0 100]);
end

hold off

f = 0:0.01:SR/2;

figure(5)
colormap jet
spectrogram(EEG,500,20,f,SR,'yaxis')
xlim([0 15])
ylim([0 100])
colorbar off



