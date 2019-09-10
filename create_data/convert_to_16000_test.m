
orig_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
% raw_path = strcat(orig_path,'\sec_mixed2_6_test_all\');
testfile_ref = 't1_2';
testfile = 't1_2';
raw_path = strcat(orig_path,'\test_targets\',testfile_ref,'\');
new_path = strcat(orig_path,'\test_16000_',testfile,'\');
test_data = dir(raw_path)';
test_data=natsort({test_data.name});
i=0;
if ~exist([new_path],'dir')
    mkdir(new_path)
end
for test_folders=3:length(test_data)
    test_files=dir(strcat(raw_path,test_data{test_folders}));
    test_files_names=natsort({test_files.name});
    if ~exist([strcat(new_path,test_data{test_folders})],'dir')
        mkdir(new_path,test_data{test_folders})
    end
    for names=3:length(test_files_names)      
        [y,Fs]=audioread(strcat(raw_path,test_data{test_folders},'\',test_files_names{names}));
        [P,Q] = rat(16e3/Fs);
        abs(P/Q*Fs-16000)
        ynew = resample(y,P,Q);
        %ynew=ynew/max(abs(ynew));
        max_amp = max(cat(1,abs(ynew)));
        scaling = 1/max_amp;
        ynew = scaling * ynew;
        audiowrite(strcat(strcat(new_path,test_data{test_folders}),'\',test_files_names{names}),ynew,16000);
%             [y,Fs]=audioread(strcat(raw_path,'\',sorted_names{test_folders},'\',test_files_names{names},'\',sorted_names3{file3}));
%             audiowrite(strcat(direct,'\',sorted_names3{file3}),y,16000);
%             clear y Fs
    end
end
% [y,Fs]=audioread(strcat(orig_path,'\mixed501_1.wav'));
% audiowrite('mixed501_1_16bit.wav',y,16000);
% clear y Fs
%asl_P56('down_mixed501_1_16bit.wav',16000,16)
% [clean, srate]= audioread('down_mixed501_1_16bit.wav'); 
% [Px, asl, c0]= asl_P56 ( clean, 16000, 32); 
% addnoise('down_mixed501_1.wav', 16000, 16, 'down_mixed501_1.wav', 16000, 16, 0)






