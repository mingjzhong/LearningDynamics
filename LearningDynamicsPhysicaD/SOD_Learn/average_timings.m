function timing_struct2 = average_timings(timing_struct1, M)
% function timing_struct2 = average_timings(timing_struct1, M)

% (C) M. Zhong

timing_struct2.assemble_rhs                 = timing_struct1.assemble_rhs/M;
timing_struct2.assemble_the_learning_matrix = timing_struct1.assemble_the_learning_matrix/M;
timing_struct2.assemble_the_rhoLTM          = timing_struct1.assemble_the_rhoLTM/M;
end