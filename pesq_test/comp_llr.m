function llr_mean= comp_llr(cleanFile, enhancedFile);

% ----------------------------------------------------------------------
%
%      Log Likelihood Ratio (LLR) Objective Speech Quality Measure
%
%
%     This function implements the Log Likelihood Ratio Measure
%     defined on page 48 of [1] (see Equation 2.18).
%
%   Usage:  llr=comp_llr(cleanFile.wav, enhancedFile.wav)
%           
%         cleanFile.wav - clean input file in .wav format
%         enhancedFile  - enhanced output file in .wav format
%         llr           - computed likelihood ratio
%
%         Note that the LLR measure is limited in the range [0, 2].
%
%  Example call:  llr =comp_llr('sp04.wav','enhanced.wav')
%
%
%  References:
%
%     [1] S. R. Quackenbush, T. P. Barnwell, and M. A. Clements,
%	    Objective Measures of Speech Quality.  Prentice Hall
%	    Advanced Reference Series, Englewood Cliffs, NJ, 1988,
%	    ISBN: 0-13-629056-6.
%
%  Authors: Bryan L. Pellom and John H. L. Hansen (July 1998)
%  Modified by: Philipos C. Loizou  (Oct 2006) - limited LLR to be in [0,2]
%
% Copyright (c) 2006 by Philipos C. Loizou
% $Revision: 0.0 $  $Date: 10/09/2006 $
% ----------------------------------------------------------------------

if nargin~=2
    fprintf('USAGE: LLR=comp_llr(cleanFile.wav, enhancedFile.wav)\n');
    fprintf('For more help, type: help comp_llr\n\n');
    return;
end

alpha=0.95;
[data1, Srate1, Nbits1]= wavread(cleanFile);
[data2, Srate2, Nbits2]= wavread(enhancedFile);
if ( Srate1~= Srate2) | ( Nbits1~= Nbits2)
    error( 'The two files do not match!\n');
end
    
len= min( length( data1), length( data2));
data1= data1( 1: len)+eps;
data2= data2( 1: len)+eps;

IS_dist= llr( data1, data2,Srate1);

IS_len= round( length( IS_dist)* alpha);
IS= sort( IS_dist);

llr_mean= mean( IS( 1: IS_len));






