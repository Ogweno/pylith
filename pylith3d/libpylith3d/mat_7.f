c -*- Fortran -*-
c
c ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
c
c  PyLith by Charles A. Williams, Brad Aagaard, and Matt Knepley
c
c  Copyright (c) 2004-2006 Rensselaer Polytechnic Institute
c
c  Permission is hereby granted, free of charge, to any person obtaining
c  a copy of this software and associated documentation files (the
c  "Software"), to deal in the Software without restriction, including
c  without limitation the rights to use, copy, modify, merge, publish,
c  distribute, sublicense, and/or sell copies of the Software, and to
c  permit persons to whom the Software is furnished to do so, subject to
c  the following conditions:
c
c  The above copyright notice and this permission notice shall be
c  included in all copies or substantial portions of the Software.
c
c  THE  SOFTWARE IS  PROVIDED  "AS  IS", WITHOUT  WARRANTY  OF ANY  KIND,
c  EXPRESS OR  IMPLIED, INCLUDING  BUT NOT LIMITED  TO THE  WARRANTIES OF
c  MERCHANTABILITY,    FITNESS    FOR    A   PARTICULAR    PURPOSE    AND
c  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
c  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
c  OF CONTRACT, TORT OR OTHERWISE,  ARISING FROM, OUT OF OR IN CONNECTION
c  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
c
c ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
c
c...  Program segment to define material model 7:
c
c       Model number:                      7
c       Model name:                        IsotropicLinearGenMaxwellViscoelastic
c       Number material properties:        9
c       Number state variables:            15
c       Tangent matrix varies with state:  True
c       Material properties:               Density
c                                          Young's Modulus
c                                          Poisson's Ratio
c                                          Shear Ratio 1
c                                          Viscosity 1
c                                          Shear Ratio 2
c                                          Viscosity 2
c                                          Shear Ratio 3
c                                          Viscosity 3
c
c...  Usage notes:
c       For a simple Maxwell model, set one shear ratio to 1.0 and the
c       other two to 0.0.
c       For a standard linear solid, set two shear ratios to 0.0 and the
c       final one to whatever fraction is appropriate.
c
      subroutine mat_prt_7(prop,nprop,matnum,idout,idsk,kw,kp,
     & ierr,errstrng)
c
c...  subroutine to output material properties for material model 7.
c
c     Error codes:
c         4:  Write error
c       101:  Attempt to use undefined material model
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "nconsts.inc"
c
c...  subroutine arguments
c
      integer nprop,matnum,idout,idsk,kw,kp,ierr
      double precision prop(nprop)
      character errstrng*(*)
c
c...  local constants
c
      character labelp(9)*15,modelname*49
      data labelp/"Density",
     &            "Young's modulus",
     &            "Poisson's ratio",
     &            "Shear Ratio 1",
     &            "Viscosity 1",
     &            "Shear Ratio 2",
     &            "Viscosity 2",
     &            "Shear Ratio 3",
     &            "Viscosity 3"/
      integer mattype
      parameter(mattype=7)
c
c...  local variables
c
      integer i
      double precision sfrac
c
cdebug      write(6,*) "Hello from mat_prt_5_f!"
c
      ierr=0
      modelname="Isotropic Linear Generalized Maxwell Viscoelastic"
      sfrac=prop(4)+prop(6)+prop(8)
      if(sfrac.lt.0.0d0.or.sfrac.gt.1.0d0) then
        ierr=116
        errstrng="mat_prt_5"
        return
      end if
c
c...  output plot results
c
      if(idsk.eq.ione) then
	write(kp,"(3i7)",err=10) matnum,mattype,nprop
	write(kp,"(1pe15.8,20(2x,1pe15.8))",err=10) (prop(i),i=1,nprop)
      else if(idsk.eq.itwo) then
	write(kp,err=10) matnum,mattype,nprop
	write(kp,err=10) prop
      end if
c
c...  output ascii results, if desired
c
      if(idout.gt.izero) then
	write(kw,700,err=10) matnum,modelname,nprop
	do i=1,nprop
	  write(kw,710,err=10) labelp(i),prop(i)
        end do
      end if
c
      return
c
c...  error writing to output file
c
 10   continue
        ierr=4
        errstrng="mat_prt_7"
        return
c
 700  format(/,5x,"Material number:       ",i7,/,5x,
     &            "Material type:         ",a37,/,5x,
     &            "Number of properties:  ",i7,/)
 710  format(15x,a15,3x,1pe15.8)
c
      end
c
c
      subroutine elas_mat_7(dmat,prop,iddmat,nprop,ierr,errstrng)
c
c...  subroutine to form the material matrix for an integration point
c     for the elastic solution.  The material matrix is assumed to be
c     independent of the state variables in this case.
c     Note also that only the upper triangle is used (or available), as
c     dmat is assumed to always be symmetric.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nprop,ierr
      integer iddmat(nstr,nstr)
      character errstrng*(*)
      double precision dmat(nddmat),prop(nprop)
c
c...  local variables
c
      integer i,j
      double precision e,pr,pr1,pr2,pr3,fac,dd,od,ss
c
cdebug      write(6,*) "Hello from elas_mat_7_f!"
c
      call fill(dmat,zero,nddmat)
      e=prop(2)
      pr=prop(3)
      pr1=one-pr
      pr2=one+pr
      pr3=one-two*pr
      fac=e/(pr2*pr3)
      dd=pr1*fac
      od=pr*fac
      ss=half*pr3*fac
      do i=1,3
        dmat(iddmat(i,i))=dd
        dmat(iddmat(i+3,i+3))=ss
        do j=i+1,3
          dmat(iddmat(i,j))=od
        end do
      end do
      return
      end
c
c
      subroutine elas_strs_7(prop,nprop,state,state0,ee,scur,dmat,tmax,
     & nstate,nstate0,ierr,errstrng)
c
c...  subroutine to compute stresses for the elastic solution.  For this
c     material, there are 3 sets of state variables:  total stress,
c     total strain, and a viscous state variable for each Maxwell
c     element.  The minimum Maxwell time is computed, even though this
c     is the elastic solution, as an aid in determining the proper time
c     step size for the next step.
c     The current total strain is contained in ee and the computed
c     total stress should be copied to scur.
c
c     state(1:6)   = Cauchy stress
c     state(7:12)  = linear strain
c     state(13:15) = viscous state variable
c
c     The state0 array contains initial stresses.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "nconsts.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nprop,nstate,nstate0,ierr
      double precision prop(nprop),state(nstate),state0(nstate0)
      double precision ee(nstr),scur(nstr)
      double precision dmat(nddmat),tmax
      character errstrng*(*)
c
c...  local variables
c
      integer i
      double precision sfrac,e,pr,vise,rmu,rmue,tmaxe
c
cdebug      write(6,*) "Hello from elas_strs_7_f!"
c
      ierr=0
      sfrac=prop(4)+prop(6)+prop(8)
      if(sfrac.lt.0.0d0.or.sfrac.gt.1.0d0) then
        ierr=116
        errstrng="mat_prt_5"
        return
      end if
c
c...  compute elastic stresses assuming material matrix has already
c     been computed.
c
      call dcopy(nstr,ee,ione,state(7),ione)
      call dcopy(nstr,state0,ione,state,ione)
      call dspmv("u",nstr,one,dmat,state(7),ione,one,state,ione)
      call dcopy(nstr,state,ione,scur,ione)
c
c...  compute Maxwell time for current stress state
c
      e=prop(2)
      pr=prop(3)
      rmu=half*e/(one+pr)
      tmax=big
      do i=1,3
        rmue=prop(2*(i-1)+4)*rmu
        vise=prop(2*(i-1)+5)
        if(rmue.ne.zero) tmax=min(tmax,vise/rmue)
      end do
      return
      end
c
c
      function compdq(deltp,vis,rmu)
c
c...  function to compute the viscous state variable increment delta-q.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "rconsts.inc"
      integer nterms
      double precision tfrac
      parameter(nterms=5,tfrac=1.0d-5)
c
c...  subroutine arguments
c
      double precision compdq,deltp,vis,rmu
c
c...  intrinsic functions
c
      intrinsic exp
c
c...  local variables
c
      integer i
      double precision tau,fsign,fac,frac
c
      compdq=zero
      if(rmu.eq.zero) return
      tau=vis/rmu
      if(tau.lt.tfrac*deltp) then
        fsign=one
        fac=one
        frac=one
        compdq=one
        do i=2,nterms
          fac=fac*dble(i)
          fsign=-one*fsign
          frac=frac*(deltp/tau)
          compdq=compdq+fsign*frac/fac
        end do
      else
        compdq=tau*(one-exp(-deltp/tau))/deltp
      end if
      return
      end
c
c
      subroutine td_matinit_7(state,dstate,state0,dmat,prop,rtimdat,
     & rgiter,ntimdat,iddmat,tmax,nstate,nstate0,nprop,matchg,ierr,
     & errstrng)
c
c...  subroutine to form the material matrix for an integration point
c     for the time-dependent solution.  This routine is meant to be
c     called at the beginning of a time step, before strains have been
c     computed.  Thus, for some time-dependent materials, the material
c     matrix will only be an approximation of the material matrix for
c     the current iteration.
c     Note that only the upper triangle is used (or available), as
c     dmat is assumed to always be symmetric.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nstate,nstate0,nprop,ierr
      integer iddmat(nstr,nstr)
      character errstrng*(*)
      double precision state(nstate),dstate(nstate)
      double precision state0(nstate0),dmat(nddmat),prop(nprop),tmax
      logical matchg
c
c...  included dimension and type statements
c
      include "rtimdat_dim.inc"
      include "rgiter_dim.inc"
      include "ntimdat_dim.inc"
c
c...  external functions
c
      double precision compdq
      external compdq
c
c...  local variables
c
      double precision sfrac,frac0,e,pr,rmu,rmue,vise,bulkm,sfac,shfac
c
c...  included variable definitions
c
      include "rtimdat_def.inc"
      include "rgiter_def.inc"
      include "ntimdat_def.inc"
c
cdebug      write(6,*) "Hello from td_matinit_7_f!"
c
      ierr=0
      sfrac=prop(4)+prop(6)+prop(8)
      if(sfrac.lt.0.0d0.or.sfrac.gt.1.0d0) then
        ierr=116
        errstrng="mat_prt_5"
        return
      end if
c
      call fill(dmat,zero,nddmat)
      e=prop(2)
      pr=prop(3)
      rmu=half*e/(one+pr)
      bulkm=third*e/(one-two*pr)
      frac0=one-sfrac
      shfac=frac0
      tmax=big
      do i=1,3
        rmue=prop(2*(i-1)+4)
        vise=prop(2*(i-1)+5)
        if(rmue.ne.zero) then
          tmax=min(tmax,vise/rmue)
          shfac=shfac+rmue*compdq(deltp,vise,rmue)
        end if
      end do
      shfac=third*rmu*shfac
      dmat(iddmat(1,1))=bulkm+two*shfac
      dmat(iddmat(2,2))=dmat(iddmat(1,1))
      dmat(iddmat(3,3))=dmat(iddmat(1,1))
      dmat(iddmat(1,2))=bulkm-shfac
      dmat(iddmat(1,3))=dmat(iddmat(1,2))
      dmat(iddmat(2,3))=dmat(iddmat(1,2))
      dmat(iddmat(4,4))=half*three*shfac
      dmat(iddmat(5,5))=dmat(iddmat(4,4))
      dmat(iddmat(6,6))=dmat(iddmat(4,4))
      return
      end
c
c
      subroutine td_strs_7(state,dstate,state0,ee,scur,dmat,prop,
     & rtimdat,rgiter,ntimdat,iddmat,tmax,nstate,nstate0,nprop,matchg,
     & ierr,errstrng)
c
c...  subroutine to compute the current stress for the time-dependent
c     solution.
c     Note that only the upper triangle is used (or available), as
c     dmat is assumed to always be symmetric.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "nconsts.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nstate,nstate0,nprop,ierr
      integer iddmat(nstr,nstr)
      character errstrng*(*)
      logical matchg
      double precision state(nstate),dstate(nstate),state0(nstate0)
      double precision ee(nstr),scur(nstr),dmat(nddmat),prop(nprop),tmax
c
c...  included dimension and type statements
c
      include "rtimdat_dim.inc"
      include "rgiter_dim.inc"
      include "ntimdat_dim.inc"
c
c...  included variable definitions
c
      include "rtimdat_def.inc"
      include "rgiter_def.inc"
      include "ntimdat_def.inc"
c
c...  return error code, as this material is not yet defined
c
      ierr=101
      errstrng="td_strs_7"
c
      return
      end
c
c
      subroutine td_strs_mat_7(state,dstate,state0,ee,scur,dmat,prop,
     & rtimdat,rgiter,ntimdat,iddmat,tmax,nstate,nstate0,nprop,matchg,
     & ierr,errstrng)
c
c...  subroutine to compute the current stress and updated material
c     matrix for the time-dependent solution.  Since this is a purely
c     elastic material, the material matrix should not change unless the
c     material properties have changed for a time step.
c     Note that only the upper triangle is used (or available), as
c     dmat is assumed to always be symmetric.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "nconsts.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nstate,nstate0,nprop,ierr
      integer iddmat(nstr,nstr)
      character errstrng*(*)
      logical matchg
      double precision state(nstate),dstate(nstate),state0(nstate0)
      double precision ee(nstr),scur(nstr),dmat(nddmat),prop(nprop),tmax
c
c...  included dimension and type statements
c
      include "rtimdat_dim.inc"
      include "rgiter_dim.inc"
      include "ntimdat_dim.inc"
c
c...  included variable definitions
c
      include "rtimdat_def.inc"
      include "rgiter_def.inc"
      include "ntimdat_def.inc"
c
c...  return error code, as this material is not yet defined
c
      ierr=101
      errstrng="td_strs_mat_7"
c
      return
      end
c
c
      subroutine prestr_mat_7(dmat,prop,tpois,tyoungs,iddmat,ipauto,
     & nprop,ierr,errstrng)
c
c...  subroutine to form the material matrix for an integration point
c     for prestress computation.  The material matrix is assumed to be
c     independent of the state variables in this case.
c     Note also that only the upper triangle is used (or available), as
c     dmat is assumed to always be symmetric.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "ndimens.inc"
      include "nconsts.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer ipauto,nprop,ierr
      integer iddmat(nstr,nstr)
      character errstrng*(*)
      double precision tpois,tyoungs,dmat(nddmat),prop(nprop)
c
c...  local variables
c
      double precision ptmp(10)
c
      call dcopy(nprop,prop,ione,ptmp,ione)
      if(ipauto.eq.ione) then
        ptmp(2)=tyoungs
        ptmp(3)=tpois
      end if
      call elas_mat_7(dmat,ptmp,iddmat,nprop,ierr,errstrng)
      return
      end
c
c
      subroutine get_state_7(state,dstate,sout,nstate)
c
c...  routine to transfer state variables into sout
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "materials.inc"
      include "nconsts.inc"
c
c...  subroutine arguments
c
      integer nstate
      double precision state(nstate),dstate(nstate),sout(3*nstatesmax)
c
      return
      end
c
c
      subroutine update_state_7(state,dstate,nstate)
c
c...  routine to update state variables at the end of a time step.
c     After updating, state should contain the current total values
c     and dstate should contain the incremental changes since the
c     previous time step.
c     On input, dstate contains the current stress and strain values and
c     state contains the values from the previous time step.
c
      include "implicit.inc"
c
c...  parameter definitions
c
      include "nconsts.inc"
      include "rconsts.inc"
c
c...  subroutine arguments
c
      integer nstate
      double precision state(nstate),dstate(nstate)
c
c...  local data
c
c
c...  local variables
c
c
      return
      end
c
c       
c version
c $Id: mat_7.f,v 1.5 2005/04/01 23:10:17 willic3 Exp $

c Generated automatically by Fortran77Mill on Tue May 18 14:18:50 2004

c End of file 
