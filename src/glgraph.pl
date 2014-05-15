#!/usr/bin/perl
#
# Name:		GLgraph
#
# Version:	0.2.5
#
# License:	GPL
#
# 2002/05/08	Jonas Jermann <jjermann@gmx.ch>
#               David Gunzinger <david@zhadum.ch>
#
#
################################################################################
#
# M O D U L E S

use OpenGL ":old",":glutfunctions",":gluconstants",":functions";
use strict; no strict "subs";
eval {use Math::Trig;} or warn "No trigonometrical function support found...\n";
use Getopt::Long;
use Time::HiRes qw (gettimeofday tv_interval usleep);
#use warnings; #CVS
#use Devel::AutoProfiler; #CVS
use cmd; #CVS
use color; #CVS
use default; #CVS
use glinit; #CVS
use gldisplay; #CVS
use idleloops; #CVS
use screenshot; #CVS
use keyboard; #CVS

################################################################################
#
# M A I N

# Variables
use vars qw(%options %time @lookat @geometry @tri2d @tri3d @yreal $xres_real $zres_real $time_real $n $z $t $zsize $tsize $PI);

options();
commandline();
init();
if ($options{mode} <=1) { reset_all(7); }
else { reset_all(15); }
glutMainLoop;

################################################################################
#
# S U B

# VERSION
sub version {
    my $version_string =  "0.2.6";
    $version_string = "$version_string-cvs"; #CVS
    print "GLgraph version $version_string\n";
    exit;
}


# RESIZE (reset -> only 2)
sub resize {
    ($options{width},$options{height})=@_;
    glViewport(0, 0, $options{width}, $options{height});
    if ($options{mode} <=1 ) { reset_all(4); }
    else { reset_all(12); }
}


# RESET
sub reset_all {
    # Variables (Space)
    if ($_[0] & 1) {
        $z = $options{zmin};
        $zsize = 0;
    }

    # Variables (Time)
    if ($_[0] & 2) {
        $t = $options{tmin};
        $tsize = 0;
    }
            
    # GL reinit
    if ($_[0] & 4) {
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho($options{xmin},$options{xmax},$options{ymin},$options{ymax},$options{zmin},$options{zmax});
    }
    
    # Standard view
    if ($_[0] & 8) {
        if (@lookat) { gluLookAt(@lookat); }
        else {
            glRotatef(50, 5, -0.5, 0.0);
            glScalef(0.8,0.8,0.8);
        }
    }

    # Delete all display lists
    if ($_[0] & 16) {
        glDeleteLists(1,$options{tres});
    }
}


# MAIN DISPLAY
sub display {
    if ($_[0]) {
        if (!$options{anim}) { reset_all(16); }

        # calculate display list if non-existing
        if (!glIsList($tsize+1)) {
            glNewList(($tsize+1), GL_COMPILE);
                if ($options{clearg}) { glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT); }
                else { glClear(GL_DEPTH_BUFFER_BIT); }
                glColor3f(0.8,0.8,0.8);
                if    ($options{mode} == 1) { display_2d(); }
                elsif ($options{mode} == 2) { display_3dwire(); }
                elsif ($options{mode} == 3) { display_3d(); }
                if    (($options{axis} > 0) and ($options{mode} > 0)) { display_axis(); }
            glEndList();
        }

        # fps corrections
        if (($time{frame}) and (tv_interval($time{frame})<(1/$options{fps}))) {
            select(undef, undef, undef, (1/$options{fps}-tv_interval($time{frame})));
        }

        # display and flush
        glCallList($tsize+1);
        glFlush();
        glutSwapBuffers();

        $time{frame} = [gettimeofday];

        # Save all frames and exit if specified
        screenshot() if ($options{save});
        exit() if (($options{save}) and (($tsize+1)==$options{tres}));
    }
}


# PREVIEW
sub preview {
    if (($xres_real) and (($_[0]==0) or ($_[0]==2))) {
        $options{xres}=$xres_real;
        $options{zres}=$zres_real;
        $xres_real=0;
        $zres_real=0;
        reset_all(1);
    }
    elsif ((!$xres_real) and (($_[0]==1) or ($_[0]==2))) {
        $xres_real=$options{xres};
        $zres_real=$options{zres};
        $options{xres}=20;
        $options{zres}=20;
        reset_all(1);
    }
    elsif (($_[0]==3) and $xres_real) { return 1; }
    elsif (($_[0]==3) and !$xres_real) { return 0; }
}