[GlobalParams]
  dg_scheme = nipg
  sigma = 10
[] #END GlobalParams

[Mesh]

    type = GeneratedMesh
	coord_type = RZ
    #NOTE: For RZ coordinates, x ==> R and y ==> Z (and z ==> nothing)
    dim = 2
    nx = 3
    ny = 20
    xmin = 0.0
    xmax = 2.0    #2cm radius
    ymin = 0.0
    ymax = 5.0    #5cm length

[] # END Mesh

[Variables]

    [./C1]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./C2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 0
    [../]

    [./q1]
        order = FIRST
        family = LAGRANGE
        initial_condition = 0
    [../]

    [./q2]
        order = FIRST
        family = LAGRANGE
        initial_condition = 0
    [../]

    [./qT]
        order = FIRST
        family = LAGRANGE
        initial_condition = 0
    [../]

[] #END Variables

[AuxVariables]

  [./Diff]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.01
  [../]

  [./pore]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.5
  [../]

  [./vel_x]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0
  [../]

  [./vel_y]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1
  [../]

  [./vel_z]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0
  [../]

[] #END AuxVariables

[ICs]

[] #END ICs

[Kernels]

    [./C1_dot]
        type = VariableCoefTimeDerivative
        variable = C1
        coupled_coef = pore
    [../]
    [./C1_gadv]
        type = GPoreConcAdvection
        variable = C1
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./C1_gdiff]
        type = GVarPoreDiffusion
        variable = C1
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Diff
    [../]
    [./transfer_q1]
      type = CoupledPorePhaseTransfer
      variable = C1
      coupled = q1
      porosity = pore
    [../]

    [./q1_rxn]
      type = Reaction
      variable = q1
    [../]
    [./q1_lang1] #site 1
      type = ExtendedLangmuirFunction
      variable = q1
      site_density = 1.0
      main_coupled = C1
      coupled_list = 'C1 C2'
      langmuir_coeff = '0.25 0.75'
    [../]
    [./q1_lang2] #site 2
      type = ExtendedLangmuirFunction
      variable = q1
      site_density = 0.5
      main_coupled = C1
      coupled_list = 'C1'
      langmuir_coeff = '0.75'
    [../]

    [./q2_rxn]
      type = Reaction
      variable = q2
    [../]
    [./q2_lang1] #site 1
      type = ExtendedLangmuirFunction
      variable = q2
      site_density = 1.0
      main_coupled = C2
      coupled_list = 'C1 C2'
      langmuir_coeff = '0.25 0.75'
    [../]

    [./qT_res]
      type = Reaction
      variable = qT
    [../]
    [./qT_sum]
      type = CoupledSumFunction
      variable = qT
      coupled_list = 'q1 q2'
    [../]

    [./C2_dot]
        type = VariableCoefTimeDerivative
        variable = C2
        coupled_coef = pore
    [../]
    [./C2_gadv]
        type = GPoreConcAdvection
        variable = C2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./C2_gdiff]
        type = GVarPoreDiffusion
        variable = C2
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Diff
    [../]
    [./transfer_q2]
      type = CoupledPorePhaseTransfer
      variable = C2
      coupled = q2
      porosity = pore
    [../]

[] #END Kernels

[DGKernels]

    [./C1_dgadv]
        type = DGPoreConcAdvection
        variable = C1
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./C1_dgdiff]
        type = DGVarPoreDiffusion
        variable = C1
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Diff
    [../]

    [./C2_dgadv]
        type = DGPoreConcAdvection
        variable = C2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./C2_dgdiff]
        type = DGVarPoreDiffusion
        variable = C2
        porosity = pore
        Dx = Diff
        Dy = Diff
        Dz = Diff
    [../]

[] #END DGKernels

[AuxKernels]

[] #END AuxKernels

[BCs]

    [./C1_FluxIn]
      type = DGPoreDiffFluxLimitedBC
      variable = C1
      boundary = 'bottom'
      u_input = 1.0
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
      Dx = Diff
      Dy = Diff
      Dz = Diff
    [../]
    [./C1_FluxOut]
      type = DGPoreConcFluxBC
      variable = C1
      boundary = 'top left right'
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
    [../]

    [./C2_FluxIn]
      type = DGPoreDiffFluxLimitedBC
      variable = C2
      boundary = 'bottom'
      u_input = 0.5
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
      Dx = Diff
      Dy = Diff
      Dz = Diff
    [../]
    [./C2_FluxOut]
      type = DGPoreConcFluxBC
      variable = C2
      boundary = 'top left right'
      porosity = pore
      ux = vel_x
      uy = vel_y
      uz = vel_z
    [../]

[] #END BCs

[Materials]

[] #END Materials

[Postprocessors]

    [./C1_exit]
        type = SideAverageValue
        boundary = 'top'
        variable = C1
        execute_on = 'initial timestep_end'
    [../]

    [./q1_avg]
        type = ElementAverageValue
        variable = q1
        execute_on = 'initial timestep_end'
    [../]

    [./q2_avg]
        type = ElementAverageValue
        variable = q2
        execute_on = 'initial timestep_end'
    [../]

    [./qT_avg]
        type = ElementAverageValue
        variable = qT
        execute_on = 'initial timestep_end'
    [../]

    [./C2_exit]
        type = SideAverageValue
        boundary = 'top'
        variable = C2
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
  petsc_options_value = 'gmres asm lu 100 NONZERO 2 1E-14 1E-12'

  #NOTE: turning off line search can help converge for high Renolds number
  line_search = none
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-10
  nl_max_its = 10
  l_tol = 1e-6
  l_max_its = 300

  start_time = 0.0
  end_time = 0.2
  dtmax = 0.5

  [./TimeStepper]
	   #type = SolutionTimeAdaptiveDT
     type = ConstantDT
     dt = 0.1
  [../]
[] #END Executioner

[Outputs]
  print_linear_residuals = true
  exodus = true
  csv = false
[] #END Outputs
