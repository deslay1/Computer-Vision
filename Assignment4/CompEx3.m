%% Computer Exercise 3
clearvars
close all
load preloadCompEx3&4

%% Steepest descent method
errors = [];
gammak = 1e-10;
for k=1:10
    % Compute residuals and Jacobian matrix
    [rk , Jk] = LinearizeReprojErr(P, U, u);
    
    % Update gradient step and solution
    deltav = -gammak*Jk.'*rk;
    [P, U] = update_solution(deltav, P, U);
    
    % Compute re-projection error for plot.
    [objective_error ,res] = ComputeReprojectionError(P, U, u);
    errors(k) = objective_error;
    
    gammak = gammak / 10;
end

% RMS-error
RMS = sqrt(sum(res.^2)/length(res));

figure(1)
plot(linspace(1,10,k), errors)
xlabel('Iteration')
ylabel('Objective value')
title('Object value in steepest descent with gradually decreasing gamma')