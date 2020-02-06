Welcome to ADAM, the **A**wesome **D**efender **A**ction **M**urderer Game


I used [TILED](https://www.mapeditor.org/) for creating the levels. 
Art is taken from [OpenGameArt](https://opengameart.org/). (see Attribution.txt for details)

This is a Work in progress! 

The game published under GNU GPLv3, so feel free to copy and modify the code as you wish, but keep it open! =D


How to install and play this, you ask?


## From scratch: download source and requirements:
In terminal, do:  

`git clone https://gitlab.com/DavidLeonardWenzel/awesomedefenderactionmurderer.git`


If you have LUA and LOVE installed skip the following steps, otherwise do:    
**ARCH:**  
`sudo pacman -S lua`  
`sudo pacman -S love`  
**UBUNTU:**   
`sudo apt install lua5.3`    
The following command should allow you to get the latest stable version:  
(which is usually newer than the default apt-package)  
`sudo add-apt-repository ppa:bartbes/love-stable`  
`sudo apt-get update`  
`sudo apt install love`

**WINDOWS:**  
[please see the instructions for downloading LÖVE and running games here](https://love2d.org/wiki/Getting_Started). 
After downloading LÖVE you can download the game folder and drag it on top of the love.exe!

## Run the game in Terminal:  
`cd awesomedefenderactionmurderer`
`love .`

