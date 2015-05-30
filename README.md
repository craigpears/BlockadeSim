# BlockadeSim
BlockadeSim is a simlated environment of blockading in the game Puzzle Pirates.  It is a multi-player game where players control ships to influence flags while shooting and sinking each other to gain flag influence.


Setup Instructions:
1. Clone the repo locally
2. Download FlashDevelop IDE - http://www.flashdevelop.org/
3. Make sure you have a 32 bit JRE installed
4. Download flash standalone player - http://www.adobe.com/support/flashplayer/downloads.html
5. Associate .swf files to open with the stand alone player

Troubleshooting
For some reason the build process hates the lines that look like "playerId:int = NetSubControl.TO_ALL".  
Whenever this happens:
Delete the right part of the assignment
Build (it will fail)
Undo the changes
Build again and it seems to be happy.
