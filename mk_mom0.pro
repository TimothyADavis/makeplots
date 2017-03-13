pro mk_mom0,f,hdrs,rms,mask,rmsfac=rmsfac,_extra=_extra,eps=eps,file=file,phasecen=phasecen,dist=dist,bardist=bardist,kpc=kpc,chans2do=chans2do,log=log,fits=fits
  ;;; Make moment zero (integrated intensity)  
  starteps,file=file,eps=eps ;;; plot to X window or EPS, depending on inputs
  
  cube=f ;;; Copy input file (so changes dont cause issues)
 
  cube*=mask
  
  ;;;; If you want to clip the cube region to consider, do this here

  if keyword_set(chans2do) then begin
   cube=cube[*,*,chans2do[0]:chans2do[1]] 
  endif else begin
   chans2do=[0,0]
  endelse
    
  ;;; Create zeorth moment!
  mom0=total(cube,3)

  
  ;;; Create X-Y vectors
  s=size(mom0)
  if not keyword_set(phasecen) then phasecen=[s[1]/2,s[2]/2]
  make_coords,s,phasecen,hdrs,x1,y1,v1
  
  ;; Log if required
  if keyword_set(log) then begin
	mom0=alog10(mom0)
    levels=alog10(rms*rmsfac) + findgen(20.)*(max(mom0,/nan)-alog10(rms*rmsfac))/20.
  endif else  levels=rms*rmsfac + findgen(20.)*(max(mom0,/nan)-(rms*rmsfac))/20.
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Do Plotting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  cgloadct,3,/rev ;;; Load colour table
  contour,mom0,x1,y1,levels=levels,background=0,color=255,/fill,/nodata,/iso,_extra=_extra,charsize=1.5,xtitle='RA offset (")',ytitle='DEC offset (")',/xstyle,/ystyle
  cgloadct,3,/rev,clip=[30,230]
  contour,mom0,x1,y1,levels=levels,background=0,color=255,/cell_fill,/overplot,_extra=_extra
  cgloadct,0
  ellipse, 0.5*sxpar(hdrs,'bmaj')*3600., 0.5*sxpar(hdrs,'bmin')*3600., sxpar(hdrs,'bpa')+90, 0,360, !x.crange[0]+(sxpar(hdrs,'bmaj')*3600.*0.85), !y.crange[0]+(sxpar(hdrs,'bmaj')*3600.*0.85),color=0 ;;; Plot beam
  
   ;;; make distbar 
  if keyword_set(dist) then begin
	if NOT keyword_set(bardist) then 	bardist=(round((dist*4.84*(!x.crange[1]-!x.crange[0]))/(4.*5.))*5.);/(dist*4.84)
	bardist2=bardist/(dist*4.84)
  	oplot,[!x.crange[1]-1.5*bardist2,!x.crange[1]-0.5*bardist2],[!y.crange[0]+0.25*bardist2,!y.crange[0]+0.25*bardist2],color=0	
  	oplot,[!x.crange[1]-1.5*bardist2,!x.crange[1]-1.5*bardist2],[!y.crange[0]+0.9*0.25*bardist2,!y.crange[0]+1.1*0.25*bardist2],color=0
    oplot,[!x.crange[1]-0.5*bardist2,!x.crange[1]-0.5*bardist2],[!y.crange[0]+0.9*0.25*bardist2,!y.crange[0]+1.1*0.25*bardist2],color=0	 	
  if keyword_set(kpc) then begin
	 xyouts,!x.crange[1]-1.0*bardist2,!y.crange[0]+0.3*bardist2,strcompress(string(bardist/1e3,format='(I10)'),/rem)+" kpc",ALIGNMENT=0.5,color=0 
	 endif else xyouts,!x.crange[1]-1.0*bardist2,!y.crange[0]+0.3*bardist2,strcompress(string(bardist,format='(I10)'),/rem)+" pc",ALIGNMENT=0.5,color=0
  endif	
  axis,xaxis=0,color=0,/xstyle,xrange=!x.crange,xtickname=replicate(' ',10)
  axis,xaxis=1,color=0,/xstyle,xrange=!x.crange,xtickname=replicate(' ',10)
  axis,yaxis=0,color=0,/ystyle,yrange=!y.crange,ytickname=replicate(' ',10)
  axis,yaxis=1,color=0,/ystyle,yrange=!y.crange,ytickname=replicate(' ',10)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  endeps,eps=eps,file=file

  if keyword_set(log) then mom0=10^mom0
  if keyword_set(fits) then makefits,mom0,hdrs,fits,0,clip=rms*rmsfac
end