// -*- C++ -*-
//
// ======================================================================
//
//                           Brad T. Aagaard
//                        U.S. Geological Survey
//
// {LicenseText}
//
// ======================================================================
//

// DO NOT EDIT THIS FILE
// This file was generated from python application elasticstress1d.

#if !defined(pylith_materials_elasticstress1ddata_hh)
#define pylith_materials_elasticstress1ddata_hh

#include "ElasticMaterialData.hh"

namespace pylith {
  namespace materials {
     class ElasticStress1DData;
  } // pylith
} // materials

class pylith::materials::ElasticStress1DData : public ElasticMaterialData
{

public: 

  /// Constructor
  ElasticStress1DData(void);

  /// Destructor
  ~ElasticStress1DData(void);

private:

  static const int _dimension;

  static const int _numDBValues;

  static const int _numParameters;

  static const int _numLocs;

  static const int _numParamValues[];

  static const char* _dbValues[];

  static const char* _parameterNames[];

  static const double _dbData[];

  static const double _parameterData[];

  static const double _density[];

  static const double _strain[];

  static const double _stress[];

  static const double _elasticConsts[];

};

#endif // pylith_materials_elasticstress1ddata_hh

// End of file
