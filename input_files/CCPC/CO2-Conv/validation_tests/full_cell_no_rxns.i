## This example file runs the full cell test WITHOUT reactions coupled
#
#     To maximize stability, all variables should be MONOMIAL except for
#         * pressure
#         * phi_s
#         * phi_e
#
#     These above variables are Poisson/Laplacian Dominated processes and are
#         easier to model with CGFE with LAGRANGE shape functions.
#
#     All other variables should be DGFE with MONOMIAL shape functions to maximize
#         stability and create sharper/smoother results nearest the interfaces.
#
#         - This mixing of methods appears to be relatively efficient and stable
#             (good stability comes from DGFE, but makes the problem size larger)
#             (good efficiency comes from CGFE, but makes the problem less stable)
#             (efficiency is improved with proper Jacobians/PC and good ICs/states)

[GlobalParams]

[] #END GlobalParams

[Problem]

[] #END Problem

[Mesh]
  [file]
    type = FileMeshGenerator
    file = FullCell_ValidationMesh_cm.msh

    ### ========= boundary_name ==========
    # "neg_collector_left"
    # "neg_collector_bottom"
    # "neg_collector_top"
    # "neg_collector_interface_neg_electrode"
    # "neg_electrode_bottom"
    # "neg_electrode_top"
    # "neg_electrode_interface_membrane"
    # "membrane_bottom"
    # "membrane_top"
    # "membrane_interface_pos_electrode"
    # "pos_electrode_bottom"
    # "pos_electrode_top"
    # "pos_electrode_interface_pos_collector"
    # "pos_collector_bottom"
    # "pos_collector_top"
    # "pos_collector_right"

    ### ====== block ========
    # "neg_collector"
    # "neg_electrode"
    # "membrane"
    # "pos_electrode"
    # "pos_collector"
  []

[] # END Mesh

[Variables]
  # solid potentials
  [./phi_s]
      order = FIRST
      family = LAGRANGE
      # initial_condition (setup in ICs block)
      block = 'neg_collector neg_electrode pos_electrode pos_collector'
  [../]

  # electrolyte potentials
  [./phi_e]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # pressure
  [./pressure]
      order = FIRST
      family = LAGRANGE
      initial_condition = 300 # kPa
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # velocity in x
  [./vel_x]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # velocity in y
  [./vel_y]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # reaction variable for negative electrode
  #       Rxn:    V(II) <---> V(III) + e-
  [./r_neg]
      order = FIRST
      family = MONOMIAL
      block = 'neg_electrode'
      [./InitialCondition]
          type = InitialModifiedButlerVolmerReaction

          reaction_rate_const = 0.00105  # cm/min
          equilibrium_potential = -0.255 # V

          reduced_state_vars = 'V_II'
          reduced_state_stoich = '1'

          oxidized_state_vars = 'V_III'
          oxidized_state_stoich = '1'

          electric_potential_difference = phi_diff

          temperature = T_e
          number_of_electrons = 1
          electron_transfer_coef = 0.5
      [../]
  [../]

  # reaction variable for positive electrode
  #       Rxn:    V(IV) <---> V(V) + e-
  [./r_pos]
      order = FIRST
      family = MONOMIAL
      block = 'pos_electrode'
      [./InitialCondition]
          type = InitialModifiedButlerVolmerReaction

          reaction_rate_const = 1.8E-5  # cm/min
          equilibrium_potential = 1.004 # V

          reduced_state_vars = 'V_IV'
          reduced_state_stoich = '1'

          oxidized_state_vars = 'V_V'
          oxidized_state_stoich = '1'

          electric_potential_difference = phi_diff

          temperature = T_e
          number_of_electrons = 1
          electron_transfer_coef = 0.5
      [../]
  [../]

  # Butler-Volmer current density for neg electrode
  [./J_neg]
      order = FIRST
      family = MONOMIAL
      block = 'neg_electrode'
      [./InitialCondition]
          type = InitialButlerVolmerCurrentDensity

          number_of_electrons = 1
          specific_area = As
          rate_var = r_neg
      [../]
      scaling = 1
  [../]

  # Butler-Volmer current density for pos electrode
  [./J_pos]
      order = FIRST
      family = MONOMIAL
      block = 'pos_electrode'
      [./InitialCondition]
          type = InitialButlerVolmerCurrentDensity

          number_of_electrons = 1
          specific_area = As
          rate_var = r_pos
      [../]
      scaling = 1
  [../]

  # Variable for potential difference
  [./phi_diff]
      order = FIRST
      family = MONOMIAL
      block = 'neg_electrode pos_electrode'
      [./InitialCondition]
          type = InitialPotentialDifference
          electrode_potential = phi_s
          electrolyte_potential = phi_e
      [../]
  [../]

  # Electrolyte current density in x (C/cm^2/min)
  [./ie_x]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1e-20
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # Electrolyte current density in y (C/cm^2/min)
  [./ie_y]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1e-20
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # electrode current density in x (C/cm^2/min)
  [./is_x]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1e-20
      block = 'neg_collector neg_electrode pos_electrode pos_collector'
  [../]

  # electrode current density in y (C/cm^2/min)
  [./is_y]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1e-20
      block = 'neg_collector neg_electrode pos_electrode pos_collector'
  [../]

  # H2O
  [./H2O]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0042 #mol/cm^3
      block = 'neg_electrode membrane pos_electrode'
  [../]

[]

[AuxVariables]
  # Temporary location of protons and other concentrations
  [./H_p]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0012 #mol/cm^3
      block = 'neg_electrode membrane pos_electrode'
  [../]

  [./HSO4_m]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0012 #mol/cm^3
      block = 'neg_electrode pos_electrode'
  [../]

  [./V_II]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.000027 #mol/cm^3
      block = 'neg_electrode'
  [../]

  [./V_III]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.001053 #mol/cm^3
      block = 'neg_electrode'
  [../]

  [./V_IV]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.001053 #mol/cm^3
      block = 'pos_electrode'
  [../]

  [./V_V]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.000027 #mol/cm^3
      block = 'pos_electrode'
  [../]

  # Diffusivities
  [./D_H2O]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0012 #cm^2/min
      block = 'neg_electrode membrane pos_electrode'
  [../]
  [./D_H_p]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0012 #cm^2/min
      block = 'neg_electrode membrane pos_electrode'
  [../]
  [./D_V_II]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1.18745E-4 #cm^2/min
      block = 'neg_electrode'
  [../]
  [./D_V_III]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1.18745E-4 #cm^2/min
      block = 'neg_electrode'
  [../]
  [./D_V_IV]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1.9296E-4 #cm^2/min
      block = 'pos_electrode'
  [../]
  [./D_V_V]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1.9296E-4 #cm^2/min
      block = 'pos_electrode'
  [../]

  # electrode porosity (switch to 1 inside membrane)
  [./eps]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.68
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # effective solid volume (1-eps)^(3/2)
  [./eff_sol_vol]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.18101936
      block = 'neg_electrode pos_electrode'
  [../]

  # velocity in z
  [./vel_z]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.0
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # water viscosity
  [./viscosity]
      order = FIRST
      family = MONOMIAL
      initial_condition = 1.667E-8 # kPa*min
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # electrolyte temperature
  [./T_e]
      order = FIRST
      family = MONOMIAL
      initial_condition = 300 # K
      block = 'neg_electrode membrane pos_electrode'
  [../]

  # solid temperature (may need separate T for membrane?)
  [./T_s]
      order = FIRST
      family = MONOMIAL
      initial_condition = 300 # K
      block = 'neg_collector neg_electrode membrane pos_electrode pos_collector'
  [../]

  # electrode conductivity (C/V/cm/min)
  [./sigma_s]
      order = FIRST
      family = MONOMIAL
      initial_condition = 300     # 500 S/m  : 1 S = 1 A/V = 1 C/V/s
      block = 'neg_electrode pos_electrode'
  [../]

  # collector conductivity (C/V/cm/min)
  [./sigma_c]
      order = FIRST
      family = MONOMIAL
      initial_condition = 600  # 1000 S/m  : 1 S = 1 A/V = 1 C/V/s
      block = 'neg_collector pos_collector'
  [../]

  # = (df^2/K/mu) * (eps^3/(1-eps)^2)  [cm^2/kPa/min]
  #
  #   df = 0.001 cm
  #   mu = 1.667E-8 kPa*min (10^-3 Pa*s)
  #   K = 5.55
  #   eps = 0.68
  [./DarcyCoeff]
      order = FIRST
      family = MONOMIAL
      initial_condition = 33.189
      block = 'neg_electrode pos_electrode'
  [../]

  # = kp / mu   [cm^2/kPa/min]
  #
  #   kp = 1.58E-14 cm^2
  #   mu = 1.667E-8 kPa*min (10^-3 Pa*s)
  [./SchloeglCoeff]
      order = FIRST
      family = MONOMIAL
      initial_condition = 9.4798E-7
      block = 'membrane'
  [../]

  # = (ko / mu) * (F*C) * f   [(cm^2/kPa/min) * (C/mol * mol/cm^3) * (kPa*cm^3/J)] = [C*cm^2/J/min]
  #
  #   ko = 1.13E-15 cm^2
  #   mu = 1.667E-8 kPa*min (10^-3 Pa*s)
  #
  #   F = 96,485.3 C/mol
  #   C = 0.0012 mol/cm^3 (should be coupled variable)
  #
  #   f = conversion factor necessary to deal with complex units
  #     = 0.001 kPa*cm^3/J
  #       [Will ultimately depend on units defined by all other variables]
  [./SchloeglElecCoeff]
      order = FIRST
      family = MONOMIAL
      initial_condition = 7.8485E-9
      block = 'membrane'
  [../]

  #Specific surface area (adjusted)
  [./As]
    order = FIRST
    family = MONOMIAL
    initial_condition = 2E4  # cm^-1
    block = 'neg_electrode pos_electrode'
  [../]

  # Keff calculation to check values for problems
  [./Keff]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0 # C/V/cm/min
      block = 'neg_electrode membrane pos_electrode'
  [../]
[]

[ICs]
  ### ==================== Solid Potentials ==========================
  [./phi_s_neg_side]
      type = ConstantIC
      variable = phi_s
      value = -0.255 # in V
      block = 'neg_collector neg_electrode'
  [../]
  [./phi_s_pos_side]
      type = ConstantIC
      variable = phi_s
      value = 1.004 # in V
      block = 'pos_electrode pos_collector'
  [../]
[]

[Kernels]
  ### ==================== Solid Potentials ==========================
  # in electrodes
  [./phi_s_conductivity_in_electrode]
      type = ElectrodePotentialConductivity
      variable = phi_s
      solid_frac = eff_sol_vol
      conductivity = sigma_s
      block = 'neg_electrode pos_electrode'
  [../]

  # in collector
  [./phi_s_conductivity_in_collector]
      type = ElectrodePotentialConductivity
      variable = phi_s
      solid_frac = 1
      conductivity = sigma_c
      block = 'neg_collector pos_collector'
  [../]

  # reactions in electrodes
  [./phi_s_J_neg]
      type = ScaledWeightedCoupledSumFunction
      variable = phi_s
      coupled_list = 'J_neg'
      weights = '-1'
      block = 'neg_electrode'
  [../]
  [./phi_s_J_pos]
      type = ScaledWeightedCoupledSumFunction
      variable = phi_s
      coupled_list = 'J_pos'
      weights = '-1'
      block = 'pos_electrode'
  [../]

  ### ==================== Electrolyte Potentials ==========================
  # in electrodes
  [./phi_e_conductivity_in_neg_electrodes]
      type = ElectrolytePotentialConductivity
      variable = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]
  [./phi_e_conductivity_in_pos_electrodes]
      type = ElectrolytePotentialConductivity
      variable = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]
  [./phi_e_ionic_conductivity_in_neg_electrodes]
      type = ElectrolyteIonConductivity
      variable = phi_e
      porosity = eps
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]
  [./phi_e_ionic_conductivity_in_pos_electrodes]
      type = ElectrolyteIonConductivity
      variable = phi_e
      porosity = eps
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]

  # in membrane
  [./phi_e_conductivity_in_membrane]
      type = ElectrolytePotentialConductivity
      variable = phi_e
      porosity = 1
      temperature = T_e
      ion_conc = 'H_p'
      ion_valence = '1'
      diffusion = 'D_H_p'
      block = 'membrane'
  [../]

  # reactions in electrodes
  #     NOTE: BCs for phi_e may NOT be correct... does not converge with this
  #     NOTE 2: This DOES solve if using NEWTON as the solver, may indicate
  #             poor jacobians on my part, or something else...
  #     NOTE 3: After updating Keff in electrolyte, converges with asm/lu
  #             (does not converge well with ksp)
  [./phi_e_J_neg]
      type = ScaledWeightedCoupledSumFunction
      variable = phi_e
      coupled_list = 'J_neg'
      weights = '1'
      block = 'neg_electrode'
  [../]
  [./phi_e_J_pos]
      type = ScaledWeightedCoupledSumFunction
      variable = phi_e
      coupled_list = 'J_pos'
      weights = '1'
      block = 'pos_electrode'
  [../]

  ### ==================== Pressure Gradients ==========================
  # in electrodes
  [./pressure_laplace_electrodes]
      type = VariableLaplacian
      variable = pressure
      coupled_coef = DarcyCoeff
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane
  [./pressure_laplace_membrane]
      type = VariableLaplacian
      variable = pressure
      coupled_coef = SchloeglCoeff
      block = 'membrane'
  [../]

  ### ==================== Fluid Velocities ==========================
  # equals sign
  [./v_x_equ]
      type = Reaction
      variable = vel_x
  [../]
  [./v_y_equ]
      type = Reaction
      variable = vel_y
  [../]

  # in electrodes
  [./x_darcy]
      type = VariableVectorCoupledGradient
      variable = vel_x
      coupled = pressure
      ux = DarcyCoeff
      block = 'neg_electrode pos_electrode'
  [../]

  [./y_darcy]
      type = VariableVectorCoupledGradient
      variable = vel_y
      coupled = pressure
      uy = DarcyCoeff
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane
  [./x_schloegl]
      type = VariableVectorCoupledGradient
      variable = vel_x
      coupled = pressure
      ux = SchloeglCoeff
      block = 'membrane'
  [../]
  [./x_schloegl_ele]
      type = VariableVectorCoupledGradient
      variable = vel_x
      coupled = phi_e
      ux = SchloeglElecCoeff
      block = 'membrane'
  [../]

  [./y_schloegl]
      type = VariableVectorCoupledGradient
      variable = vel_y
      coupled = pressure
      uy = SchloeglCoeff
      block = 'membrane'
  [../]
  [./y_schloegl_ele]
      type = VariableVectorCoupledGradient
      variable = vel_y
      coupled = phi_e
      uy = SchloeglElecCoeff
      block = 'membrane'
  [../]


  ## =============== Butler-Volmer Kinetics ================
  [./r_equ_neg]
      type = Reaction
      variable = r_neg
  [../]
  [./r_rxn_neg]
      type = ModifiedButlerVolmerReaction
      variable = r_neg

      reaction_rate_const = 0.00105  # cm/min
      equilibrium_potential = -0.255 # V

      reduced_state_vars = 'V_II'
      reduced_state_stoich = '1'

      oxidized_state_vars = 'V_III'
      oxidized_state_stoich = '1'

      electric_potential_difference = phi_diff

      temperature = T_e
      number_of_electrons = 1
      electron_transfer_coef = 0.5
  [../]

  [./r_equ_pos]
      type = Reaction
      variable = r_pos
  [../]
  [./r_rxn_pos]
      type = ModifiedButlerVolmerReaction
      variable = r_pos

      reaction_rate_const = 1.8E-5  # cm/min
      equilibrium_potential = 1.004 # V

      reduced_state_vars = 'V_IV'
      reduced_state_stoich = '1'

      oxidized_state_vars = 'V_V'
      oxidized_state_stoich = '1'

      electric_potential_difference = phi_diff

      temperature = T_e
      number_of_electrons = 1
      electron_transfer_coef = 0.5
  [../]


  ## =============== Butler-Volmer Current ================
  [./J_equ_neg]
      type = Reaction
      variable = J_neg
  [../]
  [./J_rxn_neg]
      type = ButlerVolmerCurrentDensity
      variable = J_neg

      number_of_electrons = 1
      specific_area = As
      rate_var = r_neg
  [../]

  [./J_equ_pos]
      type = Reaction
      variable = J_pos
  [../]
  [./J_rxn_pos]
      type = ButlerVolmerCurrentDensity
      variable = J_pos

      number_of_electrons = 1
      specific_area = As
      rate_var = r_pos
  [../]

  ## =============== Potential Difference ==================
  [./phi_diff_equ]
      type = Reaction
      variable = phi_diff
  [../]
  [./phi_diff_sum]
      type = WeightedCoupledSumFunction
      variable = phi_diff
      coupled_list = 'phi_s phi_e'
      weights = '1 -1'
  [../]


  ### ===================== Electrolyte Current ======================
  # --------------- Current density in x-dir from potential gradient ------------
  #  ie_x
  [./ie_x_equ]
      type = Reaction
      variable = ie_x
  [../]

  #  -K*grad(phi_e)_x   where K=f(ions, diff, etc....)
  [./ie_x_phigrad_neg_electrode]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_x
      direction = 0         # 0=x
      electric_potential = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]

  #  -K*grad(phi_e)_x   where K=f(ions, diff, etc....)
  [./ie_x_phigrad_pos_electrode]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_x
      direction = 0         # 0=x
      electric_potential = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]

  #  -K*grad(phi_e)_x   where K=f(ions, diff, etc....)
  [./ie_x_phigrad_membrane]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_x
      direction = 0         # 0=x
      electric_potential = phi_e
      porosity = 1
      temperature = T_e
      ion_conc = 'H_p'
      ion_valence = '1'
      diffusion = 'D_H_p'
      block = 'membrane'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_x )
  [./ie_x_iongrad_neg_electrode]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_x
      direction = 0         # 0=x
      porosity = eps
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_x )
  [./ie_x_iongrad_pos_electrode]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_x
      direction = 0         # 0=x
      porosity = eps
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_x )
  [./ie_x_iongrad_membrane]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_x
      direction = 0         # 0=x
      porosity = 1
      ion_conc = 'H_p'
      ion_valence = '1'
      diffusion = 'D_H_p'
      block = 'membrane'
  [../]


  # --------------- Current density in y-dir from potential gradient ---------------
  #  ie_y
  [./ie_y_equ]
      type = Reaction
      variable = ie_y
  [../]

  #  -K*grad(phi_e)_y   where K=f(ions, diff, etc....)
  [./ie_y_phigrad_neg_electrode]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_y
      direction = 1         # 1=y
      electric_potential = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]

  #  -K*grad(phi_e)_y   where K=f(ions, diff, etc....)
  [./ie_y_phigrad_pos_electrode]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_y
      direction = 1         # 1=y
      electric_potential = phi_e
      porosity = eps
      temperature = T_e
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]

  #  -K*grad(phi_e)_y   where K=f(ions, diff, etc....)
  [./ie_y_phigrad_membrane]
      type = ElectrolyteCurrentFromPotentialGradient
      variable = ie_y
      direction = 1         # 1=y
      electric_potential = phi_e
      porosity = 1
      temperature = T_e
      ion_conc = 'H_p'
      ion_valence = '1'
      diffusion = 'D_H_p'
      block = 'membrane'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_y )
  [./ie_y_iongrad_neg_electrode]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_y
      direction = 1         # 1=y
      porosity = eps
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      block = 'neg_electrode'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_y )
  [./ie_y_iongrad_pos_electrode]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_y
      direction = 1         # 1=y
      porosity = eps
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      block = 'pos_electrode'
  [../]

  #  -F*eps*SUM( zj*Dj*grad(ion)_y )
  [./ie_y_iongrad_membrane]
      type = ElectrolyteCurrentFromIonGradient
      variable = ie_y
      direction = 1         # 1=y
      porosity = 1
      ion_conc = 'H_p'
      ion_valence = '1'
      diffusion = 'D_H_p'
      block = 'membrane'
  [../]

  ### ======================= Electrode/Collector Current ==================
  # -------------- Current density in x-dir from potential gradient --------------
  #  is_x
  [./is_x_equ]
      type = Reaction
      variable = is_x
  [../]

  #  -sigma*(1-eps)*grad(phi_s)_x
  [./is_x_phigrad_electrode]
      type = ElectrodeCurrentFromPotentialGradient
      variable = is_x
      direction = 0         # 0=x
      electric_potential = phi_s
      solid_frac = eff_sol_vol
      conductivity = sigma_s
      block = 'neg_electrode pos_electrode'
  [../]

  #  -sigma*(1-eps)*grad(phi_s)_x
  [./is_x_phigrad_collector]
      type = ElectrodeCurrentFromPotentialGradient
      variable = is_x
      direction = 0         # 0=x
      electric_potential = phi_s
      solid_frac = 1
      conductivity = sigma_c
      block = 'neg_collector pos_collector'
  [../]

  # ----------------- Current density in y-dir from potential gradient ----------------
  #  is_y
  [./is_y_equ]
      type = Reaction
      variable = is_y
  [../]

  #  -sigma*(1-eps)*grad(phi_s)_y
  [./is_y_phigrad_electrode]
      type = ElectrodeCurrentFromPotentialGradient
      variable = is_y
      direction = 1         # 1=y
      electric_potential = phi_s
      solid_frac = eff_sol_vol
      conductivity = sigma_s
      block = 'neg_electrode pos_electrode'
  [../]

  #  -sigma*(1-eps)*grad(phi_s)_y
  [./is_y_phigrad_collector]
      type = ElectrodeCurrentFromPotentialGradient
      variable = is_y
      direction = 1         # 1=y
      electric_potential = phi_s
      solid_frac = 1
      conductivity = sigma_c
      block = 'neg_collector pos_collector'
  [../]


  ### ==================== H2O Transport ==========================
  # DG methods must apply same equations to full transport space for connectivity
  #   Non-transport kernels (such as reactions and time derivatives) are allowed
  #   to be different in each sub-domain, but the transport kernels (such as
  #   advection and diffusion) must be the same.

  # Divided Sub-domain kernels
  [./H2O_dot_electrodes]
      type = VariableCoefTimeDerivative
      variable = H2O
      coupled_coef = eps
      block = 'neg_electrode pos_electrode'
  [../]
  [./H2O_dot_membrane]
      type = VariableCoefTimeDerivative
      variable = H2O
      coupled_coef = 1
      block = 'membrane'
  [../]

  # Transport kernels
  [./H2O_gadv]
      type = GPoreConcAdvection
      variable = H2O
      porosity = 1
      ux = vel_x
      uy = vel_y
      uz = vel_z
  [../]
  [./H2O_gdiff]
      type = GVarPoreDiffusion
      variable = H2O
      porosity = eps
      Dx = D_H2O
      Dy = D_H2O
      Dz = D_H2O
  [../]
[]

[DGKernels]
  ### ==================== H2O Transport ==========================
  [./H2O_dgadv]
      type = DGPoreConcAdvection
      variable = H2O
      porosity = 1
      ux = vel_x
      uy = vel_y
      uz = vel_z
  [../]
  [./H2O_dgdiff]
      type = DGVarPoreDiffusion
      variable = H2O
      porosity = eps
      Dx = D_H2O
      Dy = D_H2O
      Dz = D_H2O
  [../]
[]

[AuxKernels]

  ### ==================== Variations in eps =====================
  # in electrode
  [./eps_elec]
      type = ConstantAux
      variable = eps
      value = 0.68

      execute_on = 'initial timestep_end'
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane
  [./eps_mem]
      type = ConstantAux
      variable = eps
      value = 0.999

      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

  ### ==================== Variations in D_H2O =====================
  # Units: cm^2/min  (D = 2.3E-9 m^2/s in electrode, Deff = 5.75E-10 m^2/s in membrane)
  # in electrode (D*eps^0.5)
  [./D_H2O_elec]
      type = ConstantAux
      variable = D_H2O
      value = 0.0011379772

      execute_on = 'initial timestep_end'
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane (Deff)
  [./D_H2O_mem]
      type = ConstantAux
      variable = D_H2O
      value = 3.45E-4

      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

  ### ==================== Variations in D_H_p =====================
  # Units: cm^2/min  (D = 9.31E-9 m^2/s in electrode, Deff = 1.4E-9 m^2/s in membrane)
  # in electrode (D*eps^0.5)
  [./D_H_p_elec]
      type = ConstantAux
      variable = D_H_p
      value = 0.0046063336

      execute_on = 'initial timestep_end'
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane (Deff)
  [./D_H_p_mem]
      type = ConstantAux
      variable = D_H_p
      value = 8.40E-4

      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

  ### ====================== Darcy Flow Parameters ======================
  #in electrode
  [./darcy_calc]
      type = KozenyCarmanDarcyCoefficient
      variable = DarcyCoeff
      porosity = eps
      viscosity = viscosity
      particle_diameter = 0.001  #cm
      kozeny_carman_const = 5.55
      execute_on = 'initial timestep_end'
      block = 'neg_electrode pos_electrode'
  [../]

  # in membrane
  [./schloegl_darcy_calc]
      type = SchloeglDarcyCoefficient
      variable = SchloeglCoeff
      hydraulic_permeability = 1.58E-14 # cm^2
      viscosity = viscosity             # kPa*min
      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

  [./schloegl_ele_calc]
      type = SchloeglElectrokineticCoefficient
      variable = SchloeglElecCoeff
      electrokinetic_permeability = 1.13E-15  # cm^2
      viscosity = viscosity                   # kPa*min
      ion_conc = H_p                       # mol/cm^3
      conversion_factor = 0.001               # kPa*cm^3/J
      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

  [./Keff_calc_neg_electrodes]
      type = ElectrolyteConductivity
      variable = Keff
      temperature = T_e
      ion_conc = 'H_p V_II V_III'
      diffusion = 'D_H_p D_V_II D_V_III'
      ion_valence = '1 2 3'
      execute_on = 'initial timestep_end'
      block = 'neg_electrode'
  [../]

  [./Keff_calc_pos_electrodes]
      type = ElectrolyteConductivity
      variable = Keff
      temperature = T_e
      ion_conc = 'H_p V_IV V_V'
      diffusion = 'D_H_p D_V_IV D_V_V'
      ion_valence = '1 2 1'
      execute_on = 'initial timestep_end'
      block = 'pos_electrode'
  [../]

  [./Keff_calc_membrane]
      type = ElectrolyteConductivity
      variable = Keff
      temperature = T_e
      ion_conc = 'H_p'
      diffusion = 'D_H_p'
      ion_valence = '1'
      execute_on = 'initial timestep_end'
      block = 'membrane'
  [../]

[]

[BCs]
  ### ==================== Solid Potentials ==========================
  # zero electron flux at all interfaces (except far left and far right)
  #[./phi_s_zero_flux_neg_side]
  #    type = NeumannBC
  #    variable = phi_s
  #    boundary = 'neg_collector_top neg_collector_bottom
  #                neg_electrode_top neg_electrode_bottom
  #                neg_electrode_interface_membrane'
  #    value = 0
  #[../]

  # This one causes a segfault, but not the one above?
  #[./phi_s_zero_flux_pos_side]
  #    type = NeumannBC
  #    variable = phi_s
  #    boundary = 'pos_collector_top pos_collector_bottom
  #                pos_electrode_top pos_electrode_bottom
  #                membrane_interface_pos_electrode'
  #    value = 0
  #[../]

  # Applied current on the neg & pos collector plates
  #   NOTE: SIGNS ARE REVERSED FOR DISCHARGING

  # NOTE 2: I CAN have 2 BCs on same side, as long as they are of different types!!!
  # ---- This is what is in the original reference -------
  [./phi_s_neg_side_current_charging]
      type = NeumannBC
      variable = phi_s
      boundary = 'neg_collector_left'
      #
      ## -I/a for charging (where I=current = 10 A && a=surface area = 10cm x 10cm)
      # 1 A = 1 C/s ==>  10 A = 600 C/min
      # value = I/A = 6 C/min/cm^2
      value = -6.0
  [../]

  # ---- This is what is in the Sandia reference -------
  #   (This BC type may be more numerically stable)
  [./phi_s_neg_side_dirichlet]
      type = DirichletBC
      variable = phi_s
      boundary = 'neg_collector_left'
      #
      ## edge value was defined at 0 V
      value = 0 # in V
  [../]

  [./phi_s_pos_side_current_charging]
      type = NeumannBC
      variable = phi_s
      boundary = 'pos_collector_right'

      ## I/a for charging (where I=current = 10 A && a=surface area = 10cm x 10cm)
      # 1 A = 1 C/s ==>  10 A = 600 C/min
      # value = I/A = 6 C/min/cm^2
      value = 6.0
  [../]


  ### ==================== Electrolyte Potentials ==========================
  # zero electron flux at top and bottom of membrane
  #[./phi_e_zero_flux_membrane]
  #    type = NeumannBC
  #    variable = phi_e
  #    boundary = 'membrane_bottom membrane_top'
  #    value = 0
  #[../]

  # This one causes a segfault, but not the one above?
  # zero electron flux at interface between electrodes and collectors
  #[./phi_e_zero_flux_interfaces]
  #    type = NeumannBC
  #    variable = phi_e
  #    boundary = 'neg_collector_interface_neg_electrode
  #                pos_electrode_interface_pos_collector'
  #    value = 0
  #[../]


  ### ==================== Pressure ==========================
  # exit pressure
  [./press_at_exit]
      type = DirichletBC
      variable = pressure
      boundary = 'pos_electrode_top neg_electrode_top'
      value = 300 # kPa
  [../]

  # inlet pressure gradient from velocity
  [./press_grad_at_inlet]
      type = NeumannBC
      variable = pressure
      boundary = 'pos_electrode_bottom neg_electrode_bottom'
      value = 66   # vel in cm/min (0.37 to 1.1 cm/s)
  [../]


  ### ==================== H2O ==========================
  [./H2O_FluxIn]
      type = DGPoreConcFluxBC
      variable = H2O
      boundary = 'pos_electrode_bottom neg_electrode_bottom'
      porosity = 1
      ux = vel_x
      uy = vel_y
      uz = vel_z
      u_input = 0.0042
  [../]
  [./H2O_FluxOut]
      type = DGPoreConcFluxBC
      variable = H2O
      boundary = 'pos_electrode_top neg_electrode_top'
      porosity = 1
      ux = vel_x
      uy = vel_y
      uz = vel_z
  [../]
[]


[Postprocessors]

  [./phi_s_neg_side]
      type = ElementAverageValue
      block = 'neg_electrode'
      variable = phi_s
      execute_on = 'initial timestep_end'
  [../]

  [./phi_s_pos_side]
      type = ElementAverageValue
      block = 'pos_electrode'
      variable = phi_s
      execute_on = 'initial timestep_end'
  [../]

  [./phi_diff_neg_side]
      type = ElementAverageValue
      block = 'neg_electrode'
      variable = phi_diff
      execute_on = 'initial timestep_end'
  [../]

  [./phi_diff_pos_side]
      type = ElementAverageValue
      block = 'pos_electrode'
      variable = phi_diff
      execute_on = 'initial timestep_end'
  [../]

  [./J_neg_side]
      type = ElementAverageValue
      block = 'neg_electrode'
      variable = J_neg
      execute_on = 'initial timestep_end'
  [../]

  [./J_pos_side]
      type = ElementAverageValue
      block = 'pos_electrode'
      variable = J_pos
      execute_on = 'initial timestep_end'
  [../]

  [./Keff_pos_elec]
      type = ElementAverageValue
      block = 'pos_electrode'
      variable = Keff
      execute_on = 'initial timestep_end'
  [../]

  [./Keff_neg_elec]
      type = ElementAverageValue
      block = 'neg_electrode'
      variable = Keff
      execute_on = 'initial timestep_end'
  [../]

  [./Keff_mem]
      type = ElementAverageValue
      block = 'membrane'
      variable = Keff
      execute_on = 'initial timestep_end'
  [../]
[]

[Executioner]
  type = Transient
  scheme = implicit-euler

  # NOTE: Add arg -ksp_view to get info on methods used at linear steps
  petsc_options = '-snes_converged_reason

                    -ksp_gmres_modifiedgramschmidt'

  # NOTE: The sub_pc_type arg not used if pc_type is ksp,
  #       Instead, set the ksp_ksp_type to the pc method
  #       you want. Then, also set the ksp_pc_type to be
  #       the terminal preconditioner.
  #
  # Good terminal precon options: lu, ilu, asm, gasm, pbjacobi
  #                               bjacobi, redundant, telescope
  petsc_options_iname ='-ksp_type
                        -pc_type

                        -sub_pc_type

                        -snes_max_it

                        -sub_pc_factor_shift_type
                        -pc_factor_shift_type
                        -ksp_pc_factor_shift_type

                        -pc_asm_overlap

                        -snes_atol
                        -snes_rtol

                        -ksp_ksp_type
                        -ksp_pc_type'

  petsc_options_value = 'fgmres
                         ksp

                         lu

                         20

                         NONZERO
                         NONZERO
                         NONZERO

                         5

                         1E-8
                         1E-8

                         fgmres
                         lu'

  #NOTE: turning off line search can help converge for high Renolds number
  line_search = none
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-10
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-10
  nl_max_its = 20
  l_tol = 1e-6
  l_max_its = 20

  start_time = -0.025
  end_time = 0.1
  dtmax = 0.025

  [./TimeStepper]
		  type = ConstantDT
      dt = 0.025
  [../]

[] #END Executioner

[Preconditioning]
    [./SMP_PJFNK]
      type = SMP
      full = true
      solve_type = pjfnk
    [../]

[] #END Preconditioning

[Outputs]

    exodus = true
    csv = true
    print_linear_residuals = true

[] #END Outputs
