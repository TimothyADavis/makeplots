

pro mk_chanmap,f,hdrs,rms,nplots,rmsfac=rmsfac,_extra=_extra,eps=eps,file=file,chans2do=chans2do,vsys=vsys,rev=rev,phasecen=phasecen
	
  starteps,file=file,eps=eps,xsize=16, ysize=10 ;;; plot to X window or EPS, depending on inputs
  
  cube=f
  s=size(cube)
	
  if not keyword_set(rmsfac) then rmsfac=3.
  cube[where(cube le rms*rmsfac)]=0.0
 
  if not keyword_set(chans2do) then chans2do=[0,s[3]-1]
  if not keyword_set(phasecen) then phasecen=[s[1]/2,s[2]/2]
  
  make_coords,s,phasecen,hdrs,x1,y1,v1
  
  plots2do=chans2do[1]-chans2do[0]+1
  gofromx=0.1+findgen(nplots[0]+1)*(0.9/(nplots[0]))
  gofromy=0.1+findgen(nplots[1]+1)*(0.9/(nplots[1]))

  xpos=gofromx[0:nplots[0]-1]
  ypos=reverse(gofromy[0:nplots[1]-1])
  
  dxp=gofromx[1]-gofromx[0]
  dyp=gofromy[1]-gofromy[0]
  
  !p.multi=[0,nplots[0],nplots[1]]
  var=[0,1]

  if keyword_set(rev) then begin
	v1=reverse(v1)
  endif 
	
  for i=chans2do[0],chans2do[1] do begin
     j=i-chans2do[0]
     if keyword_set(rev) then mom0=cube[*,*,chans2do[1]-(i-chans2do[0])] else  mom0=cube[*,*,i]
     cgloadct,0,/rev
     levels=rms*rmsfac + findgen(10.)*(max(mom0,/nan)-rms*rmsfac)/10.
	 xtickname=replicate(' ',10)
     ytickname=replicate(' ',10)
  
     if j mod nplots[0] eq 0 then ytickname=""
     if floor(j/nplots[0]) eq nplots[1]-1 then xtickname=""
	 if rms*rmsfac gt max(mom0,/nan) then begin
	 nodata=1
	 levels=[0,1]
	 endif else nodata=0
     cgloadct,0,/rev
	 
     contour,mom0,x1,x1,levels=levels,background=0,color=255,/fill,_extra=_extra,charsize=2.5,/xstyle,/ystyle,noclip=0,xtickname=xtickname,ytickname=ytickname,xmargin=[0,0],ymargin=[0,0],position=[xpos[j mod nplots[0]],ypos[floor(j/nplots[0])],xpos[j mod nplots[0]]+dxp,ypos[floor(j/nplots[0])]+dyp],nodata=nodata
      
	  
     clrlevels=10+findgen(abs(chans2do[1]-chans2do[0])+1)*(240./(abs(chans2do[1]-chans2do[0])+1))
	 sauron_colormap
     levels=rms*2.25 + findgen(3.)*(max(mom0,/nan)-rms*2.25)/3.
     contour,mom0,x1,x1,levels=levels[0],/fill,/overplot,_extra=_extra,color=clrlevels[j]
     cgloadct,0
     contour,mom0,x1,x1,levels=levels,color=0,/overplot,_extra=_extra,thick=1
     
     xyouts,!x.crange[0]+0.05*(!x.crange[1]-!x.crange[0]),!y.crange[1]*0.6,strcompress(string(v1[i],format='(I5)'),/rem),color=0,charsize=1.25,align=0.0

  endfor
  xyouts,0.5,0.05,'RA offset (")',color=0,charsize=1.5,/norm
  xyouts,0.05,0.5,'DEC offset (")',color=0,orient=90,charsize=1.5,/norm

  
 !p.multi=[0,1,1]
 endeps,eps=eps,file=file
end

