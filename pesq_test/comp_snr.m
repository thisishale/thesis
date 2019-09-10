function [snr_mean, segsnr_mean, segsnr_mean2]= comp_SNR(cleanFile, enhdFile);
%
%   Segmental Signal-to-Noise Ratio Objective Speech Quality Measure
%
%     This function implements the segmental signal-to-noise ratio
%     as defined in [1, p. 45] (see Equation 2.12).
%
%   Usage:  [SNRovl, SNRseg]=comp_snr(cleanFile.wav, enhancedFile.wav)
%           
%         cleanFile.wav - clean input file in .wav format
%         enhancedFile  - enhanced output file in .wav format
%         SNRovl        - overall SNR (dB)
%         SNRseg        - segmental SNR (dB)
%
%     This function returns 2 parameters.  The first item is the
%     overall SNR for the two speech signals.  The second value
%     is the segmental signal-to-noise ratio (1 seg-snr per 
%     frame of input).  The segmental SNR is clamped to range 
%     between 35dB and -10dB (see suggestions in [2]).
%
%   Example call:  [SNRovl,SNRseg]=comp_SNR('sp04.wav','enhanced.wav')
%
%  References:
%
%     [1] S. R. Quackenbush, T. P. Barnwell, and M. A. Clements,
%	    Objective Measures of Speech Quality.  Prentice Hall
%	    Advanced Reference Series, Englewood Cliffs, NJ, 1988,
%	    ISBN: 0-13-629056-6.
%
%     [2] P. E. Papamichalis, Practical Approaches to Speech 
%	    Coding, Prentice-Hall, Englewood Cliffs, NJ, 1987.
%	    ISBN: 0-13-689019-9. (see pages 179-181).
%
%  Authors: Bryan L. Pellom and John H. L. Hansen (July 1998)
%  Modified by: Philipos C. Loizou  (Oct 2006)
%
% Copyright (c) 2006 by Philipos C. Loizou
% $Revision: 0.0 $  $Date: 10/09/2006 $
%-------------------------------------------------------------------------

if nargin ~=2
    fprintf('USAGE: [snr_mean, segsnr_mean]= comp_SNR(cleanFile, enhdFile) \n');
    return;
end   

[data1, Srate1, Nbits1]= wavread(cleanFile);
[data2, Srate2, Nbits2]= wavread(enhdFile);
if (( Srate1~= Srate2) | ( Nbits1~= Nbits2))
    error( 'The two files do not match!\n');
end
  
len= min( length( data1), length( data2));
data1= data1( 1: len);
data2= data2( 1: len);

[snr_dist, segsnr_dist, segsnr_dist2]= snr( data1, data2,Srate1);

snr_mean= snr_dist;
segsnr_mean= mean(segsnr_dist);
segsnr_mean2= mean(segsnr_dist2);


% =========================================================================


