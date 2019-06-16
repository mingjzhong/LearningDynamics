function ExampleIdx = SelectExample(Params, Examples)
% function ExampleIdx = SelectExample(Params, Examples)

% (c) M. Maggioni, M. Zhong

while true
  if ~isfield(Params,'ExampleName')
    fprintf('\n Examples:\n');
    for k = 1:length(Examples)
      fprintf('\n [%2d] %s',k,Examples{k}.sys_info.name);
    end
    fprintf('\n\n');    
    ExampleIdx = input('Pick an example to run:           ');
    try
      fprintf('\nRunning %s\n',Examples{ExampleIdx}.sys_info.name);
      break;
    catch
    end
  else
    ExampleIdx  = find(cellfun(@(x) strcmp(x.sys_info.name, Params.ExampleName), Examples));
    if isempty(ExampleIdx)
      error('SOD_Utils:SelectExample:exception', 'ExampleName in Params has no matching entry in all the pre-set examples!!');
    else
      fprintf('\nRunning %s\n', Examples{ExampleIdx}.sys_info.name);
      break;
    end
  end
end

return