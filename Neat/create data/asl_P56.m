function [asl_ms, asl, c0]= asl_P56 ( x, fs, nbits)
% this implements ITU P.56 method B. 
% 'speechfile' is the speech file to calculate active speech level for,
% 'asl' is the active speech level (between 0 and 1),
% 'asl_rms' is the active speech level mean square energy.

% x is the column vector of floating point speech data

x= x(:); % make sure x is column vector
T= 0.03; % time constant of smoothing, in seconds
H= 0.2; % hangover time in seconds
M= 15.9; 
% margin in dB of the difference between threshold and active speech level
thres_no= nbits- 1; % number of thresholds, for 16 bit, it's 15

I= ceil( fs* H); % hangover in samples
g= exp( -1/( fs* T)); % smoothing factor in envelop detection
c( 1: thres_no)= 2.^ (-15: thres_no- 16); 
% vector with thresholds from one quantizing level up to half the maximum
% code, at a step of 2, in the case of 16bit samples, from 2^-15 to 0.5; 
a( 1: thres_no)= 0; % activity counter for each level threshold
hang( 1: thres_no)= I; % hangover counter for each level threshold

sq= x'* x; % long-term level square energy of x
x_len= length( x); % length of x

% use a 2nd order IIR filter to detect the envelope q
x_abs= abs( x); 
p= filter( 1-g, [1 -g], x_abs); 
q= filter( 1-g, [1 -g], p);

for k= 1: x_len
    for j= 1: thres_no
        if (q(k)>= c(j))
            a(j)= a(j)+ 1;
            hang(j)= 0;
        elseif (hang(j)< I)
            a(j)= a(j)+ 1;
            hang(j)= hang(j)+ 1;
        else
            break;
        end
    end
end

asl= 0; 
asl_rms= 0; 
if (a(1)== 0)
    return;
else
    AdB1= 10* log10( sq/ a(1)+ eps);
end

CdB1= 20* log10( c(1)+ eps);
if (AdB1- CdB1< M)
    return;
end

AdB(1)= AdB1; 
CdB(1)= CdB1;
Delta(1)= AdB1- CdB1;

for j= 2: thres_no
    AdB(j)= 10* log10( sq/ (a(j)+ eps)+ eps);
    CdB(j)= 20* log10( c(j)+ eps);
end

for j= 2: thres_no    
    if (a(j) ~= 0)       
        Delta(j)= AdB(j)- CdB(j);        
        if (Delta(j)<= M) 
            % interpolate to find the asl
            [asl_ms_log, cl0]= bin_interp( AdB(j), ...
                AdB(j-1), CdB(j), CdB(j-1), M, 0.5);
            asl_ms= 10^ (asl_ms_log/ 10);
            asl= (sq/ x_len)/ asl_ms;  
            c0= 10^( cl0/ 20);            
            break;
        end        
    end
end
end
