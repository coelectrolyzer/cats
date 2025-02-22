/*!
 *  \file CoupledNeumannBC.h
 *	\brief Boundary Condition kernel for a Neumann condition based on a coulped variable
 *  \details This kernel creates a standard Neumann type BC for a variable wherein
 *        the slope-value at the boundary is another non-linear, variable. This will primarily
 *        be used with Auxilary Variables to create step functions or any other desired
 *        relationship at the boundary.
 *
 *
 *  \author Austin Ladshaw
 *	\date 01/18/2022
 *	\copyright This kernel was designed and built at Oak Ridge National
 *              Laboratory by Austin Ladshaw for research in electrochemical
 *              CO2 conversion.
 *
 *			   Austin Ladshaw does not claim any ownership or copyright to the
 *			   MOOSE framework in which these kernels are constructed, only
 *			   the kernels themselves. The MOOSE framework copyright is held
 *			   by the Battelle Energy Alliance, LLC (c) 2010, all rights reserved.
 */

#pragma once

#include "IntegratedBC.h"

/// CoupledNeumannBC class object inherits from IntegratedBC object
/** This class object inherits from the IntegratedBC object.
  All public and protected members of this class are required function overrides.
  Boundary condition of a Neumann style whose value is computed by a anoher variable*/
class CoupledNeumannBC : public IntegratedBC
{
public:
  /// Required new syntax for InputParameters
  static InputParameters validParams();

  /// Required constructor for BC objects in MOOSE
  CoupledNeumannBC(const InputParameters & parameters);

protected:
  /// Required function override for BC objects in MOOSE
  /** This function returns a residual contribution for this object.*/
  virtual Real computeQpResidual() override;
  /// Required function override for BC objects in MOOSE
  /** This function returns a Jacobian contribution for this object. The Jacobian being
    computed is the associated diagonal element in the overall Jacobian matrix for the
    system and is used in preconditioning of the linear sub-problem. */
  virtual Real computeQpJacobian() override;
  /// Not Required, but aids in the preconditioning step
  /** This function returns the off diagonal Jacobian contribution for this object. By
    returning a non-zero value we will hopefully improve the convergence rate for the
    cross coupling of the variables. */
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  const VariableValue & _coupled;  ///< Coupled variable
  const unsigned int _coupled_var; ///< Variable identification for coupled variable
};
