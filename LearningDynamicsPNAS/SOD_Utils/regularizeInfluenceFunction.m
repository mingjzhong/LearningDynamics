function [f_reg, basis] = regularizeInfluenceFunction( phi, basis, rhoLTemp, sys_info )

for k_1 = sys_info.K:-1:1
    for k_2 = sys_info.K:-1:1
        basis{k_1,k_2}.supp         = getFcnSupp( phi{k_1,k_2}, basis{k_1,k_2}.knots );        
        basis{k_1,k_2}.interval     = intersectInterval( basis{k_1,k_2}.supp, rhoLTemp.supp{k_1,k_2} );
        if basis{k_1,k_2}.interval(2)-basis{k_1,k_2}.interval(1)>0
            f_reg{k_1,k_2}  = simplifyfcn( phi{k_1,k_2}, basis{k_1,k_2}.knots, basis{k_1,k_2}.interval, basis{k_1,k_2}.degree );
        else
            f_reg{k_1,k_2}  = phi{k_1,k_2};
        end        
    end
end


return