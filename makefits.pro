pro makefits,array,cubeheader,filename,whichmoment,clip=clip,vels=vels,phasecen=phasecen
	if  STRLOWCASE(whichmoment) eq "spec" then whichmoment=3
	if  STRLOWCASE(whichmoment) eq "pvd" then whichmoment=4
	
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
	if whichmoment eq 4 then begin
		make_coords,s,phasecen,cubeheader,x1,y1,v1
		MKHDR, newheader, array, /IMAGE
	    array*=dv
		sxaddpar,newheader,'BUNIT','Jy/beam.km/s'
		sxaddpar,newheader,'CTYPE1','OFFSET'
		sxaddpar,newheader,'CUNIT1','arcsec'
		sxaddpar,newheader,'CRVAL1',0.0
		sxaddpar,newheader,'CRPIX1',(where(x1 eq 0.0)+1)[0] ;; fits is 1 indexed
 	    sxaddpar,newheader,'CDELT1',x1[1]-x1[0]
		sxaddpar,newheader,'CTYPE2','VRAD'
		sxaddpar,newheader,'CUNIT2','km/s'
		sxaddpar,newheader,'CRVAL2',v1[0]
		sxaddpar,newheader,'CRPIX2',1 ;; fits is 1 indexed
 	    sxaddpar,newheader,'CDELT2',dv
		writefits,filename+"_PVD.fits",array,newheader
	endif
	
end