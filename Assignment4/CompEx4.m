%% Computer Exercise 4
clearvars
close all
load preloadCompEx3&4

%% Steepest descent method
errors = [];
lambda = 0.1;
for k=1:10
    % Compute residuals and Jacobian matrix
    [rk , Jk] = LinearizeReprojErr(P, U, u);
    
    % Update gradient step and solution
    C = Jk.'*Jk+lambda*speye(size(Jk,2));
    c = Jk.'*rk;
    deltav = -C\c;
    [P, U] = update_solution(deltav, P, U);
    
    % Compute re-projection error for plot.
    [objective_error ,res] = ComputeReprojectionError(P, U, u);
    errors(k) = objective_error;
end

% RMS-error
RMS = sqrt(sum(res.^2)/length(res));

figure(1)
plot(linspace(1,10,10), errors)
xlabel('Iteration')
ylabel('Objective value')
title('Object value in Levenberg-Marquardt with lambda = 0.1')