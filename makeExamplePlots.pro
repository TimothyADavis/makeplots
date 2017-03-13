pro makeExamplePlots,eps=eps

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	gal=  'NGC4710'				    ;;; name of your object - for output files
	file= "NGC4710cube.fits"	    ;;; path to your observed datacube
	
	distance=16.5					;;; Distance to your object in Mpc - for scale bars
	bardist=2000					;;; Size of the scale bars, in PARSECS
	kpc=1							;;; Flag for units in the scale bar - kpc=1 --> kiloparsecs, kpc=0 --> parsecs
	
	vsys=1102.						;;; Systemic velocity of your object, in km/s
	posang=207.						;;; Position angle of the major axis, in degrees
	
	phasecen=[65.,64.]				;;; Phase Centre of your Cube in PIXELS. The place to call 0,0
	imageSize=50					;;; How big the area you wish to image is in PIXELS around your phasecentre
	chans2do=[1,42]					;;; Which channel range contains flux from your object? [startChan, endChan]
	chanmapsize=[6,7]				;;; How many plots you want in your channel maps in the X and Y directions. Needs to be large enough to fit them all in!
		

	specbox=[-20,20,-30,30]			;;; How big an area to include when creating your spectrum in ARCSECONDS [xmin,xmax,ymin,ymax]
	vrange=[[-500,500]]+vsys        ;;; Velocity range to plot in your spectrum
	
	maxsigma=0						;;; Clip the moment two display to some maximum value, to avoid noise peaks creating range issues.
	log=0							;;; Flag for plotting the moment zero with a logarithmic scale. True = log it, False =dont
	pvdthick=2.						;;; How thick a cut to make when creating the PVD in PIXELS. Usually pick at least one beam width.
	
	rmsfac=1.5						;;; RMS clip to apply in the SMOOTH MASK. 
	
	outputfits=0					;;; Output FITS files of the produced moments? True=yes, False=no
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	makeplots,gal,file,phasecen,imageSize,chans2do,distance,rmsfac,vsys,specbox,posang,eps=eps,bardist=bardist,chanmapsize=chanmapsize,vrange=vrange,maxsigma=maxsigma,log=log,kpc=kpc,pvdthick=pvdthick,outputfits=outputfits
	
end