orig_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff\results';
Data_path='D:\studies\university\thesis\speech_separation_codes\du16\donesomestuff';
result_folder = '\results_4\';
image_folder = '\images';
raw_path = strcat(orig_path,result_folder);
files = dir(raw_path)';
sorted_names=natsort({files.name});
for i=3:8
    a = strcat(raw_path,sorted_names(i));
    files2=dir(a{1})';
    sorted_files=natsort({files2.name});
    pesq_pred=zeros(length(sorted_files),1);
    pesq_mixed=zeros(length(sorted_files),1);
    k=1;
    for j=3:length(sorted_files)
        disp(sorted_names(i))
        pred=strcat(orig_path,result_folder,sorted_names(i),'\',sorted_files(j));
%         mixed=strcat(Data_path,'\test_16000\',sorted_names(i),'\',sorted_files(j));
%         clean=strcat(Data_path,'\test_16000\clean\',sorted_files(j));
        mixed=strcat(Data_path,'\test_16000\',sorted_names(i),'\',sorted_files(j));
        clean=strcat(Data_path,'\test_16000\clean\',sorted_files(j));
        pesq_pred(k)=pesq(clean{1},pred{1});
        pesq_mixed(k)=pesq(clean{1},mixed{1});
        k=k+1;
    end
    mixed_pesq_mean(i-2)=mean(pesq_mixed);
    pred_pesq_mean(i-2)=mean(pesq_pred);
end
% fid = fopen('results_10h_BN\pesq\mixed_pesq.txt','w');
% for ii = 1:size(mixed_pesq_mean,2)
%     fwrite(fid, mixed_pesq_mean(:,ii),'double');
%     fwrite(fid,'\n');
% end
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
save(strcat(orig_path,result_folder,'pesq\mixed_pesq.txt', 'mixed_pesq_mean2', '-ascii'))
save(strcat(orig_path,result_folder,'pesq\pred_pesq.txt', 'pred_pesq_mean2', '-ascii'))
figure
x=[-9,-3,0,3,6,9];
A=plot(x,mixed_pesq_mean2,'b-o');
hold on
plot(x,pred_pesq_mean2,'r-o');
legend('mixed','pred')
saveas(A,strcat(orig_path,image_folder,result_folder,'pesq.png'),'png')