function delete_the_file(m, learn_info)
% function delete_the_file(m, learn_info)

% (C) M. Zhong

file_name = sprintf(learn_info.pd_file_form, learn_info.temp_dir, learn_info.sys_info.name, ...
            learn_info.time_stamp, m);
delete(file_name);
end