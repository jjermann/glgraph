our $last_n;	#pfy,2.11.2002 for the new eval thingi
our $last_mode; #for mode switch.... (2=2d, 3=3d)
our $func_sub;	#eval thingi.....
our ($x,$y,$z,$j,@tripar);

# IDLE
sub idle {
    # activate time function again if 0.1 seconds passed after keyboard event
    if (($time_real) and ((tv_interval($time{key}))>=0.1)) {
        $options{time}=$time_real;
        $time_real="";
    }

    # calculate frame if display list is non-existent
    if (!glIsList($tsize+1)) {
        # real calculation, can be 2d or 3d
        if ($zsize < $options{zres}) {
            if ($options{mode} == 1) {
                idle_2d();
                display(1);
            }
            if ($options{mode} >= 2) {
                idle_3d();
                if ($zsize == $options{zres}) {
                    display(1);
                }
            }
        }
        # change time direction at the end
        if ($zsize == $options{zres}) {
           if ($options{time} == 0) { usleep (0.001); }
           elsif (($options{time} == 1) and ($tsize < ($options{tres}-1))) { reset_all(1); $t += ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize++; }
           elsif (($options{time} == 2) and ($tsize > 0)) { reset_all(1); $t -= ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize--; }
           elsif ($options{time} == 1) { $options{time}=2; reset_all(1); $t -= ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize--; }
           elsif ($options{time} == 2) { $options{time}=1; reset_all(1); $t += ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize++; }
        }
    }
    # change time direction at the end
    elsif ($options{time}) {
        display(1);
        if (($options{time} == 1) and ($tsize < ($options{tres}-1))) { reset_all(1); $t += ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize++; }
        elsif (($options{time} == 2) and ($tsize > 0)) { reset_all(1); $t -= ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize--; }
        elsif ($options{time} == 1) { $options{time}=2; reset_all(1); $t -= ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize--; }
        elsif ($options{time} == 2) { $options{time}=1; reset_all(1); $t += ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize++; }
    }
    # free cpu time if in notime mode...
    else { usleep (0.001); }
}


# SUB IDLE (2D)
sub idle_2d {
    @tripar=();

    $x=$options{xmin};
    $j=0;
    
    # regenerate func_sub if necessary
    if(($last_mode !=2) or ($last_n !=$n)){
        geteval2();
        $last_n=$n;
        $last_mode=2;
    }
                                        
    while ($j<=(2*$options{xres}-2)){
        last if eval{&$func_sub};
        $tripar[$j]=$x;
        $tripar[$j+1]=0;
        $x += ($options{xmax}-$options{xmin})/($options{xres}-1);
        $j=$j+2;
    }
    
    $j = 0;
    $zsize = $options{zres} + 1;

    unshift(@tri2d,@tripar); 
    splice(@tri2d,(2*$options{xres})); 
}    


# SUB IDLE (3D)
sub idle_3d {
    @tripar=();

    $x=$options{xmin};
    $j=0;

    # regenerate func_sub if necessary
    if(($last_mode !=3) or ($last_n !=$n)){
	geteval3();
	$last_n=$n;
	$last_mode=3;
    }
    
    while ($j<=(3*$options{xres}-3)){
        last if eval{&$func_sub};
        $tripar[$j]=$x;
        $tripar[$j+1]=0;
        $tripar[$j+2]=$z;
        $x += ($options{xmax}-$options{xmin})/($options{xres}-1);
        $j=$j+3;
    }
    $j = 0;
    $z += ($options{zmax}-$options{zmin})/($options{zres}-1); 
    $zsize++; # IMPORTANT !!!!

    unshift(@tri3d,@tripar); 
    splice(@tri3d,(9*$options{xres}*$options{zres})); 
}


sub geteval2{
    my $eval_block= '
    while ($j<=(2*$options{xres}-2)) {
    ';
    $eval_block.= "\$y = $yreal[$n];";
    $eval_block.= '
        $tripar[$j]=$x;
        $tripar[$j+1]=$y;
        $x += ($options{xmax}-$options{xmin})/($options{xres}-1); 
        $j=$j+2;
    }
    return 1;
    ';

    $func_sub= eval("sub{$eval_block};");
}

sub geteval3{
    my $eval_block='
    while ($j<=(3*$options{xres}-3)) {
    ';
    $eval_block.= "\$y = $yreal[$n];";
    $eval_block.= '
        $tripar[$j]=$x;
        $tripar[$j+1]=$y;
        $tripar[$j+2]=$z;
        $x += ($options{xmax}-$options{xmin})/($options{xres}-1); 
        $j=$j+3;
    }
    return 1;
    ';

    $func_sub= eval("sub{$eval_block}");
}


1;