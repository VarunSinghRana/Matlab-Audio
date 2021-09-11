clear all;
bit=16;
duration=10;
% record 
recobj =audiorecorder(fs,bit,2);
h=msgbox("Recording");
recordblocking(recobj,duration);
delete(h)

%store in double-precision Array

myrecording=getaudiodata(recobj);
y=mean(myrecording,2);

spec(y,fs);
soundsc(y,fs);