!```````````````````````````````````````````````````````````````````````````````````````````
! Copyright (c) 2018 Shahram Yalameha <yalameha93@gmail.com> , <sh.yalameha@sci.ui.ac.ir>, `
!               Please report bugs or suggestions to:  yalameha93@gmail.com                `
!                                                                                          `
!```````````````````````````````````````````````````````````````````````````````````````````
! SUBROUTINE: fOR 2D MATERIAL , CALCULATED shear modulus.

!REF: Jasiukiewicz, Cz, T. Paszkiewicz, and S. Wolski. "Auxetic properties and anisotropy of elastic material constants of 2D crystalline media." 
!physica status solidi (b) 245.3 (2008): 562-569.

 SUBROUTINE adv_2D(phi,phi_pro,l,pro,method,Max_pro, Min_pro)
    implicit none
    CHARACTER(len=5)                    :: pro 
    CHARACTER(len=3)                    :: method  ! 1 = o 2 = r 3 = q
    DOUBLE PRECISION                    :: Max_pro, Min_pro, phi, val_pro, sai_G, r_G, o_G, G,G_inver, E_inver, poi_inver,  sahy,g0,rg0,tansh,sahy1,rv,pe0,tansh1
    DOUBLE PRECISION, DIMENSION(2010)   :: phi_pro,pro_max_phi
    DOUBLE PRECISION, DIMENSION(3,3)    :: C,S
    Integer                             :: n,i,j,l
     n=3
       
     OPEN(58,FILE="Cij-2D.dat",STATUS='OLD',ACTION='READ')
     DO i=1,n
       READ(58,*) (C(i,j),j=1,n)
     ENDDO
     close(58)
     n=3
     OPEN(51,FILE="Sij-2D.dat",STATUS='OLD',ACTION='READ')
     DO i=1,n
       READ(51,*) (S(i,j),j=1,n)
     ENDDO
     close(51)

     IF(method == 'adv' .and. pro == "shear" ) THEN
     !!!!!!!!!!!!!!!!! test method 1
     
     ! G_inver     =   S(1,1) *      ( COS(phi)*COS(phi)*SIN(phi)*SIN(phi) ) +&
	     !               S(1,2) *-2.D0*( COS(phi)*SIN(phi)*SIN(phi)*COS(phi) ) +&
	     !               S(2,2) *      ( SIN(phi)*SIN(phi)*COS(phi)*COS(phi) ) +&
	     !               S(1,3) *      ( SIN(phi)*SIN(phi)*COS(phi)*SIN(phi)   -      SIN(phi)*COS(phi)*COS(phi)*COS(phi) )+&
	     !               S(2,3) *      ( COS(phi)*COS(phi)*COS(phi)*SIN(phi)   -      SIN(phi)*COS(phi)*SIN(phi)*SIN(phi) )+&
	     !               S(3,3) *      ( COS(phi)*COS(phi)*COS(phi)*COS(phi)   - 2.D0*COS(phi)*SIN(phi)*SIN(phi)*COS(phi)  + SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) * (1.d0/4.d0)
     ! phi_pro(l)  = 1.D0/(4.D0*G_inver)
     
      !!!!!!!!!!!!!!!!! test method 2 
      
      g0=2.0d0/(S(1,1)+S(2,2)-2.0D0*S(1,2)+S(3,3))
      rg0=((((  (((S(3,3)+2.0d0*S(1,2)-S(1,1)-S(2,2))/8.d0)**2.d0)) +  ( (S(2,3)-S(1,3))/4.d0 )**2.0d0)    )**0.5d0)
      tansh=( 2d0*(S(1,6)-S(2,6) ))/(S(3,3)+2d0*S(1,2)-S(1,1)-S(2,2))
      sahy=atan(tansh)
      G_inver = (1.0d0 + 4.d0*g0*rg0*cos(4.d0*phi+sahy))/g0
      phi_pro(l)  = 1.D0/(G_inver)
       !!!!!!!!!!!!!!!!! test method 2.1
     ! G_inver = (S(2,2)+S(1,1)-2D0*S(1,2))*SIN(phi)*SIN(phi)*COS(phi)*COS(phi) + &
      !          (1.d0/4.0d0)*S(3,3)*(COS(phi)**4 + SIN(phi)**4 -2.0D0*SIN(phi)*SIN(phi)*COS(phi)*COS(phi)) + &
      !            S(1,6)*(COS(phi)*SIN(phi)**3 - SIN(phi)*COS(phi)**3)*sqrt(2.0) + &
      !            S(2,6)*(SIN(phi)*COS(phi)**3 - COS(phi)*SIN(phi)**3)*sqrt(2.0)  
      !          phi_pro(l)  = 1.D0/(4.0D0*G_inver)


     ENDIF
     !===============================================
     IF(method == 'adv' .and. pro == "young" ) THEN
      E_inver     = S(1,1) *     ( COS(phi)*COS(phi)*COS(phi)*COS(phi) ) +&    
                    S(1,2) *2.d0*( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&       
                    S(2,2) *     ( SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
                    S(3,3) *     ( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&
                    S(2,3) *2.d0*( COS(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
                    S(1,3) *2.d0*( SIN(phi)*COS(phi)*COS(phi)*COS(phi) ) 
      phi_pro(l)  = 1.D0 / E_inver
      
     ENDIF
     !!!!!!!!!!!!!!!!! test method 1
     
     IF(method == 'adv' .and. pro == "poi" ) THEN
      !E_inver     = S(1,1) *     ( COS(phi)*COS(phi)*COS(phi)*COS(phi) ) +&    
      !               S(1,2) *2.d0*( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&       
      !               S(2,2) *     ( SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
      !               S(3,3) *     ( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&
      !               S(1,3) *2.d0*( COS(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
      !               S(2,3) *2.d0*( SIN(phi)*COS(phi)*COS(phi)*COS(phi) ) 

      !  poi_inver =   S(1,1) * ( SIN(phi)*SIN(phi)*COS(phi)*COS(phi) )                                      +&
      !                S(1,2) * ( SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) + COS(phi)*COS(phi)*COS(phi)*COS(phi) )+&
      !                S(2,2) * ( SIN(phi)*SIN(phi)*COS(phi)*COS(phi) )                                      +&
      !                S(1,3) * ( SIN(phi)*SIN(phi)*COS(phi)*SIN(phi) - SIN(phi)*COS(phi)*COS(phi)*COS(phi) )+&
      !                S(2,3) * ( COS(phi)*COS(phi)*COS(phi)*SIN(phi) - SIN(phi)*COS(phi)*SIN(phi)*SIN(phi) )+&
     !                 S(3,3) * ( SIN(phi)*COS(phi)*COS(phi)*SIN(phi) * -1.0D0 )
      ! phi_pro(l)  = -(poi_inver / E_inver)
       !WRITE(*,*) phi*(180D0/3.1415),phi_pro(l) ,l
       
       !!!!!!!!!!!!!!!!! test method 2
        E_inver     = S(1,1) *     ( COS(phi)*COS(phi)*COS(phi)*COS(phi) ) +&    
                      S(1,2) *2.d0*( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&       
                      S(2,2) *     ( SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
                      S(3,3) *     ( SIN(phi)*COS(phi)*SIN(phi)*COS(phi) ) +&
                      S(1,3) *2.d0*( COS(phi)*SIN(phi)*SIN(phi)*SIN(phi) ) +&
                      S(2,3) *2.d0*( SIN(phi)*COS(phi)*COS(phi)*COS(phi) ) 

        poi_inver =   S(1,1) * ( SIN(phi)*SIN(phi)*COS(phi)*COS(phi) )                                      +&
                      S(1,2) * ( SIN(phi)*SIN(phi)*SIN(phi)*SIN(phi) + COS(phi)*COS(phi)*COS(phi)*COS(phi) )+&
                      S(2,2) * ( SIN(phi)*SIN(phi)*COS(phi)*COS(phi) )                                      +&
                      S(1,3) * ( SIN(phi)*SIN(phi)*COS(phi)*SIN(phi) - SIN(phi)*COS(phi)*COS(phi)*COS(phi) )+&
                      S(2,3) * ( COS(phi)*COS(phi)*COS(phi)*SIN(phi) - SIN(phi)*COS(phi)*SIN(phi)*SIN(phi) )+&
                      S(3,3) * ( SIN(phi)*COS(phi)*COS(phi)*SIN(phi) * -1.0D0 )
                     
          phi_pro(l)  =  -(poi_inver / E_inver)  
         ! WRITE(*,*) phi*(180D0/3.1415),phi_pro(l) ,l
        ! pe0= ( (S(1,1)+S(2,2)-S(3,3))*0.5d0 + 3.d0*S(1,2) ) * 0.25d0
        ! rv = (SQRT((S(2,3)-S(1,3))**2.0d0 + (S(1,2)-(( S(1,1)+S(2,2)-S(3,3) )/2.0d0))**2.d0))/4.0d0
        ! tansh1=(S(2,3)-S(1,3))/(S(1,2)-((S(1,1)+S(2,2)-S(3,3))/2.0d0))
        !sahy1=atan(tansh1)
        ! poi_inver = -pe0 +   rv * cos(4.d0*phi + sahy1)
        ! phi_pro(l)  = -poi_inver  
        !WRITE(*,*)   pe0,rv,cos(4.d0*phi)
      IF (l.EQ.0) THEN 
        Max_pro=phi_pro(l); Min_pro=phi_pro(l);   
      ELSE
        IF (phi_pro(l).GE.Max_pro) THEN
          Max_pro=phi_pro(l)
          !WRITE(*,*) phi*(180D0/3.1415),Max_pro
        END IF  
        IF (phi_pro(l).LE.Min_pro) THEN
          Min_pro=phi_pro(l) 
          !WRITE(*,*) Min_pro    
        END IF  
      END IF
     ENDIF
     !===============================================     

    END SUBROUTINE
