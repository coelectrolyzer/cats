/*!
 *  \file SimpleGasPropertiesBase.h
 *    \brief AuxKernel kernel base to aid in simple gas properties calculations
 *    \details This file is responsible for setting up and storing information
 *              associated with the simplified calculation of system properties.
 *              Calculations here are less rigorous than GasPropertiesBase, but
 *              will allow for more user flexibility and easier interfacing with
 *              the calculation of some simple gas-phase properties.
 *
 *
 *  \author Austin Ladshaw
 *  \date 09/14/2021
 *  \copyright This kernel was designed and built at Oak Ridge National
 *              Laboratory by Austin Ladshaw for research in catalyst
 *              performance for new vehicle technologies.
 *
 *               Austin Ladshaw does not claim any ownership or copyright to the
 *               MOOSE framework in which these kernels are constructed, only
 *               the kernels themselves. The MOOSE framework copyright is held
 *               by the Battelle Energy Alliance, LLC (c) 2010, all rights reserved.
 */

#pragma once

#include "AuxKernel.h"

#ifndef Rstd
#define Rstd 8.3144621 ///< Gas Constant in J/K/mol (or) L*kPa/K/mol (Standard Units)
#endif

/// SimpleGasPropertiesBase class object inherits from AuxKernel object
class SimpleGasPropertiesBase : public AuxKernel
{
public:
  /// Required new syntax for InputParameters
  static InputParameters validParams();

  /// Required constructor for objects in MOOSE
  SimpleGasPropertiesBase(const InputParameters & parameters);

protected:
  /// Helper function for errors
  void unsupported_conversion(std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real length_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real time_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real mass_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real energy_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real pressure_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real volume_conversion(Real value, std::string from, std::string to);

  /// Helper function to formulate a conversion
  Real volume_fraction_conversion(Real value, std::string from, std::string to);

  /// Required MOOSE function override
  virtual Real computeValue() override;

  /// NOTE: This aux system is under development. List of members likely to change
  const VariableValue & _pressure; ///< Variable for the pressure (default = kPa)
  std::string _pressure_unit;      ///< Units of the pressure term (kPa, Pa, mPa)
  bool _use_pressure_unit; ///< Boolean that tells whether or not we use the above pressure unit
  std::string _pressure_mass_unit;    ///< Units of the mass term in pressure (kg, g, mg)
  std::string _pressure_length_unit;  ///< Units of the length term in pressure (m, cm, mm)
  std::string _pressure_time_unit;    ///< Units of the time term in pressure (hr, min, s)
  const VariableValue & _temperature; ///< Variable for the temperature (K)
  const VariableValue & _micro_pore;  ///< Variable for the micro porosity
  const VariableValue & _macro_pore;  ///< Variable for the macro porosity
  const VariableValue & _char_len;    ///< Variable for the characteristic length (hydraulic diam)
  std::string _char_len_unit;         ///< Units of characteristic length (m, cm, mm)
  const VariableValue & _velocity;    ///< Variable for the average velocity
  std::string _velocity_length_unit;  ///< Units of the length term in velocity (m, cm, mm)
  std::string _velocity_time_unit;    ///< Units of the time term in velocity (hr, min, s)
  Real _ref_diffusivity;              ///< Value of reference diffusivity
  std::string _diff_length_unit; ///< Units of the length term in reference diffusivity (m, cm, mm)
  std::string _diff_time_unit;   ///< Units of the time term in reference diffusivity (hr, min, s)
  Real _ref_diff_temp;           ///< Value of reference temperature for diffusivity (K)
  Real
      _eff_diff_factor; ///< Factor for porosity to calculate effective diffusivity (default=1.4) [1,2]

private:
};
