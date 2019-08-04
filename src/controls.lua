--BUTTON LOGIC: MOVEMENT AND ATTACKS

--kinda crazy that everything in scope of call-time can be accessed without passing it. 
--maybe you should pass anyway so that the caller can see what is being manipulated?
--i think these functions should on the player and not seperate?
--see player entity for example of function in table!
--adv like this: entity and logic control is seperated
--disAdv: everything here calls the player anyway, is seperation even good when semantic is this close?



function goBerserk(dt)
    player.inBerserk=true
    player.canBerserk=false
    player.berserkCooldown = playerRaw.berserkCooldown
end

function gottaGoFast(dt)
    --TODO implement

end