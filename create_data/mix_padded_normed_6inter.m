
orig_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
write_path = 'D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\10hdata';
raw_path = strcat(orig_path,'\single_dataset_16');
files = dir(raw_path)';
sorted_names=natsort({files.name});
nbits = 16;
input_snr=0;
sum = 0;
snr_mix=-9;
% randoms = [410 455 65 459 318 50 141 275 481 485 80 488];
mixed_foldername = 'mixed_10h';
clean_foldername = 'clean_10h';
randomnums = zeros(500,6,6);
randomnames = cell(500,6,6);
for s=1:6
%     ind=1;
    file1=4;
    files2=dir(strcat(raw_path,'\',sorted_names{file1}));
    sorted_names2=natsort({files2.name});
    %direct=strcat(raw_path,'\',sorted_names{file1});
    for file2=3:length(sorted_names2)
        [y1,Fs]=audioread(strcat(raw_path,'\',sorted_names{file1},'\',sorted_names2{file2}),'double');
        intf_number=0;
%             ind=1;
        for sec_file1=[3,7,15,17,25,33]
            intf_number=intf_number+1;
            sec_files2=dir(strcat(raw_path,'\',sorted_names{sec_file1}));
            sec_sorted_names2=natsort({sec_files2.name});
            %direct=strcat(raw_path,'\',sec_sorted_names{sec_file1});
            randnum = randi([3,length(sorted_names2)]);
            randomnums(file2-2,intf_number,s) = randnum;
            randomnames(file2-2,intf_number,s) = {sec_sorted_names2{sec_file2}};
%                 ind = ind+1;
            sec_file2=randnum;
%                     disp(sec_file2)
            [y2,Fs]=audioread(strcat(raw_path,'\',sorted_names{sec_file1},'\',sec_sorted_names2{sec_file2}));
            if length(y2)>length(y1)
                y1 = [y1; zeros(length(y2)-length(y1),1)];
            else
                y2 = [y2; zeros(length(y1)-length(y2),1)];
            end
            [pathstr,name1,ext] = fileparts(sorted_names2{file2});
            [pathstr,name2,ext] = fileparts(sec_sorted_names2{sec_file2});
            maxim = max(abs(y1));
            y1=y1./maxim;
            audiowrite(strcat(write_path,'\',clean_foldername,'\mixed_',name1,'_',string(file2-2),'_',string(snr_mix),'_',name2,'_',string(sec_file1-2),'_',string(sec_file2-2),'.wav'),y1,16000);
            [P1, asl, c0]= asl_P56 ( y1, Fs, nbits); 
            [P2, asl, c0]= asl_P56 ( y2, Fs, nbits);
            %P2= y2'* y2/ length(y1); 
            sf= sqrt( P1/P2/ (10^ (snr_mix/ 10))); % scale factor for noise segment data
            y2= y2 * sf; 
            a=y1+y2;
%                     disp(find(a>=1|a<-1))
            mixed=y1+y2;%lilmixed2 lilmixed3
            max_elem = max(abs(mixed)); %lilmixed3
            mixed=mixed./max_elem; %lilmixed3
%                     max_amp = max(cat(1,abs(mixed(:)),abs(y1),abs(y2)));
%                     mix_scaling = 1/max_amp*0.9;
%                     mixed = mix_scaling * mixed;
%                     disp(sec_file2-2)
            audiowrite(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(file2-2),'_',string(snr_mix),'_',name2,'_',string(sec_file1-2),'_',string(sec_file2-2),'.wav'),mixed,16000);
            x=audioinfo(strcat(write_path,'\',mixed_foldername,'\mixed_',name1,'_',string(file2-2),'_',string(snr_mix),'_',name2,'_',string(sec_file1-2),'_',string(sec_file2-2),'.wav'));
            sum=x.Duration+sum;
            
        end
        %x=audioinfo(strcat(raw_path,'\',sorted_names{file1},'\',sorted_names2{file2}));
        %sum=x.Duration+sum;
    end
    
    snr_mix = snr_mix+3;
end
% [y,Fs]=audioread(strcat(orig_path,'\mixed501_1.wav'));
% audiowrite('mixed501_1_16bit.wav',y,16000);
% clear y Fs
%asl_P56('down_mixed501_1_16bit.wav',16000,16)
% [clean, srate]= audioread('down_mixed501_1_16bit.wav'); 
% [Px, asl, c0]= asl_P56 ( clean, 16000, 32); 
% addnoise('down_mixed501_1.wav', 16000, 16, 'down_mixed501_1.wav', 16000, 16, 0)
save randomfiles randomnums
save randomnames randomnames





