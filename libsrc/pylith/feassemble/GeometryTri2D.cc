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
// Copyright (c) 2010 University of California, Davis
//
// See COPYING for license information.
//
// ======================================================================
//

#include <portinfo>

#include "GeometryTri2D.hh" // implementation of class methods

#include "GeometryLine2D.hh" // USES GeometryLine2D

#include "petsc.h" // USES PetscLogFlops

#include "pylith/utils/array.hh" // USES double_array

#include <cassert> // USES assert()

// ----------------------------------------------------------------------
// Default constructor.
pylith::feassemble::GeometryTri2D::GeometryTri2D(void) :
  CellGeometry(TRIANGLE, 2)
{ // constructor
  const double vertices[] = {
    -1.0,  -1.0,
    +1.0,  -1.0,
    -1.0,  +1.0,
  };
  _setVertices(vertices, 3, 2);
} // constructor

// ----------------------------------------------------------------------
// Default destructor.
pylith::feassemble::GeometryTri2D::~GeometryTri2D(void)
{ // destructor
} // destructor

// ----------------------------------------------------------------------
// Create a copy of geometry.
pylith::feassemble::CellGeometry*
pylith::feassemble::GeometryTri2D::clone(void) const
{ // clone
  return new GeometryTri2D();
} // clone

// ----------------------------------------------------------------------
// Get cell geometry for lower dimension cell.
pylith::feassemble::CellGeometry*
pylith::feassemble::GeometryTri2D::geometryLowerDim(void) const
{ // geometryLowerDim
  return new GeometryLine2D();
} // geometryLowerDim

// ----------------------------------------------------------------------
// Transform coordinates in reference cell to global coordinates.
void
pylith::feassemble::GeometryTri2D::ptsRefToGlobal(double* ptsGlobal,
						  const double* ptsRef,
						  const double* vertices,
						  const int dim,
						  const int npts) const
{ // ptsRefToGlobal
  assert(0 != ptsGlobal);
  assert(0 != ptsRef);
  assert(0 != vertices);
  assert(2 == dim);
  assert(spaceDim() == dim);

  const double x0 = vertices[0];
  const double y0 = vertices[1];

  const double x1 = vertices[2];
  const double y1 = vertices[3];

  const double x2 = vertices[4];
  const double y2 = vertices[5];

  const double f_1 = x1 - x0;
  const double g_1 = y1 - y0;

  const double f_2 = x2 - x0;
  const double g_2 = y2 - y0;

  for (int i=0, iR=0, iG=0; i < npts; ++i) {
    const double p0 = 0.5 * (1.0 + ptsRef[iR++]);
    const double p1 = 0.5 * (1.0 + ptsRef[iR++]);
    ptsGlobal[iG++] = x0 + f_1 * p0 + f_2 * p1;
    ptsGlobal[iG++] = y0 + g_1 * p0 + g_2 * p1;
  } // for

  PetscLogFlops(4 + npts*12);
} // ptsRefToGlobal

// ----------------------------------------------------------------------
// Compute Jacobian at location in cell.
void
pylith::feassemble::GeometryTri2D::jacobian(double_array* jacobian,
					  double* det,
					  const double_array& vertices,
					  const double_array& location) const
{ // jacobian
  assert(0 != jacobian);

  assert(numCorners()*spaceDim() == vertices.size());
  assert(spaceDim()*cellDim() == jacobian->size());
  
  const double x0 = vertices[0];
  const double y0 = vertices[1];

  const double x1 = vertices[2];
  const double y1 = vertices[3];

  const double x2 = vertices[4];
  const double y2 = vertices[5];

  (*jacobian)[0] = (x1 - x0) / 2.0;
  (*jacobian)[1] = (x2 - x0) / 2.0;
  (*jacobian)[2] = (y1 - y0) / 2.0;
  (*jacobian)[3] = (y2 - y0) / 2.0;

  *det = 
    (*jacobian)[0]*(*jacobian)[3] - 
    (*jacobian)[1]*(*jacobian)[2];

  PetscLogFlops(11);
} // jacobian

// ----------------------------------------------------------------------
// Compute Jacobian at location in cell.
void
pylith::feassemble::GeometryTri2D::jacobian(double* jacobian,
					    double* det,
					    const double* vertices,
					    const double* location,
					    const int dim,
					    const int npts) const
{ // jacobian
  assert(0 != jacobian);
  assert(0 != det);
  assert(0 != vertices);
  assert(0 != location);
  assert(2 == dim);
  assert(spaceDim() == dim);
  
  const double x0 = vertices[0];
  const double y0 = vertices[1];

  const double x1 = vertices[2];
  const double y1 = vertices[3];

  const double x2 = vertices[4];
  const double y2 = vertices[5];


  const double j00 = (x1 - x0) / 2.0;
  const double j01 = (x2 - x0) / 2.0;
  const double j10 = (y1 - y0) / 2.0;
  const double j11 = (y2 - y0) / 2.0;
  const double jdet = j00*j11 - j10*j01;

  for (int i=0, iJ=0; i < npts; ++i) {
    jacobian[iJ++] = j00;
    jacobian[iJ++] = j01;
    jacobian[iJ++] = j10;
    jacobian[iJ++] = j11;
    det[i] = jdet;
  } // for

  PetscLogFlops(11);
} // jacobian


// End of file