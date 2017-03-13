pro mk_spec,f,hdrs,rms,box=box,rmsfac=rmsfac,vsys=vsys,_extra=_extra,eps=eps,file=file,phasecen=phasecen,gal=gal,nsum=nsum,distance=distance,chans2do=chans2do
  starteps,file=file,eps=eps ;;; plot to X window or EPS, depending on inputs
  cgloadct,39
  if not keyword_set(rmsfac) then rmsfac=3.
  
  cube=f

  s=size(cube)
  if not keyword_set(phasecen) then phasecen=[s[1]/2,s[2]/2]
  make_coords,s,phasecen,hdrs,x1,y1,v1

  wx=where(x1 ge box[0] and x1 le box[1])
  wy=where(x1 ge box[2] and x1 le box[3])
  box=cube[wx[0]:wx[-1],wy[0]:wy[-1],*]
  spec=total(total(box,1,/nan),1,/nan)
  sbox=size(box)

  psf=psf_gaussian(Npixel=[sbox[1],sbox[2]],fwhm=[sxpar(hdrs,'bmaj')/sxpar(hdrs,'cdelt1'),sxpar(hdrs,'bmin')/sxpar(hdrs,'cdelt1')],NDIMEN=2,/double)

  if total(psf) eq 0 then begin
	psf=1e3
	ytitle="Flux Density (mJy/beam)"
  endif else ytitle="Flux (mJy)"
  

  
  vsysest=total(spec[chans2do[0]:chans2do[1]]*v1[chans2do[0]:chans2do[1]],/nan)/(total(spec[chans2do[0]:chans2do[1]],/nan))
  print,"vsys est:",vsysest
  if not keyword_set(vsys) then vsys=vsysest
  xrange=[-1000,1000]+vsys
  yrange=[min(spec/total(psf),/nan)-rms,max(spec/total(psf),/nan)+rms]*1e3

  plot,v1,spec/total(psf)*1e3,psym=10,color=0,background=255,charsize=1.5,xtitle="Velocity (km/s)",/xstyle,_extra=_extra,ytitle=ytitle,yrange=yrange,xrange=xrange,/ystyle,nsum=nsum
 
  endeps,eps=eps,file=file

  w=where(v1 ge min(v1[chans2do]) and v1 le max(v1[chans2do]))
  totflux=total((spec[w]/total(psf)))*abs(v1[1]-v1[0]);
  print,"Total flux:",totflux," Jy km/s"
  print,"Assuming you are observing CO(1-0):"
  print,"H2mass (Xco=3e20):",alog10(3.93e-17*3e20*(distance^2)*total(totflux))," Msun
  
end