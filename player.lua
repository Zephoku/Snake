function love.load() 
    love.graphics.setBackgroundColor (255,255,255)
    love.graphics.setColor(0,0,0,200)
    local font = love.graphics.newFont(12)
    love.graphics.setFont(font)
end

function love.draw()
    love.graphics.draw(gridImage)
    local tmpLen = length
    local tmpamt = foodamt
    while tmpLen > 0 do
        love.graphics.rectangle("fill", Snake[tmpLen].xCoord, Snake[tmpLen].yCoord, snakeSize, snakeSize)
        tmpLen = tmpLen -1
    end
    while tmpamt > 0 do
        love.graphics.rectangle("fill", Food[tmpamt].xCoord, Food[tmpamt].yCoord, snakeSize, snakeSize)
        tmpamt = tmpamt -1
    end
end

function love.update(dt)
    if not gameFinished then
        dtotal = dtotal + dt
        if dtotal >= speed then
            dtotal = dtotal - speed
            Snake:move(global_dir)
        end
        if 5 > math.random(1,1000) then
            spawnFood()
        end
        if foodamt == 0 then
            spawnFood()
        end
        Snake:eatFood()
    end
end

function love.keypressed(key , unicode) 
    if key == "up" or key == "down" or key == "left" or key == "right" then
        if global_dir == "up" and key == "down" or
            global_dir == "down" and key == "up" or
            global_dir == "left" and key == "right" or
            global_dir == "right" and key == "left" then
            return
        end
        global_dir = key
    end
end

Segment = {
    xCoord = 256,
    yCoord = 256,
}
Segment.__index = Segment
function Segment.create(x,y)
    local seg = {}
    setmetatable(seg,Segment)
    seg.xCoord = x
    seg.yCoord = y
    return seg
end

function Segment:addSeg() 
    if length == 0 then
        length = length + 1
        Snake[length] = Segment.create(defaultX, defaultY)
    else
        Snake[length+1] = Segment.create(Snake[length].xCoord, Snake[length].yCoord)
        length = length + 1
    end
end

Snake = {}

function Snake:isCollision(dir)
    local tmpLen = length
    if dir == "up" then
        if 0 > Snake[1].yCoord -snakeSize then
            return true
        end
        while tmpLen > 1 do
            if Snake[1].yCoord -snakeSize == Snake[tmpLen].yCoord  and
                Snake[1].xCoord == Snake[tmpLen].xCoord then
                return true
            end
            tmpLen = tmpLen - 1
        end

    elseif dir == "down" then
        if systemHeight <= Snake[1].yCoord + snakeSize then
            return true
        end
        while tmpLen > 1 do
            if Snake[1].yCoord +snakeSize == Snake[tmpLen].yCoord  and
                Snake[1].xCoord == Snake[tmpLen].xCoord then
                return true
            end
            tmpLen = tmpLen - 1
        end


    elseif dir == "right" then
        if systemWidth <= Snake[1].xCoord + snakeSize then
            return true
        end
        while tmpLen > 1 do
            if Snake[1].yCoord == Snake[tmpLen].yCoord  and
                Snake[1].xCoord + snakeSize == Snake[tmpLen].xCoord then
                return true
            end
            tmpLen = tmpLen - 1
        end


    elseif dir == "left" then
        if 0 > Snake[1].xCoord - snakeSize then
            return true
        end
        while tmpLen > 1 do
            if Snake[1].yCoord == Snake[tmpLen].yCoord  and
                Snake[1].xCoord - snakeSize == Snake[tmpLen].xCoord then
                return true
            end
            tmpLen = tmpLen - 1
        end


    end

    return false
end

function Snake:move(dir)
    if Snake:isCollision(dir) then
        gameFinished = true
        return
    end

    local tmpLen = length
    while tmpLen > 1 do 
        Snake[tmpLen].xCoord = Snake[tmpLen-1].xCoord
        Snake[tmpLen].yCoord = Snake[tmpLen-1].yCoord
        tmpLen = tmpLen - 1
    end
    if dir == "up" then
        Snake[1].yCoord = Snake[1].yCoord - snakeSize
    elseif dir == "down" then
        Snake[1].yCoord = Snake[1].yCoord + snakeSize
    elseif dir == "right" then
        Snake[1].xCoord = Snake[1].xCoord + snakeSize
    elseif dir == "left" then
        Snake[1].xCoord = Snake[1].xCoord - snakeSize
    end
end

function Snake:eatFood()
    local tmpamt = foodamt
    while tmpamt > 0 do
        if Snake[1].xCoord == Food[tmpamt].xCoord and Snake[1].yCoord == Food[tmpamt].yCoord then
            while tmpamt+1 < foodamt do
                Food[tmpamt] = Food[tmpamt+1]
                tmpamt = tmpamt + 1
            end
            foodamt = foodamt - 1
            Segment:addSeg()
            return
        end
        tmpamt = tmpamt - 1
    end
end

Food = {}

function spawnFood() 
   math.randomseed(os.time())
   local randX = math.random(systemWidth)
   local randY = math.random(systemHeight) 
   Piece = {
       xCoord = randX - (randX%snakeSize),
       yCoord = randY - (randY%snakeSize),
   }
   foodamt = foodamt + 1
   Food[foodamt] = Piece
end

