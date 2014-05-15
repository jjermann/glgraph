


# COLOR
sub scolor { 
    if ($options{color} == 1) {
        return(0.8*sin($_[0]*$options{cfact}+2*$options{cconst}*$PI),0.8*sin($_[0]*$options{cfact}+2*$PI/3+2*$options{cconst}*$PI),0.8*sin($_[0]*$options{cfact}+4*$PI/3+2*$options{cconst}*$PI));
    }
    elsif ($options{color} == 2) {
        my ($r,$b,$g,$a);
        $r=$b=$g=0; 
        $a=(($_[0]-$options{ymin})/($options{ymax}-$options{ymin})*$options{cfact});

        $r=$a*3;
        $r=1 if ($r > 1);

        $g=($a*3-1) if ((($a*3-1) > 0));
        $g=1 if ($g > 1);

        $b=($a*3-2) if ((($a*3-2) > 0));
        $b=1 if ($b > 1);

        return($r,$g,$b);
    }
}
1;