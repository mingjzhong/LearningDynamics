function states = get_states_Ck1Ck2(x, v, xi, k1, k2, agent_info)
% function states = get_states_Ck1Ck2(x, v, xi, k1, k2, agent_info)

% (C) M. Zhong

if ~isempty(x),  x_Ck1  = x(:,  agent_info.type_idx{k1}); else,  x_Ck1 = []; end
if ~isempty(x),  x_Ck2  = x(:,  agent_info.type_idx{k2}); else,  x_Ck2 = []; end
if ~isempty(v),  v_Ck1  = v(:,  agent_info.type_idx{k1}); else,  v_Ck1 = []; end
if ~isempty(v),  v_Ck2  = v(:,  agent_info.type_idx{k2}); else,  v_Ck2 = []; end     
if ~isempty(xi), xi_Ck1 = xi(:, agent_info.type_idx{k1}); else, xi_Ck1 = []; end
if ~isempty(xi), xi_Ck2 = xi(:, agent_info.type_idx{k2}); else, xi_Ck2 = []; end 
states          = cell(1, 2);
states{1}       = {x_Ck1, v_Ck1, xi_Ck1};
states{2}       = {x_Ck2, v_Ck2, xi_Ck2};
end