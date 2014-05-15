

# SCREENSHOT
sub screenshot {
    my $fname="$options{image_name}";
    $fname =~ s/(.*)\.(.*)/$1/;
    my $fext="$options{image_name}";
    $fext =~ s/(.*)\.(.*)/$2/;
    my $func=$yreal[$n];
    $func =~ s/\$//g;
    my $tres_sec = $options{tres}/$options{fps};
    my $tframe = $tsize+1;
    my $num = 1;
    my $filename;

    # take screenshot
    if (!($options{save}) and ($options{image_name} =~ /\./)) {
        $num++ while(-f ($filename=sprintf("$fname\_%.4d\.$fext",$num)) );
        system("import -silent -window \"$options{wid}\" \"$filename\"");
    }
    elsif ($options{image_name} =~ /\./) {
        $filename=sprintf("$fname\_%.4d\.$fext",$tframe);
        system("rm $filename") if (-f $filename);
        system("import -silent -window \"$options{wid}\" \"$filename\"");
    }

    # create info file
    if ((! -f "$fname\_info.txt") and $options{info}) {
        if(open(IMAGE,">$fname\_info.txt")){
            print IMAGE "$fname\n";
            print IMAGE "----------------\n\n";
            print IMAGE "Function:          f(x,y,z) = $func \n\n";
            print IMAGE "Window:\n";
            print IMAGE "x Interval         \[ $options{xmin}  \-  $options{xmax} \] \n";
            print IMAGE "y Interval         \[ $options{ymin}  \-  $options{ymax} \] \n";
            print IMAGE "z Interval         \[ $options{zmin}  \-  $options{zmax} \] \n";
            print IMAGE "t Interval         \[ $options{tmin}  \-  $options{tmax} \] \n\n";
            print IMAGE "Math. Resolution:\n";
            print IMAGE "x Resolution       $options{xres} \n";
            print IMAGE "z Resolution       $options{zres} \n";
            print IMAGE "t Resolution       $tres_sec","s \n";
            print IMAGE "in Frames ($options{fps}fps)  $options{tres} \n\n";
            print IMAGE "Output:\n";
            print IMAGE "Resolution         $options{width}x$options{height} \n";
            print IMAGE "Output mode        $options{mode} \n";
            print IMAGE "Color mode         $options{color} \n";
            print IMAGE "Axis mode          $options{axis} \n\n";
            print IMAGE "Misc:\n";
            print IMAGE "Color factor       $options{cfact} \n";
            print IMAGE "Color constant     $options{cfact} \n";
            print IMAGE "Axis Step          $options{ax_step} \n";
            print IMAGE "Axis Size          $options{ax_size} \n";
            print IMAGE "(Time frame/time   $tframe / $t) \n\n";
            print IMAGE "Command line: \n";
            print IMAGE "glgraph -mode $options{mode} -colors $options{color} -axis $options{axis} -ax_step $options{ax_step} -ax_size $options{ax_size} -xmin $options{xmin} -xmax $options{xmax} -ymin $options{ymin} -ymin $options{ymax} -zmin $options{xmin} -zmin $options{zmin} -xmin $options{tmin} -xmin $options{tmin} -xres $options{xres} -zres $options{zres} -tres $options{tres} -fps $options{fps} -geometry \"$options{width}x$options{height}\" -o \"$options{image_name}\" \'$func\'\n";
            close(IMAGE);
        }
    }
}
1;