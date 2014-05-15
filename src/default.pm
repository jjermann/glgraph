


# DEFAULT OPTIONS
sub options {
    # Init variables
    $options{fullscreen} = 1;
    @geometry = (1024,768,0,0);
    $options{wid} = "graph window";
    $options{save} = 0;
    $options{image_name} = "image.jpg";
    $options{info} = 0;
    $n = 0;
    $PI = 3.415926535898;

    # TESTING OPTIONS
    $options{clearg}=1;
    $options{anim}=1;
    
    # Mode:
    #   0   no graph
    #   1   2d
    #   2   3d wire
    #   3   3d solid
    # Time:
    #   0   stable (no time)
    #   1   time-function forward
    #   2   time-function backward
    # Color:
    #   0   no colours
    #   1   iterative color-mode 1
    #   2   absolute color-mode 2 (pfy)
    # Axis (values can be added): TODO
    #   0   no axis
    #   1   default (grid for ax_size 1)
    #   2   3D square
    #   3   3D cube
    # View: TODO
    #   0   orthographic viewing
    #   1   perspective viewing
    #   2   stereo viewing
    #   3   2nd way of stereo viewing
    
    $options{mode}    = 3;
    $options{time}    = 1;
    $options{color}   = 1;
    $options{axis}    = 0;
    #$options{view}    = 0;

    # Window
    $options{xmin}    = -5;
    $options{xmax}    = 5;
    $options{ymin}    = -5;
    $options{ymax}    = 5;
    $options{zmin}    = -5;
    $options{zmax}    = 5;
    $options{tmin}    = -4;
    $options{tmax}    = 4;

    # Axis and misc
    $options{xres}    = 50;
    $options{zres}    = 50;
    $options{tres}    = 50;
    $options{fps}     = 25;
    $options{cfact}   = 0.8;
    $options{cconst}  = 0.0;
    $options{ax_step} = 1;
    $options{ax_size} = 0.01;

    # Functions
    $yreal[0] = '2*cos(t*sqrt(z*z+x*x)-2*atan(x/z))';
    $yreal[1] = '(cos(t*sqrt(z*z+x*x))-sin(t*sqrt(z*z+x*x)))*exp(-sqrt(z*z+x*x))*5';
    $yreal[2] = '0.02*z*sin(t*(z-x))-x*cos(z*x-t)';
    $yreal[3] = '2*sin(x*x+z*z+t*t)';
}
1;