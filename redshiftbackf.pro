function redshiftbackf,freq,freqRED
;   vel = double(-1.)*double(3e8)*(double(1.0)-(double(freq)/double(freqRED)))
;print,"using radio definition"

vel = double(299792458)*((double(freq)-double(freqRED))/double(freq))

   return, vel
end
