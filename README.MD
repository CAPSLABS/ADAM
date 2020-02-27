Welcome to ADAM, an open-source Shoot 'em up game!  
The game is published under the GNU GPLv3 license, so feel free to copy and modify the code as you wish, but keep it open! =D

How to install and play this, you ask?  

### LINUX
Under Linux, you can start the game directly using the source code!  
##### 1. Install Lua & Love:    
(if you aleady have LUA and LOVE installed skip this step)     
  
**ARCH:**  
`sudo pacman -S lua`  
`sudo pacman -S love`  
  
**UBUNTU:**   
`sudo apt install lua5.3`    
The following command should allow you to get the latest stable version of LÖVE (which is usually newer than the default apt-package):  
`sudo add-apt-repository ppa:bartbes/love-stable`  
`sudo apt-get update`  
`sudo apt install love`

##### 2. Clone and run source!
`git clone https://gitlab.com/DavidLeonardWenzel/adam.git`  
`love adam`  

### WINDOWS

For Windows we have created a .exe file that can be downloaded from gitlab. 
1. Visit [https://gitlab.com/DavidLeonardWenzel/adam/-/tree/master/bin](https://gitlab.com/DavidLeonardWenzel/adam/-/tree/master/bin). You should see some .dll files, as well as adam.exe.
2. On the site in the upper right corner there is a download symbol. Click on it.
3. Download the source folder as a .zip file.
4. Unpack the .zip file. Go into the extracted folder named 'adam'.
5. Start adam.exe to play!

### MAC

Under Mac, it's almost the same as with Linux.

#### 1. Install love via Homebrew:
`brew cask install love`

#### 2. Follow step 2 of the Linux install guide!

---
This game is build using the [LÖVE](https://love2d.org/) framework and is written in [Lua](https://www.lua.org/) 5.3.   
Game art was created using [pixilart](https://www.pixilart.com/) and [Tiled Map Editor](https://www.mapeditor.org/).  
Spritesheets were created using [opengameart](https://opengameart.org/).   
Game Music was created by [ozzed](http://ozzed.net) and [Scott Arrc](https://scottarc.bandcamp.com]).  
Please check the credits and Attribution.txt for more details!
