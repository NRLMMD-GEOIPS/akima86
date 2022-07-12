! Author:
!    Naval Research Laboratory, Marine Meteorology Division
!
! This program is free software: you can redistribute it and/or modify it under
! the terms of the NRLMMD License included with this program.  If you did not
! receive the license, see http://www.nrlmry.navy.mil/<LICENSE_INFO> for more
! information.
! This program is distributed WITHOUT ANY WARRANTY; without even the implied
! warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! included license for more details.
!
! Improved Akima method (Akima 1986) for 1-D piecewise polynomial interpolation.
! Original code by H. Akima, 1986.
! Modified for modern Fortran by D. Ryglicki, Monterey, CA, 2020.
!  - No more implicit typing
!  - Double precision
!  - No more GO TO commands
!  - Modern print formatting statements with automatic allocation.
!  - No EQUIVALENCE statement in UVIPIA
!  - 2021-01-24 -- Added OpenMP to UVIPIA
!  - 2021-03-07 -- Fixed OpenMP bug
!
! UVIPIA is the subroutine where all the heavy lifting occurs.
!
subroutine uvipia(np,nd,xd,yd,ni,xi,yi)
!   use, intrinsic :: iso_fortran_env
    use omp_lib
    implicit none
!   integer, parameter :: sp = real32
!   integer, parameter :: dp = real64
!   integer, parameter :: qp = real128

! *** Univariate interpolation (improved Akima method) ***
! This subroutine performs univariate interpolation. It is
! based on the improved Akima method.
! In this method, the interpolating function is a piecewise
! function composed of a set of polynomials of the degree
! specified by the user, applicable to successive intervals of
! the given datapoints. The method uses seven datapoints for
! estimating the first derivative of the function (or the slope
! of the curve) at each data point. It has the accuracy of a
! third-degree polynomial if the degree of the polynomials
! for the interpolating function is set to three.
!
! The input arguments are:
!   np = polynomial degree of interpolating function
!   nd = number of input data points (>2)
!   xd = array of dimension nd, containing the abscissas
!        of the input data points (monotonic increasing)
!   yd = array of dimension nd, containing the
!        ordinates of the input data points
!   ni = number of interpolation points
!   xi = array of dimension ni, containing the abscissas
!        of the input data points
! If an integer value smaller than 3 is given as the np argument,
! this subroutine assumes np = 3
! The xi numbers do not need to be monotonic, but the subroutine
! will be faster if they are.
!
! The output argument is:
!   yi = array of dimension ni, where the ordinates of the
!        desired points are to be stored.
    integer, intent(in)        :: np, nd, ni
    real(kind=8), intent(in)  :: xd(nd), yd(nd), xi(ni)
    real(kind=8), intent(out) :: yi(ni)
    real(kind=8) :: x0, x1, x2, x3, y0, y1, y2, y3, xx, xii
    real(kind=8) :: xuse(3), yuse(3) ! Modification of EQUIVALENCE statement in original.
    real(kind=8) :: diff(nd)
    real(kind=8) :: xstart, xend
    real(kind=8) :: smpef, smwtf, smpei, smwti, dlt, a1, a2, a3, epsln, a12, a13
    real(kind=8) :: pe, sx, sy, sxx, sxy, dnm, b0, b1
    real(kind=8) :: dy0, dy1, dy2, dy3, var, wt, renpm1, rennm2
    real(kind=8) :: yp0, yp1, yp, dx, dy, t0, t1, aa0, aa1, u, uc, v
    integer       :: id, ii, iint, id0, id1, id2, id3, iept, ipe
    integer       :: np0, npm1, iintpv

    yi(:) = -9999.0
    if (nd <= 1) then
      print * , "UVIPIA: Fewer than two input grid points. Cannot interpolate. Exiting."
      return
    endif
    diff(:) = epsilon(x1)
    diff(1:nd-1) = xd(2:nd) - xd(1:nd-1)
    if (any(diff <= 0.0)) then
       print * , "UVIPIA: XD are not monotonically increasing. Exiting."
       return
    endif
    if (np < 3) print * , "UVIPIA: Warning. NP < 3. It is being set to 3."
    xstart = xd(1) ; xend = xd(nd)

    if (nd <= 4) then ! Special cases, fewer than 5 input points.
      x0 = xd(1)
      y0 = yd(1)
      do id = 2,nd
        xuse(id-1) = xd(id) - x0
        yuse(id-1) = yd(id) - y0
      end do
      if (nd == 2) then
        a1 = yuse(1)/xuse(1)
!$omp parallel &
!$omp private (ii) &
!$omp shared  (ni,yi,y0,a1,xi,x0)
!$omp do
        do ii = 1,ni
          yi(ii) = y0 + a1*(xi(ii) - x0)
        end do
!$omp end do
!$omp end parallel
      elseif (nd == 3) then
        dlt = xuse(1) * xuse(2) * (xuse(2)-xuse(1))
        a1 = (xuse(2)*xuse(2)*yuse(1) - xuse(1)*xuse(1)*yuse(2)) / dlt
        a2 = (xuse(1)*yuse(2) - xuse(2)*yuse(1)) / dlt
        a12 = 2.0 * a2 * xuse(2) + a1
!$omp parallel &
!$omp private (ii,xx) &
!$omp shared  (ni,xi,x0,yi,y0,a1,a2,a12,xuse,yuse)
!$omp do
        do ii = 1,ni
          xx = xi(ii) - x0
          if (xx <= 0.0) then
            yi(ii) = y0 + a1*xx
          elseif (xx < xuse(2)) then
            yi(ii) = y0 + xx*(a1 + xx*a2)
          else
            yi(ii) = y0 + yuse(2) + a12*(xx - xuse(2))
          endif
        end do
!$omp end do
!$omp end parallel
      else
        dlt = (xuse(1) * xuse(2) * xuse(3)) * &
              (xuse(2) - xuse(1))*(xuse(3) - xuse(2)) * &
              (xuse(3) - xuse(1))
        a1 = ( ((xuse(2) * xuse(3))**2) * (xuse(3) - xuse(2))*yuse(1) + &
               ((xuse(3) * xuse(1))**2) * (xuse(1) - xuse(3))*yuse(2) + &
               ((xuse(1) * xuse(2))**2) * (xuse(2) - xuse(1))*yuse(3) ) / dlt
        a2 = ( (xuse(2)*xuse(3)*(xuse(2)*xuse(2) - xuse(3)*xuse(3))*yuse(1)) + &
               (xuse(3)*xuse(1)*(xuse(3)*xuse(3) - xuse(1)*xuse(1))*yuse(2)) + &
               (xuse(1)*xuse(2)*(xuse(1)*xuse(1) - xuse(2)*xuse(2))*yuse(3)) ) / dlt
        a3 = ( (xuse(2)*xuse(3)*(xuse(3) - xuse(2)) * yuse(1)) + &
               (xuse(3)*xuse(1)*(xuse(3) - xuse(2)) * yuse(1)) + &
               (xuse(2)*xuse(1)*(xuse(2) - xuse(1)) * yuse(3)) ) / dlt
        a13 = (3.0 * a3 * xuse(3) + 2.0*a2)*xuse(3) + a1
!$omp parallel &
!$omp private (ii,xx) &
!$omp shared  (ni,x0,xi,y0,a1,yuse,xuse,a2,a3,yi,a13)
!$omp do
        do ii = 1,ni
          xx = xi(ii) - x0
          if (xx <= 0.0) then
            yi(ii) = y0 + a1*xx
          elseif (xx >= xuse(3)) then
            yi(ii) = y0 + yuse(3) + a13*(xx - xuse(3))
          else
            yi(ii) = y0 + xx*(a1 + xx*(a2 + xx*a3))
          endif
        end do
!$omp end do
!$omp end parallel
      endif
    else ! General case
      epsln = epsilon(smpef)
      np0 = max(3,np)
      npm1 = np0 - 1
      renpm1 = real(npm1, kind=8)
      rennm2 = real(np0 * (np0 - 2), kind=8)
      iintpv = -1
!$omp parallel &
!$omp default (private) &
!$omp firstprivate (iintpv) &
!$omp shared (yi,xd,yd,xi,ni,nd,epsln,np0,npm1,renpm1,rennm2,xstart,xend)
!$omp do
      do ii = 1,ni
        print * , omp_get_thread_num(), ii
        xii = xi(ii)
        if (xii <= xstart) then
          iint = 0
        elseif (xii >= xend) then
          iint = nd
        else
          diff(:) = xd(:) - xii
          iint = maxloc(diff(:), dim=1, mask = diff(:) <= 0.0)
        endif
        if (iint <= 0) then ! Extrapolation before beginning
          if (iint /= iintpv) then
            iintpv = iint
            x0 = xd(1)
            x1 = xd(2) - x0
            x2 = xd(3) - x0
            x3 = xd(4) - x0
            y0 = yd(1)
            y1 = yd(2) - y0
            y2 = yd(3) - y0
            y3 = yd(4) - y0
            dlt = x1*x2*x3*(x2-x1)*(x3-x2)*(x3-x1)
            a1 = ( ((x2*x3)**2)*(x3-x2)*y1 + &
                   ((x3*x1)**2)*(x1-x3)*y2 + &
                   ((x1*x2)**2)*(x2-x1)*y3 ) / dlt
          endif
          yi(ii) = y0 + a1*(xii-x0)
        elseif (iint >= nd) then ! Extrapolation past end
          if (iint /= iintpv) then
            iintpv = iint
            x0 = xd(nd)
            x1 = xd(nd-1) - x0
            x2 = xd(nd-2) - x0
            x3 = xd(nd-3) - x0
            y0 = yd(nd)
            y1 = yd(nd-1) - y0
            y2 = yd(nd-2) - y0
            y3 = yd(nd-3) - y0
            dlt = x1*x2*x3*(x2-x1)*(x3-x2)*(x3-x1)
            a1 = ( ((x2*x3)**2)*(x3-x2)*y1 + &
                   ((x3*x1)**2)*(x1-x3)*y2 + &
                   ((x1*x2)**2)*(x2-x1)*y3) / dlt
          endif
          yi(ii) = y0 + a1*(xii-x0)
        else ! Interpolation
         if (iint /= iintpv) then
          iintpv = iint
          do iept = 1,2
            id0 = iint + iept - 1
            x0 = xd(id0)
            y0 = yd(id0)
            smpef = 0.0
            smwtf = 0.0
            smpei = 0.0
            smwti = 0.0
            ! Primary estimate of the derivative.
            do ipe = 1,4
              if (ipe == 1) then
                id1 = id0 - 3
                id2 = id0 - 2
                id3 = id0 - 1
              elseif (ipe == 2) then
                id1 = id0 + 1
              elseif (ipe == 3) then
                id2 = id0 + 2
              else
                id3 = id0 + 3
              endif
              if (id1 < 1  .or. &
                  id2 < 1  .or. &
                  id3 < 1  .or. &
                  id1 > nd .or. &
                  id2 > nd .or. &
                  id3 > nd ) cycle
              x1 = xd(id1) - x0
              x2 = xd(id2) - x0
              x3 = xd(id3) - x0
              y1 = yd(id1) - y0
              y2 = yd(id2) - y0
              y3 = yd(id3) - y0
              dlt = x1*x2*x3*(x2-x1)*(x3-x2)*(x3-x1)
              pe =( ((x2*x3)**2)*(x3-x2)*y1 + &
                    ((x3*x1)**2)*(x1-x3)*y2 + &
                    ((x1*x2)**2)*(x2-x1)*y3) / dlt
            ! Weight for the primary estimate
              sx = x1 + x2 + x3
              sy = y1 + y2 + y3
              sxx = x1*x1 + x2*x2 + x3*x3
              sxy = x1*y1 + x2*y2 + x3*y3
              dnm = 4.0*sxx - sx*sx
              b0 = (sxx*sy - sx*sxy) / dnm
              b1 = (4.0*sxy - sx*sy) / dnm
              dy0 = -b0
              dy1 = y1 - (b0 + b1*x1)
              dy2 = y2 - (b0 + b1*x2)
              dy3 = y3 - (b0 + b1*x3)
              var = (dy0*dy0) + (dy1*dy1) + (dy2*dy2) + (dy3*dy3)
              if ( var > epsln ) then
                wt = 1.0 / (var*sxx)
                smpef = smpef + pe*wt
                smwtf = smwtf + wt
              else
                smpei = smpei + pe
                smwti = smwti + 1.0
              endif
            end do
 ! Final estimate of the derivative.
            if (smwti < 0.5) then
              yp = smpef / smwtf
            else
              yp = smpei / smwti
            endif
            if ( iept == 1 ) then
              yp0 = yp
            else
              yp1 = yp
            endif
          end do
! Coefficients of the third-degree polynomial or the factors of the basic polynomials
          x0 = xd(iint)
          dx = xd(iint+1) - x0
          y0 = yd(iint)
          dy = yd(iint+1) - y0
          if (np0 <= 3) then
! Coefficients of the third-degree polynomial when np <= 3
            a1 = yp0
            yp1 = yp1 - yp0
            yp0 = yp0 - dy/dx
            a2 = -(3.0*yp0 + yp1) / dx
            a3 =  (2.0*yp0 + yp1) / (dx*dx)
          else
            t0 = yp0*dx - dy
            t1 = yp1*dx - dy
            aa0 =  (t0 + renpm1*t1)/rennm2
            aa1 = -(renpm1*t0 + t1)/rennm2
          end if
         endif ! iintpv check
! Evaluation (finally) of yi value
          if (np0 <= 3) then
            xx = xii-x0
            yi(ii) = y0 + (xx * (a1+xx*(a2 + xx*a3)))
          else
            u = (xii-x0)/dx
            uc = 1.0 - u
            v = ( aa0 * u * (-1.0 + u**npm1) ) + &
                ( aa1 * uc * (-1.0 + uc**npm1) )
            yi(ii) = y0 + dy*u + v
          endif
        endif
      end do
!$omp end do
!$omp end parallel
    endif

end subroutine uvipia
