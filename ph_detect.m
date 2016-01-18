function [pitch1,pitch2,pitch3] = ph_detect(s, fspec, tspec)
%______________________________________________________________________
% this function is to detect the pitch and harnomic frequences
% INPUT:    s, fspec, tspec (spectrogram output)
% OUTPUT:
% pitch1 (the first 'phnum' frequence points with biggest energy)
% pitch2 (similar as pitch1, but the value is the real frequence value)
% pitch3 (the result of real pitch frequence)
%______________________________________________________________________
sproc = s;          fqchange = length(fspec)/fspec(end);
lowbond = round(50*fqchange);   upbond = round(50*fqchange);

phnum = 3;          % the number of pitch + harmonic
pitch1 = zeros(phnum,length(tspec));
pitch2 = zeros(phnum,length(tspec));
for i = 1:length(tspec)  
    for j = 1:phnum
        [valpitch,pitch1(j,i)] = max(abs(sproc(:,i)));
        for t = max(1,(pitch1(j,i)-lowbond)):min(length(fspec),(pitch1(j,i)+upbond))
            sproc(t,i) = 0;   
        end
        pitch2(j,i) = fspec(pitch1(j,i));
    end   
end

figure(2)
%%%%%% find the noise points and remove them %%%%%%
aver = zeros(phnum,1);
for i = 1:phnum
    aver(i)= mean(pitch2(i,:));   
    idx = find(abs(pitch2(i,:)-aver(i))>2*aver(i));
    pitch2(i,idx) = 0;
end

subplot(phnum,1,1); plot(tspec, pitch2(1,:)); title('pitch of the music (1st method)');...
    xlabel('time');ylabel('frequence magnitude'); hold on;
for i = 2:phnum
    subplot(phnum,1,i); plot(tspec, pitch2(i,:)); title('harmonic of the music');...
    xlabel('time');ylabel('frequence magnitude'); hold on;
end
hold off;
%% get more specific pitch
freq_double = 4;
pitch3 = zeros(1,length(tspec));
for j = 1:length(tspec)
    freq_max = pitch1(1,j);
    data = s(:,j);
    data_sum = zeros(freq_double,1);
    for i = 1:freq_double
        step = round(freq_max/i);
        data_sum(i) = sum(data(step:step:freq_max))*step;
    end
    change = zeros(freq_double-1,1);
    change_sum = zeros(freq_double-1,1);
    for i = 1:freq_double-1
        change(i) = data_sum(i) - data_sum(i+1);
    end
   for i = 1:freq_double-1
       change_sum(i) = sum(change(i:i:length(change)))*i;
   end
    [maxnum,maxidx] = max(change_sum);
    pitch3(j) = round(freq_max/maxidx);
end

pitch4 = zeros(1,length(tspec));
for i = 1:length(tspec)
    if pitch3(i) >0
        pitch4(i) = fspec(pitch3(i));
    else
        pitch4(i) = 1;
    end
end
pitch5 = 2.*pitch4;
pitch6 = 3.*pitch4;
figure(3)
subplot(3,1,1); plot(tspec, pitch4); title('pitch of the music (3ed method)');...
    xlabel('time');ylabel('frequence magnitude');hold on;
subplot(3,1,2); plot(tspec, pitch5); title('harmonic of the music (3ed method)');...
    xlabel('time');ylabel('frequence magnitude'); hold on;
subplot(3,1,3); plot(tspec, pitch6); title('harmonic of the music (3ed method)');...
    xlabel('time');ylabel('frequence magnitude'); hold off;
end
