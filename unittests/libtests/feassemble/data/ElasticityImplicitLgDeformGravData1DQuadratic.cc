// -*- C++ -*-
//
// ======================================================================
//
// Brad T. Aagaard, U.S. Geological Survey
// Charles A. Williams, GNS Science
// Matthew G. Knepley, University of Chicago
//
// This code was developed as part of the Computational Infrastructure
// for Geodynamics (http://geodynamics.org).
//
// Copyright (c) 2010-2011 University of California, Davis
//
// See COPYING for license information.
//
// ======================================================================
//

// DO NOT EDIT THIS FILE
// This file was generated from python application elasticitylgdeformapp.

#include "ElasticityImplicitLgDeformGravData1DQuadratic.hh"

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_spaceDim = 1;

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_cellDim = 1;

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_numVertices = 3;

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_numCells = 1;

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_numBasis = 3;

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_numQuadPts = 2;

const char* pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_matType = "ElasticStrain1D";

const char* pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_matDBFilename = "data/elasticstrain1d.spatialdb";

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_matId = 0;

const char* pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_matLabel = "elastic strain 1-D";

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_dt =   1.00000000e-02;

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_gravityVec[] = {
 -1.00000000e+08,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_vertices[] = {
 -2.50000000e-01,
  2.00000000e+00,
  8.75000000e-01,
};

const int pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_cells[] = {
0,1,2,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_verticesRef[] = {
 -1.00000000e+00,
  1.00000000e+00,
  0.00000000e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_quadPts[] = {
 -5.77350269e-01,
  5.77350269e-01,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_quadWts[] = {
  1.00000000e+00,  1.00000000e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_basis[] = {
  4.55341801e-01,
 -1.22008468e-01,
  6.66666667e-01,
 -1.22008468e-01,
  4.55341801e-01,
  6.66666667e-01,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_basisDerivRef[] = {
 -1.07735027e+00,
 -7.73502692e-02,
  1.15470054e+00,
  7.73502692e-02,
  1.07735027e+00,
 -1.15470054e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_fieldTIncr[] = {
  1.20000000e+00,
  0.00000000e+00,
  1.70000000e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_fieldT[] = {
  1.10000000e+00,
  1.00000000e-01,
  1.50000000e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_fieldTmdt[] = {
  1.00000000e+00,
  1.00000000e-01,
  1.30000000e+00,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_valsResidual[] = {
  2.60876283e+11,
  2.37591344e+11,
 -1.06096763e+12,
};

const double pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::_valsJacobian[] = {
  5.56003292e+11,
  7.76230453e+10,
 -6.33626337e+11,
  7.76230453e+10,
  5.30719342e+11,
 -6.08342387e+11,
 -6.33626337e+11,
 -6.08342387e+11,
  1.24196872e+12,
};

pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::ElasticityImplicitLgDeformGravData1DQuadratic(void)
{ // constructor
  spaceDim = _spaceDim;
  cellDim = _cellDim;
  numVertices = _numVertices;
  numCells = _numCells;
  numBasis = _numBasis;
  numQuadPts = _numQuadPts;
  matType = const_cast<char*>(_matType);
  matDBFilename = const_cast<char*>(_matDBFilename);
  matId = _matId;
  matLabel = const_cast<char*>(_matLabel);
  dt = _dt;
  gravityVec = const_cast<double*>(_gravityVec);
  vertices = const_cast<double*>(_vertices);
  cells = const_cast<int*>(_cells);
  verticesRef = const_cast<double*>(_verticesRef);
  quadPts = const_cast<double*>(_quadPts);
  quadWts = const_cast<double*>(_quadWts);
  basis = const_cast<double*>(_basis);
  basisDerivRef = const_cast<double*>(_basisDerivRef);
  fieldTIncr = const_cast<double*>(_fieldTIncr);
  fieldT = const_cast<double*>(_fieldT);
  fieldTmdt = const_cast<double*>(_fieldTmdt);
  valsResidual = const_cast<double*>(_valsResidual);
  valsJacobian = const_cast<double*>(_valsJacobian);
} // constructor

pylith::feassemble::ElasticityImplicitLgDeformGravData1DQuadratic::~ElasticityImplicitLgDeformGravData1DQuadratic(void)
{}


// End of file
