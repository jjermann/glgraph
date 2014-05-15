


# SUB DISPLAY (2D)
sub display_2d {
    my $i;

    glBegin(GL_LINE_STRIP); {
        glColor3f(scolor($tri2d[1])) if ($options{color} > 0);
        glVertex2f($tri2d[0],$tri2d[1]);
        for ($i=2; $i<=(2*$options{xres}-2); $i=$i+2) { 
            glColor3f(scolor($tri2d[$i+1])) if ($options{color} > 0);
            glVertex2f($tri2d[$i],$tri2d[$i+1]);}
    } glEnd();
}


# SUB DISPLAY (3D WIRE)
sub display_3dwire {
    my ($h,$i);
    
    for $h (0..($zsize-2)) {
        glBegin(GL_LINE_STRIP); {

            # first line
            if ($h==0) {
                for ($i=(3*$options{xres}-3); $i>=0; $i=$i-3) {
                    glColor3f(scolor($tri3d[$i+1])) if ($options{color} > 0);
                    glVertex3f($tri3d[$i],$tri3d[$i+1],$tri3d[$i+2]);
                }
            }

            for ($i=0; $i<=(3*$options{xres}-4); $i=$i+3) {
                my $basec = $i+1+3*$h*$options{xres};
                # left behind
                glColor3f(scolor($tri3d[$basec])) if ($options{color} > 0);
                glVertex3f($tri3d[$basec-1],$tri3d[$basec],$tri3d[$basec+1]);
                # left ahead
                glColor3f(scolor($tri3d[$basec+3*$options{xres}])) if ($options{color} > 0);
                glVertex3f($tri3d[$basec-1+3*$options{xres}],$tri3d[$basec+3*$options{xres}],$tri3d[$basec+1+3*$options{xres}]);
                # rigth ahead
                glColor3f(scolor($tri3d[$basec+3+3*$options{xres}])) if ($options{color} > 0);
                glVertex3f($tri3d[$basec+2+3*$options{xres}],$tri3d[$basec+3+3*$options{xres}],$tri3d[$basec+4+3*$options{xres}]);
            }

            # right behind
            glColor3f(scolor($tri3d[3*$options{xres}-2+3*$h*$options{xres}])) if ($options{color} > 0);
            glVertex3f($tri3d[3*$options{xres}-3+3*$h*$options{xres}],$tri3d[3*$options{xres}-2+3*$h*$options{xres}],$tri3d[3*$options{xres}-1+3*$h*$options{xres}]); 
            # right ahead
            glColor3f(scolor($tri3d[3*$options{xres}-2+3*$h*$options{xres}+3*$options{xres}])) if ($options{color} > 0);
            glVertex3f($tri3d[3*$options{xres}-3+3*$h*$options{xres}+3*$options{xres}],$tri3d[3*$options{xres}-2+3*$h*$options{xres}+3*$options{xres}],$tri3d[3*$options{xres}-1+3*$h*$options{xres}+3*$options{xres}]); 
        } glEnd();
    }
}


# SUB DISPLAY (3D SOLID)
sub display_3d {
    my ($h,$i);

    glBegin(GL_TRIANGLES);
    {
        for $h (0..($zsize-2)) {
            for ($i=0; $i<=(3*$options{xres}-4); $i=$i+3) {
                my $basec = $i+1+3*$h*$options{xres};
                my @ltcolor;
                my @rbcolor;
                # left bottom
                glColor3f(scolor($tri3d[$basec])) if ($options{color} > 0);
                glVertex3f($tri3d[$basec-1],$tri3d[$basec],$tri3d[$basec+1]);
                # left top
                if ($options{color} > 0) { @ltcolor=scolor($tri3d[$basec+3*$options{xres}]); glColor3f(@ltcolor) }
                glVertex3f($tri3d[$basec+3*$options{xres}-1],$tri3d[$basec+3*$options{xres}],$tri3d[$basec+3*$options{xres}+1]); 
                # right bottom
                if ($options{color} > 0) { @rbcolor=scolor($tri3d[$basec+3]);glColor3f(@rbcolor);}
                glVertex3f($tri3d[$basec+2],$tri3d[$basec+3],$tri3d[$basec+4]); 
                # left top
                glColor3f(@ltcolor) if ($options{color} > 0);
                glVertex3f($tri3d[$basec+3*$options{xres}-1],$tri3d[$basec+3*$options{xres}],$tri3d[$basec+3*$options{xres}+1]); 
                # right top
                glColor3f(scolor($tri3d[$basec+3*$options{xres}+3])) if ($options{color} > 0);
                glVertex3f($tri3d[$basec+3*$options{xres}+2],$tri3d[$basec+3*$options{xres}+3],$tri3d[$basec+3*$options{xres}+4]); 
                # right bottom
                glColor3f(@rbcolor) if ($options{color} > 0);
                glVertex3f($tri3d[$basec+2],$tri3d[$basec+3],$tri3d[$basec+4]); 
            }
        }
    } glEnd();
}


# SUB DISPLAY (AXIS)
sub display_axis {
    my $i;
    
    glColor3f(0.3,0.3,0.3);

    if ($options{axis} == 1) {
        if ($options{mode} <= 1) {
            # 2D axis
            glBegin(GL_LINES); {
                for ($i=0; $i<=($options{xmax}); $i=$i+$options{ax_step}) {
                    glVertex2f($i,(0-($options{ymax}-$options{ymin})*$options{ax_size}/2));
                    glVertex2f($i,(0+($options{ymax}-$options{ymin})*$options{ax_size}/2));
                }
                for ($i=0; $i>=($options{xmin}); $i=$i-$options{ax_step}) {
                    glVertex2f($i,(0-($options{ymax}-$options{ymin})*$options{ax_size}/2));
                    glVertex2f($i,(0+($options{ymax}-$options{ymin})*$options{ax_size}/2));
                }
                for ($i=0; $i<=($options{ymax}); $i=$i+$options{ax_step}) {
                    glVertex2f((0-($options{xmax}-$options{xmin})*$options{ax_size}/2),$i);
                    glVertex2f((0+($options{xmax}-$options{xmin})*$options{ax_size}/2),$i);
                }
                for ($i=0; $i>=($options{ymin}); $i=$i-$options{ax_step}) {
                    glVertex2f((0-($options{xmax}-$options{xmin})*$options{ax_size}/2),$i);
                    glVertex2f((0+($options{xmax}-$options{xmin})*$options{ax_size}/2),$i);
                }

                glColor3f(0.4,0.4,0.4);
                glVertex2f($options{xmin},0);
                glVertex2f($options{xmax},0);
                glVertex2f(0,$options{ymin});
                glVertex2f(0,$options{ymax});
            } glEnd();
        }
        else {
            # 3D axis
            glBegin(GL_LINES); {
                for ($i=0; $i<=($options{xmax}); $i=$i+$options{ax_step}) {
                    glVertex3f($i,0,(0-($options{zmax}-$options{zmin})*$options{ax_size}/2));
                    glVertex3f($i,0,(0+($options{zmax}-$options{zmin})*$options{ax_size}/2));
                }
                for ($i=0; $i>=($options{xmin}); $i=$i-$options{ax_step}) {
                    glVertex3f($i,0,(0-($options{zmax}-$options{zmin})*$options{ax_size}/2));
                    glVertex3f($i,0,(0+($options{zmax}-$options{zmin})*$options{ax_size}/2));
                }
                for ($i=0; $i<=($options{zmax}); $i=$i+$options{ax_step}) {
                    glVertex3f((0-($options{xmax}-$options{xmin})*$options{ax_size}/2),0,$i);
                    glVertex3f((0+($options{xmax}-$options{xmin})*$options{ax_size}/2),0,$i);
                }
                for ($i=0; $i>=($options{zmin}); $i=$i-$options{ax_step}) {
                    glVertex3f((0-($options{xmax}-$options{xmin})*$options{ax_size}/2),0,$i);
                    glVertex3f((0+($options{xmax}-$options{xmin})*$options{ax_size}/2),0,$i);
                }

                glColor3f(0.4,0.4,0.4);
                glVertex3f($options{xmin},0,0);
                glVertex3f($options{xmax},0,0);
                glVertex3f(0,$options{ymin},0);
                glVertex3f(0,$options{ymax},0);
                glVertex3f(0,0,$options{zmin});
                glVertex3f(0,0,$options{zmax});
            } glEnd();
        }
    }

    elsif ($options{axis} == 2) {
        # Base square
        glBegin(GL_LINES); {
            glVertex3f($options{xmin},0,$options{zmin});
            glVertex3f($options{xmax},0,$options{zmin});
            glVertex3f($options{xmin},0,$options{zmin});
            glVertex3f($options{xmin},0,$options{zmax});
            glVertex3f($options{xmin},0,$options{zmax});
            glVertex3f($options{xmax},0,$options{zmax});
            glVertex3f($options{xmax},0,$options{zmax});
            glVertex3f($options{xmax},0,$options{zmin});
        } glEnd();
    }

    elsif ($options{axis} == 3) {
        # Base cube
        glBegin(GL_LINES); {
            #bottom square
            glVertex3f($options{xmin},$options{ymin},$options{zmin});
            glVertex3f($options{xmax},$options{ymin},$options{zmin});
            glVertex3f($options{xmin},$options{ymin},$options{zmin});
            glVertex3f($options{xmin},$options{ymin},$options{zmax});
            glVertex3f($options{xmin},$options{ymin},$options{zmax});
            glVertex3f($options{xmax},$options{ymin},$options{zmax});
            glVertex3f($options{xmax},$options{ymin},$options{zmax});
            glVertex3f($options{xmax},$options{ymin},$options{zmin});
            #between
            glVertex3f($options{xmin},$options{ymin},$options{zmin});
            glVertex3f($options{xmin},$options{ymax},$options{zmin});
            glVertex3f($options{xmin},$options{ymin},$options{zmax});
            glVertex3f($options{xmin},$options{ymax},$options{zmax});
            glVertex3f($options{xmax},$options{ymin},$options{zmin});
            glVertex3f($options{xmax},$options{ymax},$options{zmin});
            glVertex3f($options{xmax},$options{ymin},$options{zmax});
            glVertex3f($options{xmax},$options{ymax},$options{zmax});
            #top square
            glVertex3f($options{xmin},$options{ymax},$options{zmin});
            glVertex3f($options{xmax},$options{ymax},$options{zmin});
            glVertex3f($options{xmin},$options{ymax},$options{zmin});
            glVertex3f($options{xmin},$options{ymax},$options{zmax});
            glVertex3f($options{xmin},$options{ymax},$options{zmax});
            glVertex3f($options{xmax},$options{ymax},$options{zmax});
            glVertex3f($options{xmax},$options{ymax},$options{zmax});
            glVertex3f($options{xmax},$options{ymax},$options{zmin});
        } glEnd();
    }
}
1;