-- Full text we want to print
textToPrint  = "Hello! A typewriter is typing this. \nBye!"
printedText  = "" -- Section of the text printed so far

-- Timer to know when to print a new letter
typeTimerMax = 0.1
typeTimer    = 0.1

-- Current position in the text
typePosition = 0

function love.update(dt)
    -- Decrease timer
    typeTimer = typeTimer - dt
    
    -- Timer done, we need to print a new letter:
    -- Adjust position, use string.sub to get sub-string
    if typeTimer <= 0 then
        typeTimer = 0.1
        typePosition = typePosition + 1

        printedText = string.sub(textToPrint,0,typePosition)
    end

end

function love.draw(dt)
    -- Print text so far
    love.graphics.print(printedText,20,100)
end        

