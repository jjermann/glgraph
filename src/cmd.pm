


# USAGE
sub usage {
print STDERR <<EOF;

Usage: glgraph [options] 'function1' 'function2' ...

options:
  function         Function: f(x,z,t)=function
  -(no)fs          Fullscreen                                (ON)
  -geometry        Window Geometry                           (1024x768+0+0)
  -wid             Window Id                                 ("graph window")
  -noclear         Don't clear the screen (fixes flimmering) (OFF)
  -noanim          No animation mode (for high resolutions)  (OFF)
  -nograph         Don't draw just calculate
  -2d              2D Graph
  -wire            3D Graph: Wireframe
  -3d              3D Graph: Solid                           (DEFAULT)
  -(no)axis        Axis mode                                 ( 0)
  -ax_step         Step size for axis                        ( 1)
  -ax_size         Size of lines (1 for grid)                (0.01)
  -(no)time        Time Graph                                (ON)
  -(no)colors      Color Mode (0=nocolors, 1:mode1, 2:mode2) ( 1)
  -xmin            Beginning of x interval (Window)          (-5)
  -xmax            Ending of x interval (Window)             ( 5)
  -ymin            Beginning of y interval (Window)          (-5)
  -ymax            Ending of y interval (Window)             ( 5)
  -zmin            Beginning of z interval (Window)          (-5)
  -zmax            Ending of z interval (Window)             ( 5)
  -tmin            Beginning of t (time) interval (Window)   (-4)
  -tmax            Ending of t (time) interval (Window)      ( 4)
  -xres            Resolution of x axis (relevant dots)      (50)
  -zres            Resolution of z axis (relevant dots)      (50)
  -xzres           Space Resolution (xres and zres)
  -tres            Resolution of time "axis" (frames)        (50)
  -tsec            Resolution of time "axis" (seconds)       (2.0)
  -cfact           Interval of color function                (0.8)
  -cconst          Displace colors (0-1)                     (0.0)
  -fps             Maximal fps                               (25)
  -h, --help       Display this help message
  -v, --version    Display GLgraph's version number

keys:
  q                Quit
  _ and 0          Reset (default and hard)
  m                Screenshot
  w/a/s/d          Rotation (3°)
  7/8/9            Rotation (90°)
  ü/ö/ä/\$          Translation
  e and r          Scaling
  b and n          Change functions
  1 and 2          Change graphic mode
  3 and 4          Change color range
  p                Toggle preview mode
  c                Toggle color mode
  t                Toggle time mode
  y and x          Seeking
  z and u          Change space resolution
  h and j          Change time resolution

EOF
    exit 1;
}
1;

# COMMAND LINE
sub commandline {
    GetOptions(
        "help|h"             => \&usage,
        "version|v"          => \&version,
        "fullscreen|fs"      => \$options{fullscreen},
        "nofullscreen|nofs"  => sub { $options{fullscreen}=0; },
        "geometry=s"         => sub { @geometry=split(/[x+]/,"$_[1]"); },
        "wid=s"              => \$options{wid},
        "clear"              => sub { $options{clearg}=1; },
        "noclear"            => sub { $options{clearg}=0; },
        "save"               => sub { $options{save}=1; $options{anim}=0; $options{image_name}="image_all.jpg"; },
        "nosave"             => sub { $options{save}=0; },
        "o=s"                => \$options{image_name},
        "info|i"             => sub { $options{info}=1; },
        "anim"               => sub { $options{anim}=1; },
        "noanim"             => sub { $options{anim}=0; },
        "nograph"            => sub { $options{mode}=0; },
        "mode"               => \$options{mode},
        "2d"                 => sub { $options{mode}=1; },
        "wire|3dwire"        => sub { $options{mode}=2; },
        "lookat=s"           => sub { @lookat=split(/,/,"$_[1]"); },
        "3d|3dsolid"         => sub { $options{mode}=3; },
        "axis=i"             => \$options{axis},
        "ax_step=f"          => \$options{ax_step},
        "ax_size=f"          => \$options{ax_size},
        "noaxis"             => sub { $options{axis}=0; },
        "time"               => sub { $options{time}=1; },
        "notime"             => sub { $options{time}=0; },
        "colors=i"           => \$options{color},
        "nocolors"           => sub { $options{color}=0; },
        "xmin=f"             => \$options{xmin},
        "xmax=f"             => \$options{xmax},
        "ymin=f"             => \$options{ymin},
        "ymax=f"             => \$options{ymax},
        "zmin=f"             => \$options{zmin},
        "zmax=f"             => \$options{zmax},
        "tmin=f"             => \$options{tmin},
        "tmax=f"             => \$options{tmax},
        "xres=i"             => \$options{xres},
        "zres=i"             => \$options{zres},
        "xzres=i"            => sub { $options{xres}=$_[1];$options{zres}=$_[1]; },
        "fps=f"              => \$options{fps},
        "tres=i"             => \$options{tres},
        "tsec=f"             => sub { $options{tres}=int($_[1]*$options{fps}); },
        "cfact=f"            => \$options{cfact},
        "cconst=f"           => \$options{cconst},
    ) || usage();

    # Add command line functions
    @yreal = (@ARGV, @yreal);
    for (@yreal) { $_ =~ s/(?<!\w)([xzt])(?!\w)/\$$1/g; }
    for (@yreal) { $_ =~ s/PI/\$PI/g; }
}
1;