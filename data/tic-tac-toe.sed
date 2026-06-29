#!/usr/bin/sed -nf
#n
# the #n above
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/sed.html
# should be redundant with -n, but "just in case"
# OpenBSD doesn't recognize -S option to env,
# whereas GNU env requires it.
#!/usr/bin/env -S sed -nf

# vi(1) :se tabstop=4

# Note that at last check (2024-01-21) BSD BRE still has bug
# that prevents this from working. See:
# https://marc.info/?l=openbsd-bugs&m=161408631731043&w=2
# etc.

# Note that we won't be able to output anything until we've got
# at least our first line of input.

bS; # skip the help for now
:H
s/.*/Help: Tic-Tac-Toe: Positions are numbered 1-9 on 3x3 board:\
1|2|3 Players are X and O and alternate turns between X and O, playing\
-+-+- one position per turn.  Three in a row, horizontally, vertically,\
4|5|6 or diagonally wins.  X always goes first.  Players alternate X and\
-+-+- O between games.\
7|8|9 Enter:\
1-9 - (just one digit) to make your move\
N - Next game\
P - Print current game positions & basic status\
Q - Quit\
R - Restart game\
/p
bP
:S

1{h;s/.*/         /;x;}; # initialize at first input line

# status in hold space:
# [ ox]\{9\}
# ^^^^^^^^^ first 9 positions are board positions 1-9, each empty, x, or o
#           above may be logical equivalents, see below
#          ^ additional information after 9th position
#            [1-8] is rotation/mirror,
#            we rotate/mirror to reduce/simplify code,
#   		 squashing via rotation/mirror, equivalent games (symmetry)
#			 we use Exif Orientation:
#			 Orientation per 2.32 Exif standard (http://cipa.jp/std/documents/download_e.html?DC-008-Translation-2019-E):
#			 1           The 0th row is at the visual top of the image, and the 0th column is the visual lefthand side.
#			 2           The 0th row is at the visual top of the image, and the 0th column is the visual right-hand side.
#			 3           The 0th row is at the visual bottom of the image, and the 0th column is the visual right-hand side.
#			 4           The 0th row is at the visual bottom of the image, and the 0th column is the visual lefthand side.
#			 5           The 0th row is the visual left-hand side of the image, and the 0th column is the visual top.
#			 6           The 0th row is the visual right-hand side of the image, and the 0th column is the visual top.
#			 7           The 0th row is the visual right-hand side of the image, and the 0th column is the visual bottom.
#			 8           The 0th row is the visual left-hand side of the image, and the 0th column is the visual bottom.
#			 if not specified, we presume 1
#			 in short, orientation, 0th row, and 0th column are respectively:
#			 1 top left
#			 2 top right
#			 3 bottom right
#			 4 bottom left
#			 5 left top
#			 6 right top
#			 7 right bottom
#			 8 left bottom
#            O - if present, human is O, computer program is X,
#            otherwise human is X, computer program is O

/^[1-9]$/{
	#p;#####
	# move of 1-9 selected
	y/123456789/abcdefghi/; # label moves a-i; 1-8 used for orientation
	#p;#####
	H;x;s/\n//g;h; # push our pending move
	#p;#####
	# pattern & hold space now state+pending move
	# possibly translate our move, depending upon orientation:
	#a|b|c
	#-+-+-
	#d|e|f
	#-+-+-
	#g|h|i
	# 2-8 translate for Exif Orientation (1 no change):
	/2/{y/acdfgi/cafdig/;}
	/3/{y/abcdfghi/ihgfdcba/;}
	/4/{y/abcghi/ghiabc/;}
	/5/{y/bcdfgh/dgbhcf/;}
	/6/{y/abcdfghi/gdahbifc/;}
	/7/{y/abdfhi/ifhbda/;}
	/8/{y/abcdfghi/cfibhadg/;}
	#p;#####
	# try to mark our move (with .)
	/a/{/^ /!bI;s/ /./;}
	/b/{/^. /!bI;s/\(.\) /\1./;}
	/c/{/^.. /!bI;s/\(..\) /\1./;}
	/d/{/^... /!bI;s/\(...\) /\1./;}
	/e/{/^.... /!bI;s/\(....\) /\1./;}
	/f/{/^..... /!bI;s/\(.....\) /\1./;}
	/g/{/^...... /!bI;s/\(......\) /\1./;}
	/h/{/^....... /!bI;s/\(.......\) /\1./;}
	/i/{/^........ /!bI;s/\(........\) /\1./;}
	# change . to x or o according to player is X or O:
	/O/{s/\./o/g;}
	s/\./x/g
	s/[^ 2-8Oox]//g; # strip no longer needed state
	h
	#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
	bM
}

/^[Nn]$/{
:N
	g
	/O/{s/.*/         /;h;bP;}; # human was O, switch to X and reinitialize
	s/.*/         O/;h;bCM; # human was X, switch to O and reinitialize
}

/^[Pp]$/{g;bP;}

/^[Qq]$/q

/^[Rr]$/{
	g
	/O/!{s/.*/         /;h;bP;}; # human is X, remain X and reinitialize
	s/.*/         O/;h;bCM; # human is O, remain O and reinitialize
}

bH; # default to Help for unmatched input

:I; # Illegal move
g;s/[^ 2-8Oox]//g;h; # strip no longer needed state
#s/.*/Illegal move/;p;q;#####one shot testing#####
s/.*/Illegal move/;p;d

# print position state and start next cycle
:P
#s/.*/:P/;p;#####
g
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
/[2-8]/{
	# orient:
	/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;}
	/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;}
	/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;}
	/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;}
	/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;}
	/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;}
	/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;}
	s/[1-8]//g
}
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
s/^\(.\{9\}\)..*$/\1/; # strip to first 9 characters
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
s/x/X/g;s/o/O/g; # x's and o's to uppercase
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1|\2|\3 1|2|3\
-+-+- -+-+-\
\4|\5|\6 4|5|6\
-+-+- -+-+-\
\7|\8|\9 7|8|9 1-9NPQR?:/
p
d

:T; # Tie!
s/.*/Tie game!/;p
#q;#####one shot testing#####
bN

:W; # Winning move
#s/^/:W\n/;P;s/^[^\n]*\n//;#####
# already displayed last move, winning letter is in pattern space
s/^x/X/g;s/^o/O/g; # uppercase it
G
s/[^OX]//g
/^O$/{s/.*/O (computer program) won!/p;}
/^OO$/{s/.*/O (you) won!/p;}
/^X$/{s/.*/X (you) won!/p;}
/^XO$/{s/.*/X (computer program) won!/p;}
#q;#####one shot testing#####
g
bN

#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
:M; # move was made, display it, ...
#s/^/:M\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
g
/[2-8]/{
	# orient:
	/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;}
	/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;}
	/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;}
	/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;}
	/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;}
	/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;}
	/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;}
	s/[1-8]//g
}
s/^\(.\{9\}\)..*$/\1/; # strip to first 9 characters
s/x/X/g;s/o/O/g; # x's and o's to uppercase
s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1|\2|\3\
-+-+-\
\4|\5|\6\
-+-+-\
\7|\8|\9/
p
# was it a winning move?
#s/^/was it a winning move?\n/;P;s/^[^\n]*\n//;#####
g
# if it was a winning move, save the x or o that won, and process win:
/^\(...\)\{0,2\}\([ox]\)\2\2/{s/^\(...\)\{0,2\}\([ox]\)\2\2.*$/\2/;bW;}
/^\(.\)\{0,2\}\([ox]\)..\2..\2/{s/^\(.\)\{0,2\}\([ox]\)..\2..\2.*$/\2/;bW;}
/^\([ox]\)...\1...\1/{s/^\(.\).*$/\1/;bW;}
/^..\([ox]\).\1.\1/{s/^..\(.\).*$/\1/;bW;}
# do we have a tie?
#s/^/do we have a tie?\n/;P;s/^[^\n]*\n//;#####
/^[xo]\{9\}/bT; # all filled, no win, is tie
# neither win nor tie
:CM
# computer's move
#s/^/computer's move\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
s/[^xo]//g; # how many moves made?
# possibly change orientation to simplify (remove redundancies)
/^........$/{g;b8;}; #8
/^.......$/{g;b7;}; #7
/^......$/{g;b6;}; #6
/^.....$/{g;b5;}; #5
/^....$/{g;b4;}; #4
/^...$/{g;b3;}; #3
/^..$/{g;b2;}; #2
/^.$/{g;b1;}; #1
/^$/{g;b0;}; #0
:0; # exactly zero moves have been made
#s/.*/:0/;p;g;#####
s/^         /x        /;h;bP
:1; # exactly one move has been made
#s/^/:1\n/;P;s/^[^\n]*\n//;#####
# normalize orientation to squeeze out redundancies
# position 1, 2, or 5 must be filled
/^x/b1m; # 1 only was filled
/^ x/b1m; # 2 only was filled
/^  x/{s/^  x/x  /;s/$/6/;h;b1m;};# 3 only was filled, rotated left
/^   x/{s/^   x/ x  /;s/$/8/;h;b1m;};# 4 only was filled, rotated right
/^    x/b1m; # 5 only was filled
/^     x/{s/^     x/ x    /;s/$/6/;h;b1m;};# 6 only was filled, rotated left
/^      x/{s/^      x/x      /;s/$/8/;h;b1m;};# 7 only was filled, rotated right
/^       x/{s/^       x/ x      /;s/$/3/;h;b1m;};# 8 only was filled, rotated 180 degrees
/^        x/{s/^        x/x        /;s/$/3/;h;b1m;};# 9 only was filled, rotated 180 degrees
:1m; # fist move made and oriented, make our move
#s/^/:1m\n/;P;s/^[^\n]*\n//;#####
#p;s/^/:1m\n/;P;s/^[^\n]*\n//;p;#####
s/^x        /x   o    /
s/^ x       / x  o    /
s/^    x    /o   x    /
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
h
/o/!{s/.*/Error!/p;q;}
bP
:2; # exactly two moves have been made
#s/^/:2\n/;P;s/^[^\n]*\n//;#####
# normalize orientation to squeeze out redundancies
/^x  o     /{s/^x  o     /xo       /;y/12345678/56781234/;/[1-8]/!s/$/5/;s/1//g;h;b2m;}; # only filled 14 reoriented to 12 flip along 19
/^x     o  /{s/^x     o  /x o      /;y/12345678/56781234/;/[1-8]/!s/$/5/;s/1//g;h;b2m;}; # only filled 17 reoriented to 13 flip along 19
/^x      o /{s/^x      o /x    o   /;y/12345678/56781234/;/[1-8]/!s/$/5/;s/1//g;h;b2m;}; # only filled 18 reoriented to 16 flip along 19
:2m; # second move made and oriented, make our move, print, human's turn
/^xo       /{s/^xo       /xo x     /;h;bP;}
/^x o      /{s/^x o      /x ox     /;h;bP;}
/^x   o    /{s/^x   o    /xx  o    /;h;bP;}
/^x    o   /{s/^x    o   /x   xo   /;h;bP;}
/^x       o/{s/^x       o/x x     o/;h;bP;}
s/.*/Error !/p;q; # should be unreachable
:3; # exactly three moves have been made
#s/^/:3\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
#xh oc xh
# normalize orientation to squeeze out redundancies and move
/^xx  o    /{s/^xx  o    /xxo o    /;h;bP;}
/^x x o    /{s/^x x o    /xox o    /;h;bP;}
/^x   ox   /{s/^x   ox   /x   ox o /;h;bP;}
/^x   o   x/{s/^x   o   x/xo  o   x/;h;bP;}
/^xx  o    /{s/^xx  o    /xxo o    /;h;bP;}
/^ x xo    /{s/^ x xo    / xoxo    /;h;bP;}
/^ x  o  x /{s/^ x  o  x /ox  o  x /;h;bP;}
/^ox  x    /{s/^ox  x    /ox  x  o /;h;bP;}
/^o x x    /{s/^o x x    /o x x o  /;h;bP;}
/^o   xx   /{s/^o   xx   /o  oxx   /;h;bP;}
/^x   x   o/{s/^x   x   o/x o x   o/;h;bP;}
/^x  xo    /{s/^x  xo    /xx  o    /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip along 19
/^x   o x  /{s/^x   o x  /x x o    /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip along 19
/^x   o  x /{s/^x   o  x /x   ox   /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip along 19
/^o  xx    /{s/^o  xx    /ox  x    /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip about 19
/^o   x  x /{s/^o   x  x /o   xx   /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip about 19
/^o   x x  /{s/^o   x x  /o x x    /;/[1-8]/!s/$/1/;y/12345678/56781234/;s/1//g;b3;};#flip about 19
/^ xx o    /{s/^ xx o    /xx  o    /;/[1-8]/!s/$/1/;y/12345678/21438765/;s/1//g;b3;};#flip about 28
/^ x  ox   /{s/^ x  ox   / x xo    /;/[1-8]/!s/$/1/;y/12345678/21438765/;s/1//g;b3;};#flip about 28
/^ x  o   x/{s/^ x  o   x/x   ox   /;/[1-8]/!s/$/1/;y/12345678/78563412/;s/1//g;b3;};#flip about 37
/^o   x   x/{s/^o   x   x/x   x   o/;/[1-8]/!s/$/1/;y/12345678/78563412/;s/1//g;b3;};#flip about 37
/^ x  o x  /{s/^ x  o x  /x   ox   /;/[1-8]/!s/$/1/;y/12345678/87652143/;s/1//g;b3;};#rotate clockwise
s/.*/Error  !/p;q; # should be unreachable

# at least 3 must already be played to block fork
# at least 4 must already be played to force fork

:4; # exactly four moves have been made
#s/^/:4\n/;P;s/^[^\n]*\n//;#####

:5; # exactly five moves have been made
#s/^/:5\n/;P;s/^[^\n]*\n//;#####

:6; # exactly six moves have been made
#s/^/:6\n/;P;s/^[^\n]*\n//;#####

:7; # exactly seven moves have been made
#s/^/:7\n/;P;s/^[^\n]*\n//;#####

bs8
:8; # exactly eight moves have been made
#s/^/:8\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/O/{s/ /x/;h;bM;};s/ /o/;h;bM; # put in our last move and evaluate it
:s8

# Can we make Winning or Blocking move?
#s/^/:cwb\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/O/bcwbO
# human is X, computer O
# Can we make a winning move?
#s/^/Can we make a winning move?\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/^\(...\)\{0,2\}oo /{s/^\(\(...\)\{0,2\}\)oo /\1ooo/;h;bM;}
/^\(...\)\{0,2\}o o/{s/^\(\(...\)\{0,2\}\)o o/\1ooo/;h;bM;}
/^\(...\)\{0,2\} oo/{s/^\(\(...\)\{0,2\}\) oo/\1ooo/;h;bM;}
/^.\{0,2\}o..o.. /{s/^\(.\{0,2\}\)o\(..\)o\(..\) /\1o\2o\3o/;h;bM;}
/^.\{0,2\}o.. ..o/{s/^\(.\{0,2\}\)o\(..\) \(..\)o/\1o\2o\3o/;h;bM;}
/^.\{0,2\} ..o..o/{s/^\(.\{0,2\}\) \(..\)o\(..\)o/\1o\2o\3o/;h;bM;}
/^..o.o. /{s/^\(..\)o\(.\)o\(.\) /\1o\2o\3o/;h;bM;}
/^..o. .o/{s/^\(..\)o\(.\) \(.\)o/\1o\2o\3o/;h;bM;}
/^.. .o.o/{s/^\(..\) \(.\)o\(.\)o/\1o\2o\3o/;h;bM;}
/^o...o... /{s/^o\(...\)o\(...\) /o\1o\2o/;h;bM;}
/^o... ...o/{s/^o\(...\) \(...\)o/o\1o\2o/;h;bM;}
/^ ...o...o/{s/^ \(...\)o\(...\)o/o\1o\2o/;h;bM;}
# Can we block a winning move?
/^\(...\)\{0,2\}xx /{s/^\(\(...\)\{0,2\}\)xx /\1xxo/;h;bP;}
/^\(...\)\{0,2\}x x/{s/^\(\(...\)\{0,2\}\)x x/\1xox/;h;bP;}
/^\(...\)\{0,2\} xx/{s/^\(\(...\)\{0,2\}\) xx/\1oxx/;h;bP;}
/^.\{0,2\}x..x.. /{s/^\(.\{0,2\}\)x\(..\)x\(..\) /\1x\2x\3o/;h;bP;}
/^.\{0,2\}x.. ..x/{s/^\(.\{0,2\}\)x\(..\) \(..\)x/\1x\2o\3x/;h;bP;}
/^.\{0,2\} ..x..x/{s/^\(.\{0,2\}\) \(..\)x\(..\)x/\1o\2x\3x/;h;bP;}
/^..x.x. /{s/^\(..\)x\(.\)x\(.\) /\1x\2x\3o/;h;bP;}
/^..x. .x/{s/^\(..\)x\(.\) \(.\)x/\1x\2o\3x/;h;bP;}
/^.. .x.x/{s/^\(..\) \(.\)x\(.\)x/\1o\2x\3x/;h;bP;}
/^x...x... /{s/^x\(...\)x\(...\) /x\1x\2o/;h;bP;}
/^x... ...x/{s/^x\(...\) \(...\)x/x\1o\2x/;h;bP;}
/^ ...x...x/{s/^ \(...\)x\(...\)x/o\1x\2x/;h;bP;}
bCFFBFF
:cwbO
#s/^/:cwbO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
# human is O, computer X
# Can we make a winning move?
#s/^/Can we make a winning move?\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/^\(...\)\{0,2\}xx /{s/^\(\(...\)\{0,2\}\)xx /\1xxx/;h;bM;}
/^\(...\)\{0,2\}x x/{s/^\(\(...\)\{0,2\}\)x x/\1xxx/;h;bM;}
/^\(...\)\{0,2\} xx/{s/^\(\(...\)\{0,2\}\) xx/\1xxx/;h;bM;}
/^.\{0,2\}x..x.. /{s/^\(.\{0,2\}\)x\(..\)x\(..\) /\1x\2x\3x/;h;bM;}
/^.\{0,2\}x.. ..x/{s/^\(.\{0,2\}\)x\(..\) \(..\)x/\1x\2x\3x/;h;bM;}
/^.\{0,2\} ..x..x/{s/^\(.\{0,2\}\) \(..\)x\(..\)x/\1x\2x\3x/;h;bM;}
/^..x.x. /{s/^\(..\)x\(.\)x\(.\) /\1x\2x\3x/;h;bM;}
/^..x. .x/{s/^\(..\)x\(.\) \(.\)x/\1x\2x\3x/;h;bM;}
/^.. .x.x/{s/^\(..\) \(.\)x\(.\)x/\1x\2x\3x/;h;bM;}
/^x...x... /{s/^x\(...\)x\(...\) /x\1x\2x/;h;bM;}
/^x... ...x/{s/^x\(...\) \(...\)x/x\1x\2x/;h;bM;}
/^ ...x...x/{s/^ \(...\)x\(...\)x/x\1x\2x/;h;bM;}
# Can we block a winning move?
/^\(...\)\{0,2\}oo /{s/^\(\(...\)\{0,2\}\)oo /\1oox/;h;bP;}
/^\(...\)\{0,2\}o o/{s/^\(\(...\)\{0,2\}\)o o/\1oxo/;h;bP;}
/^\(...\)\{0,2\} oo/{s/^\(\(...\)\{0,2\}\) oo/\1xoo/;h;bP;}
/^.\{0,2\}o..o.. /{s/^\(.\{0,2\}\)o\(..\)o\(..\) /\1o\2o\3x/;h;bP;}
/^.\{0,2\}o.. ..o/{s/^\(.\{0,2\}\)o\(..\) \(..\)o/\1o\2x\3o/;h;bP;}
/^.\{0,2\} ..o..o/{s/^\(.\{0,2\}\) \(..\)o\(..\)o/\1x\2o\3o/;h;bP;}
/^..o.o. /{s/^\(..\)o\(.\)o\(.\) /\1o\2o\3x/;h;bP;}
/^..o. .o/{s/^\(..\)o\(.\) \(.\)o/\1o\2x\3o/;h;bP;}
/^.. .o.o/{s/^\(..\) \(.\)o\(.\)o/\1x\2o\3o/;h;bP;}
/^o...o... /{s/^o\(...\)o\(...\) /o\1o\2x/;h;bP;}
/^o... ...o/{s/^o\(...\) \(...\)o/o\1x\2o/;h;bP;}
/^ ...o...o/{s/^ \(...\)o\(...\)o/x\1o\2o/;h;bP;}
bCFFBFF

# outline for # Can we Force Fork or Block Forced Fork?
#:CFFBFF; # Can we Force Fork or Block Forced Fork?
#/O/bCFFBFFO
# human is X, computer O
# Can we Force Fork?
# undo our orientation first
#:TF; # Try Force
# --> :F if Forced
# try each orientation --> bTF until all tried
#bSF; # Skip Forced
#:F # handle forced
#undo orientation --> :u
#fix up orientation and state, print & to next move
#:SF; # Skip Forced
# Can we Block Fork?
# undo our orientation first
#:TB; #Try Block
# --> :B if Blocked
# try each orientation --> bTB until all tried
#bSB; # Skip Blocked
#:B # handle forced
#undo orientation --> :uB
#fix up orientation and state, print & to next move
#:SB; # Skip Blocked
#:CFFBFFO
# human is O, computer X

:CFFBFF; # Can we Force Fork or Block Forced Fork?
#s/^/:CFFBFF\n/;P;s/^[^\n]*\n//;#####
#s/.*/:CFFBFF/;p;g;#####
#s/.*/\nNot yet coded/p;q; #####
/O/bCFFBFFO; # Can we Force Fork or Block Forced Fork (human is O)?
# human is X, computer O
#s/.*/\nNot yet coded/p;q; #####
# Can we Force Fork?
#s/^/Can we Force Fork?\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
# undo our orientation first
/[1-8]/!s/$/1/
/1/bTF
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/1/;bTF;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;s/$/1/;bTF;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/1/;bTF;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;s/$/1/;bTF;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;s/$/1/;bTF;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;s/$/1/;bTF;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/1/;bTF;}
:TF; # Try Force
#s/^/:TF\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
#1 2 5, rest by symmetry
#1
/^  o ..o../{s/^ /o/;bF;}
/^  o. ...o/{s/^ /o/;bF;}
/^  o.o... /{s/^ /o/;bF;}
/^  oo.. ../{s/^ /o/;bF;}
/^ ..  .o.o/{s/^ /o/;bF;}
/^ .. o.o. /{s/^ /o/;bF;}
/^ ..o . .o/{s/^ /o/;bF;}
/^ ..oo. . /{s/^ /o/;bF;}
/^ o  ..o../{s/^ /o/;bF;}
/^ o . ...o/{s/^ /o/;bF;}
/^ o .o... /{s/^ /o/;bF;}
/^ o o.. ../{s/^ /o/;bF;}
#2
/^o  .o.. ./{s/^\(.\) /\1o/;bF;}
/^o  . ..o./{s/^\(.\) /\1o/;bF;}
/^  o.o.. ./{s/^\(.\) /\1o/;bF;}
/^  o. ..o./{s/^\(.\) /\1o/;bF;}
#5
/^  .. ..oo/{s/^\(....\) /\1o/;bF;}
/^ . . .o.o/{s/^\(....\) /\1o/;bF;}
/^ ..  o..o/{s/^\(....\) /\1o/;bF;}
/^ ..o  ..o/{s/^\(....\) /\1o/;bF;}
/^ .o. . .o/{s/^\(....\) /\1o/;bF;}
/^ o.. .. o/{s/^\(....\) /\1o/;bF;}
/^.  . .oo./{s/^\(....\) /\1o/;bF;}
/^. .  o.o./{s/^\(....\) /\1o/;bF;}
/^. .o  .o./{s/^\(....\) /\1o/;bF;}
/^. o. . o./{s/^\(....\) /\1o/;bF;}
/^..   oo../{s/^\(....\) /\1o/;bF;}
/^.. o  o../{s/^\(....\) /\1o/;bF;}
/^..o  o ../{s/^\(....\) /\1o/;bF;}
/^..oo   ../{s/^\(....\) /\1o/;bF;}
/^.o . .o ./{s/^\(....\) /\1o/;bF;}
/^.o.  o. ./{s/^\(....\) /\1o/;bF;}
/^.o.o  . ./{s/^\(....\) /\1o/;bF;}
/^.oo. .  ./{s/^\(....\) /\1o/;bF;}
/^o .. ..o /{s/^\(....\) /\1o/;bF;}
/^o. . .o. /{s/^\(....\) /\1o/;bF;}
/^o..  o.. /{s/^\(....\) /\1o/;bF;}
/^o..o  .. /{s/^\(....\) /\1o/;bF;}
/^o.o. . . /{s/^\(....\) /\1o/;bF;}
/^oo.. ..  /{s/^\(....\) /\1o/;bF;}
# try next orientation if any remain
#s/^/try next F\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
#/.\{12,\}/{s/.*/too long/;p;q;};#####
/1/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/2/;bTF;}
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/3/;bTF;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/4/;bTF;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/5/;bTF;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/6/;bTF;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/7/;bTF;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/8/;bTF;}
#/8/!{s/^/no match for 8\n/;P;s/^[^\n]*\n//;};#####
/8/!{s/.*/Error   !/p;q;}
#s/^/tried last F\n/;P;s/^[^\n]*\n//;#####
g

bSF; # Skip Forced
:F; # we Forced
#s/^/:F\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
# reapply orientation, save state, human's turn
# We need to be careful here - we have preferred orientation in hold space,
# and current orientation in pattern space.  Pattern space has our latest
# move, hold space doesn't yet.
# Rather than 8x8 possible single step reorientation, we'll do (up to) 2
# steps - 1x8 + 1x8.
# first step - undo orientation in pattern space
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;bu;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;bu;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;bu;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;bu;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;bu;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;bu;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;bu;}
:u
#s/^/:u\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
x;/[1-8]/!s/$/1/; #now we have:
# moved unoriented in hold,
# outdated move state but preferred orientation and possibly additional
# status in pattern space
s/[^1-8O]//g; # strip move state from pattern space (outdated anyway)
H; # append desired state/orientation to unoriented move state in hold
g;s/\n//g; # fetch that to pattern space and strip newlines
/O/{s/O//g;s/$/O/;}; # squash redundant O's to single
# now reapply the desired orientation, save it to hold space,
# print it, go to next move:
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;h;bP;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;h;bP;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;h;bP;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;h;bP;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;h;bP;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;h;bP;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;h;bP;}
# already in desired orientation:
s/1//g;h;bP
:SF; # Skip Forced
#s/^/:SF\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
# Can we Block Fork?
# undo our orientation first
/[1-8]/!s/$/1/
/1/bTB
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/1/;bTB;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;s/$/1/;bTB;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/1/;bTB;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;s/$/1/;bTB;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;s/$/1/;bTB;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;s/$/1/;bTB;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/1/;bTB;}
:TB; #Try Block
#s/^/:TB\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
#1 2 5, rest by symmetry
#1
/^  x ..x../{s/^ /o/;bB;}
/^  x. ...x/{s/^ /o/;bB;}
/^  x.x... /{s/^ /o/;bB;}
/^  xx.. ../{s/^ /o/;bB;}
/^ ..  .x.x/{s/^ /o/;bB;}
/^ .. x.x. /{s/^ /o/;bB;}
/^ ..x . .x/{s/^ /o/;bB;}
/^ ..xx. . /{s/^ /o/;bB;}
/^ x  ..x../{s/^ /o/;bB;}
/^ x . ...x/{s/^ /o/;bB;}
/^ x .x... /{s/^ /o/;bB;}
/^ x x.. ../{s/^ /o/;bB;}
#2
/^x  .x.. ./{s/^\(.\) /\1o/;bB;}
/^x  . ..x./{s/^\(.\) /\1o/;bB;}
/^  x.x.. ./{s/^\(.\) /\1o/;bB;}
/^  x. ..x./{s/^\(.\) /\1o/;bB;}
#5
/^  .. ..xx/{s/^\(....\) /\1o/;bB;}
/^ . . .x.x/{s/^\(....\) /\1o/;bB;}
/^ ..  x..x/{s/^\(....\) /\1o/;bB;}
/^ ..x  ..x/{s/^\(....\) /\1o/;bB;}
/^ .x. . .x/{s/^\(....\) /\1o/;bB;}
/^ x.. .. x/{s/^\(....\) /\1o/;bB;}
/^.  . .xx./{s/^\(....\) /\1o/;bB;}
/^. .  x.x./{s/^\(....\) /\1o/;bB;}
/^. .x  .x./{s/^\(....\) /\1o/;bB;}
/^. x. . x./{s/^\(....\) /\1o/;bB;}
/^..   xx../{s/^\(....\) /\1o/;bB;}
/^.. x  x../{s/^\(....\) /\1o/;bB;}
/^..x  x ../{s/^\(....\) /\1o/;bB;}
/^..xx   ../{s/^\(....\) /\1o/;bB;}
/^.x . .x ./{s/^\(....\) /\1o/;bB;}
/^.x.  x. ./{s/^\(....\) /\1o/;bB;}
/^.x.x  . ./{s/^\(....\) /\1o/;bB;}
/^.xx. .  ./{s/^\(....\) /\1o/;bB;}
/^x .. ..x /{s/^\(....\) /\1o/;bB;}
/^x. . .x. /{s/^\(....\) /\1o/;bB;}
/^x..  x.. /{s/^\(....\) /\1o/;bB;}
/^x..x  .. /{s/^\(....\) /\1o/;bB;}
/^x.x. . . /{s/^\(....\) /\1o/;bB;}
/^xx.. ..  /{s/^\(....\) /\1o/;bB;}
# try next orientation if any remain
#s/^/try next B\n/;P;s/^[^\n]*\n//;#####
/1/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/2/;bTB;}
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/3/;bTB;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/4/;bTB;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/5/;bTB;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/6/;bTB;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/7/;bTB;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/8/;bTB;}
/8/!{s/.*/Error    !/p;q;}
#s/^/tried last B\n/;P;s/^[^\n]*\n//;#####
g

bSB; #Skip Blocked
:B; # we Blocked
#s/^/:B\n/;P;s/^[^\n]*\n//;#####
# reapply orientation, save state, human's turn
# We need to be careful here - we have preferred orientation in hold space,
# and current orientation in pattern space.  Pattern space has our latest
# move, hold space doesn't yet.
# Rather than 8x8 possible single step reorientation, we'll do (up to) 2
# steps - 1x8 + 1x8.
# first step - undo orientation in pattern space
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;buB;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;buB;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;buB;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;buB;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;buB;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;buB;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;buB;}
:uB
#s/^/:uB\n/;P;s/^[^\n]*\n//;#####
x;/[1-8]/!s/$/1/; #now we have:
# moved unoriented in hold,
# outdated move state but preferred orientation and possibly additional
# status in pattern space
s/[^1-8O]//g; # strip move state from pattern space (outdated anyway)
H; # append desired state/orientation to unoriented move state in hold
g;s/\n//g; # fetch that to pattern space and strip newlines
/O/{s/O//g;s/$/O/;}; # squash redundant O's to single
# now reapply the desired orientation, save it to hold space,
# print it, go to next move:
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;h;bP;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;h;bP;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;h;bP;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;h;bP;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;h;bP;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;h;bP;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;h;bP;}
# already in desired orientation:
s/1//g;h;bP
:SB; #Skip Blocked
#s/^/:SB\n/;P;s/^[^\n]*\n//;#####

bSCFFBFFO; # Skip Can we Force Fork or Block Forced Fork (human is O)?
:CFFBFFO; # Can we Force Fork or Block Forced Fork (human is O)?
#s/^/:CFFBFFO\n/;P;s/^[^\n]*\n//;#####
# human is O, computer X
#s/.*/\nNot yet coded/p;q; #####
# Can we Force Fork?
#s/^/Can we Force Fork?\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
# undo our orientation first
/[1-8]/!s/$/1/
/1/bTFO
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/1/;bTFO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;s/$/1/;bTFO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/1/;bTFO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;s/$/1/;bTFO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;s/$/1/;bTFO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;s/$/1/;bTFO;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/1/;bTFO;}
:TFO; # Try Force (human is O)
#s/^/:TFO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
#1 2 5, rest by symmetry
#1
/^  x ..x../{s/^ /x/;bFO;}
/^  x. ...x/{s/^ /x/;bFO;}
/^  x.x... /{s/^ /x/;bFO;}
/^  xx.. ../{s/^ /x/;bFO;}
/^ ..  .x.x/{s/^ /x/;bFO;}
/^ .. x.x. /{s/^ /x/;bFO;}
/^ ..x . .x/{s/^ /x/;bFO;}
/^ ..xx. . /{s/^ /x/;bFO;}
/^ x  ..x../{s/^ /x/;bFO;}
/^ x . ...x/{s/^ /x/;bFO;}
/^ x .x... /{s/^ /x/;bFO;}
/^ x x.. ../{s/^ /x/;bFO;}
#2
/^x  .x.. ./{s/^\(.\) /\1x/;bFO;}
/^x  . ..x./{s/^\(.\) /\1x/;bFO;}
/^  x.x.. ./{s/^\(.\) /\1x/;bFO;}
/^  x. ..x./{s/^\(.\) /\1x/;bFO;}
#5
/^  .. ..xx/{s/^\(....\) /\1x/;bFO;}
/^ . . .x.x/{s/^\(....\) /\1x/;bFO;}
/^ ..  x..x/{s/^\(....\) /\1x/;bFO;}
/^ ..x  ..x/{s/^\(....\) /\1x/;bFO;}
/^ .x. . .x/{s/^\(....\) /\1x/;bFO;}
/^ x.. .. x/{s/^\(....\) /\1x/;bFO;}
/^.  . .xx./{s/^\(....\) /\1x/;bFO;}
/^. .  x.x./{s/^\(....\) /\1x/;bFO;}
/^. .x  .x./{s/^\(....\) /\1x/;bFO;}
/^. x. . x./{s/^\(....\) /\1x/;bFO;}
/^..   xx../{s/^\(....\) /\1x/;bFO;}
/^.. x  x../{s/^\(....\) /\1x/;bFO;}
/^..x  x ../{s/^\(....\) /\1x/;bFO;}
/^..xx   ../{s/^\(....\) /\1x/;bFO;}
/^.x . .x ./{s/^\(....\) /\1x/;bFO;}
/^.x.  x. ./{s/^\(....\) /\1x/;bFO;}
/^.x.x  . ./{s/^\(....\) /\1x/;bFO;}
/^.xx. .  ./{s/^\(....\) /\1x/;bFO;}
/^x .. ..x /{s/^\(....\) /\1x/;bFO;}
/^x. . .x. /{s/^\(....\) /\1x/;bFO;}
/^x..  x.. /{s/^\(....\) /\1x/;bFO;}
/^x..x  .. /{s/^\(....\) /\1x/;bFO;}
/^x.x. . . /{s/^\(....\) /\1x/;bFO;}
/^xx.. ..  /{s/^\(....\) /\1x/;bFO;}
# try next orientation if any remain
#s/^/try next FO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
#/.\{12,\}/{s/.*/too long/;p;q;};#####
/1/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/2/;bTFO;}
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/3/;bTFO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/4/;bTFO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/5/;bTFO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/6/;bTFO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/7/;bTFO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/8/;bTFO;}
#/8/!{s/^/no match for 8\n/;P;s/^[^\n]*\n//;};#####
/8/!{s/.*/Error     !/p;q;}
#s/^/tried last FO\n/;P;s/^[^\n]*\n//;#####
g

bSFO; # Skip Forced
:FO; # we Forced
#s/^/:FO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
# reapply orientation, save state, human's turn
# We need to be careful here - we have preferred orientation in hold space,
# and current orientation in pattern space.  Pattern space has our latest
# move, hold space doesn't yet.
# Rather than 8x8 possible single step reorientation, we'll do (up to) 2
# steps - 1x8 + 1x8.
# first step - undo orientation in pattern space
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;buO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;buO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;buO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;buO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;buO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;buO;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;buO;}
:uO
#s/^/:uO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
x;/[1-8]/!s/$/1/; #now we have:
# moved unoriented in hold,
# outdated move state but preferred orientation and possibly additional
# status in pattern space
s/[^1-8O]//g; # strip move state from pattern space (outdated anyway)
H; # append desired state/orientation to unoriented move state in hold
g;s/\n//g; # fetch that to pattern space and strip newlines
/O/{s/O//g;s/$/O/;}; # squash redundant O's to single
# now reapply the desired orientation, save it to hold space,
# print it, go to next move:
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;h;bP;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;h;bP;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;h;bP;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;h;bP;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;h;bP;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;h;bP;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;h;bP;}
# already in desired orientation:
s/1//g;h;bP
:SFO; # Skip Forced
#s/^/:SFO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
# Can we Block Fork?
# undo our orientation first
/[1-8]/!s/$/1/
/1/bTBO
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/1/;bTBO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;s/$/1/;bTBO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/1/;bTBO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;s/$/1/;bTBO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;s/$/1/;bTBO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;s/$/1/;bTBO;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/1/;bTBO;}
:TBO; #Try Block
#s/^/:TBO\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x
#1 2 5, rest by symmetry
#1
/^  o ..o../{s/^ /x/;bBO;}
/^  o. ...o/{s/^ /x/;bBO;}
/^  o.o... /{s/^ /x/;bBO;}
/^  oo.. ../{s/^ /x/;bBO;}
/^ ..  .o.o/{s/^ /x/;bBO;}
/^ .. o.o. /{s/^ /x/;bBO;}
/^ ..o . .o/{s/^ /x/;bBO;}
/^ ..oo. . /{s/^ /x/;bBO;}
/^ o  ..o../{s/^ /x/;bBO;}
/^ o . ...o/{s/^ /x/;bBO;}
/^ o .o... /{s/^ /x/;bBO;}
/^ o o.. ../{s/^ /x/;bBO;}
#2
/^o  .o.. ./{s/^\(.\) /\1x/;bBO;}
/^o  . ..o./{s/^\(.\) /\1x/;bBO;}
/^  o.o.. ./{s/^\(.\) /\1x/;bBO;}
/^  o. ..o./{s/^\(.\) /\1x/;bBO;}
#5
/^  .. ..oo/{s/^\(....\) /\1x/;bBO;}
/^ . . .o.o/{s/^\(....\) /\1x/;bBO;}
/^ ..  o..o/{s/^\(....\) /\1x/;bBO;}
/^ ..o  ..o/{s/^\(....\) /\1x/;bBO;}
/^ .o. . .o/{s/^\(....\) /\1x/;bBO;}
/^ o.. .. o/{s/^\(....\) /\1x/;bBO;}
/^.  . .oo./{s/^\(....\) /\1x/;bBO;}
/^. .  o.o./{s/^\(....\) /\1x/;bBO;}
/^. .o  .o./{s/^\(....\) /\1x/;bBO;}
/^. o. . o./{s/^\(....\) /\1x/;bBO;}
/^..   oo../{s/^\(....\) /\1x/;bBO;}
/^.. o  o../{s/^\(....\) /\1x/;bBO;}
/^..o  o ../{s/^\(....\) /\1x/;bBO;}
/^..oo   ../{s/^\(....\) /\1x/;bBO;}
/^.o . .o ./{s/^\(....\) /\1x/;bBO;}
/^.o.  o. ./{s/^\(....\) /\1x/;bBO;}
/^.o.o  . ./{s/^\(....\) /\1x/;bBO;}
/^.oo. .  ./{s/^\(....\) /\1x/;bBO;}
/^o .. ..o /{s/^\(....\) /\1x/;bBO;}
/^o. . .o. /{s/^\(....\) /\1x/;bBO;}
/^o..  o.. /{s/^\(....\) /\1x/;bBO;}
/^o..o  .. /{s/^\(....\) /\1x/;bBO;}
/^o.o. . . /{s/^\(....\) /\1x/;bBO;}
/^oo.. ..  /{s/^\(....\) /\1x/;bBO;}
# try next orientation if any remain
#s/^/try next BO\n/;P;s/^[^\n]*\n//;#####
/1/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/2/;bTBO;}
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/3/;bTBO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/4/;bTBO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;s/$/5/;bTBO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/6/;bTBO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;s/$/7/;bTBO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;s/$/8/;bTBO;}
/8/!{s/.*/Error      !/p;q;}
#s/^/tried last BO\n/;P;s/^[^\n]*\n//;#####
g

bSBO; #Skip Blocked
:BO; # we Blocked
#s/^/:BO\n/;P;s/^[^\n]*\n//;#####
# reapply orientation, save state, human's turn
# We need to be careful here - we have preferred orientation in hold space,
# and current orientation in pattern space.  Pattern space has our latest
# move, hold space doesn't yet.
# Rather than 8x8 possible single step reorientation, we'll do (up to) 2
# steps - 1x8 + 1x8.
# first step - undo orientation in pattern space
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;s/[1-8]//g;buBO;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;s/[1-8]//g;buBO;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;s/[1-8]//g;buBO;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;s/[1-8]//g;buBO;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;s/[1-8]//g;buBO;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;s/[1-8]//g;buBO;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;s/[1-8]//g;buBO;}
:uBO
#s/^/:uBO\n/;P;s/^[^\n]*\n//;#####
x;/[1-8]/!s/$/1/; #now we have:
# moved unoriented in hold,
# outdated move state but preferred orientation and possibly additional
# status in pattern space
s/[^1-8O]//g; # strip move state from pattern space (outdated anyway)
H; # append desired state/orientation to unoriented move state in hold
g;s/\n//g; # fetch that to pattern space and strip newlines
/O/{s/O//g;s/$/O/;}; # squash redundant O's to single
# now reapply the desired orientation, save it to hold space,
# print it, go to next move:
/2/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\2\1\6\5\4\9\8\7/;h;bP;}
/3/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\8\7\6\5\4\3\2\1/;h;bP;}
/4/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\8\9\4\5\6\1\2\3/;h;bP;}
/5/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\1\4\7\2\5\8\3\6\9/;h;bP;}
/6/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\3\6\9\2\5\8\1\4\7/;h;bP;}
/7/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\9\6\3\8\5\2\7\4\1/;h;bP;}
/8/{s/^\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)\(.\)/\7\4\1\8\5\2\9\6\3/;h;bP;}
# already in desired orientation:
s/1//g;h;bP
:SBO; #Skip Blocked
#s/^/:SBO\n/;P;s/^[^\n]*\n//;#####
:SCFFBFFO; # Skip Can we Force Fork or Block Forced Fork (human is O)?
#s/^/:SCFFBFFO\n/;P;s/^[^\n]*\n//;#####

# Handle any possible remaining moves for computer
/^ xo oxxox/{s/^ xo oxxox/oxo oxxox/;h;bP;}
/^o xxxoo x/{s/^o xxxoo x/ooxxxoo x/;h;bP;}
/^ox xo xox/{s/^ox xo xox/oxoxo xox/;h;bP;}
/^ox xxo ox/{s/^ox xxo ox/oxoxxo ox/;h;bP;}
/^oxo x xox/{s/^oxo x xox/oxoox xox/;h;bP;}
/^x ooxxx o/{s/^x ooxxx o/xoooxxx o/;h;bP;}
/^xox ox xo/{s/^xox ox xo/xoxoox xo/;h;bP;}
/^xoxxo ox /{s/^xoxxo ox /xoxxooox /;h;bP;}
/^xxoooxx  /{s/^xxoooxx  /xxoooxxo /;h;bP;}

s/^/Error!: Not yet coded\
/;P;s/^[^\n]*\n//;q
#s/^/Error!: Not yet coded\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####
#q;#####

#s/^/display text here\n/;P;s/^[^\n]*\n//;#####
#x;s/.*/   hold>&<hold/;x;s/.*/pattern>&<pattern/;G;p;s/^pattern>\(.*\)<pattern\n   hold>.*<hold$/\1/;x;s/^   hold>\(.*\)<hold$/\1/;x;#####