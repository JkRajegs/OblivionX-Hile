local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")

local settings = {
    ESP = false,
    ESP_DISTANCE = 300,
    ESP_HEALTHBAR = false,
    AIMBOT = false,
    AIM_SMOOTH = 5,
    AIM_FOV = 100,
    AIM_TEAM_CHECK = true,
    FLY = false,
    FLY_SPEED = 50,
    FLY_BIND = "G",
    NOCLIP = false,
    NOCLIP_BIND = "H",
    GODMODE = false,
    GODMODE_BIND = "J"
}

local theme = {
    Primary = Color3.fromRGB(45, 45, 45),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(80, 80, 80),
    AccentHover = Color3.fromRGB(100, 100, 100),
    Text = Color3.fromRGB(220, 220, 220),
    Border = Color3.fromRGB(60, 60, 60),
    Success = Color3.fromRGB(100, 200, 100),
    Error = Color3.fromRGB(200, 100, 100)
}

local function getTeamColor(player)
    if not player or not LP then return Color3.fromRGB(255, 255, 0) end
    if LP.Team and player.Team then
        if player.Team == LP.Team then
            return Color3.fromRGB(0, 100, 255)
        else
            return Color3.fromRGB(255, 50, 50)
        end
    end
    return Color3.fromRGB(255, 255, 0)
end

local function getHumanoid(character)
    return character:FindFirstChildOfClass("Humanoid") or character:FindFirstChild("Humanoid")
end

local function getRootPart(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end

local gui = Instance.new("ScreenGui")
if syn and syn.protect_gui then
    syn.protect_gui(gui)
end
gui.Name = "OblivionX"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local mainContainer = Instance.new("Frame", gui)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.Size = UDim2.new(0, 400, 0, 700)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.BackgroundColor3 = theme.Primary
mainContainer.BackgroundTransparency = 0
mainContainer.Visible = false
mainContainer.Name = "MainContainer"
mainContainer.ZIndex = 10

local mainCorner = Instance.new("UICorner", mainContainer)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", mainContainer)
mainStroke.Color = theme.Border
mainStroke.Thickness = 2

local titleBar = Instance.new("Frame", mainContainer)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = theme.Secondary
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0, 250, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "OblivionX Cheat"
title.TextColor3 = theme.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local subtitle = Instance.new("TextLabel", titleBar)
subtitle.Size = UDim2.new(0, 250, 0, 18)
subtitle.Position = UDim2.new(0, 15, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Simple Cheat - @MytHirax"
subtitle.TextColor3 = theme.Accent
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextTransparency = 0.4
subtitle.ZIndex = 12

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
closeBtn.BackgroundColor3 = theme.Error
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.ZIndex = 12

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    TS:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 120, 120)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TS:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Error}):Play()
end)

local content = Instance.new("ScrollingFrame", mainContainer)
content.Size = UDim2.new(1, -30, 1, -65)
content.Position = UDim2.new(0, 15, 0, 60)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = theme.Accent
content.ZIndex = 11
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0, 8)

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.AIM_FOV * 2, 0, settings.AIM_FOV * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.ZIndex = 999
fovCircle.Parent = gui

local circleCorner = Instance.new("UICorner", fovCircle)
circleCorner.CornerRadius = UDim.new(1, 0)

local circleStroke = Instance.new("UIStroke", fovCircle)
circleStroke.Color = theme.Error
circleStroke.Thickness = 2
circleStroke.Transparency = 0.5

local menuVisible = false
local function toggleMenu(state)
    if state == nil then state = not menuVisible end
    menuVisible = state
    
    if state then
        mainContainer.Visible = true
        mainContainer.Size = UDim2.new(0, 0, 0, 0)
        
        TS:Create(mainContainer, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 400, 0, 700)
        }):Play()
    else
        TS:Create(mainContainer, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        task.wait(0.25)
        if not menuVisible then
            mainContainer.Visible = false
        end
    end
end

closeBtn.MouseButton1Click:Connect(function()
    toggleMenu(false)
end)

local function createToggle(name, description, defaultValue, func)
    local toggleFrame = Instance.new("Frame", content)
    toggleFrame.Size = UDim2.new(1, 0, 0, description and 60 or 45)
    toggleFrame.BackgroundColor3 = theme.Secondary
    toggleFrame.ZIndex = 12
    
    local corner = Instance.new("UICorner", toggleFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", toggleFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local toggleName = Instance.new("TextLabel", toggleFrame)
    toggleName.Size = UDim2.new(0.65, 0, description and 0.45 or 1, 0)
    toggleName.Position = UDim2.new(0, 12, 0, 4)
    toggleName.BackgroundTransparency = 1
    toggleName.Text = name
    toggleName.TextColor3 = theme.Text
    toggleName.Font = Enum.Font.GothamBold
    toggleName.TextSize = 14
    toggleName.TextXAlignment = Enum.TextXAlignment.Left
    toggleName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", toggleFrame)
        desc.Size = UDim2.new(0.65, 0, 0.5, -5)
        desc.Position = UDim2.new(0, 12, 0.5, 0)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.Text
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextTransparency = 0.5
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 75, 0, 32)
    toggleBtn.Position = UDim2.new(1, -85, 0.5, -16)
    toggleBtn.BackgroundColor3 = defaultValue and theme.Success or theme.Error
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 13
    toggleBtn.ZIndex = 13
    
    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local state = defaultValue
    
    local function updateToggle()
        local targetColor = state and theme.Success or theme.Error
        toggleBtn.BackgroundColor3 = targetColor
        toggleBtn.Text = state and "ON" or "OFF"
        
        toggleBtn.MouseEnter:Connect(function()
            TS:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = state and Color3.fromRGB(120, 220, 120) or Color3.fromRGB(220, 120, 120)
            }):Play()
        end)
        
        toggleBtn.MouseLeave:Connect(function()
            TS:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = targetColor
            }):Play()
        end)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        func(state)
        updateToggle()
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TS:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(120, 220, 120) or Color3.fromRGB(220, 120, 120)
        }):Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        local targetColor = state and theme.Success or theme.Error
        TS:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = targetColor
        }):Play()
    end)
    
    updateToggle()
    
    return toggleFrame
end

local function createSlider(name, description, minVal, maxVal, defaultValue, func)
    local sliderFrame = Instance.new("Frame", content)
    sliderFrame.Size = UDim2.new(1, 0, 0, description and 75 or 60)
    sliderFrame.BackgroundColor3 = theme.Secondary
    sliderFrame.ZIndex = 12
    
    local corner = Instance.new("UICorner", sliderFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", sliderFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local sliderName = Instance.new("TextLabel", sliderFrame)
    sliderName.Size = UDim2.new(0.7, 0, 0, 22)
    sliderName.Position = UDim2.new(0, 12, 0, 6)
    sliderName.BackgroundTransparency = 1
    sliderName.Text = name
    sliderName.TextColor3 = theme.Text
    sliderName.Font = Enum.Font.GothamBold
    sliderName.TextSize = 13
    sliderName.TextXAlignment = Enum.TextXAlignment.Left
    sliderName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", sliderFrame)
        desc.Size = UDim2.new(0.7, 0, 0, 18)
        desc.Position = UDim2.new(0, 12, 0, 26)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.Text
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextTransparency = 0.5
        desc.ZIndex = 13
    end
    
    local valueDisplay = Instance.new("TextLabel", sliderFrame)
    valueDisplay.Size = UDim2.new(0, 70, 0, 28)
    valueDisplay.Position = UDim2.new(1, -80, 0, 4)
    valueDisplay.BackgroundColor3 = theme.Accent
    valueDisplay.Text = tostring(defaultValue)
    valueDisplay.TextColor3 = theme.Text
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.TextSize = 14
    valueDisplay.ZIndex = 13
    
    local valueCorner = Instance.new("UICorner", valueDisplay)
    valueCorner.CornerRadius = UDim.new(0, 6)
    
    local sliderTrack = Instance.new("Frame", sliderFrame)
    sliderTrack.Size = UDim2.new(1, -24, 0, 6)
    sliderTrack.Position = UDim2.new(0, 12, 1, description and -22 or -18)
    sliderTrack.BackgroundColor3 = theme.Primary
    sliderTrack.ZIndex = 13
    
    local trackCorner = Instance.new("UICorner", sliderTrack)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderTrack)
    sliderFill.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.ZIndex = 14
    
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderBtn = Instance.new("Frame", sliderTrack)
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new((defaultValue - minVal) / (maxVal - minVal), -8, 0.5, -8)
    sliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderBtn.ZIndex = 15
    
    local btnCorner = Instance.new("UICorner", sliderBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local btnStroke = Instance.new("UIStroke", sliderBtn)
    btnStroke.Color = theme.Accent
    btnStroke.Thickness = 2
    
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, minVal, maxVal)
        valueDisplay.Text = tostring(value)
        
        TS:Create(sliderFill, TweenInfo.new(0.1), {
            Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
        }):Play()
        
        TS:Create(sliderBtn, TweenInfo.new(0.1), {
            Position = UDim2.new((value - minVal) / (maxVal - minVal), -8, 0.5, -8)
        }):Play()
        
        func(value)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            TS:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TS:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play()
        end
    end)
    
    RS.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UIS:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            
            local relativeX = math.clamp(mousePos.X - trackPos.X, 0, trackSize.X)
            local percent = relativeX / trackSize.X
            
            local value = math.floor(minVal + percent * (maxVal - minVal))
            updateSlider(value)
        end
    end)
    
    return sliderFrame
end

local function createKeybind(name, description, defaultValue, func)
    local keybindFrame = Instance.new("Frame", content)
    keybindFrame.Size = UDim2.new(1, 0, 0, description and 60 or 45)
    keybindFrame.BackgroundColor3 = theme.Secondary
    keybindFrame.ZIndex = 12
    
    local corner = Instance.new("UICorner", keybindFrame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", keybindFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local keybindName = Instance.new("TextLabel", keybindFrame)
    keybindName.Size = UDim2.new(0.65, 0, description and 0.45 or 1, 0)
    keybindName.Position = UDim2.new(0, 12, 0, 4)
    keybindName.BackgroundTransparency = 1
    keybindName.Text = name
    keybindName.TextColor3 = theme.Text
    keybindName.Font = Enum.Font.GothamBold
    keybindName.TextSize = 14
    keybindName.TextXAlignment = Enum.TextXAlignment.Left
    keybindName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", keybindFrame)
        desc.Size = UDim2.new(0.65, 0, 0.5, -5)
        desc.Position = UDim2.new(0, 12, 0.5, 0)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.Text
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextTransparency = 0.5
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local keybindBtn = Instance.new("TextButton", keybindFrame)
    keybindBtn.Size = UDim2.new(0, 75, 0, 32)
    keybindBtn.Position = UDim2.new(1, -85, 0.5, -16)
    keybindBtn.BackgroundColor3 = theme.Accent
    keybindBtn.Text = defaultValue
    keybindBtn.TextColor3 = theme.Text
    keybindBtn.Font = Enum.Font.GothamBold
    keybindBtn.TextSize = 13
    keybindBtn.ZIndex = 13
    
    local btnCorner = Instance.new("UICorner", keybindBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local listening = false
    
    local function updateKeybind(key)
        keybindBtn.Text = key
        func(key)
    end
    
    keybindBtn.MouseButton1Click:Connect(function()
        if not listening then
            listening = true
            keybindBtn.Text = "..."
            keybindBtn.BackgroundColor3 = theme.Success
            
            local connection
            connection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    connection:Disconnect()
                    
                    local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    updateKeybind(keyName)
                    keybindBtn.BackgroundColor3 = theme.Accent
                end
            end)
        end
    end)
    
    keybindBtn.MouseEnter:Connect(function()
        TS:Create(keybindBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.AccentHover
        }):Play()
    end)
    
    keybindBtn.MouseLeave:Connect(function()
        TS:Create(keybindBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.Accent
        }):Play()
    end)
    
    return keybindFrame
end

createToggle("ESP", "Oyuncuları duvarların arkasından görme.", settings.ESP, function(v)
    settings.ESP = v
    updateESP()
end)

createToggle("ESP HEALTHBAR", "Sağlık çubuklarını göster.", settings.ESP_HEALTHBAR, function(v)
    settings.ESP_HEALTHBAR = v
    updateESP()
end)

createToggle("AIMBOT", "Oyunculara otomatik nişan alma.", settings.AIMBOT, function(v)
    settings.AIMBOT = v
    fovCircle.Visible = v
end)

createToggle("TEAM CHECK", "Takım arkadaşlarınızı hedef almayın.", settings.AIM_TEAM_CHECK, function(v)
    settings.AIM_TEAM_CHECK = v
end)

createKeybind("FLY BIND", "Uçmayı açıp kapatmak için tuş.", settings.FLY_BIND, function(v)
    settings.FLY_BIND = v
end)

createKeybind("NOCLIP BIND", "Noclip özelliğini açıp kapatmak için tuş.", settings.NOCLIP_BIND, function(v)
    settings.NOCLIP_BIND = v
end)

createKeybind("GODMODE BIND", "Ölümsüzlük modunu açıp kapatmak için tuş.", settings.GODMODE_BIND, function(v)
    settings.GODMODE_BIND = v
end)

createSlider("Aim Smoothness", "Daha düşük = Daha hızlı", 1, 20, settings.AIM_SMOOTH, function(v)
    settings.AIM_SMOOTH = v
end)

createSlider("Aim FOV", "Görüş alanı yarıçapı.", 1, 1000, settings.AIM_FOV, function(v)
    settings.AIM_FOV = v
    fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)

createSlider("Fly Speed", "Hareket hızı.", 10, 200, settings.FLY_SPEED, function(v)
    settings.FLY_SPEED = v
end)

createSlider("ESP Distance", "Gösterilecek maksimum mesafe.", 50, 2000, settings.ESP_DISTANCE, function(v)
    settings.ESP_DISTANCE = v
end)

local espCache = {}
local healthbarCache = {}

function updateESP()
    for player, esp in pairs(espCache) do
        if esp then esp:Destroy() end
        if healthbarCache[player] then
            healthbarCache[player]:Destroy()
            healthbarCache[player] = nil
        end
    end
    espCache = {}
    
    if not settings.ESP then return end
    
    for _, player in pairs(P:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = getRootPart(player.Character)
            local humanoid = getHumanoid(player.Character)
            
            if root and humanoid and humanoid.Health > 0 then
                if LP.Character then
                    local myRoot = getRootPart(LP.Character)
                    if myRoot then
                        local distance = (myRoot.Position - root.Position).Magnitude
                        if distance > settings.ESP_DISTANCE then
                            continue
                        end
                    end
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Parent = gui
                highlight.Adornee = player.Character
                highlight.FillColor = getTeamColor(player)
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0.5
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                
                espCache[player] = highlight
                
                if settings.ESP_HEALTHBAR then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Parent = gui
                    billboard.Adornee = root
                    billboard.Size = UDim2.new(0, 120, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 4, 0)
                    billboard.AlwaysOnTop = true
                    billboard.MaxDistance = settings.ESP_DISTANCE
                    
                    local background = Instance.new("Frame", billboard)
                    background.Size = UDim2.new(1, 0, 1, 0)
                    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    background.BackgroundTransparency = 0.5
                    background.BorderSizePixel = 0
                    
                    local corner = Instance.new("UICorner", background)
                    corner.CornerRadius = UDim.new(0, 4)
                    
                    local healthBarBg = Instance.new("Frame", background)
                    healthBarBg.Size = UDim2.new(0.9, 0, 0, 20)
                    healthBarBg.Position = UDim2.new(0.05, 0, 0.1, 0)
                    healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    healthBarBg.BorderSizePixel = 0
                    
                    local barCorner = Instance.new("UICorner", healthBarBg)
                    barCorner.CornerRadius = UDim.new(0, 4)
                    
                    local healthBar = Instance.new("Frame", healthBarBg)
                    healthBar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    healthBar.BorderSizePixel = 0
                    
                    local healthCorner = Instance.new("UICorner", healthBar)
                    healthCorner.CornerRadius = UDim.new(0, 4)
                    
                    local nameText = Instance.new("TextLabel", background)
                    nameText.Size = UDim2.new(1, 0, 0, 15)
                    nameText.Position = UDim2.new(0, 0, 0.6, 0)
                    nameText.BackgroundTransparency = 1
                    nameText.Text = player.Name
                    nameText.TextColor3 = Color3.new(1, 1, 1)
                    nameText.Font = Enum.Font.GothamBold
                    nameText.TextSize = 12
                    nameText.TextStrokeColor3 = Color3.new(0, 0, 0)
                    nameText.TextStrokeTransparency = 0.5
                    
                    local healthText = Instance.new("TextLabel", background)
                    healthText.Size = UDim2.new(1, 0, 0, 12)
                    healthText.Position = UDim2.new(0, 0, 0.8, 0)
                    healthText.BackgroundTransparency = 1
                    healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    healthText.TextColor3 = Color3.new(1, 1, 1)
                    healthText.Font = Enum.Font.Gotham
                    healthText.TextSize = 10
                    healthText.TextStrokeColor3 = Color3.new(0, 0, 0)
                    healthText.TextStrokeTransparency = 0.5
                    
                    healthbarCache[player] = billboard
                    
                    humanoid.HealthChanged:Connect(function()
                        if healthBar and healthBar.Parent then
                            local healthPercent = humanoid.Health / humanoid.MaxHealth
                            healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                            
                            if healthPercent > 0.5 then
                                healthBar.BackgroundColor3 = Color3.fromRGB(
                                    255 * (1 - healthPercent) * 2,
                                    255,
                                    0
                                )
                            else
                                healthBar.BackgroundColor3 = Color3.fromRGB(
                                    255,
                                    255 * healthPercent * 2,
                                    0
                                )
                            end
                            
                            healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        end
                    end)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if settings.ESP then
            updateESP()
        end
        wait(1)
    end
end)

local currentTarget = nil

local function getClosestPlayer()
    if not settings.AIMBOT then return nil end
    
    local camera = workspace.CurrentCamera
    local closestPlayer = nil
    local closestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, player in pairs(P:GetPlayers()) do
        if player ~= LP and player.Character then
            if settings.AIM_TEAM_CHECK and LP.Team and player.Team then
                if player.Team == LP.Team then
                    continue
                end
            end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local humanoid = getHumanoid(player.Character)
                if humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local headPos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (screenCenter - headPos).Magnitude
                        
                        if distance < closestDistance and distance <= settings.AIM_FOV then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local flying = false
local flyBV, flyBG

local originalProperties = {}

local function restoreOriginalProperties()
    for part, properties in pairs(originalProperties) do
        if part and part.Parent then
            if properties.CanCollide ~= nil then
                part.CanCollide = properties.CanCollide
            end
        end
    end
    originalProperties = {}
end

local function startFly()
    if not LP.Character then return end
    local root = getRootPart(LP.Character)
    if not root then return end
    
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.Parent = root
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    
    flyBG = Instance.new("BodyGyro")
    flyBG.Parent = root
    flyBG.MaxTorque = Vector3.new(10000, 10000, 10000)
    flyBG.P = 1000
    
    flying = true
    
    RS.Heartbeat:Connect(function()
        if not flying or not settings.FLY or not LP.Character then
            flying = false
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        flyBG.CFrame = camera.CFrame
        
        local velocity = Vector3.new(0, 0, 0)
        local speed = settings.FLY_SPEED
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            velocity = velocity - Vector3.new(0, 1, 0)
        end
        
        if velocity.Magnitude > 0 then
            velocity = velocity.Unit * speed
        end
        
        flyBV.Velocity = velocity
    end)
end

local function stopFly()
    flying = false
    if flyBV then 
        flyBV:Destroy()
        flyBV = nil
    end
    if flyBG then 
        flyBG:Destroy()
        flyBG = nil
    end
end

local godModeConnection = nil

local function startGodMode()
    if not LP.Character then return end
    local humanoid = getHumanoid(LP.Character)
    if not humanoid then return end
    
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    
    local maxHealth = humanoid.MaxHealth
    godModeConnection = humanoid.HealthChanged:Connect(function()
        if settings.GODMODE and humanoid then
            humanoid.Health = maxHealth
        end
    end)
end

local function stopGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
end

RS.Stepped:Connect(function()
    if settings.NOCLIP and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if not originalProperties[part] then
                    originalProperties[part] = {CanCollide = part.CanCollide}
                end
                part.CanCollide = false
            end
        end
    elseif not settings.NOCLIP and next(originalProperties) ~= nil then
        restoreOriginalProperties()
    end
    
    if settings.GODMODE and LP.Character then
        local humanoid = getHumanoid(LP.Character)
        if humanoid and not godModeConnection then
            startGodMode()
        end
    elseif not settings.GODMODE and godModeConnection then
        stopGodMode()
    end
end)

RS.RenderStepped:Connect(function()
    if settings.AIMBOT then
        local target = getClosestPlayer()
        currentTarget = target
        
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local camera = workspace.CurrentCamera
                
                local offset = Vector3.new(0, 0, 0)
                local smoothness = settings.AIM_SMOOTH
                
                local targetPos = head.Position + offset
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(camera.CFrame.Position, targetPos)
                camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothness)
            end
        end
    end
    
    if settings.FLY and not flying then
        startFly()
    elseif not settings.FLY and flying then
        stopFly()
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMenu()
    end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        if keyName == settings.FLY_BIND then
            settings.FLY = not settings.FLY
        elseif keyName == settings.NOCLIP_BIND then
            settings.NOCLIP = not settings.NOCLIP
        elseif keyName == settings.GODMODE_BIND then
            settings.GODMODE = not settings.GODMODE
        end
    end
end)

LP.CharacterAdded:Connect(function(character)
    if settings.GODMODE then
        wait(1)
        startGodMode()
    end
end)

print("OblivionX yüklendi!")
print("Menüyü açmak için F1 tuşuna basın.")
print("Uçmak için " .. settings.FLY_BIND .. " tuşuna basın.")
print("Noclip için " .. settings.NOCLIP_BIND .. " tuşuna basın.")
print("Godmode için " .. settings.GODMODE_BIND .. " tuşuna basın.")
