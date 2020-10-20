clc 
clear all 
close all
% paths are defined.
orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\30hdata_2_f';
raw_path = strcat(orig_path,'\du16_data');
mixed_foldername = 'mixed_30h_f';
clean_foldername = 'clean_30h_f';
if ~exist([strcat(write_path,mixed_foldername)],'dir')
    mkdir(write_path,mixed_foldername)
end
if ~exist([strcat(write_path,clean_foldername)],'dir')
    mkdir(write_path,clean_foldername)
end
% variables are defined.
dataset_dir = dir(raw_path)';
dataset_names=natsort({dataset_dir.name});
nbits = 16;
sum = 0;
snr_mix=-10;
randomnums_sp2 = zeros(500,6,21);
randomnames_sp2 = cell(500,6,21);
% data is mixed.
%number of speaker is summed with two in code. 4 is speaker number 2 for
%instance.
for s=1:21
    sp_1=3;%speaker number
    sp_1_dir=dir(strcat(raw_path,'\',dataset_names{sp_1}));
    sp_1_names=natsort({sp_1_dir.name});%the voices inside speaker number
    for sp_1_num=3:length(sp_1_names)
        [y1,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_1},'\',sp_1_names{sp_1_num}),'double');
        intf_number=0;
        for sp_2=[4,8,16,24,17,26]
            intf_number=intf_number+1;
            sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
            sp_2_names=natsort({sp_2_dir.name});
            sp_2_rand = randi([3,length(sp_2_names)]);%random file of interferer
            randomnums_sp2(sp_1_num-2,intf_number,s) = sp_2_rand;
            randomnames_sp2(sp_1_num-2,intf_number,s) = {sp_2_names{sp_2_rand}};
            [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
            if length(y2)>length(y1) %data is padded.
                y1 = [y1; zeros(length(y2)-length(y1),1)];
            else
                y2 = [y2; zeros(length(y1)-length(y2),1)];
            end
            [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_num});
            [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
            maxim = max(abs(y1));
            %normalization between 0 and 1.
            y1=y1./maxim;
            audiowrite(strcat(write_path,'\',clean_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
            [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
            [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
            sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
            y2= y2 * sf; 
            a=y1+y2;
            mixed=y1+y2;
            max_elem = max(abs(mixed)); 
            mixed=mixed./max_elem;
            audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
            x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
            sum=x.Duration+sum;  %sum is the seconds sum.
        end
    end    
    snr_mix = snr_mix+1;
end
hour = sum/3600;
save hour_2 hour
save randomfiles_intf_30h_2 randomnums_sp2
save randomnames_intf_30h_2 randomnames_sp2

