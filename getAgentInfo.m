function agents_info = getAgentInfo( sys_info )

agents_info.idxs             = cell(1, sys_info.K);
agents_info.num_agents       = zeros(1, sys_info.K);
for k = 1:sys_info.K
  agents_info.idxs{k}        = find( sys_info.type_info==k );
  agents_info.num_agents(k)  = length( agents_info.idxs{k} );
end
end