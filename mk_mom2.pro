

pro mk_mom2,f,hdrs,rms,mask,rmsfac=rmsfac,_extra=_extra,dv=dv,vsys=vsys,eps=eps,file=file,phasecen=phasecen,dist=dist,bardist=bardist,kpc=kpc,chans2do=chans2do,maxsigma=maxsigma,fits=fits
  
  starteps,file=file,eps=eps ;;; plot to X window or EPS, depending on inputs

  cube=f	  
  s=size(f)
  if not keyword_set(phasecen) then phasecen=[s[1]/2,s[2]/2]
  make_coords,s,phasecen,hdrs,x1,y1,v1
  
  cube*=mask
  
  if keyword_set(chans2do) then begin
     cube=cube[*,*,chans2do[0]:chans2do[1]] 
     v1=v1[chans2do[0]:chans2do[1]]
  endif else begin
     chans2do=[0,0]
  endelse
 
  if v1[0] gt v1[-1] then v1=reverse(v1)

  
  mom1=fltarr(s[1],s[2])*!VALUES.F_NAN
  mom2=mom1
  for i=0,s[1]-1 do begin
        for j=0,s[2]-1 do begin
			if total(cube[i,j,*],/nan) gt 0 then begin
          	 mom1[i,j]=total(cube[i,j,*]*v1,/nan)/(total(cube[i,j,*],/nan))
			 mom2[i,j]=sqrt(total(cube[i,j,*]*((v1-mom1[i,j])^2),/nan)/(total(cube[i,j,*],/nan)))
			endif
        endfor
  endfor
  
 

  if not keyword_set(vsys) then vsys=0.0
 
 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Do Plotting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  if not keyword_set(maxsigma) then maxsigma=max(mom2,/nan)
  levs2do=findgen(21)*(maxsigma/20.)
  cgloadct,0
  contour,mom2,x1,y1,levels=levs2do,background=255,color=0,/fill,/nodata,/iso,_extra=_extra,charsize=1.5,xtitle='RA offset (")',ytitle='DEC offset (")',/xstyle,/ystyle
  sauron_colormap
  contour,mom2,x1,y1,levels=levs2do,/cell_fill,/overplot ;,_extra=_extra
  cgloadct,0
  ellipse, 0.5*sxpar(hdrs,'bmaj')*3600., 0.5*sxpar(hdrs,'bmin')*3600., sxpar(hdrs,'bpa')+90, 0,360, !x.crange[0]+(sxpar(hdrs,'bmaj')*3600.*0.65), !y.crange[0]+(sxpar(hdrs,'bmaj')*3600.*0.65),color=0
  sauron_colormap
  cgCOLORBAR,/right,/vert,color=0,divisions=nlevs,range=[0,maxsigma],title="Vel. Disp. (km/s)",charsize=1.5, POSITION=[!x.window[1]+0.02, !y.window[0], !x.window[1]+0.07,!y.window[1]],/norm
   

  if keyword_set(dist) then begin
    	if NOT keyword_set(bardist) then bardist=(round((dist*4.84*(!x.crange[1]-!x.crange[0]))/(4.*5.))*5.)
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
   
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End Plotting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   
   
  endeps,eps=eps,file=file
  if keyword_set(fits) then makefits,mom2,hdrs,fits,2
end