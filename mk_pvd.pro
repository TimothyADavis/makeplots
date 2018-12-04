


pro mk_pvd,f,hdrs,rms,posang,mask,rmsfac=rmsfac,_extra=_extra,dv=dv,vsys=vsys,eps=eps,file=file,phasecen=phasecen,dist=dist,bardist=bardist,kpc=kpc,chans2do=chans2do,xrange=xrange,vrange=vrange,pvdthick=pvdthick,fits=fits
  starteps,file=file,eps=eps,xsize=8, ysize=5 ;;; plot to X window or EPS, depending on inputs



  cube=f 
  s=size(cube)
	  
  if not keyword_set(pvdthick) then pvdthick=2.
  if not keyword_set(phasecen) then phasecen=[s[1]/2,s[2]/2]
  make_coords,s,phasecen,hdrs,x1,y1,v1
   
  cube*=mask
  
  if keyword_set(chans2do) then begin
  	cube=cube[*,*,chans2do[0]:chans2do[1]] 
   	v1=v1[chans2do[0]:chans2do[1]]
	s=size(cube)
  endif else begin
    chans2do=[0,0]
  endelse
   
  pvdcubedata=cube
  for i=0,s[3]-1 do pvdcubedata[*,*,i]=rot(cube[*,*,i],posang-90,/interp)
  pvddata=reform(total(pvdcubedata[*,(s[2]/2.)-pvdthick:(s[2]/2.)+pvdthick,*],2))

	     


   cgloadct,0
   contour,pvddata,x1,v1,levels=max(pvddata)*((findgen(9)+1)/10.),/xstyle,ystyle=9,xtitle='Position (")',ytitle="Velocity (km/s)",background=255,color=0,/cell_fill,xrange=xrange,yrange=vrange,/nodata,charsize=1.5,xmargin=[12,12]
   axis,yaxis=1,color=0,yrange=!y.crange-vsys,charsize=1.5,ytitle="Velocity (km/s)",/ystyle
   cgloadct,3,/rev,clip=[50,240]
   levs=max(pvddata)*[((((findgen(10)*10)+1)/100.))]
   contour,pvddata,x1,v1,levels=levs,/cell_fill,/overplot
   cgloadct,0
   contour,pvddata,x1,v1,levels=levs,/overplot,color=0


   if keyword_set(dist) then begin
   	  if NOT keyword_set(bardist) then bardist=(round((dist*4.84*(!x.crange[1]-!x.crange[0]))/(4.*5.))*5.);/(dist*4.84)
  	  bardist2=bardist/(dist*4.84)
	  ybarplace=(!y.crange[1]-!y.crange[0])*0.05
      oplot,[!x.crange[1]-1.5*bardist2,!x.crange[1]-0.5*bardist2],[!y.crange[0]+ybarplace,!y.crange[0]+ybarplace],color=0	
	  oplot,[!x.crange[1]-1.5*bardist2,!x.crange[1]-1.5*bardist2],[!y.crange[0]+0.9*ybarplace,!y.crange[0]+1.1*ybarplace],color=0
      oplot,[!x.crange[1]-0.5*bardist2,!x.crange[1]-0.5*bardist2],[!y.crange[0]+0.9*ybarplace,!y.crange[0]+1.1*ybarplace],color=0	 
      if keyword_set(kpc) then begin
   	      xyouts,!x.crange[1]-1.0*bardist2,!y.crange[0]+ybarplace*1.1,strcompress(string(bardist/1e3,format='(I10)'),/rem)+" kpc",ALIGNMENT=0.5,color=0 
   	  endif else xyouts,!x.crange[1]-1.0*bardist2,!y.crange[0]+ybarplace*1.1,strcompress(string(bardist,format='(I10)'),/rem)+" pc",ALIGNMENT=0.5,color=0
   endif

   al_legend,["PA: "+strcompress(round(posang),/rem)+cgSymbol('deg')],/bottom,/left,textcolor=0,box=0,charsize=1.5

   if keyword_set(fits) then makefits,pvddata,hdrs,fits,"pvd",phasecen=phasecen,chans2do=chans2do

   endeps,eps=eps,file=file
end