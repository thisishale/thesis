%% test snr with speech+noise
a=audioread('bbaf3p.wav');
b=audioread('White_short.wav');
addnoise_asl('bbaf3p.wav', 'White_short.wav', 'outf.wav', 0) 
o=audioread('outf.wav');
b=b(1:length(a));
rate=16000;
[overall_snr, segmental_snr,segmental_snr1]=loizou_snr(a,o,rate);
overall_snr
snr(a,o-a)
%% test snr with speech+snr
% a=audioread('bbaf3p.wav');
% b=audioread('mixed_bbaf3p_1_bbac1p_34_1.wav');
% snr(b,b-a)
%% test snr with loizou 
a=audioread('bbaf3p.wav');
b=audioread('mixed_bbaf3p_1_bbac1p_34_1__2.wav');
loizou_snr(a,b,rate)
active_snr(a,b,rate)