function ExampleIdx = SelectExample(Params, Examples)
% function ExampleIdx = SelectExample(Params, Examples)

% (c) M. Maggioni, M. Zhong

fprintf('\n Examples:\n');
for k = 1:length(Examples)
    fprintf('\n [%d] %s',k,Examples{k}.sys_info.name);
end
fprintf('\n\n');

while true
    if ~isfield(Params,'ExampleName')
        ExampleIdx          = input('Pick an example to run:           ');
        try
            fprintf('\nRunning %s',Examples{ExampleIdx}.sys_info.name);
            break;
        catch
        end
    end
end

return