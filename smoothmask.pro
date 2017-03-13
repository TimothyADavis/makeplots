function smoothmask,cube,clip,smoothrad,hann
	;;; Function to create a mask for use in the "masked moment" techique. 
	;;; It smooths the observed data cube spatially (by a factor SMOOTHRAD)
	;;; and spectrally (HANN) before clipping, in order to create a mask
	;;; slightly larger than the data which can help detect faint emission.
	;;; INPUTS:
	;;; CUBE - Observed datacube
	;;; Clip level - Clip level, in the native intensity units used in the cube 
	;;; Smoothrad in pixels
	;;; hann in channels
	;;; Returns a mask which is 1 everywhere inside the mask, and 0 outside.
	
	mask=SMOOTH(cube,[smoothrad,smoothrad,hann],/edge_trunc,/nan)
	mask[where(mask gt clip)]=1.0
	mask[where(mask ne 1.0)]=0.0
	return,mask
end