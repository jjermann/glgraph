#!/bin/sh

cat src/glgraph.pl | grep -v "#CVS$" > glgraph
cat src/keyboard.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/cmd.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/default.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/glinit.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/color.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/idleloops.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/gldisplay.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
cat src/screenshot.pm | grep -v "^1;$" | grep -v "#CVS$" >> glgraph
chmod +x glgraph
