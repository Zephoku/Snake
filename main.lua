function love.run()
    love.graphics.setMode(1024,768, false, true, 0)
    gridImage = love.graphics.newImage("Images/Grid.png")
    if love.load then love.load(arg) end
    systemHeight = love.graphics.getHeight()
    systemWidth = love.graphics.getWidth()
    local dt = 0
    dtotal = 0
    dtotal2 = 0
    snakeSize = 16
    speed = .08 -- value from .01 to .1
    global_dir = nil
    length = 0
    foodamt = 0
    initialLength = 5
    gameFinished = false 
    defaultX = 256
    defaultY = 256
    dofile("player.lua")
    while initialLength > 0 do
        Segment:addSeg()
        initialLength = initialLength -1
    end

    -- Main loop time.
    while true do
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        -- Process events.
        if love.event then
            for e,a,b,c in love.event.poll() do
                if e == "q" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c)
            end
        end

        if love.timer then love.timer.sleep(1) end
        if love.graphics then love.graphics.present() end

    end

end
