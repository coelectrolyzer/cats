[GlobalParams]
  dg_scheme = nipg
  sigma = 10
  transfer_rate = 5757.541  #min^-1
[] #END GlobalParams

[Mesh]
    type = GeneratedMesh
	coord_type = RZ
    #NOTE: For RZ coordinates, x ==> R and y ==> Z (and z ==> nothing)
    dim = 2
    nx = 1
    ny = 20
    xmin = 0.0
    xmax = 1.0    #2cm radius
    ymin = 0.0
    ymax = 5.0    #5cm length
[] # END Mesh

[Variables]

## ----- NOTE: Cross-Coupled Variables for Mass MUST have same order and family !!! ------- ##
    [./NH3]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-9
    [../]

    [./NH3w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-9
    [../]

    [./q1]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./q2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./q2a]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./q2b]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./q3]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

     [./qH2O]
         order = FIRST
         family = MONOMIAL
         initial_condition = 0
     [../]

     [./qH2O_2]
         order = FIRST
         family = MONOMIAL
         initial_condition = 0
     [../]

     [./r1]
         order = FIRST
         family = MONOMIAL
     [../]

     [./r2a]
         order = FIRST
         family = MONOMIAL
     [../]

     [./r2b]
         order = FIRST
         family = MONOMIAL
     [../]

     [./r3]
         order = FIRST
         family = MONOMIAL
     [../]

      [./r4a]
          order = FIRST
          family = MONOMIAL
      [../]

      [./r4b]
          order = FIRST
          family = MONOMIAL
      [../]

     [./S1]
         order = FIRST
         family = MONOMIAL
     [../]

     [./S2]
         order = FIRST
         family = MONOMIAL
     [../]

     [./S3]
         order = FIRST
         family = MONOMIAL
     [../]

    [./qT]
        order = FIRST
        family = MONOMIAL
    [../]

    [./H2O]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-9
    [../]

    [./H2Ow]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-9
    [../]

[] #END Variables

[AuxVariables]

  [./O2]
      order = FIRST
      family = MONOMIAL
      initial_condition = 5.35186739166803E-05
  [../]

  [./w1]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.052619
  [../]

  [./w2]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0231257
  [../]

  [./w3]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0262515
  [../]

  [./temp]
      order = FIRST
      family = MONOMIAL
      initial_condition = 423.15
  [../]

  [./Diff]
    order = FIRST
    family = MONOMIAL
    initial_condition = 0.0
  [../]

  [./Dz]
    order = FIRST
    family = MONOMIAL
    initial_condition = 0.0
  [../]

  [./pore]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.3309
  [../]

  [./non_pore]
  # non_pore = (1 - pore)
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.6691
  [../]

  [./total_pore]
# ew =~ 1/5
# total_pore = ew* (1 - pore)
# micro_pore_vol = 0.18 cm^3/g
# assume ew = 0.2
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.13382
  [../]

  [./vel_x]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0
  [../]

  [./vel_y]
      order = FIRST
      family = LAGRANGE
      initial_condition = 7555.15
  [../]

  [./vel_z]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0
  [../]

[] #END AuxVariables

[ICs]

[] #END ICs

[Kernels]
    [./H2O_dot]
        type = VariableCoefTimeDerivative
        variable = H2O
        coupled_coef = pore
    [../]
    [./H2O_gadv]
        type = GPoreConcAdvection
        variable = H2O
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./H2O_gdiff]
        type = GVarPoreDiffusion
        variable = H2O
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Dz
    [../]
    [./H2Ow_trans]
        type = ConstMassTransfer
        variable = H2O
        coupled = H2Ow
    [../]

    [./H2Ow_dot]
        type = VariableCoefTimeDerivative
        variable = H2Ow
        coupled_coef = total_pore
    [../]
    [./H2O_trans]
        type = ConstMassTransfer
        variable = H2Ow
        coupled = H2O
    [../]
    [./H2Ow_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = H2Ow
        coupled_list = 'r4a r4b'
        weights = '-1 -1'
        scale = non_pore
    [../]

    [./NH3_dot]
        type = VariableCoefTimeDerivative
        variable = NH3
        coupled_coef = pore
    [../]
    [./NH3_gadv]
        type = GPoreConcAdvection
        variable = NH3
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./NH3_gdiff]
        type = GVarPoreDiffusion
        variable = NH3
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Dz
    [../]
    [./NH3w_trans]
        type = ConstMassTransfer
        variable = NH3
        coupled = NH3w
    [../]

    [./NH3w_dot]
        type = VariableCoefTimeDerivative
        variable = NH3w
        coupled_coef = total_pore
    [../]
    [./NH3_trans]
        type = ConstMassTransfer
        variable = NH3w
        coupled = NH3
    [../]
    [./NH3w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = NH3w
        coupled_list = 'r1 r2a r2b r3'
        # weights are negative here because NH3w is consumed by reactions
        weights = '-1 -1 -1 -1'
        scale = non_pore
    [../]

#   NOTE: According to the Olsson paper, the activation energy for adsorption is 0.0
    [./q1_dot]
        type = TimeDerivative
        variable = q1
    [../]
    [./q1_rate]
        type = WeightedCoupledSumFunction
        variable = q1
        coupled_list = 'r1'
        weights = '1'
    [../]

    [./r1_val]
        type = Reaction
        variable = r1
    [../]
    [./r1_rx]  #   NH3w + S1 <-- --> q1
      type = ArrheniusEquilibriumReaction
      variable = r1
      this_variable = r1
      forward_activation_energy = 0
      forward_pre_exponential = 250000
      enthalpy = -54547.9
      entropy = -29.9943
      temperature = temp
      scale = 1.0
      reactants = 'NH3w S1'
      reactant_stoich = '1 1'
      products = 'q1'
      product_stoich = '1'
    [../]

    [./q2a_dot]
        type = TimeDerivative
        variable = q2a
    [../]
    [./q2a_rate]
        type = WeightedCoupledSumFunction
        variable = q2a
        coupled_list = 'r2a r2b'
        weights = '1 -1'
    [../]

    [./r2a_val]
        type = Reaction
        variable = r2a
    [../]
    [./r2a_rx]  #   NH3w + S2 <-- --> q2a
      type = ArrheniusEquilibriumReaction
      variable = r2a
      this_variable = r2a
      forward_activation_energy = 0
      forward_pre_exponential = 300000
      enthalpy = -78073.843
      entropy = -35.311574
      temperature = temp
      scale = 1.0
      reactants = 'NH3w S2'
      reactant_stoich = '1 1'
      products = 'q2a'
      product_stoich = '1'
    [../]

    [./r2b_val]
        type = Reaction
        variable = r2b
    [../]
    [./r2b_rx_a]  #   NH3w + q2a <-- --> q2b
      type = ArrheniusEquilibriumReaction
      variable = r2b
      this_variable = r2b
      forward_activation_energy = 0
      forward_pre_exponential = 150000
      enthalpy = -78064.167
      entropy = -46.821878
      temperature = temp
      scale = 1.0
      reactants = 'NH3w q2a'
      reactant_stoich = '1 1'
      products = 'q2b'
      product_stoich = '1'
    [../]

    [./q2b_dot]
        type = TimeDerivative
        variable = q2b
    [../]
    [./q2b_rate]
        type = WeightedCoupledSumFunction
        variable = q2b
        coupled_list = 'r2b'
        weights = '1'
    [../]

    [./q3_dot]
        type = TimeDerivative
        variable = q3
    [../]
    [./q3_rate]
        type = WeightedCoupledSumFunction
        variable = q3
        coupled_list = 'r3'
        weights = '1'
    [../]

    [./r3_dot]
        type = Reaction
        variable = r3
    [../]
    [./r3_rx]  #   NH3w + S3 <-- --> q3
      type = ArrheniusEquilibriumReaction
      variable = r3
      this_variable = r3
      forward_activation_energy = 0
      forward_pre_exponential = 2500000
      enthalpy = -91860.8
      entropy = -28.9292
      temperature = temp
      scale = 1.0
      reactants = 'NH3w S3'
      reactant_stoich = '1 1'
      products = 'q3'
      product_stoich = '1'
    [../]

    [./qH2O_dot]
        type = TimeDerivative
        variable = qH2O
    [../]
    [./qH2O_rate]
        type = WeightedCoupledSumFunction
        variable = qH2O
        coupled_list = 'r4a'
        weights = '1'
    [../]

    [./r4a_val]
        type = Reaction
        variable = r4a
    [../]
    [./r4a_rx]  #   H2Ow + S1 <-- --> qH2O
      type = ArrheniusEquilibriumReaction
      variable = r4a
      this_variable = r4a
      forward_activation_energy = 0
      forward_pre_exponential = 44000
      enthalpy = -32099.1
      entropy = -24.2494
      temperature = temp
      scale = 1.0
      reactants = 'H2Ow S1'
      reactant_stoich = '1 1'
      products = 'qH2O'
      product_stoich = '1'
    [../]

    [./qH2O_2_dot]
        type = TimeDerivative
        variable = qH2O_2
    [../]
    [./qH2O_2_rate]
        type = WeightedCoupledSumFunction
        variable = qH2O_2
        coupled_list = 'r4b'
        weights = '1'
    [../]

    [./r4b_val]
        type = Reaction
        variable = r4b
    [../]
    [./r4b_rx]  #   H2Ow + S2 <-- --> qH2O_2
      type = ArrheniusEquilibriumReaction
      variable = r4b
      this_variable = r4b
      forward_activation_energy = 0
      forward_pre_exponential = 70000
      enthalpy = -28889.23
      entropy = -26.674
      temperature = temp
      scale = 1.0
      reactants = 'H2Ow S2'
      reactant_stoich = '1 1'
      products = 'qH2O_2'
      product_stoich = '1'
    [../]

    [./qT_calc]
        type = MaterialBalance
        variable = qT
        this_variable = qT
        coupled_list = 'q1 q2a q2b q3'
        weights = '1 1 2 1'
        total_material = qT
    [../]

    [./q2_calc]
        type = MaterialBalance
        variable = q2
        this_variable = q2
        coupled_list = 'q2a q2b'
        weights = '1 2'
        total_material = q2
    [../]

    [./S1_bal]
        type = MaterialBalance
        variable = S1
        this_variable = S1
        coupled_list = 'q1 S1 qH2O'
        weights = '1 1 1'
        total_material = w1
    [../]

    [./S2_bal]
        type = MaterialBalance
        variable = S2
        this_variable = S2
        coupled_list = 'q2a q2b S2 qH2O_2'
        weights = '1 1 1 1'
        total_material = w2
    [../]

    [./S3_bal]
        type = MaterialBalance
        variable = S3
        this_variable = S3
        coupled_list = 'q3 S3'
        weights = '1 1'
        total_material = w3
    [../]

[] #END Kernels

[DGKernels]

    [./NH3_dgadv]
        type = DGPoreConcAdvection
        variable = NH3
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./NH3_dgdiff]
        type = DGVarPoreDiffusion
        variable = NH3
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Dz
    [../]

    [./H2O_dgadv]
        type = DGPoreConcAdvection
        variable = H2O
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./H2O_dgdiff]
        type = DGVarPoreDiffusion
        variable = H2O
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Dz
    [../]

[] #END DGKernels

[AuxKernels]

[] #END AuxKernels

[BCs]

    [./NH3_FluxIn]
      type = DGPoreConcFluxStepwiseBC
      variable = NH3
      boundary = 'bottom'
      u_input = 1.1442E-5
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
      input_vals = '1.1442E-5 1.108E-5   1.111E-5    1.127E-5    1.128E-5    1.141E-5'
      input_times = '-30 5.333    14.43    23.78    32.18    41.78'
      time_spans = '0.25 0.25    0.25    0.25    0.25    0.25'
    [../]
    [./NH3_FluxOut]
      type = DGPoreConcFluxBC
      variable = NH3
      boundary = 'top'
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
    [../]

    [./H2O_FluxIn]
      type = DGPoreConcFluxStepwiseBC
      variable = H2O
      boundary = 'bottom'
      u_input = 0.000792
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
      input_vals = '0.000792 0.003043    0.002498    0.001928    0.001350    0.000792'
      input_times = '-30 5.333    14.43    23.78    32.18    41.78'
      time_spans = '0.25 0.25    0.25    0.25    0.25    0.25'
    [../]
    [./H2O_FluxOut]
      type = DGPoreConcFluxBC
      variable = H2O
      boundary = 'top'
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
    [../]

[] #END BCs

[Materials]

[] #END Materials

[Postprocessors]

    [./NH3_out]
        type = SideAverageValue
        boundary = 'top'
        variable = NH3
        execute_on = 'initial timestep_end'
    [../]

    [./NH3_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = NH3
        execute_on = 'initial timestep_end'
    [../]

    [./H2O_out]
        type = SideAverageValue
        boundary = 'top'
        variable = H2O
        execute_on = 'initial timestep_end'
    [../]

    [./H2O_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = H2O
        execute_on = 'initial timestep_end'
    [../]

    [./Z1CuOH]
        type = ElementAverageValue
        variable = q1
        execute_on = 'initial timestep_end'
    [../]

    [./Z2Cu]
        type = ElementAverageValue
        variable = q2
        execute_on = 'initial timestep_end'
    [../]

    [./ZH]
        type = ElementAverageValue
        variable = q3
        execute_on = 'initial timestep_end'
    [../]

    [./total]
        type = ElementAverageValue
        variable = qT
        execute_on = 'initial timestep_end'
    [../]

[] #END Postprocessors

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
  petsc_options_iname ='-ksp_type -pc_type -sub_pc_type -snes_max_it -sub_pc_factor_shift_type -pc_asm_overlap -snes_atol -snes_rtol'
  petsc_options_value = 'gmres lu ilu 100 NONZERO 2 1E-14 1E-12'

  #NOTE: turning off line search can help converge for high Renolds number
  line_search = none
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-10
  nl_max_its = 10
  l_tol = 1e-6
  l_max_its = 300

  start_time = -30.0
  end_time = -28.0
  dtmax = 0.25

  [./TimeStepper]
     type = ConstantDT
     dt = 0.25
  [../]
[] #END Executioner

[Outputs]
  print_linear_residuals = false
  exodus = true
  csv = true
[] #END Outputs
