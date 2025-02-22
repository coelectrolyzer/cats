# This file is a demo for the 'Isothermal_Monolith_Simulator' object
import sys
sys.path.append('../..')
from catalyst.isothermal_monolith_catalysis import *

# Read in data
exp_name = "CO2_H2O_CO_H2"

O2_in = 3135
CO2_in = 130000
H2O_in = 130000
CO_in = 5000
H2_in = 1670
NO_in = 0
NH3_in = 0
N2O_in = 0

data = naively_read_data_file("inputfiles/"+exp_name+"_lightoff.txt",factor=2)
temp_data = naively_read_data_file("inputfiles/"+exp_name+"_temp.txt",factor=2)

time_list = time_point_selector(data["time"], data)

sim = Isothermal_Monolith_Simulator()
sim.add_axial_dim(0,5)         #cm
sim.add_axial_dataset(5)

sim.add_temporal_dim(point_list=time_list)
sim.add_temporal_dataset(data["time"])

sim.add_age_set("A0")
sim.add_data_age_set("A0")

sim.add_temperature_set("T0")
sim.add_data_temperature_set("T0")

sim.add_gas_species(["CO","NO","N2O","NH3","H2","O2","H2O","CO2"])
sim.add_data_gas_species(["CO","NO","N2O","NH3","H2"])

sim.set_data_values_for("CO","A0","T0",5,data["time"],data["CO"])
sim.set_data_values_for("NO","A0","T0",5,data["time"],data["NO"])
sim.set_data_values_for("N2O","A0","T0",5,data["time"],data["N2O"])
sim.set_data_values_for("NH3","A0","T0",5,data["time"],data["NH3"])
sim.set_data_values_for("H2","A0","T0",5,data["time"],data["H2"])

sim.add_reactions({
                    # CO + 0.5 O2 --> CO2
                    "r1": ReactionType.Arrhenius,

                    # H2 + 0.5 O2 --> H2O
                    "r2": ReactionType.Arrhenius,

                    # CO + H2O <-- --> CO2 + H2
                    "r11": ReactionType.EquilibriumArrhenius,
                  })

sim.set_bulk_porosity(0.775)
sim.set_washcoat_porosity(0.4)
sim.set_reactor_radius(1)
sim.set_space_velocity_all_runs(500)
sim.set_cell_density(93)

# CO + 0.5 O2 --> CO2
r1 = {"parameters": {"A": 1.6550871137667489e+31, "E": 235293.33281046877},
          "mol_reactants": {"CO": 1, "O2": 0.5},
          "mol_products": {"CO2": 1},
          "rxn_orders": {"CO": 1, "O2": 1}
        }

# H2 + 0.5 O2 --> H2O
r2 = {"parameters": {"A": 1.733658868809338e+24, "E": 158891.38869742613},
          "mol_reactants": {"H2": 1, "O2": 0.5},
          "mol_products": {"H2O": 1},
          "rxn_orders": {"H2": 1, "O2": 1}
        }

# CO + H2O <-- --> CO2 + H2
r11 = {"parameters": {"A": 1.8429782328496848e+17, "E": 136610.55181420766,
                        "dH": 16769.16637626293, "dS": 139.10839203326302},
          "mol_reactants": {"CO": 1, "H2O": 1},
          "mol_products": {"H2": 1, "CO2": 1},
          "rxn_orders": {"CO": 1, "H2O": 1, "CO2": 1, "H2": 1}
        }

sim.set_reaction_info("r1", r1)
sim.set_reaction_info("r2", r2)
sim.set_reaction_info("r11", r11)

sim.build_constraints()
sim.discretize_model(method=DiscretizationMethod.FiniteDifference,
                    tstep=90,elems=10,colpoints=2)

# Setup temperature information from data
sim.set_temperature_from_data("A0", "T0", temp_data, {"T_in": 0, "T_mid": 2.5, "T_out": 5})

# Setup reaction zones for each reaction
#   These are just guesses for now (Assuming the co-reactions between CO and NO
#       only occur on Pd/Rh zone)
#-------------------------------------------------------------------------------
'''
sim.set_reaction_zone("r4", (2.51, 5))
sim.set_reaction_zone("r5", (2.51, 5))
sim.set_reaction_zone("r8", (2.51, 5))
sim.set_reaction_zone("r9", (2.51, 5))
sim.set_reaction_zone("r15", (2.51, 5))
'''


# ICs in ppm
sim.set_const_IC_in_ppm("CO","A0","T0",CO_in)
sim.set_const_IC_in_ppm("NO","A0","T0",NO_in)
sim.set_const_IC_in_ppm("N2O","A0","T0",N2O_in)
sim.set_const_IC_in_ppm("NH3","A0","T0",NH3_in)
sim.set_const_IC_in_ppm("H2","A0","T0",H2_in)
sim.set_const_IC_in_ppm("O2","A0","T0",O2_in)
sim.set_const_IC_in_ppm("H2O","A0","T0",H2O_in)
sim.set_const_IC_in_ppm("CO2","A0","T0",CO2_in)

# BCs in ppm
sim.set_const_BC_in_ppm("CO","A0","T0",CO_in)
sim.set_const_BC_in_ppm("NO","A0","T0",NO_in)
sim.set_const_BC_in_ppm("N2O","A0","T0",N2O_in)
sim.set_const_BC_in_ppm("NH3","A0","T0",NH3_in)
sim.set_const_BC_in_ppm("H2","A0","T0",H2_in)
sim.set_const_BC_in_ppm("O2","A0","T0",O2_in)
sim.set_const_BC_in_ppm("H2O","A0","T0",H2O_in)
sim.set_const_BC_in_ppm("CO2","A0","T0",CO2_in)


sim.auto_select_all_weight_factors()

sim.ignore_weight_factor("N2O","A0","T0",time_window=(0,110))
sim.ignore_weight_factor("NO","A0","T0",time_window=(0,110))
sim.ignore_weight_factor("NH3","A0","T0",time_window=(0,110))
#sim.ignore_weight_factor("H2","A0","T0",time_window=(0,110))

sim.fix_all_reactions()

sim.initialize_auto_scaling()
sim.initialize_simulator(console_out=False, restart_on_warning=True, restart_on_error=True)

sim.finalize_auto_scaling()
sim.run_solver()

sim.plot_vs_data("CO", "A0", "T0", 5, display_live=False, file_name="exp-"+exp_name+"-CO-out")
sim.plot_vs_data("NO", "A0", "T0", 5, display_live=False, file_name="exp-"+exp_name+"-NO-out")
sim.plot_vs_data("NH3", "A0", "T0", 5, display_live=False, file_name="exp-"+exp_name+"-NH3-out")
sim.plot_vs_data("N2O", "A0", "T0", 5, display_live=False, file_name="exp-"+exp_name+"-N2O-out")
sim.plot_vs_data("H2", "A0", "T0", 5, display_live=False, file_name="exp-"+exp_name+"-H2-out")
sim.plot_at_locations(["O2"], ["A0"], ["T0"], [0, 5], display_live=False, file_name="exp-"+exp_name+"-O2-out")

sim.plot_at_times(["CO"], ["A0"], ["T0"], [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95],
                display_live=False, file_name="exp-"+exp_name+"-COprofile-out")

sim.plot_at_times(["O2"], ["A0"], ["T0"], [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95],
                display_live=False, file_name="exp-"+exp_name+"-O2profile-out")

sim.print_results_of_breakthrough(["CO","NO","NH3","N2O","H2","O2","H2O","CO2"],
                                "A0", "T0", file_name=exp_name+"_lightoff"+".txt", include_temp=True)
sim.print_kinetic_parameter_info(file_name=exp_name+"_params"+".txt")
sim.save_model_state(file_name=exp_name+"_model"+".json")
