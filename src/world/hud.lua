Hud = {}

Hud.__index = Hud
function Hud:Create()
    local this = {
        media = {
            hud = {
                berserk = "assets/hud/berserk/berserk.png",
                berserkUsed = "assets/hud/berserk/berserkUsed.png",
                boom = "assets/hud/boom/boom64.png",
                boomUsed = "assets/hud/boom/boom64used.png",
                explo = "assets/hud/explo/explo.png",
                exploUsed = "assets/hud/explo/exploUsed.png",
                fast = "assets/hud/fast/fast.png",
                fastUsed = "assets/hud/fast/fastUsed.png",
                fire = "assets/hud/fire/fire.png",
                fireUsed = "assets/hud/fire/fireUsed.png",
                healthFrame = "assets/hud/healthbar/healthFrame.png",
                health = "assets/hud/healthbar/health.png",
                heart = "assets/hud/healthbar/heart.png",
                money = "assets/hud/money/coin.png",
                a = "assets/hud/controls/a.png",
                s = "assets/hud/controls/s.png",
                d = "assets/hud/controls/d.png",
                f = "assets/hud/controls/f.png",
                space = "assets/hud/controls/space.png",
                brown = "assets/hud/border/brown.png",
                silver = "assets/hud/border/silver.png",
                gold = "assets/hud/border/gold.png",
                border = "assets/hud/border/border.png",
                borderSmall = "assets/hud/border/border384.png"
            },
            hudSkillBorder = {
                a = false,
                s = false,
                d = false,
                f = false,
                space = false
            },
            hudPos = {
                --SKILLS:
                xOffset = 75,
                yOffset = 850,
                skillDistance = 80,
                healthX = 100,
                healthY = 920,
                moneyX = 310,
                moneyY = 5,
                heartX = -50,
                heartY = 755,
                heartDistance = 40,
                letterX = 80, --xoffset + 5
                letterY = 855, --yoffset + 5
                letterDistance = 80, --same as skillDistance
                -- KILL COUNTERS
                counterX = 420,
                counterY = 110,
                -- Width of focussed buttons
                focussedButtonBorderWidth = 5
            }
        }
    }
    setmetatable(this, Hud)
    return this
end

function Hud:loadHudImages()
    for key, imgPath in pairs(self.media.hud) do
        self.media.hud[key] = love.graphics.newImage(imgPath)
    end
end

function Hud:drawHud(player, currentLevel, currentRunTime, healthInPercent, world)
    self.player = player
    self.currentLevel = currentLevel
    self.currentRunTime = currentRunTime
    self.world = world -- TODO: remove when not used anymore

    self:drawSkills()
    self:drawHealthBar(healthInPercent)
    self:drawHearts()
    self:drawButtons()
    self:drawSkillBorders()
    self:drawMoney()
    self:drawKillCounters()
    self:drawLevelTimer()
    self:drawCollectCounter()
end

function Hud:drawSkills()
    local skills = self:getSkillsToDraw()
    self:drawOnSkillPositions(skills)
    if self.player.inBerserk then
        -- make the berserk box bling
        love.graphics.setColor(1, 0.8313, 0, self.player.berserkAlpha)
        love.graphics.rectangle(
            "fill",
            self.media.hudPos.xOffset + (self.media.hudPos.skillDistance * 2),
            self.media.hudPos.yOffset,
            self.media.hud.boom:getWidth(),
            self.media.hud.boom:getHeight()
        )
        love.graphics.setColor(255, 255, 255, 255)
    end
end

function Hud:drawSkillBorders()
    local skillBorders = self:getSkillBordersToDraw()
    self:drawOnSkillPositions(skillBorders)
end

function Hud:drawOnSkillPositions(drawableSkillObjects)
    for drawableSkillCount = 1, #drawableSkillObjects do
        if drawableSkillObjects[drawableSkillCount] then
            love.graphics.draw(
                drawableSkillObjects[drawableSkillCount],
                self.media.hudPos.xOffset + (self.media.hudPos.skillDistance * (drawableSkillCount - 1)),
                self.media.hudPos.yOffset
            )
        end
    end
end

function Hud:getSkillsToDraw()
    local skills = {}
    if self.player.canBoom then
        table.insert(skills, self.media.hud.boom)
    else
        table.insert(skills, self.media.hud.boomUsed)
    end
    if self.player.canFire and (self.player.fireLevel ~= 0) then
        table.insert(skills, self.media.hud.fire)
    else
        table.insert(skills, self.media.hud.fireUsed)
    end
    if self.player.canBerserk and (self.player.berserkLevel ~= 0) then
        table.insert(skills, self.media.hud.berserk)
    else
        table.insert(skills, self.media.hud.berserkUsed)
    end
    if self.player.canGoFast and (self.player.goFastLevel ~= 0) then
        table.insert(skills, self.media.hud.fast)
    else
        table.insert(skills, self.media.hud.fastUsed)
    end
    if self.player.canBurst and (self.player.burstLevel ~= 0) then
        table.insert(skills, self.media.hud.explo)
    else
        table.insert(skills, self.media.hud.exploUsed)
    end
    return skills
end

function Hud:getSkillBordersToDraw()
    local skillBorders = {}
    if self.media.hudSkillBorder.a then
        table.insert(skillBorders, self.media.hudSkillBorder.a)
    else 
        table.insert(skillBorders, false)
    end
    if self.media.hudSkillBorder.s then
        table.insert(skillBorders, self.media.hudSkillBorder.s)
    else 
        table.insert(skillBorders, false)
    end
    if self.media.hudSkillBorder.d then
        table.insert(skillBorders, self.media.hudSkillBorder.d)
    else 
        table.insert(skillBorders, false)
    end
    if self.media.hudSkillBorder.f then
        table.insert(skillBorders, self.media.hudSkillBorder.f)
    else 
        table.insert(skillBorders, false)
    end
    if self.media.hudSkillBorder.space then
        table.insert(skillBorders, self.media.hudSkillBorder.space)
    else 
        table.insert(skillBorders, false)
    end
    return skillBorders
end

function Hud:drawHealthBar(healthInPercent)
    love.graphics.draw(
        self.media.hud.health,
        self.media.hudPos.healthX,
        self.media.hudPos.healthY,
        0,
        healthInPercent,
        1
    )
    love.graphics.draw(self.media.hud.healthFrame, self.media.hudPos.healthX, self.media.hudPos.healthY)
end

function Hud:drawHearts() --a heart for kids
    for heart in Range(self.player.hearts) do
        love.graphics.draw(
            self.media.hud.heart,
            self.media.hudPos.heartX + self.media.hudPos.heartDistance,
            --self.media.hudPos.heartX + (self.media.hudPos.heartDistance * heart - 1),
            self.media.hudPos.heartY + self.media.hudPos.heartDistance * heart - 1,
            --self.media.hudPos.heartY,
            0,
            0.5,
            0.5
        )
    end
end

function Hud:drawButtons()
    local lettersToDraw = {
        self.media.hud.a,
        self.media.hud.s,
        self.media.hud.d,
        self.media.hud.f
    }
    self:drawLetters(lettersToDraw)
    self:drawSpaceButton(self.media.hud.space, #lettersToDraw)
end

function Hud:drawLetters(lettersToDraw)
    for letterCount = 1, #lettersToDraw do
        self:drawSingleButton(lettersToDraw[letterCount], letterCount - 1, 0, 0.65)
    end
end

function Hud:drawSpaceButton(drawableButton, distanceFactor)
    self:drawSingleButton(drawableButton, distanceFactor, 0, 0)
end

function Hud:drawSingleButton(drawable, distanceFactor, x, y)
    love.graphics.draw(
        drawable,
        (self.media.hudPos.letterX + self.media.hudPos.letterDistance * distanceFactor),
        self.media.hudPos.letterY,
        x,
        y
    )
end

function Hud:drawMoney()
    --todo make sparkle and rarely turn (no need for anim, use x rotation)
    love.graphics.draw(self.media.hud.money, self.media.hudPos.moneyX, self.media.hudPos.moneyY, 0, 0.5)
    love.graphics.setFont(WORLD.media.bigreadfont)
    love.graphics.print(self.player.money, self.media.hudPos.moneyX + 90, self.media.hudPos.moneyY + 35)
end

function Hud:drawKillCounters()
    if self.currentLevel.winType == "kill" then
        -- scale down the kill counter a little, or a little bit more if it is the door
        local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
        local doorScaling =
            love.math.newTransform(
            self.media.hudPos.counterX - (self.media.hud.brown:getWidth() / 2) - 3,
            self.media.hudPos.counterY - 3,
            0,
            0.1,
            0.2,
            0,
            0
        )
        love.graphics.push()
        love.graphics.applyTransform(scaling)
        local enemyCount = 1
        for enemyName, enemySpawnInfo in pairs(self.currentLevel.enemies) do
            -- if enemy on hitlist
            if enemySpawnInfo.killToWin then
                -- let background be transparent black
                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle(
                    "fill",
                    self.media.hudPos.counterX,
                    self.media.hudPos.counterY * enemyCount,
                    self.media.hud.brown:getWidth(),
                    self.media.hud.brown:getHeight()
                )
                -- reset black color
                love.graphics.setColor(255, 255, 255, 255)
                -- draw brown frame
                love.graphics.draw(
                    self.media.hud.brown,
                    self.media.hudPos.counterX,
                    self.media.hudPos.counterY * enemyCount
                )
                -- draw enemy pic into frame
                if enemyName == "door" then
                    love.graphics.push()
                    love.graphics.applyTransform(doorScaling)
                end
                love.graphics.draw(
                    -- TODO: get img and portrait direct from enemy
                    self.world.statsRaw[enemyName].media.img,
                    self.world.statsRaw[enemyName].portrait,
                    self.media.hudPos.counterX,
                    self.media.hudPos.counterY * enemyCount
                )
                if enemyName == "door" then
                    love.graphics.pop()
                end
                -- write killCounter
                love.graphics.setFont(WORLD.media.bigreadfont)
                --local text =
                --    (bossMode and enemySpawnInfo.hp) or (enemySpawnInfo.counter .. "/" .. enemySpawnInfo.goal)
                love.graphics.printf(
                    enemySpawnInfo.counter .. "/" .. enemySpawnInfo.goal, --text,
                    self.media.hudPos.counterX + self.media.hud.brown:getWidth() + 5,
                    self.media.hudPos.counterY * enemyCount,
                    (500 - (0.8 * self.media.hudPos.counterX + 0.8 * self.media.hud.brown:getWidth())),
                    "center"
                )
                enemyCount = enemyCount + 1
            end
        end
        enemyCount = 0
        love.graphics.pop()
    end
end

function Hud:drawLevelTimer()
    if self.currentLevel.winType == "endure" then
        -- scale down the kill counter a little, make it gradually more red until we reach zero
        local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
        love.graphics.push()
        love.graphics.applyTransform(scaling)
        love.graphics.setFont(WORLD.media.bigfantasyfont)
        if self.currentRunTime >= self.currentLevel.goal then
            -- runtime goal reached
            local time = DisplayTime(0)
            love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
        else
            -- runtime goal not reached
            love.graphics.setColor(
                1,
                1 - self.currentRunTime / self.currentLevel.goal,
                1 - self.currentRunTime / self.currentLevel.goal,
                1
            )
            local time = DisplayTime(self.currentLevel.goal - self.currentRunTime)
            love.graphics.printf(time, self.media.hudPos.counterX + 5, self.media.hudPos.counterY, 150, "left")
            love.graphics.setColor(255, 255, 255, 255)
        end
        love.graphics.pop()
    end
end

function Hud:drawCollectCounter()
    if self.currentLevel.winType == "collect" then
        -- scale down the kill counter a little, make it gradually more red until we reach zero
        local scaling = love.math.newTransform(0, 0, 0, 0.8, 0.8, 0, 0)
        love.graphics.push()
        love.graphics.applyTransform(scaling)
        love.graphics.setFont(WORLD.media.bigfantasyfont)
        -- let background be transparent black
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle(
            "fill",
            self.media.hudPos.counterX,
            self.media.hudPos.counterY,
            self.media.hud.brown:getWidth(),
            self.media.hud.brown:getHeight()
        )
        -- reset black color
        love.graphics.setColor(255, 255, 255, 255)
        -- draw brown frame
        love.graphics.draw(self.media.hud.brown, self.media.hudPos.counterX, self.media.hudPos.counterY)
        -- draw enemy pic into frame
        love.graphics.draw(
            self.world.itemsRaw.items["importantCoin"].img,
            self.media.hudPos.counterX +
                (self.media.hud.brown:getWidth() - self.world.itemsRaw.items["importantCoin"].img:getWidth()) / 2,
            self.media.hudPos.counterY +
                (self.media.hud.brown:getHeight() - self.world.itemsRaw.items["importantCoin"].img:getHeight()) / 2
        )
        -- write collectCounter
        love.graphics.setFont(WORLD.media.bigfantasyfont)
        love.graphics.printf(
            self.currentLevel.counter .. "/" .. self.currentLevel.goal,
            self.media.hudPos.counterX + self.media.hud.brown:getWidth() + 5,
            self.media.hudPos.counterY,
            (500 - (0.8 * self.media.hudPos.counterX + 0.8 * self.media.hud.brown:getWidth())),
            "center"
        )
        love.graphics.pop()
    end
end

function Hud:drawIteration(iteration, x)
    love.graphics.print(iteration, x / 2, 20)
end

function Hud:drawWinScreen()
    love.graphics.setFont(WORLD.media.bigfantasyfont)
    love.graphics.print("YOU WIN!", 152, 250)
    -- draw red rectangle as marking box around continue button
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        240 - (self.media.hud.borderSmall:getWidth() / 2) - self.media.hudPos.focussedButtonBorderWidth,
        480 - (self.media.hud.borderSmall:getHeight() / 2) - self.media.hudPos.focussedButtonBorderWidth,
        WORLD.HUD.media.hud.borderSmall:getWidth() + 2 * self.media.hudPos.focussedButtonBorderWidth,
        WORLD.HUD.media.hud.borderSmall:getHeight() + 2 * self.media.hudPos.focussedButtonBorderWidth
    )
    love.graphics.setColor(255, 255, 255)
    -- draw continue button
    SUIT.draw()
    love.graphics.printf("CONTINUE", 0, 450, 480, "center")
end
