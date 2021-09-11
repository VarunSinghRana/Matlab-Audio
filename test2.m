close all
clear

%---------------- PARAMETERS
param = local_settings();
songdir = param.songdir;
hashdir = param.hashdir;
fs = param.fs;

load songnames;		% contains 'songnames'
sampsec = 5;		% length of sample sound (seconds)
snr_db = -5;

%---------------------------

tic
wlen = param.wlen;
olen = param.olen;
t_mindelta = param.t_mindelta;
t_maxdelta = param.t_maxdelta;
t_freqdiff = param.t_freqdiff;

num_s = length(songnames);
samplen = sampsec*fs;

% bit and duration
bit=16;
duration=10;
% record 
recobj =audiorecorder(fs,bit,2);
h=msgbox("Recording...",'Rec.');
recordblocking(recobj,duration);
delete(h)

%store in double-precision Array

myrecording=getaudiodata(recobj);
s=mean(myrecording,2);
s = s(:);
slen = length(s);
num_win = floor((slen-olen)/(wlen-olen));

% choose sample
sampstart = floor(rand*(slen-samplen-1)+1);
ss = s(sampstart:sampstart+samplen-1);
% generate noise
%pown = pows/(10^(snr_db/10));
%noise = sqrt(pown)*randn(samplen,1);

sample = ss %+ noise;
%soundsc(sample,fs);

%------------------------- DO THE TEST --------------
score = zeros(num_s,1);

fprintf('Matching hash tables\n');
for s_ind = 1:num_s,
    if ~mod(s_ind,floor(num_s/10)), fprintf('.'); end
    % get hash table
    sname_i = strrep(songnames{s_ind},'.','_');
    hashname = fullfile(hashdir,sprintf('hashtable %s.mat',sname_i));
    load(hashname); % contains 'localhash' and 'slen'
    num_win = floor((slen-olen)/(wlen-olen));
    
    score(s_ind) = trymatch(sample,localhash,num_win);
end

fprintf('\n')

[maxscore,detected_songind] = max(score);

%soundsc(sample,fs);
%pause(samplen/fs+0.3)
soundsc(ss,fs)
fprintf(1,'score: %f\n',max(score));
fprintf(1,'detected_songind: %f\n',detected_songind);
fprintf(1,'Detected sound: %s\n',songnames{detected_songind});
h = msgbox({'Detected Sound..';songnames{detected_songind}});
t = toc;