function love.load()
    start()
end

function love.draw()
    for i = 1, 8 do
        love.graphics.draw(rollImg, rollsX[i], (i - 1) * 100)
        love.graphics.draw(toasterImg, toastersX[i], (i - 1) * 100)
    end
    love.graphics.draw(player.image, player.x, player.y)

    love.graphics.print("score: "..math.floor(timer), 5, 5)
    love.graphics.print("highscore: "..math.floor(highscore), 5, 30)
end

function love.update(dt)
    for i = 1, 8 do
        rollsX[i] = rollsX[i] - rollsSpeed[i] * dt
        if rollsX[i] < -800 then 
            rollsX[i] = 0
        end
        toastersX[i] = toastersX[i] - (rollsSpeed[i] + timer * 20) * dt
        if toastersX[i] < -100 then
            toastersX[i] = love.math.random(800) + 800
        end
        local heightIndex = (player.y / 100) + 1
        if heightIndex == i then
            local rightX = toastersX[i] + 100
            local leftX = toastersX[i]
            if player.x + player.image:getWidth() > leftX and player.x < rightX then
                if player.burned then
                    restart()
                else
                    player.burned = true
                    player.image = love.graphics.newImage("burnedToast.png")
                    player.x = rightX + 10
                end

                break
            end
        end
    end
    timer = timer + dt
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "up" and not (player.y == 0) then 
        player.y = player.y - 100
    end
    if key == "down" and not (player.y == 700) then
        player.y = player.y + 100
    end
end

function start()
    timer = 0
    highscore = 0
    player = {
        image = love.graphics.newImage("toast.png"),
        x = 100,
        y = 100,
        burned = false
    }

    rollImg = love.graphics.newImage("roll.png")
    rollsX = {}
    rollsSpeed = {}
    for i = 1, 8 do
        rollsX[i] = love.math.random(800) * -1
        rollsSpeed[i] = (love.math.random(300) + 100)
    end

    toasterImg = love.graphics.newImage("toaster.png")
    toastersX = {}
    for i = 1, 8 do
        toastersX[i] = love.math.random(800) + 800
    end

    loop = love.audio.newSource("loop.wav", "stream")
    loop:setLooping(true)
    loop:play()
end

function restart()

    if timer > highscore then highscore = timer end

    timer = 0

    loop:pause()
    love.audio.newSource("lose.wav", "static"):play()
    loop:play()

    player.burned = false
    player.image = love.graphics.newImage("toast.png")
    player.x = 100
    player.y = 100

    rollsX = {}
    rollsSpeed = {}
    for i = 1, 8 do
        rollsX[i] = love.math.random(800) * -1
        rollsSpeed[i] = (love.math.random(300) + 100)
    end

    toastersX = {}
    for i = 1, 8 do
        toastersX[i] = love.math.random(800) + 800
    end
end