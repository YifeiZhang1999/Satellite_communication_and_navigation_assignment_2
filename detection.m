function [Updated_mat, Detect_results] = detection(y, W, G, Nr_sat, allSettings, isolation_mat)
    P_fa = 1e-2;

    if nargin == 5
        isolation_mat = ones(Nr_sat, 1);
    end


    y = isolation_mat .* y;
    W = W * diag(isolation_mat);
    G = diag(isolation_mat) * G;

    K = inv(G'*W*G)*G'*W;
    P = G*K;

    I = eye(Nr_sat);   
    I = I * diag(isolation_mat);

    Updated_mat.W = W;
    Updated_mat.G = G;

    Thres = sqrt(chi2inv(1-P_fa, sum(isolation_mat)-4));
    if allSettings.sys.raim_type == 0  
        WSSE_sqrt = sqrt(y'*W*(I-P)*y ./ (sum(isolation_mat)-4));
    elseif allSettings.sys.raim_type == 1  
        WSSE_sqrt = sqrt(y'*W*(I-P)*y);
    end
    
    Detect_results.WSSE_sqrt = WSSE_sqrt;
    Detect_results.Thres = Thres;
    Detect_results.fault_confirmed = (WSSE_sqrt>Thres);
end

