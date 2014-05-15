


# KEYBOARD
sub keyboard {
    # deactivate time function (activated in idle again)
    if (($options{time}!=0) and (!$time_real)) {
        $time_real=$options{time};
        $options{time}=0;
    }
    $time{key} = [gettimeofday];

    my ($key) = @_; 
    $key = chr($key);
    
    # Misc
    if   ($key=~/q/){ exit(); }
    elsif($key=~/m/){ screenshot(); }
    elsif($key=~/3/){
        $options{cfact}=$options{cfact}*0.98;
        if (glIsList($tsize+1)) { reset_all(17); }
        else {
            reset_all(16);
            glutPostRedisplay();
        }
    }
    elsif($key=~/4/){
        $options{cfact}=$options{cfact}*1.02;
        reset_all(17);
        if (glIsList($tsize+1)) { reset_all(17); }
        else {
            reset_all(16);
            glutPostRedisplay();
        }
    }

    # Preview
    elsif($key=~/p/){ reset_all(16); preview(2); }
    
    # Function change
    elsif($key=~/n/){ $n++; reset_all(17); }
    elsif(($key=~/b/) and ($n > 0)){ $n--; reset_all(17); }

    # Mode change
    elsif(($key=~/1/) and ($options{mode}>0)){ $options{mode}--; reset_all(17); }
    elsif(($key=~/2/) and ($options{mode}<3)){ $options{mode}++; reset_all(17); }
    elsif($key=~/c/) { 
        $options{color}++;
        if ($options{color} >=3) { $options{color}=0; }
        reset_all(17);
        #if (glIsList($tsize+1)) { reset_all(17); }
        #else {
        #    reset_all(16);
        #    glutPostRedisplay();
        #}
    }
    elsif($key=~/t/) { 
        if (!$time_real) { $options{time}=1; }
        else { $options{time}=0; $time_real=(); }
    }

    # Extend : BUGGY
    elsif($key=~/R/) { $options{xmin}*=0.9; $options{xmax}*=0.9; $options{ymin}*=0.9; $options{ymax}*=0.9; $options{zmin}*=0.9; $options{zmax}*=0.9; reset_all(31); }
    elsif($key=~/E/) { $options{xmin}*=1.1; $options{xmax}*=1.1; $options{ymin}*=1.1; $options{ymax}*=1.1; $options{zmin}*=1.1; $options{zmax}*=1.1; reset_all(31); }
    elsif($key=~/D/) { $options{xmin}-=($options{xmax}-$options{xmin})*0.1; $options{xmax}-=($options{xmax}-$options{xmin})*0.1; reset_all(31); }
    elsif($key=~/A/) { $options{xmin}+=($options{xmax}-$options{xmin})*0.1; $options{xmax}+=($options{xmax}-$options{xmin})*0.1; reset_all(31); }
    elsif($key=~/X/) { $options{ymin}-=($options{ymax}-$options{ymin})*0.1; $options{ymax}-=($options{ymax}-$options{ymin})*0.1; reset_all(31); }
    elsif($key=~/Y/) { $options{ymin}+=($options{ymax}-$options{ymin})*0.1; $options{ymax}+=($options{ymax}-$options{ymin})*0.1; reset_all(31); }
    elsif($key=~/S/) { $options{zmin}-=($options{zmax}-$options{zmin})*0.1; $options{zmax}-=($options{zmax}-$options{zmin})*0.1; reset_all(31); }
    elsif($key=~/W/) { $options{zmin}+=($options{zmax}-$options{zmin})*0.1; $options{zmax}+=($options{zmax}-$options{zmin})*0.1; reset_all(31); }

    # Seeking
    elsif($key=~/x/) { 
        reset_all(1);
        if (($options{time} > 0) and (($tsize+1) <= ($options{tres}-5))) { $t += 5*($options{tmax}-$options{tmin})/($options{tres}-1); $tsize=$tsize+5; }
        elsif (($tsize+1) < $options{tres}) { $t += ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize++; }
        if (glIsList($tsize+1)) {
            glCallList($tsize+1);
            glFlush();
        }
    }
    elsif($key=~/y/) { 
        reset_all(1);
        if (($options{time} > 0) and ($tsize >= 5)) { $t -= 5*($options{tmax}-$options{tmin})/($options{tres}-1); $tsize=$tsize-5; }
        elsif ($tsize > 0) { $t -= ($options{tmax}-$options{tmin})/($options{tres}-1); $tsize--; }
        if (glIsList($tsize+1)) {
            glCallList($tsize+1);
            glFlush();
        }
    }

    # Resolution
    elsif($key=~/u/){ 
        if (preview(3)) { $xres_real+=1; $zres_real+=1; }
        else { $options{xres}+=1; $options{zres}+=1; reset_all(17); }
        # if (preview(3)) { $xres_real=int($xres_real*1.1+0.9); $zres_real=int($zres_real*1.1+0.9); }
        # else { $options{xres}=int($options{xres}*1.1+0.9); $options{zres}=int($options{zres}*1.1+0.9); reset_all(17); }
    }
    elsif($key=~/z/){
        if (preview(3) and (($xres_real>=3) and ($zres_real>=3))) { $xres_real-=1; $zres_real-=1; }
        elsif (($options{xres}>=3) and ($options{zres}>=3)) { $options{xres}-=1; $options{zres}-=1; reset_all(17); }
        # if (preview(3)) { $xres_real=int($xres_real*0.91+0.2); $zres_real=int($zres_real*0.91+0.2); }
        # else { $options{xres}=int($options{xres}*0.91+0.2); $options{zres}=int($options{zres}*0.91+0.2); reset_all(17); }
    }
    elsif($key=~/j/){ $options{tres}=int($options{tres}*1.1+0.9); reset_all(19); }
    elsif($key=~/h/){ $options{tres}=int($options{tres}*0.91+0.2); reset_all(19); }
    # elsif($key=~/j/){ $options{tres}+=1; reset_all(19); }
    # elsif($key=~/h/){ if ($options{tres}>=2) { $options{tres}-=1; reset_all(19); } }

    # Rotation
    elsif($key=~/w/){ glRotatef(-3, 1, 0, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/s/){ glRotatef(3, 1, 0, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/a/){ glRotatef(-3, 0, 1, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/d/){ glRotatef(3, 0, 1, 0); glCallList($tsize+1); glFlush(); }

    # Translation
    elsif($key=~/\ü/){ glTranslatef(0, 0.5, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/\ä/){ glTranslatef(0, -0.5, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/\ö/){ glTranslatef(-0.5, 0, 0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/\$/){ glTranslatef(0.5, 0, 0); glCallList($tsize+1); glFlush(); }

    # Scaling
    elsif($key=~/e/){ glScalef(0.91,0.91,0.91); glCallList($tsize+1); glFlush(); }
    elsif($key=~/r/){ glScalef(1.1,1.1,1.1); glCallList($tsize+1); glFlush(); }
    elsif($key=~/Z/){ glScalef(1,0.91,1); glCallList($tsize+1); glFlush(); }
    elsif($key=~/U/){ glScalef(1,1.1,1); glCallList($tsize+1); glFlush(); }
    elsif($key=~/H/){ glScalef(0.91,1,1); glCallList($tsize+1); glFlush(); }
    elsif($key=~/J/){ glScalef(1.1,1,1); glCallList($tsize+1); glFlush(); }
    elsif($key=~/N/){ glScalef(1,1,0.91); glCallList($tsize+1); glFlush(); }
    elsif($key=~/M/){ glScalef(1,1,1.1); glCallList($tsize+1); glFlush(); }

    # Position
    elsif($key=~/0/){ reset_all(4); }
    elsif($key=~/_/){ reset_all(12); }
    elsif($key=~/'/){ reset_all(31); }
    elsif($key=~/9/){ glRotatef(90,1,0,0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/8/){ glRotatef(90,0,1,0); glCallList($tsize+1); glFlush(); }
    elsif($key=~/7/){ glRotatef(90,0,0,1); glCallList($tsize+1); glFlush(); }
}


# SPECIAL KEYBOARD
sub special_keyboard {
    if (($options{time}!=0) and (!$time_real)) {
        $time_real=$options{time};
        $options{time}=0;
    }
    $time{key} = [gettimeofday];

    my ($key) = @_; 

    # Special keys
    if   ($key==GLUT_KEY_LEFT){ reset_all(4); }
    elsif($key==GLUT_KEY_RIGHT){ reset_all(31); }
    elsif($key==GLUT_KEY_UP){ }
    elsif($key==GLUT_KEY_DOWN){ }
    elsif($key==GLUT_KEY_F1){ }
    elsif($key==GLUT_KEY_F2){ }
    elsif($key==GLUT_KEY_F3){ }
    elsif($key==GLUT_KEY_F4){ }
    elsif($key==GLUT_KEY_F5){ }
    elsif($key==GLUT_KEY_F6){ }
    elsif($key==GLUT_KEY_F7){ }
    elsif($key==GLUT_KEY_F8){ }
    elsif($key==GLUT_KEY_F9){ }
    elsif($key==GLUT_KEY_F10){ }
    elsif($key==GLUT_KEY_F11){ }
    elsif($key==GLUT_KEY_F12){ }
    elsif($key==GLUT_KEY_PAGE_UP){ }
    elsif($key==GLUT_KEY_PAGE_DOWN){ }
    elsif($key==GLUT_KEY_HOME){ }
    elsif($key==GLUT_KEY_END){ }
    elsif($key==GLUT_KEY_INSERT){ }
}
1;