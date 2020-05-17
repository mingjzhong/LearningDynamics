function f_simple = simplifyfcn_old(f, knots, degree)
% function f_simple = simplifyfcn_old(f, knots, degree)

% (C) M. Maggionoi (JHU)

interpts_sub    = interpts( interpts>=interval(1) & interpts<=interval(2) );
evalpts         = (interpts_sub(1:end-1)+interpts_sub(2:end))/2;                                    
% evalpts        = sort([(0.75*edgepoints_sub(1:end-1)+0.25*edgepoints_sub(2:end)),
%               (0.25*edgepoints_sub(1:end-1)+0.75*edgepoints_sub(2:end))]);

try
    if degree==0
        f_simple = griddedInterpolant(evalpts,f(evalpts),'linear','nearest');
    else
        f_simple = griddedInterpolant(evalpts,f(evalpts),'linear','linear');
    end
catch
    f_simple = f;
end

return