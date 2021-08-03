function trajErr = clean_up_memory_for_trajErr(trajErr_old)
% function trajErr = clean_up_memory_for_trajErr(trajErr_old)

% (C) M. Zhong 

if ~isempty(trajErr_old)
  % save the output in trajErr
  trajErr.Timings.TrueKernelTrainICs = trajErr_old.Timings.TrueKernelTrainICs;
  trajErr.Timings.EstKernelTrainICs  = trajErr_old.Timings.EstKernelTrainICs;
  trajErr.Timings.TrajNorm           = trajErr_old.Timings.TrajNorm;
  trajErr.sup                        = trajErr_old.sup;
  trajErr.sup_mid                    = trajErr_old.sup_mid;
  trajErr.sup_fut                    = trajErr_old.sup_fut;
  trajErr.time_vec                   = trajErr_old.time_vec;
  trajErr.time_vec_mid               = trajErr_old.time_vec_mid;
  trajErr.time_vec_fut               = trajErr_old.time_vec_fut;
  trajErr.y_init                     = trajErr_old.y_init;
else
  trajErr                            = [];
end
end