function [recon_music,xnew] = reconmu(snew_fft,x1)
%___________________________________________________________
% in this section we reconstruct the music use snew_fft
% INPUT: x1, snew_fft
% OUTPUT: 
% recon_music (the music reconstructed by ifft from snew_fft)
% xnew (same as recon_music, but with the same length of x1)
%___________________________________________________________
[row,col] = size(snew_fft);
recon_music = zeros(round(row/2)*(col+1),1);
for i = 1:col
    begin_point = (i-1)*round(row/2)+1;
    end_point = begin_point+row-1;
    recon_music(begin_point:end_point) = ...
        recon_music(begin_point:end_point) + ifft(snew_fft(:,i));
end
recon_music = real(recon_music);
xnew = zeros(size(x1));
xnew(1:length(recon_music)) = recon_music;
end
