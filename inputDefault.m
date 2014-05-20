function res = inputDefault(str,val)

  if (isnumeric(val))
    sval = num2str(val);
  elseif isprint(val)
    sval = val;
  else
    sval = '';
  endif
  res = input(strcat(str,' (', sval, ') '));
  if isempty(res)
     res = val;
  endif
endfunction
