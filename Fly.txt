-- Mobile Flight Script with Anti-Cheat Bypass
-- Usage: loadstring(script_content)()

loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() -- Load UI library

local FlightScript = (function()
    -- Configuration
    local config = {
        enabled = false,
        speed = 50,
        verticalSpeed = 25,
        antiCheatBypass = true,
        bypassMode = "pulse", -- "pulse", "random", "smooth"
        uiOffset = {x = 0, y = 0}
    }
    
    -- Internal variables
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local flying = false
    local lastUpdate = tick()
    local antiCheatPulse = 0
    local ui = nil
    
    -- Anti-cheat bypass methods
    local function applyBypass()
        if not config.antiCheatBypass then return end
        
        if config.bypassMode == "pulse" then
            antiCheatPulse = (antiCheatPulse + 1) % 60
            if antiCheatPulse < 30 then
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        elseif config.bypassMode == "random" then
            if math.random() < 0.3 then
                rootPart.Velocity = Vector3.new(math.random(-5,5), math.random(-2,2), math.random(-5,5))
            end
        elseif config.bypassMode == "smooth" then
            rootPart.Velocity = rootPart.Velocity:Lerp(Vector3.new(0,0,0), 0.1)
        end
    end
    
    -- Flight logic
    local function fly()
        if not flying or not rootPart then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0,0,0)
        
        if userinputservice:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0,1,0)
        end
        if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0,1,0)
        end
        
        moveVector = moveVector.Unit * config.speed
        moveVector = Vector3.new(moveVector.X, moveVector.Y * config.verticalSpeed, moveVector.Z)
        
        rootPart.Velocity = moveVector
        applyBypass()
    end
    
    -- Create mobile-friendly UI
    local function createUI()
        ui = Instance.new("ScreenGui")
        ui.Name = "FlightMobileUI"
        ui.Parent = game:GetService("CoreGui")
        
        -- Main frame
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.3, 0, 0.4, 0)
        frame.Position = UDim2.new(0.05 + config.uiOffset.x, 0, 0.3 + config.uiOffset.y, 0)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BackgroundTransparency = 0.5
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true
        frame.Name = "MainFrame"
        frame.Parent = ui
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0.1, 0)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.Text = "Flight Controls"
        title.TextColor3 = Color3.new(1,1,1)
        title.BackgroundTransparency = 1
        title.Parent = frame
        
        -- Toggle button
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.8, 0, 0.2, 0)
        toggle.Position = UDim2.new(0.1, 0, 0.15, 0)
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.new(1,1,1)
        toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        toggle.Parent = frame
        
        toggle.MouseButton1Click:Connect(function()
            config.enabled = not config.enabled
            flying = config.enabled
            if config.enabled then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            else
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
        
        -- Speed controls
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
        speedLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
        speedLabel.Text = "Speed: "..config.speed
        speedLabel.TextColor3 = Color3.new(1,1,1)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Parent = frame
        
        local speedUp = Instance.new("TextButton")
        speedUp.Size = UDim2.new(0.35, 0, 0.1, 0)
        speedUp.Position = UDim2.new(0.1, 0, 0.55, 0)
        speedUp.Text = "+ Speed"
        speedUp.TextColor3 = Color3.new(1,1,1)
        speedUp.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        speedUp.Parent = frame
        
        speedUp.MouseButton1Click:Connect(function()
            config.speed = math.min(config.speed + 5, 100)
            speedLabel.Text = "Speed: "..config.speed
        end)
        
        local speedDown = Instance.new("TextButton")
        speedDown.Size = UDim2.new(0.35, 0, 0.1, 0)
        speedDown.Position = UDim2.new(0.55, 0, 0.55, 0)
        speedDown.Text = "- Speed"
        speedDown.TextColor3 = Color3.new(1,1,1)
        speedDown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        speedDown.Parent = frame
        
        speedDown.MouseButton1Click:Connect(function()
            config.speed = math.max(config.speed - 5, 5)
            speedLabel.Text = "Speed: "..config.speed
        end)
        
        -- Bypass mode selector
        local bypassLabel = Instance.new("TextLabel")
        bypassLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
        bypassLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
        bypassLabel.Text = "Bypass: "..config.bypassMode
        bypassLabel.TextColor3 = Color3.new(1,1,1)
        bypassLabel.BackgroundTransparency = 1
        bypassLabel.Parent = frame
        
        local bypassToggle = Instance.new("TextButton")
        bypassToggle.Size = UDim2.new(0.8, 0, 0.1, 0)
        bypassToggle.Position = UDim2.new(0.1, 0, 0.85, 0)
        bypassToggle.Text = "Change Bypass"
        bypassToggle.TextColor3 = Color3.new(1,1,1)
        bypassToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        bypassToggle.Parent = frame
        
        local bypassModes = {"pulse", "random", "smooth"}
        local currentMode = 1
        
        bypassToggle.MouseButton1Click:Connect(function()
            currentMode = currentMode % #bypassModes + 1
            config.bypassMode = bypassModes[currentMode]
            bypassLabel.Text = "Bypass: "..config.bypassMode
        end)
        
        -- Save position when dragging ends
        frame.DragEnd:Connect(function()
            config.uiOffset = {
                x = frame.Position.X.Offset/1000,
                y = frame.Position.Y.Offset/1000
            }
        end)
    end
    
    -- Initialize
    local function init()
        createUI()
        
        player.CharacterAdded:Connect(function(newChar)
            character = newChar
            humanoid = character:WaitForChild("Humanoid")
            rootPart = character:WaitForChild("HumanoidRootPart")
        end)
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if flying then
                fly()
            end
        end)
        
        print("Flight script loaded! Use the UI to control flight.")
    end
    
    return {
        Init = init
    }
end)()

FlightScript.Init()
