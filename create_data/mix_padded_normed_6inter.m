clc 
clear all 
close all
% paths are defined.
% orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
% write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\30hdata_2';
% raw_path = strcat(orig_path,'\du16_data');
% mixed_foldername = 'mixed_30h';
% clean_foldername = 'clean_30h';
% if ~exist([strcat(write_path,mixed_foldername)],'dir')
%     mkdir(write_path,mixed_foldername)
% end
% if ~exist([strcat(write_path,clean_foldername)],'dir')
%     mkdir(write_path,clean_foldername)
% end
% % variables are defined.
% dataset_dir = dir(raw_path)';
% dataset_names=natsort({dataset_dir.name});
% nbits = 16;
% sum = 0;
% snr_mix=-10;
% randomnums_sp2 = zeros(500,6,21);
% randomnames_sp2 = cell(500,6,21);
% % randomnums_sp2=load('randomfiles_intf_30h.mat');
% % data is mixed.
% %number of speaker is summed with two in code. 4 is speaker number 2 for
% %instance.
% for s=1:21
%     sp_1=3;%speaker number
%     sp_1_dir=dir(strcat(raw_path,'\',dataset_names{sp_1}));
%     sp_1_names=natsort({sp_1_dir.name});%the voices inside speaker number
%     for sp_1_num=3:length(sp_1_names)
%         [y1,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_1},'\',sp_1_names{sp_1_num}),'double');
%         intf_number=0;
%         for sp_2=[4,8,16,24,17,26]
%             intf_number=intf_number+1;
%             sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
%             sp_2_names=natsort({sp_2_dir.name});
%             sp_2_rand = randi([3,length(sp_2_names)]);%random file of interferer
% %             sp_2_rand=randomnums_sp2.randomnums_sp2(sp_1_num-2,intf_number,s);
%             randomnums_sp2(sp_1_num-2,intf_number,s) = sp_2_rand;
%             randomnames_sp2(sp_1_num-2,intf_number,s) = {sp_2_names{sp_2_rand}};
%             [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
%             if length(y2)>length(y1) %data is padded.
%                 y1 = [y1; zeros(length(y2)-length(y1),1)];
% %                 y2 = y2(1:length(y1));
%             else
%                 y2 = [y2; zeros(length(y1)-length(y2),1)];
%             end
%             [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_num});
%             [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
%             maxim = max(abs(y1));
%             %normalization between 0 and 1.
%             y1=y1./maxim;
%             audiowrite(strcat(write_path,'\',clean_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
%             [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
%             [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
%             sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
%             y2= y2 * sf; 
%             a=y1+y2;
%             mixed=y1+y2;
%             max_elem = max(abs(mixed)); 
%             mixed=mixed./max_elem;
%             audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
%             x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
%             sum=x.Duration+sum;  %sum is the seconds sum.
%         end
%     end    
%     snr_mix = snr_mix+1;
% end
% hour = sum/3600;
% save hour_2 hour
% save randomfiles_intf_30h_2 randomnums_sp2
% save randomnames_intf_30h_2 randomnames_sp2

%% mix in to female category.
m_or_f = 1;
%paths are defined.
orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\30hdata_2';
raw_path = strcat(orig_path,'\','du16_data');
mixed_foldername = 'mixed_female';
target_foldername = 'target_female';
intf_foldername = 'intf_female';
male_female_foldername = 'male_female';
pos_snr_m_foldername = 'snr_pos_m';
neg_snr_m_foldername = 'snr_neg_m';
pos_snr_f_foldername = 'snr_pos_f';
neg_snr_f_foldername = 'snr_neg_f';
pos_snr_m_target_folder = 'snr_pos_m_clean';
pos_snr_f_target_folder = 'snr_pos_f_clean';
pos_snr_m_mixed_folder = 'snr_pos_m_mixed';
pos_snr_f_mixed_folder = 'snr_pos_f_mixed';
neg_snr_m_target_folder = 'snr_neg_m_clean';
neg_snr_f_target_folder = 'snr_neg_f_clean';
neg_snr_m_mixed_folder = 'snr_neg_m_mixed';
neg_snr_f_mixed_folder = 'snr_neg_f_mixed';
pos_snr_m_intf_folder = 'snr_pos_m_intf';
pos_snr_f_intf_folder = 'snr_pos_f_intf';
neg_snr_m_intf_folder = 'snr_neg_m_intf';
neg_snr_f_intf_folder = 'snr_neg_f_intf';
folders={pos_snr_m_target_folder, pos_snr_f_target_folder, pos_snr_m_mixed_folder,...
    pos_snr_f_mixed_folder, neg_snr_m_target_folder, neg_snr_f_target_folder,...
    neg_snr_m_mixed_folder, neg_snr_f_mixed_folder, pos_snr_m_intf_folder,...
    pos_snr_f_intf_folder, neg_snr_m_intf_folder, neg_snr_f_intf_folder};
for folderinds=1:length(folders)
    if ~exist(strcat(write_path,'\',folders{folderinds}),'dir')
        mkdir(write_path,folders{folderinds})
    end
end
if ~exist([strcat(write_path,'\',mixed_foldername)],'dir')
    mkdir(write_path,mixed_foldername)
end
if ~exist([strcat(write_path,'\',target_foldername)],'dir')
    mkdir(write_path,target_foldername)
end
if ~exist([strcat(write_path,'\',intf_foldername)],'dir')
    mkdir(write_path,intf_foldername)
end

if ~exist([strcat(write_path,'\',male_female_foldername)],'dir')
    mkdir(write_path,male_female_foldername)
end

if ~exist([strcat(write_path,'\',pos_snr_f_foldername)],'dir')
    mkdir(write_path,pos_snr_f_foldername)
end
if ~exist([strcat(write_path,'\',neg_snr_f_foldername)],'dir')
    mkdir(write_path,neg_snr_f_foldername)
end
if ~exist([strcat(write_path,'\',pos_snr_m_foldername)],'dir')
    mkdir(write_path,pos_snr_m_foldername)
end
if ~exist([strcat(write_path,'\',neg_snr_m_foldername)],'dir')
    mkdir(write_path,neg_snr_m_foldername)
end

% variables are defined.
dataset_dir = dir(raw_path)';
dataset_names=natsort({dataset_dir.name});
nbits = 16;
sum = 0;
snr_mix=-10;
randomnums_sp2 = zeros(500,6,21);
randomnames_sp2 = cell(500,6,21);
% randomnums_sp2=load('randomfiles_intf_30h.mat');
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
        for sp_2=[24,17,26]
            intf_number=intf_number+1;
            sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
            sp_2_names=natsort({sp_2_dir.name});
            sp_2_rand = randi([3,length(sp_2_names)]);%random file of interferer
%             sp_2_rand=randomnums_sp2.randomnums_sp2(sp_1_num-2,intf_number,s);
            randomnums_sp2(sp_1_num-2,intf_number,s) = sp_2_rand;
            randomnames_sp2(sp_1_num-2,intf_number,s) = {sp_2_names{sp_2_rand}};
            [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
            if length(y2)>length(y1) %data is padded.
                y1 = [y1; zeros(length(y2)-length(y1),1)];
%                 y2 = y2(1:length(y1));
            else
                y2 = [y2; zeros(length(y1)-length(y2),1)];
            end
            [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_num});
            [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
            %normalization between 0 and 1.
            maxim = max(abs(y1));
            y1=y1./maxim;
            maxim = max(abs(y2));
            y2=y2./maxim;
            audiowrite(strcat(write_path,'\',target_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
            audiowrite(strcat(write_path,'\',intf_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            save(strcat(write_path,'\',male_female_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'m_or_f','-ascii')
            if s<12
                audiowrite(strcat(write_path,'\',neg_snr_f_target_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
                audiowrite(strcat(write_path,'\',neg_snr_f_intf_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            end
            if s>10
                audiowrite(strcat(write_path,'\',pos_snr_f_target_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
                audiowrite(strcat(write_path,'\',pos_snr_f_intf_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            end
            [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
            [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
            sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
            y2= y2 * sf; 
            a=y1+y2;
            mixed=y1+y2;
            max_elem = max(abs(mixed)); 
            mixed=mixed./max_elem;
            audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
            if s<12
                audiowrite(strcat(write_path,'\',neg_snr_f_mixed_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
                snr_num = 0;
                save(strcat(write_path,'\',neg_snr_f_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'snr_num','-ascii')
            end
            if s>10
                audiowrite(strcat(write_path,'\',pos_snr_f_mixed_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
                snr_num = 1;
                save(strcat(write_path,'\',pos_snr_f_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'snr_num','-ascii')
            end
            x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
            sum=x.Duration+sum;  %sum is the seconds sum.
        end
    end    
    snr_mix = snr_mix+1;
end
hour = sum/3600;
save(strcat(write_path,'\info','\hour_f.txt'),'hour','-ascii')
save(strcat(write_path,'\info','\randomfiles_intf_30h_2_f.mat'),'randomnums_sp2')
save(strcat(write_path,'\info','\randomnames_intf_30h_2_f.mat'),'randomnames_sp2')
% save randomfiles_intf_30h_2_f randomnums_sp2
% save randomnames_intf_30h_2_f randomnames_sp2
%% mix in to male category.
%paths are defined.
m_or_f = 0;
orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\30hdata_2';
raw_path = strcat(orig_path,'\','du16_data');
mixed_foldername = 'mixed_male';
target_foldername = 'target_male';
intf_foldername = 'intf_male';
if ~exist([strcat(write_path,'\',mixed_foldername)],'dir')
    mkdir(write_path,mixed_foldername)
end
if ~exist([strcat(write_path,'\',target_foldername)],'dir')
    mkdir(write_path,target_foldername)
end
if ~exist([strcat(write_path,'\',intf_foldername)],'dir')
    mkdir(write_path,intf_foldername)
end
% variables are defined.
dataset_dir = dir(raw_path)';
dataset_names=natsort({dataset_dir.name});
nbits = 16;
sum = 0;
snr_mix=-10;
randomnums_sp2 = zeros(500,6,21);
randomnames_sp2 = cell(500,6,21);
% randomnums_sp2=load('randomfiles_intf_30h.mat');
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
        for sp_2=[4,8,16]
            intf_number=intf_number+1;
            sp_2_dir=dir(strcat(raw_path,'\',dataset_names{sp_2}));%voices inside interferers.
            sp_2_names=natsort({sp_2_dir.name});
            sp_2_rand = randi([3,length(sp_2_names)]);%random file of interferer
%             sp_2_rand=randomnums_sp2.randomnums_sp2(sp_1_num-2,intf_number,s);
            randomnums_sp2(sp_1_num-2,intf_number,s) = sp_2_rand;
            randomnames_sp2(sp_1_num-2,intf_number,s) = {sp_2_names{sp_2_rand}};
            [y2,Fs]=audioread(strcat(raw_path,'\',dataset_names{sp_2},'\',sp_2_names{sp_2_rand}));
            if length(y2)>length(y1) %data is padded.
                y1 = [y1; zeros(length(y2)-length(y1),1)];
%                 y2 = y2(1:length(y1));
            else
                y2 = [y2; zeros(length(y1)-length(y2),1)];
            end
            [pathstr,name1,ext] = fileparts(sp_1_names{sp_1_num});
            [pathstr,name2,ext] = fileparts(sp_2_names{sp_2_rand});
            %normalization between 0 and 1.
            maxim = max(abs(y1));
            y1=y1./maxim;
            maxim = max(abs(y2));
            y2=y2./maxim;
            audiowrite(strcat(write_path,'\',target_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
            audiowrite(strcat(write_path,'\',intf_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            save(strcat(write_path,'\',male_female_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'m_or_f','-ascii')
            if s<12
                audiowrite(strcat(write_path,'\',neg_snr_m_target_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
                audiowrite(strcat(write_path,'\',neg_snr_m_intf_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            end
            if s>10
                audiowrite(strcat(write_path,'\',pos_snr_m_target_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y1,16000);
                audiowrite(strcat(write_path,'\',pos_snr_m_intf_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),y2,16000);
            end
            [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); %power according to active level of voice.
            [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
            sf= sqrt( P1/P2/ (10^ (snr_mix/ 10)));%data is mixed according to snr of utterances. 
            y2= y2 * sf; 
            a=y1+y2;
            mixed=y1+y2;
            max_elem = max(abs(mixed)); 
            mixed=mixed./max_elem;
            audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
            if s<12
                audiowrite(strcat(write_path,'\',neg_snr_m_mixed_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
                snr_num = 0;
                save(strcat(write_path,'\',neg_snr_m_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'snr_num','-ascii')
            end
            if s>10
                audiowrite(strcat(write_path,'\',pos_snr_m_mixed_folder,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'),mixed,16000);
                snr_num = 1;
                save(strcat(write_path,'\',pos_snr_m_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.txt'),'snr_num','-ascii')
            end
            x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(sp_1_num-2),'_',string(snr_mix),'_',name2,'_',string(sp_2-2),'_',string(sp_2_rand-2),'.wav'));
            sum=x.Duration+sum;  %sum is the seconds sum.
        end
    end    
    snr_mix = snr_mix+1;
end
hour = sum/3600;
save(strcat(write_path,'\info','\hour_m.txt'),'hour','-ascii')
save(strcat(write_path,'\info','\randomfiles_intf_30h_2_m.mat'),'randomnums_sp2')
save(strcat(write_path,'\info','\randomnames_intf_30h_2_m.mat'),'randomnames_sp2')




