
function dy =RHS_NN(net,x)

if size(x,1)~=net.inputs{1}.size
    
    msg = 'the size of input is not correct!';
    error(msg)
end

dy =net(x);




end
