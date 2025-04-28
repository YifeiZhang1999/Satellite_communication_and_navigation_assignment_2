%% T2
clearvars
load("urban_matlab.mat")
skymask = readmatrix(".\skymask_A1_urban.csv");
angles     = skymask(2:end,1);
elevations = skymask(2:end,2);

angles_smooth = linspace(min(angles), max(angles), 1e4);
smoothing_param = 0.99; 
pp = csaps(angles, elevations, smoothing_param);
elevations_smooth = fnval(pp, angles_smooth);
settings.sys.skymask = [angles_smooth', elevations_smooth'];

settings.sys.ls_type = 0; 
settings.sys.raim_type = 2; 
settings.sys.skymask_type = 0; 
[obsData, satData, navData] = doNavigation(obsData, settings, ephData);

%% T3 
clearvars
load("opensky_matlab.mat")
settings.sys.ls_type = 1; 
settings.sys.raim_type = 1;
[obsData, satData, navData] = doNavigation(obsData, settings, ephData);
close all

clearvars
load("urban_nav_OLS.mat")
solu_ols = navData;
load("urban_nav_OLS_skymask.mat")
solu_ols_skymask = navData;

NrEpoch    = size(navData, 2);
GT_llh     = [settings.nav.trueLat, settings.nav.trueLong, settings.nav.trueHeight];
GT_ecef    = llh2ecef(GT_llh.*[pi/180, pi/180, 1]);
R_mat      = R_ecef_enu(GT_llh.*[pi/180, pi/180, 1]);

pos_llh = (1:3);
vel_enu = (4:6);
pos_enu = (7:9);
pos_raim = (10:13);

for i = 1: NrEpoch 
    SOLU.ols(i, pos_llh) = solu_ols{1,i}.Pos.LLA;
    SOLU.ols(i, vel_enu) = (R_mat * solu_ols{1,i}.Vel.xyz')';
    SOLU.ols(i, pos_enu) = (R_mat * (solu_ols{1,i}.Pos.xyz - GT_ecef)' )';

    SOLU.ols_skymask(i, pos_llh) = solu_ols_skymask{1,i}.Pos.LLA;
    SOLU.ols_skymask(i, vel_enu) = (R_mat * solu_ols_skymask{1,i}.Vel.xyz')';
    SOLU.ols_skymask(i, pos_enu) = (R_mat * (solu_ols_skymask{1,i}.Pos.xyz - GT_ecef)' )';
end

figure; 
geobasemap('satellite');
geoscatter(SOLU.ols(:, pos_llh(1)), SOLU.ols(:, pos_llh(2)), 30, 'filled', 'r', 'DisplayName', 'OLS'); hold on
geoscatter(SOLU.ols_skymask(:, pos_llh(1)), SOLU.ols_skymask(:, pos_llh(2)), 30, 'filled', 'b', 'DisplayName', 'OLS with Skymask'); hold on
geoscatter(GT_llh(1), GT_llh(2), 300, 'filled', 'g', "pentagram",'MarkerEdgeColor', 'k', 'DisplayName', 'Grount Truth'); hold on
legend('show');

err_3d_ols = vecnorm(SOLU.ols(:, pos_enu),2,2);
err_3d_ols_skymask = vecnorm(SOLU.ols_skymask(:, pos_enu),2,2);

mean(err_3d_ols)
std(err_3d_ols)
mean(err_3d_ols_skymask)
std(err_3d_ols_skymask)

SOLU.ols_skymask(:, pos_enu)


fde_info = SOLU.ols(:, pos_raim);
nav_info = SOLU.ols;

figure; 
subplot(1,3,1)
hold on
plot(fde_info(:, 1), 'b', LineWidth=1); 
plot(fde_info(:, 2), 'r', LineWidth=1); 
xlabel("Time (Epoch)")
ylabel("Test Statistics (m)")
title("Detection results for WLS")

subplot(1,3,2)
plot(fde_info(:, 3), 'g', LineWidth=1); 
xlabel("Time (Epoch)")
ylabel("PL (m)")
title("PL for WLS")

err_3d = vecnorm(nav_info(:, pos_enu), 2, 2);
pl_3d = fde_info(:, 3);
subplot(1,3,3)
hold on;
scatter(err_3d, pl_3d, 'filled', 'b');
ylabel('Protection Level (m)');
xlabel('Position Error (m)');
grid on;
yline(50, '--black', 'LineWidth', 1.5);
xline(50, '--black', 'LineWidth', 1.5);
plot([0, 60], [0, 60], 'k--', 'LineWidth', 1);
title("Stanford chart for WLS")


% pose error
figure; 
subplot(3,1,1)
hold on; grid on
plot(1:NrEpoch, SOLU.ols(:,pos_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.ols(:,pos_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.ols(:,pos_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Error (m)")
title("OLS")

subplot(3,1,2)
hold on; grid on
plot(1:NrEpoch, SOLU.wls(:,pos_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.wls(:,pos_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.wls(:,pos_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Error (m)")
title("WLS")

subplot(3,1,3)
hold on; grid on
plot(1:NrEpoch, SOLU.ekf(:,pos_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.ekf(:,pos_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.ekf(:,pos_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Error (m)")
title("EKF")
xlabel("Time (Epoch)")

% velocity error
figure; 
subplot(3,1,1)
hold on; grid on
plot(1:NrEpoch, SOLU.ols(:,vel_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.ols(:,vel_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.ols(:,vel_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Velocity (m/s)")
title("OLS")

subplot(3,1,2)
hold on; grid on
plot(1:NrEpoch, SOLU.wls(:,vel_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.wls(:,vel_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.wls(:,vel_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Velocity (m/s)")
title("WLS")

subplot(3,1,3)
hold on; grid on
plot(1:NrEpoch, SOLU.ekf(:,vel_enu(1)), 'b-*', 'DisplayName', 'E', LineWidth=1);
plot(1:NrEpoch, SOLU.ekf(:,vel_enu(2)), 'g-+', 'DisplayName', 'N', LineWidth=1); 
plot(1:NrEpoch, SOLU.ekf(:,vel_enu(3)), 'r-o', 'DisplayName', 'U', LineWidth=1);  
legend('show');
ylabel("Velocity (m/s)")
title("EKF")

xlabel("Time (Epoch)")

