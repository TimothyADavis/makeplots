pro makefits,array,cubeheader_sav,filename,whichmoment,clip=clip,vels=vels,phasecen=phasecen,chans2do=chans2do
	cubeheader=cubeheader_sav
	if  STRLOWCASE(whichmoment) eq "spec" then whichmoment=3
	if  STRLOWCASE(whichmoment) eq "pvd" then whichmoment=4
	
	
	if not keyword_set(phasecen) then phasecen=[sxpar(cubeheader,'NAXIS1')/2,sxpar(cubeheader,'NAXIS1')/2]
	make_coords,[3,sxpar(cubeheader,'NAXIS1'),sxpar(cubeheader,'NAXIS2'),sxpar(cubeheader,'NAXIS3')],phasecen,cubeheader,x1,y1,v1
    if keyword_set(chans2do) then v1=v1[chans2do[0]:chans2do[1]]
  	
	
	
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