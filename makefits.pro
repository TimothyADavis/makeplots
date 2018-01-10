pro makefits,array,cubeheader,filename,whichmoment,clip=clip,vels=vels
	if  STRLOWCASE(whichmoment) eq "spec" then whichmoment=3
	s=size(array)
    v1=((findgen(s[3])-sxpar(cubeheader,'crpix3'))*(sxpar(cubeheader,'cdelt3'))) + sxpar(cubeheader,'crval3')
    if v1[0] gt 1e9 then v1=(redshiftbackf(sxpar(cubeheader,'RESTFRQ'),v1)) 
    v1/=1e3
	dv=abs(v1[1]-v1[0])
	if whichmoment eq 0 then begin
	    array*=dv
		sxaddpar,cubeheader,'BUNIT','Jy/beam.km/s' 
		if keyword_set(clip) then sxaddpar,cubeheader,'MOMCLIP',clip*dv,'Jy/beam.km/s'
		writefits,filename+"_mom0.fits",array,cubeheader		
	endif
	if whichmoment eq 1 then begin
		sxaddpar,cubeheader,'BUNIT','km/s' 
		if keyword_set(clip) then sxaddpar,cubeheader,'MOMCLIP',clip,'Jy/beam'
		writefits,filename+"_mom1.fits",array,cubeheader		
	endif
	if whichmoment eq 2 then begin
		sxaddpar,cubeheader,'BUNIT','km/s' 
		if keyword_set(clip) then sxaddpar,cubeheader,'MOMCLIP',clip,'Jy/beam'
		writefits,filename+"_mom2.fits",array,cubeheader
	endif
	if whichmoment eq 3 then begin
		fname=filename+"_spectrum.txt"
		write_csv,fname,vels,array,header=["Velocity (km/s)","Flux Density (Jy)"]
	endif
	
end