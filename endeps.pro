pro endeps,eps=eps,file=file
  if keyword_set(eps) then begin
   device, /close
   set_plot, 'x'
  endif
end