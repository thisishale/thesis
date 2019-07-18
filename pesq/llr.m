function distortion = llr(clean_speech, processed_speech,sample_rate)


% ----------------------------------------------------------------------
% Check the length of the clean and processed speech.  Must be the same.
% ----------------------------------------------------------------------

clean_length      = length(clean_speech);
processed_length  = length(processed_speech);

if (clean_length ~= processed_length)
  disp('Error: Both Speech Files must be same length.');
  return
end

% ----------------------------------------------------------------------
% Global Variables
% ----------------------------------------------------------------------

winlength   = round(30*sample_rate/1000); %240;		   % window length in samples
skiprate    = floor(winlength/4);		   % window skip in samples
if sample_rate<10000
   P           = 10;		   % LPC Analysis Order
else
    P=16;     % this could vary depending on sampling frequency.
end
% ----------------------------------------------------------------------
% For each frame of input speech, calculate the Log Likelihood Ratio 
% ----------------------------------------------------------------------

num_frames = clean_length/skiprate-(winlength/skiprate); % number of frames
start      = 1;					% starting sample
window     = 0.5*(1 - cos(2*pi*(1:winlength)'/(winlength+1)));

for frame_count = 1:num_frames

   % ----------------------------------------------------------
   % (1) Get the Frames for the test and reference speech. 
   %     Multiply by Hanning Window.
   % ----------------------------------------------------------

   clean_frame = clean_speech(start:start+winlength-1);
   processed_frame = processed_speech(start:start+winlength-1);
   clean_frame = clean_frame.*window;
   processed_frame = processed_frame.*window;

   % ----------------------------------------------------------
   % (2) Get the autocorrelation lags and LPC parameters used
   %     to compute the LLR measure.
   % ----------------------------------------------------------

   [R_clean, Ref_clean, A_clean] = ...
      lpcoeff(clean_frame, P);
   [R_processed, Ref_processed, A_processed] = ...
      lpcoeff(processed_frame, P);

   % ----------------------------------------------------------
   % (3) Compute the LLR measure
   % ----------------------------------------------------------

   numerator   = A_processed*toeplitz(R_clean)*A_processed';
   denominator = max(A_clean*toeplitz(R_clean)*A_clean',eps);
   distortion(frame_count) = min(2,log(numerator/denominator));
   start = start + skiprate;

end