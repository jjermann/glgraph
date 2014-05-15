


# INIT
sub init {
    # Glut init
    glutInit();
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize($geometry[0],$geometry[1]);
    glutInitWindowPosition($geometry[2],$geometry[3]);
    glutCreateWindow($options{wid});
    glutFullScreen() if ($options{fullscreen});

    # Functions
    glutKeyboardFunc(\&keyboard);
    glutSpecialFunc(\&special_keyboard);
    glutDisplayFunc(\&display);
    glutReshapeFunc(\&resize);
    glutIdleFunc(\&idle);
    
    glClearColor(0,0,0,0);
    glEnable(GL_DEPTH_TEST); #TEST
}    
1;