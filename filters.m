function snew_fft = filters(s,pitch1)
%% in this function, we design filters to get the signal contains only one instrument
% INPUT: s, pitch1 (pitch of the music)
% OUTPUT: snew_fft
% snew_fft (design 'filternum' filters to get the frequence in pitch,2*pitch,...filternum*pitch points)
%——————————————————————————————————————————————————————————————————————————————————————————————————————
[fscop,tscop] = size(s);
snew = zeros(fscop,tscop);
filternum = 50;     winwid = 5;
windfilter = zeros(1,fscop);    window = hanning(winwid);
for i = 1:winwid
    windfilter(i) = window(i);
end
for i = 1:tscop
    % create filter
    filters = zeros(filternum,fscop);
    for j = 1:filternum
        if ((j*pitch1(1,i)-round(winwid/2))>0)&&((j*pitch1(1,i)+round(winwid/2))<fscop)
            filters(j,:) = circshift(windfilter,[0,(j*pitch1(1,i)-round(winwid/2))]);
        end
    end
    sumfilter = sum(filters)';
    snew(:,i) = s(:,i).*sumfilter;
end

fspecsq = 1:1:257;
fspecsq = fspecsq.*43.0664;
figure(5)
subplot(2,1,1);plot(fspecsq,abs(s(:,1500)));title('frequence response of a frame');...
    xlabel('frequence value');ylabel('magnitude');hold on;
subplot(2,1,2);plot(fspecsq,abs(snew(:,1000)));title('frequence response of a frame after filtered');...
    xlabel('frequence value');ylabel('magnitude');hold off;

snew_fft = zeros(2*fscop-2,tscop);

for i = 1:fscop
    snew_fft(i,:) = snew(i,:);
end
for i = fscop+1:2*fscop-2
    snew_fft(i,:) = snew(2*fscop-i,:);
end
    
end
