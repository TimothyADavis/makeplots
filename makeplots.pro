pro plot_helpers,specbox,pvdthick,hdr,posang
	oplot,specbox[0:1],[specbox[2],specbox[2]],color=0
	oplot,specbox[0:1],[specbox[3],specbox[3]],color=0
	oplot,[specbox[0],specbox[0]],specbox[2:3],color=0
	oplot,[specbox[1],specbox[1]],specbox[2:3],color=0
    ypv=!y.crange
    xpv=[0,0]+(pvdthick*abs(sxpar(hdr,'cdelt1')*3600.))
    xpv2=[0,0]-(pvdthick*abs(sxpar(hdr,'cdelt1')*3600.))
    ang=(-1)*posang
    c = cos((ang)/!radeg)
    s = sin((ang)/!radeg)
    x2 =  c*xpv + s*ypv
    y2 = -s*xpv + c*ypv
    x3 =  c*xpv2 + s*ypv
    y3 = -s*xpv2 + c*ypv
    oplot,x2,y2,color=0
    oplot,x3,y3,color=0
    oplot,[0],[0],psym=1,color=0
end

pro makeplots,gal,file,phasecen,imageSize,chans2do,distance,rmsfac,vsys,specbox,posang,xrange=xrange,yrange=yrange,bardist=bardist,kpc=kpc,eps=eps,vrange=vrange,chanmapsize=chanmapsize,nsum=nsum,pvdthick=pvdthick,log=log,maxsigma=maxsigma,outputfits=outputfits
	
  if not keyword_set(bardist) then bardist=1000.
  if not keyword_set(pvdthick) then pvdthick=2.
  fdata=readfits(file,hdr)	
  s=size(fdata)
  halfsize=imageSize/2.
  if keyword_set(outputfits) then fits=gal
  
  
  HEXTRACTCUBE, fdata, hdr, fnew, newhdr, phasecen[0]-halfsize, phasecen[0]+halfsize,phasecen[1]-halfsize,phasecen[1]+halfsize, /SILENT
  
  phasecen=[halfsize,halfsize] ;;; Now the phasecen is the centre by construction
  fdata=fnew
  hdr=newhdr
  s=size(fdata)
  
  RMS=robust_sigma(fdata[*,*,(chans2do[0]-2)>0:chans2do[0]])
  print,"RMS is",RMS/1e-3,"mJy"
  s=size(fdata)
  
  mask=smoothmask(fdata,rms*rmsfac,1.5*abs(sxpar(hdr,'bmaj')/sxpar(hdr,'cdelt1')),4.0)

  mk_mom0,fdata,hdr,rms,mask,rmsfac=rmsfac,xrange=xrange,yrange=yrange,file=gal+"_mom0",eps=eps,phasecen=phasecen,dist=distance,bardist=bardist,kpc=kpc,log=log,fits=fits,chans2do=chans2do



  meep=""
  if not keyword_set(eps) then read,meep


  mk_mom1,fdata,hdr,rms,mask,rmsfac=rmsfac,xrange=xrange,yrange=yrange,dv=dv,file=gal+"_mom1",eps=eps,phasecen=phasecen,dist=distance,bardist=bardist,kpc=kpc,vsys=vsys,chans2do=chans2do,fits=fits

  if not keyword_set(eps) then plot_helpers,specbox,pvdthick,hdr,posang

  meep=""
  if not keyword_set(eps) then read,meep

  mk_mom2,fdata,hdr,rms,mask,rmsfac=rmsfac,xrange=xrange,yrange=yrange,dv=dv,file=gal+"_mom2",eps=eps,phasecen=phasecen,dist=distance,bardist=bardist,kpc=kpc,vsys=vsys,chans2do=chans2do,maxsigma=maxsigma,fits=fits

  meep=""
  if not keyword_set(eps) then read,meep


  mk_spec,fdata,hdr,rms,rmsfac=0.0001,vsys=vsys,file=gal+"_spec",eps=eps,box=specbox,phasecen=phasecen,/ystyle,gal=gal,chans2do=chans2do,xrange=vrange,nsum=nsum,dist=distance

  meep=""
  if not keyword_set(eps) then read,meep

  mk_pvd,fdata,hdr,rms,posang,mask,rmsfac=rmsfac,vsys=vsys,chans2do=[(chans2do[0]-10)>0 ,(chans2do[1]+10)<s[3]-1],phasecen=[halfsize,halfsize],dist=distance,bardist=bardist,kpc=kpc,eps=eps,file=gal+"_PVD",xrange=xrange,specialclip=specialclip,pvdthick=pvdthick
  
  meep=""
  if not keyword_set(eps) then read,meep
  
  if not keyword_set(chanmapsize) then chanmapsize=[ceil(sqrt(chans2do[1]-chans2do[0])),ceil(sqrt(chans2do[1]-chans2do[0]))]
  mk_chanmap,fdata,hdr,rms,chanmapsize,rmsfac=rmsfac,xrange=xrange,yrange=yrange,file=gal+"chanmap",eps=eps,vsys=vsys,chans2do=chans2do,phasecen=phasecen,rev=rev


end
