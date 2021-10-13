# Example is for coupled mass and energy in a monolith system

[GlobalParams]
    dg_scheme = nipg
    sigma = 10

[] #END GlobalParams

[Problem]
    #NOTE: For RZ coordinates, x ==> R and y ==> Z (and z ==> nothing)
    coord_type = RZ
[] #END Problem

[Mesh]
    type = GeneratedMesh
    dim = 2
    nx = 5
    ny = 20
    xmin = 0.0
    xmax = 1    # cm radius
    ymin = 0.0
    ymax = 5   # cm length
[]

[Variables]
    [./Ef]
        order = FIRST
        family = MONOMIAL

        # Ef = rho*cp*Tf
        [./InitialCondition]
            type = InitialPhaseEnergy
            specific_heat = cpg
            density = rho
            temperature = Tf
        [../]
    [../]

    [./Es]
        order = FIRST
        family = MONOMIAL

        # Es = rho_s*cp_s*Ts
        [./InitialCondition]
            type = InitialPhaseEnergy
            specific_heat = cps
            density = rho_s
            temperature = Ts
        [../]
    [../]

    [./Tf]
        order = FIRST
        family = MONOMIAL
        initial_condition = 378  #K
    [../]

    [./Ts]
        order = FIRST
        family = MONOMIAL
        initial_condition = 378  #K
    [../]

    # Bulk gas concentration for CO
    [./CO]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Micro-pore gas concentration for CO
    [./COw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Bulk gas concentration for O2
    [./O2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Micro-pore gas concentration for O2
    [./O2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Bulk gas concentration for CO2
    [./CO2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Micro-pore gas concentration for CO2
    [./CO2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-15    #mol/L
    [../]

    # Reaction variables
    #     Units of these variables depend on
    #         (1) Units of the pre_exponential term
    #         (2) Unit basis of the mass and energy balances
    #
    #   In this example, each reaction variable has units of
    #       moles per solid volume per min. This is because
    #       we are using minutes as our time unit and these
    #       are catalytic reactions that occur in the solid
    #       phase.
    #
    #   Also, because the reactions occur on the solids, they
    #       directly impact the solid phase energy balance.
    [./r1]
        order = FIRST
        family = MONOMIAL
                                  # moles / (vol solid) / min
    [../]
[]

[AuxVariables]
    [./vel_x]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    # Calculated in cm/min via aux kernel
    [./vel_y]
        order = FIRST
        family = MONOMIAL
                                          #cm/min  - avg linear velocity
    [../]

    [./vel_z]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./Kg]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0.06          #W/m/K ==> J/min/cm/K
    [../]

    [./Ks]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0.9       #W/m/K ==> J/min/cm/K
    [../]

    [./eps]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0.775          # vol air / total volume
    [../]

    # Calculated via aux kernel
    [./s_frac]
        order = FIRST
        family = MONOMIAL
                                          # vol solid / total volume
    [../]

    [./eps_w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0.4             # vol micropore / volume solid
    [../]

    # Calculated via aux kernel
    [./total_pore]
        order = FIRST
        family = MONOMIAL
                                            # vol micropore / total volume
    [../]

    # NOW being calculated in aux kernel
    [./rho]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1e-6       #kg/cm^3
    [../]

    # This is 'mass of particle per hard-shell volume of particle'
    #       i.e., mass of the solids per volume (including pore volume)
    [./rho_s]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0.001599       #kg/cm^3
    [../]

    # NOW being calculated in aux kernel
    [./cpg]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1000       #J/kg/K
    [../]

    # This is 'net/effective particle heat capacity'
    #     i.e., heat capacity of the particle/solids
    #           NOT the heat capacity of the material
    [./cps]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1100       #J/kg/K
    [../]

    [./hw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 2.22       #W/m^2/K ==> J/min/cm^2/K
    [../]

    # Wall temperature set via aux kernel
    [./Tw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 378  #K
    [../]

    # Inlet temperature set via aux kernel
    [./Tin]
        order = FIRST
        family = MONOMIAL
        initial_condition = 378       #K
    [../]

    [./hs]
        order = FIRST
        family = MONOMIAL
        initial_condition = 2.22      #W/m^2/K ==> J/min/cm^2/K
    [../]

    # Calculated via aux kernel
    [./Ao]
        order = FIRST
        family = MONOMIAL
                                      #cm^-1
    [../]

    # Calculated via aux kernel
    [./dh]
        order = FIRST
        family = MONOMIAL
                                      #cm
    [../]

    # Calculated via aux kernel
    [./Disp]
        order = FIRST
        family = MONOMIAL
                                      #cm^2/min
    [../]

    # Calculated via aux kernel
    [./km]
        order = FIRST
        family = MONOMIAL
                                      #cm/min
    [../]

[]

[Kernels]
     # ================ Fluid phase energy balance ===============
     [./Ef_dot]
         type = VariableCoefTimeDerivative
         variable = Ef
         coupled_coef = eps
     [../]
     [./Ef_gadv]
         type = GPoreConcAdvection
         variable = Ef
         porosity = eps
         ux = vel_x
         uy = vel_y
         uz = vel_z
     [../]
     [./Ef_gdiff]
         type = GPhaseThermalConductivity
         variable = Ef
         temperature = Tf
         volume_frac = eps
         Dx = Kg
         Dy = Kg
         Dz = Kg
     [../]
     [./Ef_trans]
         type = PhaseEnergyTransfer
         variable = Ef
         this_phase_temp = Tf
         other_phase_temp = Ts

         transfer_coef = hs
         specific_area = Ao
         volume_frac = s_frac
     [../]

    # ================ Solid phase energy balance ===============
    [./Es_dot]
        type = VariableCoefTimeDerivative
        variable = Es
        coupled_coef = s_frac
    [../]
    [./Es_gdiff]
        type = GPhaseThermalConductivity
        variable = Es
        temperature = Ts
        volume_frac = s_frac
        Dx = Ks
        Dy = Ks
        Dz = Ks
    [../]
    [./Es_trans]
        type = PhaseEnergyTransfer
        variable = Es
        this_phase_temp = Ts
        other_phase_temp = Tf

        transfer_coef = hs
        specific_area = Ao
        volume_frac = s_frac
    [../]
    # NOTE: We may want to create a new kernel for this
    #       that will allow the 'weights' to be variables
    #       representing the heats of each reaction.
    #       (However, this may be unnecessary)
    #
    #   In our case, since 'r1' has units of moles per solid volume per min,
    #         AND our energy balance is in energy per total volume, then
    #         the 'scale' must be the solids fraction (1-eps).
    #
    #   Residual:   (1-eps)*SUM( (-dH_i) * r_i)
    #
    #       'scale' = (1-eps)
    #       'weights' = -dH_i
    #           Thus, if dH_i is positive (the weight is negative)
    #                 if dH_i is negative (the weight is positive)
    #
    #   NOTE: We NEED to also be cautious of the units on solid volume.
    #         In our kinetic model, volume units in the reaction variable
    #         use liters (L), but for the energy balance, we use cm^3.
    #         THUS, the 'dH' values (i.e., weights) or the 'scale' need
    #         to account for this additional unit conversion.
    [./Es_rxns_heat]
        type = ScaledWeightedCoupledSumFunction
        variable = Es
        coupled_list = 'r1'

        # Here, our dH for r1 is -283 kJ/mol (-283,000 J/mol)
        #   HOWEVER, since r1 has units of mol/L/min, we need
        #   dH to have units of J/mol*(L/cm^3), thus we divide
        #   by 1000 (or provide in kJ/mol)
        #
        #         dH = -283 kJ/mol ==> weight = 283 J/mol*(L/cm^3)
        #
        # For this reaction, 283 kJ/mol might be too low based
        #   on experiments. That value was taken from a paper,
        #   but the temperature profile does not match. This
        #   could also be because we don't know what the wall
        #   temperature and energy transfer coefficients should
        #   actually be (or that we aren't tracking density
        #   changes yet.)

        weights = '283'   #og value
        #weights = '1283'   #edited value
        scale = s_frac
    [../]

    # ============== Fluid Temperature Calculation =============
    [./Tf_calc]
        type = PhaseTemperature
        variable = Tf
        energy = Ef
        specific_heat = cpg
        density = rho
    [../]

    # ============== Solid Temperature Calculation =============
    [./Ts_calc]
        type = PhaseTemperature
        variable = Ts
        energy = Es
        specific_heat = cps
        density = rho_s
    [../]

    # ================ Bulk fluid mass balance ===============
    # -------------------------- CO --------------------------
    [./CO_dot]
        type = VariableCoefTimeDerivative
        variable = CO
        coupled_coef = eps
    [../]
    [./CO_gadv]
        type = GPoreConcAdvection
        variable = CO
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO_gdiff]
        type = GVarPoreDiffusion
        variable = CO
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]
    [./COw_trans]
        type = FilmMassTransfer
        variable = CO
        coupled = COw

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]

    # ================ Micropore fluid mass balance ===============
    # ----------------------------- CO ----------------------------
    [./COw_dot]
        type = VariableCoefTimeDerivative
        variable = COw
        coupled_coef = total_pore
    [../]
    [./CO_trans]
        type = FilmMassTransfer
        variable = COw
        coupled = CO

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]
    [./COw_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = COw
        coupled_list = 'r1'
        weights = '-1'
        scale = s_frac
    [../]

    # ================ Bulk fluid mass balance ===============
    # -------------------------- O2 --------------------------
    [./O2_dot]
        type = VariableCoefTimeDerivative
        variable = O2
        coupled_coef = eps
    [../]
    [./O2_gadv]
        type = GPoreConcAdvection
        variable = O2
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./O2_gdiff]
        type = GVarPoreDiffusion
        variable = O2
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]
    [./O2w_trans]
        type = FilmMassTransfer
        variable = O2
        coupled = O2w

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]

    # ================ Micropore fluid mass balance ===============
    # ----------------------------- O2 ----------------------------
    [./O2w_dot]
        type = VariableCoefTimeDerivative
        variable = O2w
        coupled_coef = total_pore
    [../]
    [./O2_trans]
        type = FilmMassTransfer
        variable = O2w
        coupled = O2

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]
    [./O2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = O2w
        coupled_list = 'r1'
        weights = '-0.5'
        scale = s_frac
    [../]

    # ================ Bulk fluid mass balance ===============
    # -------------------------- CO2 --------------------------
    [./CO2_dot]
        type = VariableCoefTimeDerivative
        variable = CO2
        coupled_coef = eps
    [../]
    [./CO2_gadv]
        type = GPoreConcAdvection
        variable = CO2
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO2_gdiff]
        type = GVarPoreDiffusion
        variable = CO2
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]
    [./CO2w_trans]
        type = FilmMassTransfer
        variable = CO2
        coupled = CO2w

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]

    # ================ Micropore fluid mass balance ===============
    # ----------------------------- CO2 ----------------------------
    [./CO2w_dot]
        type = VariableCoefTimeDerivative
        variable = CO2w
        coupled_coef = total_pore
    [../]
    [./CO2_trans]
        type = FilmMassTransfer
        variable = CO2w
        coupled = CO2

        av_ratio = Ao
        rate_variable = km
        volume_frac = s_frac
    [../]
    [./CO2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = CO2w
        coupled_list = 'r1'
        weights = '1'
        scale = s_frac
    [../]

    ### +++++++++++++++++++++ Reaction Kernels +++++++++++++++++++
    ## ======= CO Oxidation ======
    # CO + 0.5 O2 --> CO2
    [./r1_val]
        type = Reaction
        variable = r1
    [../]
    [./r1_rx]
      type = ArrheniusReaction
      variable = r1
      this_variable = r1

      forward_activation_energy = 235293.33281046877
      forward_pre_exponential = 3.2550871137667489e+31

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = Ts
      scale = 1.0
      reactants = 'COw O2w'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]
[]

[DGKernels]
    # ========== Fluid Energy DG Kernels ==========
    [./Ef_dgadv]
        type = DGPoreConcAdvection
        variable = Ef
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./Ef_dgdiff]
        type = DGPhaseThermalConductivity
        variable = Ef
        temperature = Tf
        volume_frac = eps
        Dx = Kg
        Dy = Kg
        Dz = Kg
    [../]

    # ========== Solid Energy DG Kernels ==========
    [./Es_dgdiff]
        type = DGPhaseThermalConductivity
        variable = Es
        temperature = Ts
        volume_frac = s_frac
        Dx = Ks
        Dy = Ks
        Dz = Ks
    [../]

    # ========== Fluid Mass DG Kernels ==========
    # ------------------- CO --------------------
    [./CO_dgadv]
        type = DGPoreConcAdvection
        variable = CO
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO_dgdiff]
        type = DGVarPoreDiffusion
        variable = CO
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]

    # ========== Fluid Mass DG Kernels ==========
    # ------------------- O2 --------------------
    [./O2_dgadv]
        type = DGPoreConcAdvection
        variable = O2
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./O2_dgdiff]
        type = DGVarPoreDiffusion
        variable = O2
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]

    # ========== Fluid Mass DG Kernels ==========
    # ------------------- CO2 --------------------
    [./CO2_dgadv]
        type = DGPoreConcAdvection
        variable = CO2
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO2_dgdiff]
        type = DGVarPoreDiffusion
        variable = CO2
        porosity = eps
        Dx = Disp
        Dy = Disp
        Dz = Disp
    [../]
[]

[AuxKernels]

    [./temp_in_increase]
        type = LinearChangeInTime
        variable = Tin
        start_time = 16   # time at which we start ramping (in min)
        end_time = 92    # time at which we reach 825 K (in min)
        end_value = 825   # final temp in K
        execute_on = 'initial timestep_end'
    [../]

    [./temp_wall_increase]
        type = LinearChangeInTime
        variable = Tw
        start_time = 16   # time at which we start ramping (in min)
        end_time = 92    # time at which we reach 782 K (in min)
        end_value = 782   # final temp in K
        execute_on = 'initial timestep_end'
    [../]

    [./velocity]
        # NOTE: velocity must use same shape function type as temperature and space-velocity
        type = GasVelocityCylindricalReactor
        variable = vel_y
        porosity = eps
        space_velocity = 500   #volumes per min
        inlet_temperature = Tin   # K
        inlet_pressure = 101.35   # kPa
        ref_temperature = 273.15  # K
        ref_pressure = 101.35     # kPa
        radius = 1  #cm
        length = 5  #cm
        execute_on = 'initial timestep_end'
    [../]

    [./s_frac_calc]
        type = SolidsVolumeFraction
        variable = s_frac
        porosity = eps
        execute_on = 'initial timestep_end'
    [../]

    [./Ao_calc]
        type = MonolithAreaVolumeRatio
        variable = Ao
        cell_density = 93   #cells/cm^2
        channel_vol_ratio = eps
        per_solids_volume = true
        execute_on = 'initial timestep_end'
    [../]

    [./total_pore_calc]
        type = MicroscalePoreVolumePerTotalVolume
        variable = total_pore
        porosity = eps
        microscale_porosity = eps_w
        execute_on = 'initial timestep_end'
    [../]

    [./dh_calc]
        type = MonolithHydraulicDiameter
        variable = dh
        cell_density = 93   #cells/cm^2
        channel_vol_ratio = eps
        execute_on = 'initial timestep_end'
    [../]

    [./km_calc]
        type = SimpleGasMonolithMassTransCoef
        variable = km

        pressure = 101.35
        temperature = Tf
        micro_porosity = eps_w
        macro_porosity = eps
        characteristic_length = dh
        char_length_unit = "cm"

        velocity = vel_y
        vel_length_unit = "cm"
        vel_time_unit = "min"

        ref_diffusivity = 0.561
        diff_length_unit = "cm"
        diff_time_unit = "s"
        ref_diff_temp = 473

        output_length_unit = "cm"
        output_time_unit = "min"

        execute_on = 'initial timestep_end'
    [../]

    [./Disp_calc]
        type = SimpleGasDispersion
        variable = Disp

        pressure = 101.35
        temperature = Tf
        micro_porosity = eps_w
        macro_porosity = eps

        # NOTE: For this calculation, use bed diameter as char_length
        characteristic_length = 2
        char_length_unit = "cm"

        velocity = vel_y
        vel_length_unit = "cm"
        vel_time_unit = "min"

        ref_diffusivity = 0.561
        diff_length_unit = "cm"
        diff_time_unit = "s"
        ref_diff_temp = 473

        output_length_unit = "cm"
        output_time_unit = "min"

        execute_on = 'initial timestep_end'
    [../]

    [./dens_calc]
        type = SimpleGasDensity
        variable = rho

        pressure = 101.35
        temperature = Tf

        output_length_unit = "cm"
        output_mass_unit = "kg"

        execute_on = 'initial timestep_end'
    [../]

    [./cpg_calc]
        type = SimpleGasIsobaricHeatCapacity
        variable = cpg

        pressure = 101.35
        temperature = Tf

        output_energy_unit = "J"
        output_mass_unit = "kg"

        execute_on = 'initial timestep_end'
    [../]
[]

[BCs]
    # =============== Fluid Energy Open Bounds ============
    [./Ef_Flux_OpenBounds]
        type = DGFlowEnergyFluxBC
        variable = Ef
        boundary = 'bottom top'
        porosity = eps
        specific_heat = cpg
        density = rho
        inlet_temp = Tin
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # =============== Fluid Energy Wall Bounds ============
    [./Ef_WallFluxIn]
        type = DGWallEnergyFluxBC
        variable = Ef
        boundary = 'right'
        transfer_coef = hw
        wall_temp = Tw
        temperature = Tf
        area_frac = eps
    [../]

    # =============== Solid Energy Wall Bounds ============
    [./Es_WallFluxIn]
        type = DGWallEnergyFluxBC
        variable = Es
        boundary = 'right'
        transfer_coef = hw
        wall_temp = Tw
        temperature = Ts
        area_frac = s_frac
    [../]

    # =============== Fluid Mass Open Bounds ============
    # ----------------------- CO ------------------------
    [./CO_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = CO
        boundary = 'bottom'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = 101.35
        temperature = Tin
        inlet_ppm = 5000
    [../]
    [./CO_FluxOut]
        type = DGPoreConcFluxBC
        variable = CO
        boundary = 'top'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # =============== Fluid Mass Open Bounds ============
    # ----------------------- O2 ------------------------
    [./O2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = O2
        boundary = 'bottom'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = 101.35
        temperature = Tin
        inlet_ppm = 2500
    [../]
    [./O2_FluxOut]
        type = DGPoreConcFluxBC
        variable = O2
        boundary = 'top'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # =============== Fluid Mass Open Bounds ============
    # ----------------------- CO2 ------------------------
    [./CO2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = CO2
        boundary = 'bottom'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = 101.35
        temperature = Tin
        inlet_ppm = 130000
    [../]
    [./CO2_FluxOut]
        type = DGPoreConcFluxBC
        variable = CO2
        boundary = 'top'
        porosity = eps
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

[]

[Postprocessors]
    [./Ef_out]
        type = SideAverageValue
        boundary = 'top'
        variable = Ef
        execute_on = 'initial timestep_end'
    [../]

    [./Ef_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = Ef
        execute_on = 'initial timestep_end'
    [../]

    [./Es_out]
        type = SideAverageValue
        boundary = 'top'
        variable = Es
        execute_on = 'initial timestep_end'
    [../]

    [./Es_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = Es
        execute_on = 'initial timestep_end'
    [../]

    [./T_out]
        type = SideAverageValue
        boundary = 'top'
        variable = Tf
        execute_on = 'initial timestep_end'
    [../]

    # NOTE: The below 2 post-processors are used to obtain
    #     temperature read outs of the mid/center point of
    #     the catalyst and the mid/wall point of the catalyst.
    #   To get these points, you MUST know the elementid's
    #     that correspond to the points of interest. To get
    #     this info, you MUST first create your mesh, view
    #     it, and see which elements you want. If you change
    #     your mesh, then you must change your elementid's.
    [./T_mid_center]
        type = ElementalVariableValue
        elementid = 46
        variable = Tf
        execute_on = 'initial timestep_end'
    [../]
    [./T_mid_wall]
        type = ElementalVariableValue
        elementid = 50
        variable = Tf
        execute_on = 'initial timestep_end'
    [../]

    [./T_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = Tf
        execute_on = 'initial timestep_end'
    [../]

    [./Ts_out]
        type = SideAverageValue
        boundary = 'top'
        variable = Ts
        execute_on = 'initial timestep_end'
    [../]

    # NOTE: The below 2 post-processors are used to obtain
    #     temperature read outs of the mid/center point of
    #     the catalyst and the mid/wall point of the catalyst.
    #   To get these points, you MUST know the elementid's
    #     that correspond to the points of interest. To get
    #     this info, you MUST first create your mesh, view
    #     it, and see which elements you want. If you change
    #     your mesh, then you must change your elementid's.
    [./Ts_mid_center]
        type = ElementalVariableValue
        elementid = 46
        variable = Ts
        execute_on = 'initial timestep_end'
    [../]
    [./Ts_mid_wall]
        type = ElementalVariableValue
        elementid = 50
        variable = Ts
        execute_on = 'initial timestep_end'
    [../]

    [./Ts_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = Ts
        execute_on = 'initial timestep_end'
    [../]

    [./CO_out]
        type = SideAverageValue
        boundary = 'top'
        variable = CO
        execute_on = 'initial timestep_end'
    [../]

    [./CO_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = CO
        execute_on = 'initial timestep_end'
    [../]

    [./O2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = O2
        execute_on = 'initial timestep_end'
    [../]

    [./O2_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = O2
        execute_on = 'initial timestep_end'
    [../]

    [./CO2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = CO2
        execute_on = 'initial timestep_end'
    [../]

    [./CO2_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = CO2
        execute_on = 'initial timestep_end'
    [../]

    [./cpg_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = cpg
        execute_on = 'initial timestep_end'
    [../]
    [./cpg_out]
        type = SideAverageValue
        boundary = 'top'
        variable = cpg
        execute_on = 'initial timestep_end'
    [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = pjfnk   #default to newton, but use pjfnk if newton too slow
  [../]
[] #END Preconditioning

[Executioner]
  type = Transient
  scheme = implicit-euler
  petsc_options = '-snes_converged_reason'

  petsc_options_iname ='-ksp_type
                        -pc_type
                        -sub_pc_type
                        -snes_max_it
                        -sub_pc_factor_shift_type
                        -pc_asm_overlap
                        -snes_atol
                        -snes_rtol'

  # snes_max_it = maximum non-linear steps
  petsc_options_value = 'gmres
                         asm
                         lu
                         10
                         NONZERO
                         10
                         1E-8
                         1E-10'

  #NOTE: turning off line search can help converge for high Renolds number
  line_search = bt
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-8
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-8
  nl_max_its = 10
  l_tol = 1e-6
  l_max_its = 100

  start_time = -1
  end_time = 102
  dtmax = 0.25

  [./TimeStepper]
     type = ConstantDT
     dt = 0.25
  [../]
[] #END Executioner

[Outputs]
  print_linear_residuals = true
  exodus = true
  csv = true
[] #END Outputs