pro make_coords,s,phasecen,hdrs,x1,y1,v1
  x1=(findgen(s[1])-phasecen[0])*abs(sxpar(hdrs,'cdelt1')*3600.)
  y1=(findgen(s[2])-phasecen[1])*abs(sxpar(hdrs,'cdelt2')*3600.)
  v1=((findgen(s[3])-sxpar(hdrs,'crpix3'))*(sxpar(hdrs,'cdelt3'))) + sxpar(hdrs,'crval3')
  if v1[0] gt 1e9 then v1=(redshiftbackf(sxpar(hdrs,'RESTFRQ'),v1)) 
  v1/=1e3 
end