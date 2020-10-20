function [overall_snr, segmental_snr,segmental_snr1] = active_snr(clean_speech, processed_speech,sample_rate)
nbits = 16;
srate = 16000;
clean_length      = length(clean_speech);
processed_length  = length(processed_speech);

if (clean_length ~= processed_length)
  disp('Error: Both Speech Files must be same length.');
  return
end

clean_speech     = clean_speech     - mean(clean_speech);
processed_speech = processed_speech - mean(processed_speech);

processed_speech = processed_speech.*(max(abs(clean_speech))/ max(abs(processed_speech)));
[p_clean, asl, c0]= asl_P56 ( clean_speech, srate, nbits); 
[p_clean_processed, asl, c0]= asl_P56 ( clean_speech-processed_speech, srate, nbits); 
overall_snr = 10* log10( p_clean/p_clean_processed);
