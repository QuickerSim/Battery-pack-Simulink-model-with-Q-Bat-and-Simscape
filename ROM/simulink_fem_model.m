classdef simulink_fem_model < matlab.System
    
    properties(Constant)
        % 15-Nov-2021 09:28:37
        
        % Number of solid components
        fem_n_ele = 58;
        
        % Number of cell components
        cell_n_ele = 14;
        
        % Number of pipe components
        th_n_ele = 2;
    end
    
    properties(Nontunable)
        %Battery initial temperature (degC)
        T_init_fem = NaN;
        %Coolant initial temperature (degC)
        T_init_th = NaN;
        % Step size for thermal simulation
        dt = NaN;
        % Maximum error of thermal nonlinearity
        max_res = NaN;
        % Maximum number of subiterations
        max_sub_iter = NaN;
        solver_type = NaN;
    end
    
    % Pre-computed constants
    properties(Access = private)
        model
        T_prev
        total_time = 0;
        
        fem_max_temp_to_save = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
        fem_mean_temp_to_save = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
        fem_min_temp_to_save = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
        fem_probed_temp_to_save = [];
        th_outlet_temp_to_save = [1, 2];
    end
    
    methods(Access = public)
        function obj = simulink_fem_model()
        end
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            data = load("data/fem_model.mat");
            
            obj.model = data.fem_model;
        end
        
        function [fem_mean_temp , fem_max_temp_output , fem_mean_temp_output , fem_min_temp_output  , th_outlet_temp_output] = ...
                stepImpl(obj, ele_source_term, bus_input)
            
            [Tr, n_fem_bodies, n_fem_grids, n_th_bodies, n_th_grids, fem_body_names, ...
                fem_grid_names, th_body_names, th_grid_names] = doStep(obj.solver_type, ...
                obj.dt, obj.max_sub_iter, obj.T_prev, ...
                obj.total_time, obj.max_res, obj.model, ...
                ele_source_term, bus_input);
            
            obj.T_prev = Tr;
            
            fem_mean_temp = zeros(obj.cell_n_ele, 1);
            fem_max_temp_output = zeros(14,1);
            fem_min_temp_output = zeros(14,1);
            fem_mean_temp_output = zeros(14,1);
            fem_probed_temp_output = zeros(0,1);
            th_outlet_temp_output = zeros(2,1);
            
            
            
            for i = 1 : n_fem_bodies
                g_id = obj.model.fem_bodies.(fem_body_names{i}).grid_name;
                for j = 1 : n_fem_grids
                    if(j == g_id)
                        if any(i == unique([obj.fem_max_temp_to_save, obj.fem_min_temp_to_save]) ) 
    modes_ids = obj.model.fem_bodies.(fem_body_names{i}).modes_ids; 
    u_full = obj.model.fem_grids.(fem_grid_names{j}).reduced_basis(:, modes_ids) * ... 
        obj.T_prev(obj.model.fem_bodies.(fem_body_names{i}).lrgr);
    fem_max_temp_output(i == obj.fem_max_temp_to_save) = max(u_full);
    fem_min_temp_output(i == obj.fem_min_temp_to_save) = min(u_full);
end

                        
                        if ~isempty(obj.model.fem_bodies.(fem_body_names{i}).ele_body_id) || any(i == obj.fem_mean_temp_to_save)
                           average_operator =...
                              obj.model.fem_grids.(fem_grid_names{j}).average_operator(obj.model.fem_bodies.(fem_body_names{i}).modes_ids);
                           if ~isempty(obj.model.fem_bodies.(fem_body_names{i}).ele_body_id)
                              fem_mean_temp(obj.model.fem_bodies.(fem_body_names{i}).ele_body_id) = average_operator * obj.T_prev(obj.model.fem_bodies.(fem_body_names{i}).lrgr);
                           end
                           if any(i == obj.fem_mean_temp_to_save)
    fem_mean_temp_output(i == obj.fem_mean_temp_to_save) = average_operator * obj.T_prev(obj.model.fem_bodies.(fem_body_names{i}).lrgr);
end

                           average_operator = [];
                        end
                        break
                    end
                end
                
            end
            
            for i = 1 : n_th_bodies
        g_id = obj.model.th_bodies.(th_body_names{i}).grid_name;
        for j = 1 : n_th_grids
            if(j == g_id)
                local_dofs_T = obj.model.th_bodies.(th_body_names{i}).lrgr_T;
                u_ene = obj.T_prev(local_dofs_T(end));
                energy_data = obj.model.th_grids.(th_grid_names{j}).data_T_ene;
                u_temp = nearestInterp1(energy_data(:,2), energy_data(:,1), u_ene);
                th_outlet_temp_output(i == obj.th_outlet_temp_to_save) = u_temp;
            end
        end
    end
            obj.total_time = obj.total_time + obj.dt;
        end
        
        function resetImpl(obj)
            obj.T_prev = doReset(obj.model, obj.T_init_fem, obj.T_init_th);
        end
        
        function num = getNumOutputsImpl(~)
            num = 5;
        end
        
        function [dataout , dataout_max , dataout_mean , dataout_min  , dataout_outlet] = getOutputDataTypeImpl(~)
            dataout = 'double';
            dataout_max = 'double';
            dataout_mean = 'double';
            dataout_min = 'double';
            
            dataout_outlet = 'double';
        end
        
        function [cplxout , cplx_max , cplx_mean , cplx_min  , cplx_outlet] = isOutputComplexImpl(~)
            cplxout = false;
            cplx_max = false;
            cplx_mean = false;
            cplx_min = false;
            
            cplx_outlet = false;
        end
        
        function [sz1 , sz_max , sz_mean , sz_min  , sz_outlet] = getOutputSizeImpl(obj)
            sz1 = [obj.cell_n_ele, 1];
            sz_max = [14, 1];
            sz_mean = [14, 1];
            sz_min = [14, 1];
            
            sz_outlet = [2, 1];
        end
        
        function [fz1 , fz_max , fz_mean , fz_min  , fz_outlet] = isOutputFixedSizeImpl(~)
            fz1 = true;
            fz_max = true;
            fz_mean = true;
            fz_min = true;
            
            fz_outlet = true;
        end
        
    end
    
    methods(Access = private)
    end
end