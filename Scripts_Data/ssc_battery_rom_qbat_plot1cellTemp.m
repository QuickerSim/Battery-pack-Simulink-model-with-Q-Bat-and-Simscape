% Code to plot simulation results from ssc_battery_rom_qbat

% Reuse figure if it exists, else create new figure
if ~exist('h1_simscape_qbat', 'var') || ...
        ~isgraphics(h1_simscape_qbat, 'figure')
    h1_simscape_qbat = figure('Name', 'simscape_qbat');
end
figure(h1_simscape_qbat)
clf(h1_simscape_qbat)

% Generate simulation results if they don't exist
if(~exist('simlog_ssc_battery_rom_qbat','var'))
    sim('ssc_battery_rom_qbat')
end

% Get simulation results
% Extract temperature from cells
simlog_t = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_01.temperature.series.time;
simlog_tC01 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_01.temperature.series.values('degC');
simlog_tC02 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_02.temperature.series.values('degC');
simlog_tC03 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_03.temperature.series.values('degC');
simlog_tC04 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_04.temperature.series.values('degC');
simlog_tC05 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_05.temperature.series.values('degC');
simlog_tC06 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_06.temperature.series.values('degC');
simlog_tC07 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_07.temperature.series.values('degC');
simlog_tC08 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_08.temperature.series.values('degC');
simlog_tC09 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_09.temperature.series.values('degC');
simlog_tC10 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_10.temperature.series.values('degC');
simlog_tC11 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_11.temperature.series.values('degC');
simlog_tC12 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_12.temperature.series.values('degC');
simlog_tC13 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_13.temperature.series.values('degC');
simlog_tC14 = simlog_ssc_battery_rom_qbat.Battery.Electrical.Cell_14.temperature.series.values('degC');

tCellFinal = [...
    simlog_tC01(end)
    simlog_tC02(end)
    simlog_tC03(end)
    simlog_tC04(end)
    simlog_tC05(end)
    simlog_tC06(end)
    simlog_tC07(end)
    simlog_tC08(end)
    simlog_tC09(end)
    simlog_tC10(end)
    simlog_tC11(end)
    simlog_tC12(end)
    simlog_tC13(end)
    simlog_tC14(end)];
 
% Extract max and minimum temperature
simlog_tMax = logsout_ssc_battery_rom_qbat.get('Cell T(max)');
simlog_tMax_final = simlog_tMax.Values.Data(:,1,end);
simlog_tMin = logsout_ssc_battery_rom_qbat.get('Cell T(min)');  
simlog_tMin_final = simlog_tMin.Values.Data(:,1,end);

% Plot results
plot(simlog_t,simlog_tC01,'LineWidth',1,'DisplayName','Cell  1')
hold on
plot(simlog_t,simlog_tC02,'LineWidth',1,'DisplayName','Cell  2');
plot(simlog_t,simlog_tC03,'LineWidth',1,'DisplayName','Cell  3');
plot(simlog_t,simlog_tC04,'LineWidth',1,'DisplayName','Cell  4');
plot(simlog_t,simlog_tC05,'LineWidth',1,'DisplayName','Cell  5');
plot(simlog_t,simlog_tC06,'LineWidth',1,'DisplayName','Cell  6');
plot(simlog_t,simlog_tC07,'LineWidth',1,'DisplayName','Cell  7');
plot(simlog_t,simlog_tC08,'LineWidth',1,'DisplayName','Cell  8');
plot(simlog_t,simlog_tC09,'LineWidth',1,'DisplayName','Cell  9');
plot(simlog_t,simlog_tC10,'LineWidth',1,'DisplayName','Cell 10');
plot(simlog_t,simlog_tC11,'LineWidth',1,'DisplayName','Cell 11');
plot(simlog_t,simlog_tC12,'LineWidth',1,'DisplayName','Cell 12');
plot(simlog_t,simlog_tC13,'LineWidth',1,'DisplayName','Cell 13');
plot(simlog_t,simlog_tC14,'LineWidth',1,'DisplayName','Cell 14');
hold off
grid on
title('Cell Temperatures');
ylabel('Temperature (degC)');
xlabel('Time (s)');

legend('Location','Best')

try
    figure(h2_simscape_qbat)
catch
    h2_simscape_qbat=figure('Name', 'simscape_qbat');
end

% Reuse figure if it exists, else create new figure
if ~exist('h2_simscape_qbat', 'var') || ...
        ~isgraphics(h2_simscape_qbat, 'figure')
    h2_simscape_qbat = figure('Name', 'simscape_qbat_tFinal');
end
figure(h2_simscape_qbat)
clf(h2_simscape_qbat)

colormap(parula)
color_lim = [min(tCellFinal) max(simlog_tMax_final)];

ydata = [1 0.5 0]*34.5;
xdata = linspace(0,32.3,8);

cnum = 0;
for r_i = 1:2
    for c_i = 1:7
        if(r_i==2)
            x_ind = 8-c_i;%8-c_i;
        else
            x_ind = 8-c_i;
        end
        cnum = cnum+1;
        xpatch = xdata([x_ind x_ind+1 x_ind+1 x_ind  ]);
        ypatch = ydata([r_i r_i   r_i+1 r_i+1]);
        patch(xpatch,ypatch,tCellFinal(cnum));
        hold on
        text(sum(xdata([x_ind x_ind+1]))/2,sum(ydata([r_i r_i+1]))/2,...
            ['Cell ' num2str(cnum)],'HorizontalAlign','center',...
            'VerticalAlign','middle');
    end
end

hold off
box on
colorbar
set(gca,'XLim',[min(xdata) max(xdata)],'YLim',[min(ydata) max(ydata)]);
set(gca,'XTickLabel',{''})
set(gca,'YTickLabel',{''})
title('Final Cell Temperatures (mean, degC)');
