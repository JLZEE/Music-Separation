%% DSP PROJECT: music seperation
clear all;
clc;
%% PART 1: get the spectrogram of the music
[x, fs] = audioread('Saima_part2.wav');
x1 = x(:,1);
xlen = length(x);
[s, fspec, tspec] = spectrogram(x1,triang(512),256,512,fs);
T = xlen/fs;

%% PART 2: set frame to the audio signal and do FFT to every frame
%[frame_array,frame_fft] = frameFFT(x1);

%% PART 3: pitch detection
[pitch1,pitch2,pitch3] = ph_detect(s, fspec, tspec);

%% PART 4: use filter sequence to get the signal (frequence domain) of main instrument
snew_fft = filters(s,pitch3);

%% PART 5: use IFFT in every frame and combine all frames together
[recon_music,xnew] = reconmu(snew_fft,x1);
xnew = smooth(xnew,3);
tim_lenx1 = 1:1:length(x1);
tim_lenx1 = T.*(tim_lenx1./length(tim_lenx1));
tim_lenxnew = 1:1:length(xnew);
tim_lenxnew = T.*(tim_lenxnew/length(tim_lenxnew));
figure(4)
subplot(2,1,1);plot(tim_lenx1,x1);xlabel('time');ylabel('magnitude');title('Original music');hold on;
subplot(2,1,2);plot(tim_lenxnew,2.*xnew);xlabel('time');ylabel('magnitude');title('Reconstruct music');hold off;

%% PART 6: music show
sound(x1,fs); pause(T);
sound(5*xnew,fs);
