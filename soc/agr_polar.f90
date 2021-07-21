
!```````````````````````````````````````````````````````````````````````````````````````````
! Copyright (c) 09/08/2018 Shahram Yalameha <yalameha93@gmail.com> , <sh.yalameha@sci.ui.ac.ir>, `
!               Please report bugs or suggestions to:  yalameha93@gmail.com                `
!                                                                                          `
!```````````````````````````````````````````````````````````````````````````````````````````
! SUBROUTINE: For 3D matereials; convert polat to plane for agr file

SUBROUTINE polar2xy(theta,rho,x,y)
  implicit none
  DOUBLE PRECISION, PARAMETER        :: pi=3.14159265358979323846264338327950D0 
 	REAL(8) :: rho,x,y,theta
 	
	  x = (rho*( COS(theta*pi/180.0d0) ))
	  y = (rho*( SIN(theta*pi/180.0d0) ))	  
 END SUBROUTINE polar2xy
 
 

