
orig_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
raw_path = strcat(orig_path,'\sec_mixed2_6_test\');
new_path = strcat(orig_path,'\test_16000\');
files = dir(raw_path)';
sorted_names=natsort({files.name});
i=0;
for file1=3:length(sorted_names)
    files2=dir(strcat(raw_path,sorted_names{file1}));
    sorted_names2=natsort({files2.name});
    if ~exist([strcat(new_path,sorted_names{file1})],'dir')
        mkdir(new_path,sorted_names{file1})
    end
    direct=strcat(new_path,sorted_names{file1});
    for file2=3:length(sorted_names2)      
            [y,Fs]=audioread(strcat(raw_path,sorted_names{file1},'\',sorted_names2{file2}));
            [P,Q] = rat(16e3/Fs);
            abs(P/Q*Fs-16000)
            ynew = resample(y,P,Q);
            %ynew=ynew/max(abs(ynew));
            max_amp = max(cat(1,abs(ynew)));
            scaling = 1/max_amp;
            ynew = scaling * ynew;
            audiowrite(strcat(direct,'\',sorted_names2{file2}),ynew,16000);
%             [y,Fs]=audioread(strcat(raw_path,'\',sorted_names{file1},'\',sorted_names2{file2},'\',sorted_names3{file3}));
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






