#define proj3d
! single node, fine cell, NGP projection
subroutine projection
use variables
implicit none
save
integer idxf(3),np
real proj_yz(nf,nf), proj_xz(nf,nf), proj_xy(nf,nf)
#ifdef proj3d
  !real proj_3d(nf,nf,nf)[*]
  real proj_3d_global(nf*nn,nf*nn,nf*nn)
#endif

if (head) print*, 'projection'

proj_yz=0
proj_xz=0
proj_xy=0
#ifdef proj3d
  proj_3d=0
#endif

ip=0

do itz=1,nnt
do ity=1,nnt
do itx=1,nnt
do k=1,nt
do j=1,nt
do i=1,nt
  np=rhoc(i,j,k,itx,ity,itz)
  do l=1,np
    ip=ip+1
    !idxf=ceiling( nft*((/itx,ity,itz/)-1) &
    !             +4.0*((/i,j,k/)-1) &
    !             +0.015625*((x(:,ip)+int(-128,1))+128.5) )
    idxf=ceiling(nft*((/itx,ity,itz/)-1)+ncell*((/i,j,k/)-1) &
                 +(x(:,ip)+ishift+rshift)*ncell*x_resolution)
    proj_yz(idxf(2),idxf(3))=proj_yz(idxf(2),idxf(3))+1
    proj_xz(idxf(1),idxf(3))=proj_xz(idxf(1),idxf(3))+1
    proj_xy(idxf(1),idxf(2))=proj_xy(idxf(1),idxf(2))+1
#ifdef proj3d
    proj_3d(idxf(1),idxf(2),idxf(3))=proj_3d(idxf(1),idxf(2),idxf(3))+1
#endif
  enddo
enddo
enddo
enddo
enddo
enddo
enddo
sync all

if (head) then
  do k=1,nn
  do j=1,nn
  do i=1,nn
    proj_3d_global((i-1)*nf+1:i*nf,(j-1)*nf+1:j*nf,(k-1)*nf+1:k*nf)=proj_3d(:,:,:)[image1d(i,j,k)]
  enddo
  enddo
  enddo
  open(11,file='proj_3d_global.bin',status='replace',access='stream')
  write(11) proj_3d_global
  close(11)
endif


!open(11,file='./output/proj_yz.dat',status='replace',access='stream')
!write(11) proj_yz
!close(11)

!open(12,file='./output/proj_xz.dat',status='replace',access='stream')
!write(12) proj_xz
!close(12)

!open(13,file='./output/proj_xy.dat',status='replace',access='stream')
!write(13) proj_xy
!close(13)

!#ifdef proj3d
!open(14,file='./output/proj_3d.dat',status='replace',access='stream')
!write(14) proj_3d
!close(14)
!#endif
sync all

endsubroutine
