rm -f *.mod *.o *.out

FC=mpif90
#XFLAG='-O3 -cpp -fcoarray=single -mcmodel=medium -DFFTFINE'
XFLAG='-O3 -cpp -fcoarray=single -DFFTFINE'
OFLAG=${XFLAG}' -c'
FFTFLAG='-lfftw3f -lm -ldl'

$FC $OFLAG ../main/parameters.f90
$FC $OFLAG ../main/pencil_fft.f90 $FFTFLAG
$FC $OFLAG powerspectrum.f90 $FFTFLAG
$FC $OFLAG displacement.f90 $FFTFLAG

$FC $XFLAG parameters.o pencil_fft.o powerspectrum.o displacement.o $FFTFLAG
