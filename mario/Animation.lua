Animation = Class{}

function Animation:init(params)
    self.texture = params.texture
    self.frames = params.frames or {}
    -- time passed between each frame
    self.interval = params.interval or 0.05
    -- going to be incremented by dt in every frame
    self.timer = 0
    -- index for self.frames
    self.currentFrame = 1
end


function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end


function Animation:restart()
    self.timer = 0
    self.currentFrame = 1
end


function Animation:update(dt)
    self.timer = self.timer + dt
    
    while self.timer > self.interval do
        self.timer = self.timer - self.interval
        self.currentFrame = (self.currentFrame + 1) % (#self.frames + 1)

        if self.currentFrame == 0 then
            self.currentFrame = 1
        end
    end
end


function Animation:render()

end