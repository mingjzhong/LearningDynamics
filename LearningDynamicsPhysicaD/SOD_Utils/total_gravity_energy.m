function [f, gradf] = total_gravity_energy(x, params, kind)
% function [f, gradf] = total_gravity_energy(x, params, kind)

% M. Zhong (JHU)

switch kind
  case 1
% check x
    if ~iscolumn(x), x = x'; end
% unpack x and prepare beta_1 and phi_vec   
    beta      = x(1);
    beta_vec  = beta * ones(size(params.Phi, 1), 1);
    phi_vec   = x(2 : end);
    the_mat   = params.Phi - beta_vec * phi_vec';
    f         = sum(sum(the_mat.^2 .* params.Rho));
    gradf     = -2 * [ones(1, size(params.Phi, 1)) * (the_mat .* params.Rho) * phi_vec; (the_mat .* params.Rho)' * beta_vec];
  case 2
% check x
    if ~iscolumn(x), x = x'; end
% unpack x, prepare (beta_2, \cdots, beta_N)
    beta_vec  = x;
    the_mat   = params.Phi - beta_vec * params.phi_vec';
    f         = sum(sum(the_mat.^2 .* params.Rho));
    gradf     = -2 * (the_mat .* params.Rho) * params.phi_vec;
  case 3
% check x
    if ~iscolumn(x), x = x'; end
% get the Phi/Rho matrices
    Phii1     = params.Phii1;
    Rhoi1     = params.Rhoi1;
    Phi1i     = params.Phi1i;
    Rho1i     = params.Rho1i;
    N         = size(Phii1, 1) + 1;
% unpack x, prepare (beat_1, \cdots, beta_N) and phi_vec
    beta1     = x(1);
    beta1_vec = beta1 * ones(N - 1, 1);
    beta2_vec = x(2 : N);
    phi_vec   = x(N + 1 : end);
    the_mat1  = Phii1 - beta1_vec * phi_vec';
    the_mat2  = Phi1i - beta2_vec * phi_vec';
    f         = sum(sum(the_mat1.^2 .* Rhoi1 + the_mat2.^2 .* Rho1i));
    gradf     = -2 * [ones(1, N - 1) * (the_mat1 .* Rhoi1) * phi_vec; (the_mat2 .* Rho1i) * phi_vec; (the_mat1 .* Rhoi1)' * beta1_vec + (the_mat2 .* Rho1i)' * beta2_vec];
  case 4
% check x
    if ~iscolumn(x), x = x'; end
% get the Phi/Rho matrices
    Phii1     = params.Phii1;
    Rhoi1     = params.Rhoi1;
    Phi1i     = params.Phi1i;
    Rho1i     = params.Rho1i;
    N         = size(Phii1, 1) + 1;
% unpack x, prepare (beat_1, \cdots, beta_N) and phi_vec
    beta1     = x(1);
    beta1_vec = beta1 * ones(N - 1, 1);
    beta2_vec = x(2 : N);
    phi_vec   = x(N + 1 : end);
    the_mat1  = Phii1 - beta1_vec * phi_vec';
    the_mat2  = Phi1i - beta2_vec * phi_vec';
    f         = max(max(sum(the_mat1.^2 .* Rhoi1, 2), sum(the_mat2.^2 .* Rho1i, 2)));
    gradf     = zeros(size(x));   
  case 5
% check x
    if ~iscolumn(x), x = x'; end
% get the Phi/Rho matrices
    Phii1     = params.Phii1;
    Rhoi1     = params.Rhoi1;
    Phi1i     = params.Phi1i;
    Rho1i     = params.Rho1i;
    N         = size(Phii1, 1) + 1;
% unpack x, prepare (beat_1, \cdots, beta_N) and phi_vec
    beta1     = x(1);
    beta1_vec = beta1 * ones(N - 1, 1);
    beta2_vec = x(2 : N);
    phi_vec   = x(N + 1 : end);
    the_mat1  = Phii1 - beta1_vec * phi_vec';
    the_mat2  = Phi1i - beta2_vec * phi_vec';
    f         = max(max(sum(abs(the_mat1) .* Rhoi1, 2), sum(abs(the_mat2) .* Rho1i, 2)));
    gradf     = zeros(size(x));    
  case 6
% check x
    if ~iscolumn(x), x = x'; end
% get the Phi/Rho matrices
    PhiMat    = params.PhiMat;
    RhoMat    = params.RhoMat;
    N         = size(PhiMat, 1);
    P         = size(PhiMat, 3);
% unpack x, prepare (beat_1, \cdots, beta_N) and phi_vec
    betas     = x(1 : N);
    phi_vec   = x(N + 1 : end);
    f         = 0;
    for ind = 1 : N - 1
      f              = f + sum(sum((squeeze(PhiMat(ind + 1 : N, ind, :)) - betas(ind) * ones(N - ind, 1) * phi_vec').^2 .* squeeze(RhoMat(ind + 1 : N, ind, :)) + ...
      (squeeze(PhiMat(ind, ind + 1 : N, :)) - betas(ind + 1 : N) * phi_vec').^2 .* squeeze(RhoMat(ind, ind + 1 : N, :))));
    end
    gradf            = zeros(N + P, 1);
    gradf(1)         = -2 * ones(1, N - 1) * ((squeeze(PhiMat(2 : N,     1, :)) - betas(1) * ones(N - 1, 1) * phi_vec') .* squeeze(RhoMat(2 : N,    1, :))) * phi_vec;
    gradf(N)         = -2 * ones(1, N - 1) * ((squeeze(PhiMat(1 : N - 1, N, :)) - betas(N) * ones(N - 1, 1) * phi_vec') .* squeeze(RhoMat(1 : N -1, N, :))) * phi_vec;
    for ind = 2 : N - 1
      gradf(ind)     = -2 * ones(1, N - 1) * ((squeeze(PhiMat([1 : ind - 1, ind + 1 : N], ind, :)) -  betas(ind) * ones(N - 1, 1) * phi_vec') ...
      .* squeeze(RhoMat([1 : ind - 1, ind + 1 : N], ind, :))) * phi_vec;
    end
    B_mat            = repmat(betas', [N, 1]);
    ind              = logical(eye(N));
    B_mat(ind)       = 0;
    for ind = 1 : P
      gradf(N + ind) = -2 * ones(1, N) * ((squeeze(PhiMat(:, :, ind)) - B_mat * phi_vec(ind)) .* squeeze(RhoMat(:, :, ind))) * betas;
    end
  otherwise
end
end