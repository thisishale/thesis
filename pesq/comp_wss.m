function wss_dist= comp_wss(cleanFile, enhancedFile)
% ----------------------------------------------------------------------
%
%     Weighted Spectral Slope (WSS) Objective Speech Quality Measure
%
%     This function implements the Weighted Spectral Slope (WSS)
%     distance measure originally proposed in [1].  The algorithm
%     works by first decomposing the speech signal into a set of
%     frequency bands (this is done for both the test and reference
%     frame).  The intensities within each critical band are 
%     measured.  Then, a weighted distances between the measured
%     slopes of the log-critical band spectra are computed.  
%     This measure is also described in Section 2.2.9 (pages 56-58)
%     of [2].
%
%     Whereas Klatt's original measure used 36 critical-band 
%     filters to estimate the smoothed short-time spectrum, this
%     implementation considers a bank of 25 filters spanning 
%     the 4 kHz bandwidth.  
%
%   Usage:  wss_dist=comp_wss(cleanFile.wav, enhancedFile.wav)
%           
%         cleanFile.wav - clean input file in .wav format
%         enhancedFile  - enhanced output file in .wav format
%         wss_dist      - computed spectral slope distance
%
%  Example call:  ws =comp_wss('sp04.wav','enhanced.wav')
%
%  References:
%
%     [1] D. H. Klatt, "Prediction of Perceived Phonetic Distance
%	    from Critical-Band Spectra: A First Step", Proc. IEEE
%	    ICASSP'82, Volume 2, pp. 1278-1281, May, 1982.
%
%     [2] S. R. Quackenbush, T. P. Barnwell, and M. A. Clements,
%	    Objective Measures of Speech Quality.  Prentice Hall
%	    Advanced Reference Series, Englewood Cliffs, NJ, 1988,
%	    ISBN: 0-13-629056-6.
%
%  Authors: Bryan L. Pellom and John H. L. Hansen (July 1998)
%  Modified by: Philipos C. Loizou  (Oct 2006)
%
% Copyright (c) 2006 by Philipos C. Loizou
% $Revision: 0.0 $  $Date: 10/09/2006 $
%
% ----------------------------------------------------------------------
if nargin~=2
    fprintf('USAGE: WSS=comp_wss(cleanFile.wav, enhancedFile.wav)\n');
    fprintf('For more help, type: help comp_wss\n\n');
    return;
end

alpha= 0.95;

[data1, Srate1, Nbits1]= wavread(cleanFile);
[data2, Srate2, Nbits2]= wavread(enhancedFile);
if ( Srate1~= Srate2) || ( Nbits1~= Nbits2)
    error( 'The two files do not match!\n');
end

len= min( length( data1), length( data2));
data1= data1( 1: len)+eps;
data2= data2( 1: len)+eps;

wss_dist_vec= wss( data1, data2,Srate1);
wss_dist_vec= sort( wss_dist_vec);
wss_dist= mean( wss_dist_vec( 1: round( length( wss_dist_vec)*alpha)));



