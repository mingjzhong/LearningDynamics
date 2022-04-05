function prob = get_probability_from_rhoLT_on_subInt(rhoLT, subInt)
% function prob = get_probability_from_rhoLT_on_subInt(rhoLT, subInt)

% (C) M. Zhong

relsol         = 2000;
r_ctrs         = get_centers_from_supp(intersectInterval(rhoLT.supp(1, :), subInt(1, :)), relsol);
h_r            = r_ctrs(2) - r_ctrs(1); 
switch rhoLT.dim
  case 1
    prob       = sum(rhoLT.dense(r_ctrs)) * h_r;
  case 2
    switch size(subInt, 1)
      case 1
        s_ctrs = get_centers_from_supp(rhoLT.supp(2, :), relsol);
        h_s    = s_ctrs(2) - s_ctrs(1);        
      case 2
        s_ctrs = get_centers_from_supp(intersectInterval(rhoLT.supp(2, :), subInt(2, :)), relsol);
        h_s    = s_ctrs(2) - s_ctrs(1);             
    end
    [R, S]     = ndgrid(r_ctrs, s_ctrs);
    prob       = sum(sum(rhoLT.dense(R, S))) * h_r * h_s;
  case 3
    switch size(subInt, 1)
      case 1
        s_ctrs = get_centers_from_supp(rhoLT.supp(2, :), relsol);
        h_s    = s_ctrs(2) - s_ctrs(1);  
        z_ctrs = get_centers_from_supp(rhoLT.supp(3, :), relsol);
        h_z    = z_ctrs(2) - z_ctrs(1);
      case 2
        s_ctrs = get_centers_from_supp(intersectInterval(rhoLT.supp(2, :), subInt(2, :)), relsol);
        h_s    = s_ctrs(2) - s_ctrs(1);
        z_ctrs = get_centers_from_supp(rhoLT.supp(3, :), relsol);
        h_z    = z_ctrs(2) - z_ctrs(1);
      case 3
        s_ctrs = get_centers_from_supp(intersectInterval(rhoLT.supp(2, :), subInt(2, :)), relsol);
        h_s    = s_ctrs(2) - s_ctrs(1);
        z_ctrs = get_centers_from_supp(intersectInterval(rhoLT.supp(3, :), subInt(3, :)), relsol);
        h_z    = z_ctrs(2) - z_ctrs(1);        
    end
    [R, S, Z]  = ndgrid(r_ctrs, s_ctrs, z_ctrs);
    prob       = sum(sum(sum(rhoLT.dense(R, S, Z)))) * h_r * h_s * h_z;  
  otherwise
    error('');
end
end