clc
clear 
close all

%%main part of code is mostly, defining directories and looping in the directories to find the sudio files.

orig_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\results';
Data_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
%folder of results
result_folder = '\results_562_test_2\';
image_folder = '\images';
test_file = '_t1_2';
raw_path = strcat(Data_path,'\test_16000',test_file,'\');
files = dir(raw_path)';
sorted_names={files.name};
ind = 3;
if ~exist([strcat(orig_path,'\images',result_folder)],'dir')
    mkdir(strcat(orig_path,'\images',result_folder))
end
if ~exist([strcat(orig_path,'\images',result_folder)],'dir')
    mkdir(strcat(orig_path,'\images',result_folder))
end
for i=[3,4,5,7,8,9]
    a = strcat(raw_path,sorted_names(i));
    files2=dir(a{1})';
    sorted_files={files2.name};
    pesq_pred=zeros(length(sorted_files)-2,1);
    pesq_mixed=zeros(length(sorted_files)-2,1);
    stoi_pred=zeros(length(sorted_files)-2,1);
    stoi_mixed=zeros(length(sorted_files)-2,1);
    SDR_pred=zeros(length(sorted_files)-2,1);
    SDR_mixed=zeros(length(sorted_files)-2,1);
    k=1;
    for j=3:length(sorted_files)
        pred_name = strcat(orig_path,result_folder,sorted_names{i},'\',sorted_files{j});
        mixed_name = strcat(Data_path,'\test_16000',test_file,'\',sorted_names{i},'\',sorted_files{j});
        clean_name = strcat(Data_path,'\test_16000',test_file,'\clean\',sorted_files{j});
        [pred,fs]=audioread(pred_name);
        [mixed,fs]=audioread(mixed_name);
        [clean,fs]=audioread(clean_name);
        pesq_pred(k)=pesq(clean_name,pred_name);
        pesq_mixed(k)=pesq(clean_name,mixed_name);
        stoi_pred(k)=stoi(clean(1:length(pred)),pred,fs);
        stoi_mixed(k)=stoi(clean(1:length(pred)),mixed(1:length(pred)),fs);
        [SDR_pred(k),SIR_pred(k),SAR_pred(k),~]=bss_eval_sources([pred.',pred.'],[clean(1:length(pred)).',clean(1:length(pred)).']);
        [SDR_mixed(k),SIR_mixed(k),SAR_mixed(k),~]=bss_eval_sources([mixed(1:length(pred)).',mixed(1:length(pred)).'],[clean(1:length(pred)).',clean(1:length(pred)).']);
        k=k+1;
        
    end
    mixed_pesq_mean(ind-2)=mean(pesq_mixed);
    pred_pesq_mean(ind-2)=mean(pesq_pred);
    mixed_stoi_mean(ind-2)=mean(stoi_mixed);
    pred_stoi_mean(ind-2)=mean(stoi_pred);
    mixed_SDR_mean(ind-2)=mean(SDR_mixed);
    pred_SDR_mean(ind-2)=mean(SDR_pred);
    mixed_SAR_mean(ind-2)=mean(SAR_mixed);
    pred_SAR_mean(ind-2)=mean(SAR_pred);
    mixed_SIR_mean(ind-2)=mean(SIR_mixed);
    pred_SIR_mean(ind-2)=mean(SIR_pred);
    ind = ind+1;
end
mixed_pesq_mean2 = mixed_pesq_mean;
mixed_pesq_mean2(1) = mixed_pesq_mean(6);
mixed_pesq_mean2(2) = mixed_pesq_mean(5);
mixed_pesq_mean2(3) = mixed_pesq_mean(4);
mixed_pesq_mean2(6) = mixed_pesq_mean(3);
mixed_pesq_mean2(5) = mixed_pesq_mean(2);
mixed_pesq_mean2(4) = mixed_pesq_mean(1);
pred_pesq_mean2 = pred_pesq_mean;
pred_pesq_mean2(1) = pred_pesq_mean(6);
pred_pesq_mean2(2) = pred_pesq_mean(5);
pred_pesq_mean2(3) = pred_pesq_mean(4);
pred_pesq_mean2(6) = pred_pesq_mean(3);
pred_pesq_mean2(5) = pred_pesq_mean(2);
pred_pesq_mean2(4) = pred_pesq_mean(1);

mixed_stoi_mean2 = mixed_stoi_mean;
mixed_stoi_mean2(1) = mixed_stoi_mean(6);
mixed_stoi_mean2(2) = mixed_stoi_mean(5);
mixed_stoi_mean2(3) = mixed_stoi_mean(4);
mixed_stoi_mean2(6) = mixed_stoi_mean(3);
mixed_stoi_mean2(5) = mixed_stoi_mean(2);
mixed_stoi_mean2(4) = mixed_stoi_mean(1);
pred_stoi_mean2 = pred_stoi_mean;
pred_stoi_mean2(1) = pred_stoi_mean(6);
pred_stoi_mean2(2) = pred_stoi_mean(5);
pred_stoi_mean2(3) = pred_stoi_mean(4);
pred_stoi_mean2(6) = pred_stoi_mean(3);
pred_stoi_mean2(5) = pred_stoi_mean(2);
pred_stoi_mean2(4) = pred_stoi_mean(1);

mixed_SDR_mean2 = mixed_SDR_mean;
mixed_SDR_mean2(1) = mixed_SDR_mean(6);
mixed_SDR_mean2(2) = mixed_SDR_mean(5);
mixed_SDR_mean2(3) = mixed_SDR_mean(4);
mixed_SDR_mean2(6) = mixed_SDR_mean(3);
mixed_SDR_mean2(5) = mixed_SDR_mean(2);
mixed_SDR_mean2(4) = mixed_SDR_mean(1);
pred_SDR_mean2 = pred_SDR_mean;
pred_SDR_mean2(1) = pred_SDR_mean(6);
pred_SDR_mean2(2) = pred_SDR_mean(5);
pred_SDR_mean2(3) = pred_SDR_mean(4);
pred_SDR_mean2(6) = pred_SDR_mean(3);
pred_SDR_mean2(5) = pred_SDR_mean(2);
pred_SDR_mean2(4) = pred_SDR_mean(1);

mixed_SAR_mean2 = mixed_SAR_mean;
mixed_SAR_mean2(1) = mixed_SAR_mean(6);
mixed_SAR_mean2(2) = mixed_SAR_mean(5);
mixed_SAR_mean2(3) = mixed_SAR_mean(4);
mixed_SAR_mean2(6) = mixed_SAR_mean(3);
mixed_SAR_mean2(5) = mixed_SAR_mean(2);
mixed_SAR_mean2(4) = mixed_SAR_mean(1);
pred_SAR_mean2 = pred_SAR_mean;
pred_SAR_mean2(1) = pred_SAR_mean(6);
pred_SAR_mean2(2) = pred_SAR_mean(5);
pred_SAR_mean2(3) = pred_SAR_mean(4);
pred_SAR_mean2(6) = pred_SAR_mean(3);
pred_SAR_mean2(5) = pred_SAR_mean(2);
pred_SAR_mean2(4) = pred_SAR_mean(1);

mixed_SIR_mean2 = mixed_SIR_mean;
mixed_SIR_mean2(1) = mixed_SIR_mean(6);
mixed_SIR_mean2(2) = mixed_SIR_mean(5);
mixed_SIR_mean2(3) = mixed_SIR_mean(4);
mixed_SIR_mean2(6) = mixed_SIR_mean(3);
mixed_SIR_mean2(5) = mixed_SIR_mean(2);
mixed_SIR_mean2(4) = mixed_SIR_mean(1);
pred_SIR_mean2 = pred_SIR_mean;
pred_SIR_mean2(1) = pred_SIR_mean(6);
pred_SIR_mean2(2) = pred_SIR_mean(5);
pred_SIR_mean2(3) = pred_SIR_mean(4);
pred_SIR_mean2(6) = pred_SIR_mean(3);
pred_SIR_mean2(5) = pred_SIR_mean(2);
pred_SIR_mean2(4) = pred_SIR_mean(1);

%%save results

save(strcat(orig_path,result_folder,'mixed_pesq.txt'), 'mixed_pesq_mean2', '-ascii')
save(strcat(orig_path,result_folder,'pred_pesq.txt'), 'pred_pesq_mean2', '-ascii')
save(strcat(orig_path,result_folder,'mixed_stoi.txt'), 'mixed_stoi_mean2', '-ascii')
save(strcat(orig_path,result_folder,'pred_stoi.txt'), 'pred_stoi_mean2', '-ascii')
save(strcat(orig_path,result_folder,'mixed_SDR.txt'), 'mixed_SDR_mean2', '-ascii')
save(strcat(orig_path,result_folder,'pred_SDR.txt'), 'pred_SDR_mean2', '-ascii')
save(strcat(orig_path,result_folder,'mixed_SAR.txt'), 'mixed_SAR_mean2', '-ascii')
save(strcat(orig_path,result_folder,'pred_SAR.txt'), 'pred_SAR_mean2', '-ascii')
save(strcat(orig_path,result_folder,'mixed_SIR.txt'), 'mixed_SIR_mean2', '-ascii')
save(strcat(orig_path,result_folder,'pred_SIR.txt'), 'pred_SIR_mean2', '-ascii')

%%plot figures

figure
x=[-9,-6,-3,0,3,6];
A=plot(x,mixed_pesq_mean2,'-x','color',[0 0.4470 0.7410],'LineWidth',1);
hold on
plot(x,pred_pesq_mean2,'-x','color',[0.6350 0.0780 0.1840],'LineWidth',1);
x=[-9,-6,-3,0,3,6];
xticks(x)
grid on
legend('mixed','pred','Location','NorthWest')
saveas(A,strcat(orig_path,'\images',result_folder,'pesq.png'),'png')
figure
A=plot(x,mixed_stoi_mean2,'-x','color',[0 0.4470 0.7410],'LineWidth',1);
x=[-9,-6,-3,0,3,6];
xticks(x)
grid on
hold on
plot(x,pred_stoi_mean2,'-x','color',[0.6350 0.0780 0.1840],'LineWidth',1);
x=[-9,-6,-3,0,3,6];
xticks(x)
grid on
legend('mixed','pred','Location','NorthWest')
saveas(A,strcat(orig_path,'\images',result_folder,'stoi.png'),'png')
figure
A=plot(x,mixed_SDR_mean2,'-x','color',[0 0.4470 0.7410],'LineWidth',1);
hold on
plot(x,pred_SDR_mean2,'-x','color',[0.6350 0.0780 0.1840],'LineWidth',1);
grid on
x=[-9,-6,-3,0,3,6];
xticks(x)
legend('mixed','pred','Location','NorthWest');
saveas(A,strcat(orig_path,'\images',result_folder,'SDR.png'),'png')




