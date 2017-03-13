pro starteps,file=file,eps=eps,xsize=xsize,ysize=ysize
 if not keyword_set(eps) then begin
   device, decomposed=0
   !p.thick=1
   !x.thick=1
   !y.thick=1
   !p.charthick=1
 endif else begin
   !p.thick=5
   !x.thick=5
   !y.thick=5
   !p.charthick=5
   set_plot, 'ps'
   if not keyword_set(file) then file="mk_mom0"
   if not keyword_set(xsize) then xsize=7.0
   if not keyword_set(ysize) then ysize=5.0
   file+=".eps"
  device, filename=file, /color, /encap, xsize=xsize, ysize=ysize ,/inches
 endelse
end
