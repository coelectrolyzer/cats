
[GlobalParams]
  # 'dg_scheme' and 'sigma' are parameters for the DG kernels
  dg_scheme = nipg
  sigma = 10

[] #END GlobalParams

[Problem]
    coord_type = RZ
    #NOTE: For RZ coordinates, x ==> R and y ==> Z (and z ==> nothing)
[] #END Problem

[Mesh]
    type = GeneratedMesh
    dim = 2
    nx = 1
    ny = 10
    xmin = 0.0
    xmax = 1.0    #2cm diameter (1cm radius)
    ymin = 0.0
    ymax = 5.0    #5cm length
[] # END Mesh

[Variables]

## Gas phase variable lists
    [./O2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./O2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./H2O]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./H2Ow]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./NH3]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./NH3w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./NOx]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./NOxw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./N2O]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./N2Ow]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./CO]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./COw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./CO2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./CO2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./N2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./N2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./H2]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./H2w]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./HC]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

    [./HCw]
        order = FIRST
        family = MONOMIAL
        initial_condition = 1E-15
    [../]

## Reaction variable list
    [./r1]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r2]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r3]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r4]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r5]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r6]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r7]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r8]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r10]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r11]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r12]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r14]
        order = FIRST
        family = MONOMIAL
    [../]

    [./r15]
        order = FIRST
        family = MONOMIAL
    [../]

## Inhibition Variables
  [./R_CO]
    order = FIRST
    family = MONOMIAL
     [./InitialCondition]
         type = InitialLangmuirInhibition
         temperature = temp
         coupled_list = 'COw'
         pre_exponentials = '2.59'
         activation_energies = '-36284.4'
     [../]
  [../]

  [./R_HC]
    order = FIRST
    family = MONOMIAL
     [./InitialCondition]
         type = InitialLangmuirInhibition
         temperature = temp
         coupled_list = 'HCw'
         pre_exponentials = '0'
         activation_energies = '0'
     [../]
  [../]

[] #END Variables

[AuxVariables]

  [./temp]
      order = FIRST
      family = MONOMIAL
      initial_condition = 379
  [../]

  [./press]
      order = FIRST
      family = MONOMIAL
      initial_condition = 101.35
  [../]

  [./D]
    order = FIRST
    family = MONOMIAL
  [../]

  # e_b
  [./pore]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.775
  [../]

  # non_pore = (1 - pore)
  [./non_pore]
      order = FIRST
      family = MONOMIAL
  [../]

  # ew value
  [./micro_pore]
      order = FIRST
      family = MONOMIAL
      initial_condition = 0.4
  [../]

  # total_pore = ew* (1 - pore)
  # assume ew = 0.4
  [./total_pore]
      order = FIRST
      family = MONOMIAL
  [../]

  # area to volume ratio for monolith - auto calculated in properties
  [./Ga]
      order = FIRST
      family = MONOMIAL
  [../]

  # hydraulic diameter for monolith - auto calculated in properties
  [./dh]
      order = FIRST
      family = MONOMIAL
  [../]

  # effective thickness of microscale
  [./wt]
      order = FIRST
      family = MONOMIAL
  [../]

  # Mass transfer coefficient - auto calculated in properties
  [./km]
      order = FIRST
      family = MONOMIAL
  [../]

  [./vel_x]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0
  [../]

  [./vel_y]
      order = FIRST
      family = MONOMIAL
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
# ------------------- Start Gas Balances ----------------------
# -------------------------------------------------------------
    # =============== Bulk phase O2 ===============
    [./O2_dot]
        type = VariableCoefTimeDerivative
        variable = O2
        coupled_coef = pore
    [../]
    [./O2_gadv]
        type = GPoreConcAdvection
        variable = O2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./O2_gdiff]
        type = GVarPoreDiffusion
        variable = O2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./O2w_trans]
        type = FilmMassTransfer
        variable = O2
        coupled = O2w

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase O2 ===============
    [./O2w_dot]
        type = VariableCoefTimeDerivative
        variable = O2w
        coupled_coef = total_pore
    [../]
    [./O2_trans]
        type = FilmMassTransfer
        variable = O2w
        coupled = O2

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./O2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = O2w
        coupled_list = 'r1 r2 r15 r3'
        weights = '-0.5 -0.5 -0.25 -7'
        scale = 1
    [../]

    # =============== Bulk phase H2O ===============
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
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./H2Ow_trans]
        type = FilmMassTransfer
        variable = H2O
        coupled = H2Ow

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase H2O ===============
    [./H2Ow_dot]
        type = VariableCoefTimeDerivative
        variable = H2Ow
        coupled_coef = total_pore
    [../]
    [./H2O_trans]
        type = FilmMassTransfer
        variable = H2Ow
        coupled = H2O

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./H2Ow_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = H2Ow
        coupled_list = 'r2 r8 r11 r6 r7 r14 r15 r3 r10 r12'
        weights = '1 -1.5 -1 1 1 1 1.5 5 5 -4'
        scale = 1
    [../]

    # =============== Bulk phase NH3 ===============
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
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./NH3w_trans]
        type = FilmMassTransfer
        variable = NH3
        coupled = NH3w

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase NH3 ===============
    [./NH3w_dot]
        type = VariableCoefTimeDerivative
        variable = NH3w
        coupled_coef = total_pore
    [../]
    [./NH3_trans]
        type = FilmMassTransfer
        variable = NH3w
        coupled = NH3

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    [./NH3w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = NH3w
        coupled_list = 'r8 r6 r15'
        weights = '1 1 -1'
        scale = 1
    [../]

    # =============== Bulk phase NO ===============
    [./NOx_dot]
        type = VariableCoefTimeDerivative
        variable = NOx
        coupled_coef = pore
    [../]
    [./NOx_gadv]
        type = GPoreConcAdvection
        variable = NOx
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./NOx_gdiff]
        type = GVarPoreDiffusion
        variable = NOx
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./NOxw_trans]
        type = FilmMassTransfer
        variable = NOx
        coupled = NOxw

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase NO ===============
    [./NOxw_dot]
        type = VariableCoefTimeDerivative
        variable = NOxw
        coupled_coef = total_pore
    [../]
    [./NOx_trans]
        type = FilmMassTransfer
        variable = NOxw
        coupled = NOx

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./NOxw_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = NOxw
        coupled_list = 'r4 r5 r8 r6 r7 r14 r15 r10'
        weights = '-1 -2 -1 -1 -1 -2 -1 -14'
        scale = 1
    [../]

    # =============== Bulk phase N2O ===============
    [./N2O_dot]
        type = VariableCoefTimeDerivative
        variable = N2O
        coupled_coef = pore
    [../]
    [./N2O_gadv]
        type = GPoreConcAdvection
        variable = N2O
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./N2O_gdiff]
        type = GVarPoreDiffusion
        variable = N2O
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./N2Ow_trans]
        type = FilmMassTransfer
        variable = N2O
        coupled = N2Ow

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase N2O ===============
    [./N2Ow_dot]
        type = VariableCoefTimeDerivative
        variable = N2Ow
        coupled_coef = total_pore
    [../]
    [./N2O_trans]
        type = FilmMassTransfer
        variable = N2Ow
        coupled = N2O

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    [./N2Ow_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = N2Ow
        coupled_list = 'r5 r14'
        weights = '1 1'
        scale = 1
    [../]

    # =============== Bulk phase CO ===============
    [./CO_dot]
        type = VariableCoefTimeDerivative
        variable = CO
        coupled_coef = pore
    [../]
    [./CO_gadv]
        type = GPoreConcAdvection
        variable = CO
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO_gdiff]
        type = GVarPoreDiffusion
        variable = CO
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./COw_trans]
        type = FilmMassTransfer
        variable = CO
        coupled = COw

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase CO ===============
    [./COw_dot]
        type = VariableCoefTimeDerivative
        variable = COw
        coupled_coef = total_pore
    [../]
    [./CO_trans]
        type = FilmMassTransfer
        variable = COw
        coupled = CO

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./COw_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = COw
        coupled_list = 'r1 r4 r5 r8 r11 r12'
        weights = '-1 -1 -1 -2.5 -1 5'
        scale = 1
    [../]

    # =============== Bulk phase CO2 ===============
    [./CO2_dot]
        type = VariableCoefTimeDerivative
        variable = CO2
        coupled_coef = pore
    [../]
    [./CO2_gadv]
        type = GPoreConcAdvection
        variable = CO2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO2_gdiff]
        type = GVarPoreDiffusion
        variable = CO2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./CO2w_trans]
        type = FilmMassTransfer
        variable = CO2
        coupled = CO2w

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase CO2 ===============
    [./CO2w_dot]
        type = VariableCoefTimeDerivative
        variable = CO2w
        coupled_coef = total_pore
    [../]
    [./CO2_trans]
        type = FilmMassTransfer
        variable = CO2w
        coupled = CO2

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./CO2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = CO2w
        coupled_list = 'r1 r4 r5 r8 r11 r3 r10'
        weights = '1 1 1 2.5 1 5 5'
        scale = 1
    [../]

    # =============== Bulk phase N2 ===============
    [./N2_dot]
        type = VariableCoefTimeDerivative
        variable = N2
        coupled_coef = pore
    [../]
    [./N2_gadv]
        type = GPoreConcAdvection
        variable = N2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./N2_gdiff]
        type = GVarPoreDiffusion
        variable = N2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./N2w_trans]
        type = FilmMassTransfer
        variable = N2
        coupled = N2w

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase N2 ===============
    [./N2w_dot]
        type = VariableCoefTimeDerivative
        variable = N2w
        coupled_coef = total_pore
    [../]
    [./N2_trans]
        type = FilmMassTransfer
        variable = N2w
        coupled = N2

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./N2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = N2w
        coupled_list = 'r4 r7 r15 r10'
        weights = '0.5 0.5 1 7'
        scale = 1
    [../]

    # =============== Bulk phase H2 ===============
    [./H2_dot]
        type = VariableCoefTimeDerivative
        variable = H2
        coupled_coef = pore
    [../]
    [./H2_gadv]
        type = GPoreConcAdvection
        variable = H2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./H2_gdiff]
        type = GVarPoreDiffusion
        variable = H2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./H2w_trans]
        type = FilmMassTransfer
        variable = H2
        coupled = H2w

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase H2 ===============
    [./H2w_dot]
        type = VariableCoefTimeDerivative
        variable = H2w
        coupled_coef = total_pore
    [../]
    [./H2_trans]
        type = FilmMassTransfer
        variable = H2w
        coupled = H2

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./H2w_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = H2w
        coupled_list = 'r2 r11 r6 r7 r14 r12'
        weights = '-1 1 -2.5 -1 -1 9'
        scale = 1
    [../]

    # =============== Bulk phase HC ===============
    [./HC_dot]
        type = VariableCoefTimeDerivative
        variable = HC
        coupled_coef = pore
    [../]
    [./HC_gadv]
        type = GPoreConcAdvection
        variable = HC
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./HC_gdiff]
        type = GVarPoreDiffusion
        variable = HC
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]
    [./HCw_trans]
        type = FilmMassTransfer
        variable = HC
        coupled = HCw

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]

    # =============== Washcoat phase HC ===============
    [./HCw_dot]
        type = VariableCoefTimeDerivative
        variable = HCw
        coupled_coef = total_pore
    [../]
    [./HC_trans]
        type = FilmMassTransfer
        variable = HCw
        coupled = HC

        av_ratio = Ga
        rate_variable = km
        volume_frac = non_pore
    [../]
    # r3:  CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    # r10: CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    # r12: CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    #
    # 2-pentanone ==> x = 5, y = 10, z = 1
    [./HCw_rxns]
        type = ScaledWeightedCoupledSumFunction
        variable = HCw
        coupled_list = 'r3 r10 r12'
        weights = '-1 -1 -1'
        scale = 1
    [../]

# ------------------- Start Reaction Balances ----------------------
# -------------------------------------------------------------

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

      temperature = temp
      scale = 1.0
      reactants = 'COw O2w'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= H2 Oxidation ======
# H2 + 0.5 O2 --> H2O
    [./r2_val]
        type = Reaction
        variable = r2
    [../]
    [./r2_rx]
      type = ArrheniusReaction
      variable = r2
      this_variable = r2

      forward_activation_energy = 158891.38869742613
      forward_pre_exponential = 1.733658868809338e+24

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'H2w O2w'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= CO/NO Rxn ======
# CO + NO --> CO2 (+ 0.5 N2)
    [./r4_val]
        type = Reaction
        variable = r4
    [../]
    [./r4_rx]
      type = InhibitedArrheniusReaction
      variable = r4
      this_variable = r4

      # OG #forward_activation_energy = 304924.98618328216
      # OG #forward_pre_exponential = 3.473335911420499e+36

      forward_activation_energy = 225293.33281046877
      forward_pre_exponential = 1.573335911420499e+29

      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'COw NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= CO/NO Rxn ======
# CO + 2 NO --> CO2 + N2O
    [./r5_val]
        type = Reaction
        variable = r5
    [../]
    [./r5_rx]
      type = InhibitedArrheniusReaction
      variable = r5
      this_variable = r5

      # OG #forward_activation_energy = 170429.67328083533
      # OG #forward_pre_exponential = 3.174729324826581e+22

      forward_activation_energy = 220429.67328083533
      forward_pre_exponential = 6.174729324826581e+25

      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'COw NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= CO/NO Rxn ======
# 2.5 CO + NO + 1.5 H2O --> 2.5 CO2 + NH3
    [./r8_val]
        type = Reaction
        variable = r8
    [../]
    [./r8_rx]
      type = InhibitedArrheniusReaction
      variable = r8
      this_variable = r8

      # OG #forward_activation_energy = 304127.76066024584
      # OG #forward_pre_exponential = 1.8767305119846367e+38

      forward_activation_energy = 225293.33281046877
      forward_pre_exponential = 2.6767305119846367e+31

      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'COw NOxw H2Ow'
      reactant_stoich = '1 1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= WGS Rxn ======
# CO + H2O <-- --> CO2 + H2
    [./r11_val]
        type = Reaction
        variable = r11
    [../]
    [./r11_rx]
      type = ArrheniusEquilibriumReaction
      variable = r11
      this_variable = r11

      forward_activation_energy = 136610.55181420766
      forward_pre_exponential = 1.8429782328496848e+17

      enthalpy = 16769.16637626293
      entropy = 139.10839203326302

      temperature = temp
      scale = 1.0
      reactants = 'COw H2Ow'
      reactant_stoich = '1 1'
      products = 'CO2w H2w'
      product_stoich = '1 1'
    [../]

## ======= H2/NO Rxn ======
# 2.5 H2 + NO --> NH3 + H2O
    [./r6_val]
        type = Reaction
        variable = r6
    [../]
    [./r6_rx]
      type = InhibitedArrheniusReaction
      variable = r6
      this_variable = r6

      forward_pre_exponential = 2.60E+14
      forward_activation_energy = 59342.9
      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'H2w NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= H2/NO Rxn ======
# H2 + NO --> H2O (+ 0.5 N2)
    [./r7_val]
        type = Reaction
        variable = r7
    [../]
    [./r7_rx]
      type = InhibitedArrheniusReaction
      variable = r7
      this_variable = r7

      forward_pre_exponential = 6.96E+11
      forward_activation_energy = 32221.5
      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'H2w NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= H2/NO Rxn ======
# H2 + 2 NO --> N2O + H2O
    [./r14_val]
        type = Reaction
        variable = r14
    [../]
    [./r14_rx]
      type = InhibitedArrheniusReaction
      variable = r14
      this_variable = r14

      forward_pre_exponential = 2.56E+09
      forward_activation_energy = 13318.5
      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'H2w NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= SCR Rxn ======
# NH3 + NO + 0.25 O2 --> N2 + 1.5 H2O
    [./r15_val]
        type = Reaction
        variable = r15
    [../]
    [./r15_rx]
      type = InhibitedArrheniusReaction
      variable = r15
      this_variable = r15

      forward_pre_exponential = 1.65e+44
      forward_activation_energy = 324000
      forward_inhibition = R_CO

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'NH3w NOxw O2w'
      reactant_stoich = '1 1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= HC oxidation Rxn ======
# CxHyOz + (x + (y/4) - (z/2)) O2 --> x CO2 + (y/2) H2O
    [./r3_val]
        type = Reaction
        variable = r3
    [../]
    [./r3_rx]
      type = ArrheniusReaction
      variable = r3
      this_variable = r3

      forward_activation_energy = 190230.5815090796
      forward_pre_exponential = 7.781256728192754e+25

      #forward_activation_energy = 0
      #forward_pre_exponential = 0

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'HCw O2w'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= HC/NO Rxn ======
# CxHyOz + (2x + (y/2) - z) NO --> x CO2 + (y/2) H2O + (x + (y/4) - (z/2)) N2
    [./r10_val]
        type = Reaction
        variable = r10
    [../]
    [./r10_rx]
      type = ArrheniusReaction
      variable = r10
      this_variable = r10

      forward_activation_energy = 306490.50138277872
      forward_pre_exponential = 5.319699411823072e+34

      #forward_activation_energy = 0
      #forward_pre_exponential = 0

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'HCw NOxw'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

## ======= HC Steam Reforming Rxn ======
# CxHyOz + (x - z) H2O --> x CO + (x + (y/2) - z) H2
    [./r12_val]
        type = Reaction
        variable = r12
    [../]
    [./r12_rx]
      type = ArrheniusReaction
      variable = r12
      this_variable = r12

      forward_activation_energy = 109820.79317905376
      forward_pre_exponential = 1273304692765556.0

      #forward_activation_energy = 0
      #forward_pre_exponential = 0

      reverse_activation_energy = 0
      reverse_pre_exponential = 0

      temperature = temp
      scale = 1.0
      reactants = 'HCw H2Ow'
      reactant_stoich = '1 1'
      products = ''
      product_stoich = ''
    [../]

# ------------------ Start list of inhibition terms --------------------
# ============= CO Term =============
     [./R_CO_eq]
       type = Reaction
       variable = R_CO
     [../]
     [./R_CO_lang]
       type = LangmuirInhibition
       variable = R_CO
       temperature = temp
       coupled_list = 'COw'
       pre_exponentials = '2.59'
       activation_energies = '-36284.4'
     [../]

# ============= HC Term =============
   [./R_HC_eq]
     type = Reaction
     variable = R_HC
   [../]
   [./R_HC_lang]
     type = LangmuirInhibition
     variable = R_HC
     temperature = temp
     coupled_list = 'HCw'
     pre_exponentials = '0'
     activation_energies = '0'
   [../]

[] #END Kernels

[DGKernels]

    # =========== O2 DG kernels ===========
    [./O2_dgadv]
        type = DGPoreConcAdvection
        variable = O2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./O2_dgdiff]
        type = DGVarPoreDiffusion
        variable = O2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== H2O DG kernels ===========
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
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== NH3 DG kernels ===========
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
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== NO DG kernels ===========
    [./NOx_dgadv]
        type = DGPoreConcAdvection
        variable = NOx
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./NOx_dgdiff]
        type = DGVarPoreDiffusion
        variable = NOx
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== N2O DG kernels ===========
    [./N2O_dgadv]
        type = DGPoreConcAdvection
        variable = N2O
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./N2O_dgdiff]
        type = DGVarPoreDiffusion
        variable = N2O
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== CO DG kernels ===========
    [./CO_dgadv]
        type = DGPoreConcAdvection
        variable = CO
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO_dgdiff]
        type = DGVarPoreDiffusion
        variable = CO
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== CO2 DG kernels ===========
    [./CO2_dgadv]
        type = DGPoreConcAdvection
        variable = CO2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./CO2_dgdiff]
        type = DGVarPoreDiffusion
        variable = CO2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== N2 DG kernels ===========
    [./N2_dgadv]
        type = DGPoreConcAdvection
        variable = N2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./N2_dgdiff]
        type = DGVarPoreDiffusion
        variable = N2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== H2 DG kernels ===========
    [./H2_dgadv]
        type = DGPoreConcAdvection
        variable = H2
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./H2_dgdiff]
        type = DGVarPoreDiffusion
        variable = H2
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

    # =========== HC DG kernels ===========
    [./HC_dgadv]
        type = DGPoreConcAdvection
        variable = HC
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]
    [./HC_dgdiff]
        type = DGVarPoreDiffusion
        variable = HC
        porosity = pore
        Dx = D
        Dy = D
        Dz = D
    [../]

[] #END DGKernels

[AuxKernels]

    [./velocity]
        # NOTE: velocity must use same shape function type as temperature and space-velocity
        type = GasVelocityCylindricalReactor
        variable = vel_y
        porosity = 0.775
        space_velocity = 500   #volumes per min
        inlet_temperature = temp
        ref_pressure = 101.35
        ref_temperature = 273.15
        radius = 1  #cm
        length = 5  #cm
        execute_on = 'initial timestep_end'
    [../]

    [./temp_AuxK]
      type = FunctionAux
      variable = temp
      function = data_fun
    [../]

    [./Ga_calc]
        type = MonolithAreaVolumeRatio
        variable = Ga
        cell_density = 93   #cells/cm^2
        channel_vol_ratio = pore
        per_solids_volume = true
        execute_on = 'initial timestep_end'
    [../]

    [./dh_calc]
        type = MonolithHydraulicDiameter
        variable = dh
        cell_density = 93   #cells/cm^2
        channel_vol_ratio = pore
        execute_on = 'initial timestep_end'
    [../]

    [./wt_calc]
        type = MonolithMicroscaleTotalThickness
        variable = wt
        cell_density = 93   #cells/cm^2
        channel_vol_ratio = pore
        execute_on = 'initial timestep_end'
    [../]

    [./non_pore_calc]
        type = SolidsVolumeFraction
        variable = non_pore
        porosity = pore
        execute_on = 'initial timestep_end'
    [../]

    [./total_pore_calc]
        type = MicroscalePoreVolumePerTotalVolume
        variable = total_pore
        porosity = pore
        microscale_porosity = micro_pore
        execute_on = 'initial timestep_end'
    [../]

    [./km_calc]
        type = SimpleGasMonolithMassTransCoef
        variable = km

        pressure = press
        temperature = temp
        micro_porosity = micro_pore
        macro_porosity = pore
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
        variable = D

        pressure = press
        temperature = temp
        micro_porosity = micro_pore
        macro_porosity = pore

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

[] #END AuxKernels

[Functions]
  [./data_fun]
    type = PiecewiseMultilinear
    data_file = 2-pentanone_temperature.txt
  [../]

[]

[BCs]

    # ============== O2 BCs ================
    [./O2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = O2
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 6800
    [../]
    [./O2_FluxOut]
        type = DGPoreConcFluxBC
        variable = O2
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== H2O BCs ================
    [./H2O_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = H2O
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 130000
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

    # ============== NH3 BCs ================
    [./NH3_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = NH3
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 1e-6
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

    # ============== NO BCs ================
    [./NOx_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = NOx
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 1070
    [../]
    [./NOx_FluxOut]
        type = DGPoreConcFluxBC
        variable = NOx
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== N2O BCs ================
    [./N2O_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = N2O
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 1e-6
    [../]
    [./N2O_FluxOut]
        type = DGPoreConcFluxBC
        variable = N2O
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== CO BCs ================
    [./CO_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = CO
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 5200  #updated
    [../]
    [./CO_FluxOut]
        type = DGPoreConcFluxBC
        variable = CO
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== CO2 BCs ================
    [./CO2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = CO2
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 130000
    [../]
    [./CO2_FluxOut]
        type = DGPoreConcFluxBC
        variable = CO2
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== N2 BCs ================
    [./N2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = N2
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 990000
    [../]
    [./N2_FluxOut]
        type = DGPoreConcFluxBC
        variable = N2
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== H2 BCs ================
    [./H2_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = H2
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 1670
    [../]
    [./H2_FluxOut]
        type = DGPoreConcFluxBC
        variable = H2
        boundary = 'top'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
    [../]

    # ============== HC BCs ================
    # 2-pentanone ==> x = 5, y = 10, z = 1
    #   inlet_ppm = 3000 / x
    [./HC_FluxIn]
        type = DGPoreConcFluxBC_ppm
        variable = HC
        boundary = 'bottom'
        porosity = pore
        ux = vel_x
        uy = vel_y
        uz = vel_z
        pressure = press
        temperature = temp
        inlet_ppm = 600
    [../]
    [./HC_FluxOut]
        type = DGPoreConcFluxBC
        variable = HC
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

    [./O2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = O2
        execute_on = 'initial timestep_end'
    [../]

    [./O2_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = O2
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

    [./NO_out]
        type = SideAverageValue
        boundary = 'top'
        variable = NOx
        execute_on = 'initial timestep_end'
    [../]

    [./NO_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = NOx
        execute_on = 'initial timestep_end'
    [../]

    [./N2O_out]
        type = SideAverageValue
        boundary = 'top'
        variable = N2O
        execute_on = 'initial timestep_end'
    [../]

    [./N2O_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = N2O
        execute_on = 'initial timestep_end'
    [../]

    [./CO_out]
        type = SideAverageValue
        boundary = 'top'
        variable = CO
        execute_on = 'initial timestep_end'
    [../]

    [./CO_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = CO
        execute_on = 'initial timestep_end'
    [../]

    [./CO2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = CO2
        execute_on = 'initial timestep_end'
    [../]

    [./CO2_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = CO2
        execute_on = 'initial timestep_end'
    [../]

    [./N2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = N2
        execute_on = 'initial timestep_end'
    [../]

    [./N2_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = N2
        execute_on = 'initial timestep_end'
    [../]

    [./H2_out]
        type = SideAverageValue
        boundary = 'top'
        variable = H2
        execute_on = 'initial timestep_end'
    [../]

    [./H2_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = H2
        execute_on = 'initial timestep_end'
    [../]

    [./zHC_out]
        type = SideAverageValue
        boundary = 'top'
        variable = HC
        execute_on = 'initial timestep_end'
    [../]

    [./zHC_bypass]
        type = SideAverageValue
        boundary = 'bottom'
        variable = HC
        execute_on = 'initial timestep_end'
    [../]

    [./temp_avg]
        type = ElementAverageValue
        variable = temp
        execute_on = 'initial timestep_end'
    [../]

    [./temp_in]
        type = SideAverageValue
        boundary = 'bottom'
        variable = temp
        execute_on = 'initial timestep_end'
    [../]

    [./temp_out]
        type = SideAverageValue
        boundary = 'top'
        variable = temp
        execute_on = 'initial timestep_end'
    [../]

    [./R_HC]
        type = ElementAverageValue
        variable = R_HC
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
  line_search = bt
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-10
  nl_max_its = 10
  l_tol = 1e-6
  l_max_its = 300

  start_time = -1.0
  end_time = 102.0
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
