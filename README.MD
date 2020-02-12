Welcome to ADAM, the **A**wesome **D**efender **A**ction **M**urderer Game


We used [TILED](https://www.mapeditor.org/) for creating the levels. 
Art is taken from [OpenGameArt](https://opengameart.org/) (see Attribution.txt for details). 
This game is build using the [LÖVE](https://love2d.org/) framework and is written in [Lua](https://www.lua.org/) 5.3.

The game published under GNU GPLv3, so feel free to copy and modify the code as you wish, but keep it open! =D

How to install and play this, you ask?

### LINUX

In terminal, do:  

`git clone https://gitlab.com/DavidLeonardWenzel/awesomedefenderactionmurderer.git`

If you have LUA and LÖVE installed skip the following steps, otherwise to install LUA and LÖVE do:

**ARCH:**  
`sudo pacman -S lua`  
`sudo pacman -S love`  

**UBUNTU:**   
`sudo apt install lua5.3`    
The following command should allow you to get the latest stable version of LÖVE (which is usually newer than the default apt-package):
`sudo add-apt-repository ppa:bartbes/love-stable`  
`sudo apt-get update`  
`sudo apt install love`

Then, to run the game in the terminal:
`cd awesomedefenderactionmurderer`  
`love .`

### WINDOWS

For Windows we have created an .exe file that can be downloaded from gitlab. 
1. Visit [https://gitlab.com/DavidLeonardWenzel/awesomedefenderactionmurderer/-/tree/master/bin](https://gitlab.com/DavidLeonardWenzel/awesomedefenderactionmurderer/-/tree/master/bin). You should see some .dll files, as well as ADAM.exe.
2. On the site in the upper right corner there is a download symbol. Click on it.
3. Download the source folder as a .zip file.
4. Unpack the .zip file. Go into the extracted folder named 'ADAM'.
5. Start ADAM.exe to play!

### MAC

We do not support Mac yet.
