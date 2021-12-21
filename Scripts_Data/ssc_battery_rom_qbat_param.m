%% Initial Values
iniBatterySOC  = 1;     % Initial state of charge [-]
iniBatteryTemp = 293;   % Initial temperature [degK]
iniCoolantTemp = 20;    % degC

%% Battery Cell Parameters
T_vec   =[278 293 313];               % Temperature vector T [K]
AH_vec  =[28.0081 27.6250 27.6392];   % Cell capacity vector AH(T) [Ahr]
SOC_vec =[0 0.1 0.25 0.5 0.75 0.9 1]; % Cell state of charge vector SOC [-]

V0_mat=[
    3.4966    3.5057    3.5148
    3.5519    3.5660    3.5653
    3.6183    3.6337    3.6402
    3.7066    3.7127    3.7213
    3.9131    3.9259    3.9376  
    4.0748    4.0777    4.0821
    4.1923    4.1928    4.1930]; % [V] Em open-circuit voltage vs SOC rows and T columns
R0_mat=[
    0.0117    0.0085    0.0090
    0.0110    0.0085    0.0090
    0.0114    0.0087    0.0092
    0.0107    0.0082    0.0088
    0.0107    0.0083    0.0091
    0.0113    0.0085    0.0089
    0.0116    0.0085    0.0089]/2; % [Ohm] R0 resistance vs SOC rows and T columns
R1_mat=[
    0.0109    0.0029    0.0013
    0.0069    0.0024    0.0012
    0.0047    0.0026    0.0013
    0.0034    0.0016    0.0010
    0.0033    0.0023    0.0014
    0.0033    0.0018    0.0011
    0.0028    0.0017    0.0011]; % [Ohm] R1 Resistance vs SOC rows and T columns
C1_mat=[
    1913.6    12447    30609
    4625.7    18872    32995
    23306     40764    47535
    10736     18721    26325
    18036     33630    48274
    12251     18360    26839
    9022.9    23394    30606]; % [F] C1 Capacitance vs SOC rows and T columns
Tau1_mat=R1_mat.*C1_mat;

%% Cell Thermal
MdotCp=100;        % Cell thermal mass (mass times specific heat [J/K])

%% Coolant control
coolant_flow_Ton  = 35;   % degC
coolant_flow_Toff = 30;   % degC
coolant_flow_qon  = 0.3;  
coolant_flow_qoff = 0.01; 


%% Simulation time steps
heat_dt           = 5; % sec
elec_dt           = 1; % sec
