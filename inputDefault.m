function res = inputDefault(str,val)
  % INPUTDEFAULT allows for default values over standard input command
  %  RES = inputDefault(STR, VAL)
  %       STR Message to display to user with (VAL) added
  %       VAL Default value if input is empty (auto-detects numeric values)
  %  Output:
  %       RES will use numeric type if VAL is numeric
  %
  % Copyright (C) 2014 Alex J. Grede
  % GPL v3, See LICENSE.txt for details
  % This function is part of Simple Diode Fitting (https://github.com/agrede/simple-diode-fitting)

  if (isnumeric(val))
    sval = num2str(val);
  elseif isprint(val)
    sval = val;
  else
    sval = '';
  end
  res = input(strcat(str,' (', sval, ') '));
  if isempty(res)
     res = val;
  end
end
