clc
clear all
close all
%% paths are defined.
orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\devdata';
raw_path = strcat(orig_path,'\GRID_16');
mixed_foldername = 'mixed_dev_sp1';
clean_foldername = 'clean_dev_sp1';
if ~exist([strcat(write_path,mixed_foldername)],'dir')
    mkdir(write_path,mixed_foldername)
end
if ~exist([strcat(write_path,clean_foldername)],'dir')
    mkdir(write_path,clean_foldername)
end
%% variables are defined.
dataset_dir = dir(raw_path)';
dataset_names=natsort({dataset_dir.name});
nbits = 16;
sum = 0;
snr_mix=-9;
%% data is mixed.
%number of speaker is summed with two in code. 4 is speaker number 2 for
%instance.
m_speakers = [3,5,15,21,32,19,10];
f_speakers = [25,36,27,35,13,6];
randomnums_sp1 = zeros(1000,6);
randomnames_sp1 = cell(1000,6);
randomnums_m = zeros(1000,6);
randomnames_m = cell(1000,6);
randomnums_f = zeros(1200,6);
randomnames_f = cell(1200,6);
for s=1:6
    sp_1=3;%speaker number
    sp_1_dir=dir(strcat(raw_path,'\',dataset_names{sp_1}));
    sp_1_names=natsort({sp_1_dir.name});%the voices inside speaker number
    for i=1:1100
        sp_1_rand=randi([3,1002]);
        [y1,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_1},'\',sp_1_names{sp_1_rand}),'double');
        sp_2 = m_speakers(randi([1,6]));
        sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
        sp_2_names=natsort({sp_2_dir.name});
        sp_2_rand=randi([3,length(sp_2_names)]);
        randomnums_sp1(i,s) = sp_1_rand;
        randomnames_sp1(i,s) = {sp_1_names{sp_1_rand}};       
        randomnums_m(i,s) = sp_2_rand;
        randomnames_m(i,s) = {sp_2_names{sp_2_rand}};
        [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
        if length(y2)>length(y1) %data is padded.
            y1 = [y1; zeros(length(y2)-length(y1),1)];
        else
            y2 = [y2; zeros(length(y1)-length(y2),1)];
        end
        [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_rand});
        [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
        maxim = max(abs(y1));
        %normalization between 0 and 1.
        y1=y1./maxim;
        audiowrite(strcat(write_path,'\',clean_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
        [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
        [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
        sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
        y2= y2 * sf; 
        a=y1+y2;
        mixed=y1+y2;
        max_elem = max(abs(mixed)); 
        mixed=mixed./max_elem;
        audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
        x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
        sum=x.Duration+sum;  %sum is the seconds sum.
    end   
    snr_mix = snr_mix+3;
end
snr_mix=-9;
for s=1:6
    sp_1=3;%speaker number
    sp_1_dir=dir(strcat(raw_path,'\',dataset_names{sp_1}));
    sp_1_names=natsort({sp_1_dir.name});%the voices inside speaker number
    for i=1:1000
        sp_1_rand=randi([3,1002]);
        [y1,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_1},'\',sp_1_names{sp_1_rand}),'double');
        sp_2 = f_speakers(randi([1,6]));
        sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
        sp_2_names=natsort({sp_2_dir.name});
        sp_2_rand=randi([3,length(sp_2_names)]);
        randomnums_sp1(i,s) = sp_1_rand;
        randomnames_sp1(i,s) = {sp_1_names{sp_1_rand}};       
        randomnums_f(i,s) = sp_2_rand;
        randomnames_f(i,s) = {sp_2_names{sp_2_rand}};
        [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
        if length(y2)>length(y1) %data is padded.
            y1 = [y1; zeros(length(y2)-length(y1),1)];
        else
            y2 = [y2; zeros(length(y1)-length(y2),1)];
        end
        [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_rand});
        [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
        maxim = max(abs(y1));
        %normalization between 0 and 1.
        y1=y1./maxim;
        audiowrite(strcat(write_path,'\',clean_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
        [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
        [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
        sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
        y2= y2 * sf; 
        a=y1+y2;
        mixed=y1+y2;
        max_elem = max(abs(mixed)); 
        mixed=mixed./max_elem;
        audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
        x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_rand-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
        sum=x.Duration+sum;  %sum is the seconds sum.
        hour = sum/3600;
    end   
    snr_mix = snr_mix+3;
end
save randomfiles_dev_sp1 randomnums_sp1
save randomnames_dev_sp1 randomnames_sp1
save randomfiles_dev_intf_m randomnums_m
save randomnames_dev_intf_m randomnames_m
save randomfiles_dev_intf_f randomnums_f
save randomnames_dev_intf_f randomnames_f
save hours_dev hour





