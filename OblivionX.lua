local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = P.LocalPlayer
local WS = game:GetService("Workspace")
local SG = game:GetService("StarterGui")

local settings = {
    ESP = false,
    ESP_DISTANCE = 300,
    ESP_HEALTHBAR = false,
    ESP_BOX = false,
    ESP_WEAPON = false,
    ESP_SKELETON = false,
    ESP_DISTANCE_SHOW = false,
    AIMBOT = false,
    AIM_SMOOTH = 5,
    AIM_FOV = 100,
    AIM_TEAM_CHECK = true,
    SILENT_AIM = false,
    TRIGGER_BOT = false,
    TRIGGER_DELAY = 0.1,
    FLY = false,
    FLY_SPEED = 50,
    FLY_BIND = "G",
    SPEED_HACK = false,
    SPEED_AMOUNT = 2,
    NOCLIP = false,
    NOCLIP_BIND = "H",
    GODMODE = false,
    GODMODE_BIND = "J",
    WALLBANG = false,
    SELECTED_PLAYER = nil
}

local theme = {
    Background = Color3.fromRGB(18, 18, 20),
    Surface = Color3.fromRGB(26, 26, 28),
    SurfaceLight = Color3.fromRGB(33, 33, 36),
    Primary = Color3.fromRGB(42, 42, 45),
    Accent = Color3.fromRGB(155, 155, 160),
    AccentHover = Color3.fromRGB(175, 175, 180),
    Text = Color3.fromRGB(235, 235, 240),
    TextDim = Color3.fromRGB(145, 145, 150),
    Border = Color3.fromRGB(38, 38, 40),
    Success = Color3.fromRGB(110, 175, 130),
    Error = Color3.fromRGB(195, 115, 115),
    Highlight = Color3.fromRGB(195, 195, 200)
}

-- Bildirim Sistemi
local function sendNotification(title, text, duration)
    pcall(function()
        SG:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
            Icon = "rbxassetid://7733993369"
        })
    end)
end

-- Başlangıç bildirimi
sendNotification("OBLIVION X v2.0", "Ultimate Edition loaded! Press F1 to open menu.", 6)

local function getTeamColor(player)
    if not player or not LP then return Color3.fromRGB(255, 255, 0) end
    if LP.Team and player.Team then
        if player.Team == LP.Team then
            return Color3.fromRGB(0, 120, 255)
        else
            return Color3.fromRGB(255, 60, 60)
        end
    end
    return Color3.fromRGB(255, 200, 0)
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
elseif gethui then
    gui.Parent = gethui()
else
    gui.Parent = game:GetService("CoreGui")
end
gui.Name = "OblivionX_" .. tostring(math.random(1000, 9999))
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

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
circleStroke.Color = theme.Highlight
circleStroke.Thickness = 2
circleStroke.Transparency = 0.3

local shadowFrame = Instance.new("Frame", gui)
shadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
shadowFrame.Size = UDim2.new(0, 560, 0, 430)
shadowFrame.Position = UDim2.new(0.5, 3, 0.5, 3)
shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.65
shadowFrame.Visible = false
shadowFrame.Name = "Shadow"
shadowFrame.ZIndex = 9
shadowFrame.BorderSizePixel = 0

local shadowCorner = Instance.new("UICorner", shadowFrame)
shadowCorner.CornerRadius = UDim.new(0, 12)

local mainContainer = Instance.new("Frame", gui)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.Size = UDim2.new(0, 560, 0, 430)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.BackgroundColor3 = theme.Background
mainContainer.BackgroundTransparency = 0
mainContainer.Visible = false
mainContainer.Name = "MainContainer"
mainContainer.ZIndex = 10
mainContainer.BorderSizePixel = 0

local mainCorner = Instance.new("UICorner", mainContainer)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainContainer)
mainStroke.Color = theme.Border
mainStroke.Thickness = 1
mainStroke.Transparency = 0

local titleBar = Instance.new("Frame", mainContainer)
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = theme.Surface
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 11

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local titleBarBottom = Instance.new("Frame", titleBar)
titleBarBottom.Size = UDim2.new(1, 0, 0, 12)
titleBarBottom.Position = UDim2.new(0, 0, 1, -12)
titleBarBottom.BackgroundColor3 = theme.Surface
titleBarBottom.BorderSizePixel = 0
titleBarBottom.ZIndex = 11

local titleDivider = Instance.new("Frame", titleBar)
titleDivider.Size = UDim2.new(1, 0, 0, 1)
titleDivider.Position = UDim2.new(0, 0, 1, -1)
titleDivider.BackgroundColor3 = theme.Border
titleDivider.BorderSizePixel = 0
titleDivider.ZIndex = 12

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(0, 220, 0, 24)
title.Position = UDim2.new(0, 20, 0, 8)
title.BackgroundTransparency = 1
title.Text = "OBLIVION X"
title.TextColor3 = theme.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local subtitle = Instance.new("TextLabel", titleBar)
subtitle.Size = UDim2.new(0, 220, 0, 15)
subtitle.Position = UDim2.new(0, 20, 0, 32)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Simple Cheat Menu"
subtitle.TextColor3 = theme.TextDim
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 12

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -44, 0.5, -17)
closeBtn.BackgroundColor3 = theme.Primary
closeBtn.Text = "×"
closeBtn.TextColor3 = theme.Text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.ZIndex = 12
closeBtn.AutoButtonColor = false
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseEnter:Connect(function()
    TS:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Error}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TS:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Primary}):Play()
end)

local tabsContainer = Instance.new("Frame", mainContainer)
tabsContainer.Size = UDim2.new(0, 145, 1, -72)
tabsContainer.Position = UDim2.new(0, 16, 0, 62)
tabsContainer.BackgroundTransparency = 1
tabsContainer.ZIndex = 11
tabsContainer.BorderSizePixel = 0

local tabsLayout = Instance.new("UIListLayout", tabsContainer)
tabsLayout.Padding = UDim.new(0, 7)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local contentContainer = Instance.new("Frame", mainContainer)
contentContainer.Size = UDim2.new(1, -182, 1, -72)
contentContainer.Position = UDim2.new(0, 171, 0, 62)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 11
contentContainer.BorderSizePixel = 0

local currentTab = nil
local tabs = {}

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton", tabsContainer)
    tabBtn.Size = UDim2.new(1, 0, 0, 40)
    tabBtn.BackgroundColor3 = theme.Surface
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.ZIndex = 12
    tabBtn.LayoutOrder = order
    tabBtn.BorderSizePixel = 0
    
    local tabCorner = Instance.new("UICorner", tabBtn)
    tabCorner.CornerRadius = UDim.new(0, 7)
    
    local tabStroke = Instance.new("UIStroke", tabBtn)
    tabStroke.Color = theme.Border
    tabStroke.Thickness = 1
    tabStroke.Transparency = 1
    
    local tabLabel = Instance.new("TextLabel", tabBtn)
    tabLabel.Size = UDim2.new(1, -24, 1, 0)
    tabLabel.Position = UDim2.new(0, 16, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = string.upper(name)
    tabLabel.TextColor3 = theme.TextDim
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 11
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.ZIndex = 13
    
    local indicator = Instance.new("Frame", tabBtn)
    indicator.Size = UDim2.new(0, 3, 1, -14)
    indicator.Position = UDim2.new(0, 5, 0, 7)
    indicator.BackgroundColor3 = theme.Highlight
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 13
    indicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner", indicator)
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local content = Instance.new("ScrollingFrame", contentContainer)
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = theme.Accent
    content.ZIndex = 11
    content.Visible = false
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.BorderSizePixel = 0
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local contentLayout = Instance.new("UIListLayout", content)
    contentLayout.Padding = UDim.new(0, 9)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    tabs[name] = {
        button = tabBtn, 
        content = content, 
        label = tabLabel, 
        stroke = tabStroke, 
        indicator = indicator
    }
    
    local function setActive(active)
        if active then
            tabBtn.BackgroundColor3 = theme.SurfaceLight
            tabLabel.TextColor3 = theme.Text
            tabStroke.Transparency = 0
            indicator.Visible = true
        else
            tabBtn.BackgroundColor3 = theme.Surface
            tabLabel.TextColor3 = theme.TextDim
            tabStroke.Transparency = 1
            indicator.Visible = false
        end
    end
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(tabs) do
            tab.content.Visible = false
            if tab.button == tabBtn then
                setActive(true)
            else
                tab.button.BackgroundColor3 = theme.Surface
                tab.label.TextColor3 = theme.TextDim
                tab.stroke.Transparency = 1
                tab.indicator.Visible = false
            end
        end
        content.Visible = true
        currentTab = name
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TS:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Primary}):Play()
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TS:Create(tabBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
        end
    end)
    
    return content
end

local mainTab = createTab("Main", 1)
local visualTab = createTab("Visual", 2)
local combatTab = createTab("Combat", 3)
local movementTab = createTab("Movement", 4)
local settingsTab = createTab("Settings", 5)

local menuVisible = false
local function toggleMenu(state)
    if state == nil then state = not menuVisible end
    menuVisible = state
    
    if state then
        mainContainer.Visible = true
        shadowFrame.Visible = true
        mainContainer.Size = UDim2.new(0, 0, 0, 0)
        shadowFrame.Size = UDim2.new(0, 0, 0, 0)
        
        local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TS:Create(mainContainer, tweenInfo, {Size = UDim2.new(0, 560, 0, 430)}):Play()
        TS:Create(shadowFrame, tweenInfo, {Size = UDim2.new(0, 560, 0, 430)}):Play()
        
        if not currentTab then
            if tabs["Main"] then
                for _, tab in pairs(tabs) do
                    tab.content.Visible = false
                    tab.button.BackgroundColor3 = theme.Surface
                    tab.label.TextColor3 = theme.TextDim
                    tab.stroke.Transparency = 1
                    tab.indicator.Visible = false
                end
                tabs["Main"].button.BackgroundColor3 = theme.SurfaceLight
                tabs["Main"].label.TextColor3 = theme.Text
                tabs["Main"].stroke.Transparency = 0
                tabs["Main"].indicator.Visible = true
                tabs["Main"].content.Visible = true
                currentTab = "Main"
            end
        else
            for _, tab in pairs(tabs) do
                tab.content.Visible = false
                if tab.button == tabs[currentTab].button then
                    tab.button.BackgroundColor3 = theme.SurfaceLight
                    tab.label.TextColor3 = theme.Text
                    tab.stroke.Transparency = 0
                    tab.indicator.Visible = true
                    tab.content.Visible = true
                else
                    tab.button.BackgroundColor3 = theme.Surface
                    tab.label.TextColor3 = theme.TextDim
                    tab.stroke.Transparency = 1
                    tab.indicator.Visible = false
                end
            end
        end
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TS:Create(mainContainer, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TS:Create(shadowFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.wait(0.3)
        if not menuVisible then
            mainContainer.Visible = false
            shadowFrame.Visible = false
        end
    end
end

closeBtn.MouseButton1Click:Connect(function()
    toggleMenu(false)
end)

local function createToggle(parent, name, description, defaultValue, func)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(1, 0, 0, description and 58 or 42)
    toggleFrame.BackgroundColor3 = theme.Surface
    toggleFrame.ZIndex = 12
    toggleFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", toggleFrame)
    corner.CornerRadius = UDim.new(0, 7)
    
    local stroke = Instance.new("UIStroke", toggleFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local toggleName = Instance.new("TextLabel", toggleFrame)
    toggleName.Size = UDim2.new(0.6, 0, description and 0.42 or 1, 0)
    toggleName.Position = UDim2.new(0, 14, 0, 4)
    toggleName.BackgroundTransparency = 1
    toggleName.Text = name
    toggleName.TextColor3 = theme.Text
    toggleName.Font = Enum.Font.GothamBold
    toggleName.TextSize = 13
    toggleName.TextXAlignment = Enum.TextXAlignment.Left
    toggleName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", toggleFrame)
        desc.Size = UDim2.new(0.6, 0, 0.5, -6)
        desc.Position = UDim2.new(0, 14, 0.5, 2)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0, 50, 0, 26)
    toggleBtn.Position = UDim2.new(1, -58, 0.5, -13)
    toggleBtn.BackgroundColor3 = defaultValue and theme.Success or theme.Primary
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 13
    toggleBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local toggleIndicator = Instance.new("Frame", toggleBtn)
    toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    toggleIndicator.Position = defaultValue and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleIndicator.ZIndex = 14
    toggleIndicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner", toggleIndicator)
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    
    local state = defaultValue
    
    local function updateToggle()
        local targetColor = state and theme.Success or theme.Primary
        local targetPos = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        
        TS:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        TS:Create(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        func(state)
        updateToggle()
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TS:Create(toggleBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = state and Color3.fromRGB(130, 195, 150) or theme.SurfaceLight
        }):Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        local targetColor = state and theme.Success or theme.Primary
        TS:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
    end)
    
    updateToggle()
    return toggleFrame
end

local function createSlider(parent, name, description, minVal, maxVal, defaultValue, func)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(1, 0, 0, description and 70 or 54)
    sliderFrame.BackgroundColor3 = theme.Surface
    sliderFrame.ZIndex = 12
    sliderFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", sliderFrame)
    corner.CornerRadius = UDim.new(0, 7)
    
    local stroke = Instance.new("UIStroke", sliderFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local sliderName = Instance.new("TextLabel", sliderFrame)
    sliderName.Size = UDim2.new(0.65, 0, 0, 22)
    sliderName.Position = UDim2.new(0, 14, 0, 7)
    sliderName.BackgroundTransparency = 1
    sliderName.Text = name
    sliderName.TextColor3 = theme.Text
    sliderName.Font = Enum.Font.GothamBold
    sliderName.TextSize = 13
    sliderName.TextXAlignment = Enum.TextXAlignment.Left
    sliderName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", sliderFrame)
        desc.Size = UDim2.new(0.65, 0, 0, 18)
        desc.Position = UDim2.new(0, 14, 0, 26)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.ZIndex = 13
    end
    
    local valueDisplay = Instance.new("TextLabel", sliderFrame)
    valueDisplay.Size = UDim2.new(0, 56, 0, 24)
    valueDisplay.Position = UDim2.new(1, -64, 0, 5)
    valueDisplay.BackgroundColor3 = theme.Primary
    valueDisplay.Text = tostring(defaultValue)
    valueDisplay.TextColor3 = theme.Highlight
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.TextSize = 13
    valueDisplay.ZIndex = 13
    valueDisplay.BorderSizePixel = 0
    
    local valueCorner = Instance.new("UICorner", valueDisplay)
    valueCorner.CornerRadius = UDim.new(0, 6)
    
    local sliderTrack = Instance.new("Frame", sliderFrame)
    sliderTrack.Size = UDim2.new(1, -28, 0, 5)
    sliderTrack.Position = UDim2.new(0, 14, 1, description and -18 or -16)
    sliderTrack.BackgroundColor3 = theme.Primary
    sliderTrack.ZIndex = 13
    sliderTrack.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner", sliderTrack)
    trackCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderTrack)
    sliderFill.Size = UDim2.new((defaultValue - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Highlight
    sliderFill.ZIndex = 14
    sliderFill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderBtn = Instance.new("Frame", sliderTrack)
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new((defaultValue - minVal) / (maxVal - minVal), -7, 0.5, -7)
    sliderBtn.BackgroundColor3 = theme.Highlight
    sliderBtn.ZIndex = 15
    sliderBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", sliderBtn)
    btnCorner.CornerRadius = UDim.new(1, 0)
    
    local btnGlow = Instance.new("Frame", sliderBtn)
    btnGlow.Size = UDim2.new(1, 8, 1, 8)
    btnGlow.Position = UDim2.new(0.5, -11, 0.5, -11)
    btnGlow.BackgroundColor3 = theme.Highlight
    btnGlow.BackgroundTransparency = 0.6
    btnGlow.ZIndex = 14
    btnGlow.BorderSizePixel = 0
    
    local glowCorner = Instance.new("UICorner", btnGlow)
    glowCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, minVal, maxVal)
        valueDisplay.Text = tostring(value)
        
        TS:Create(sliderFill, TweenInfo.new(0.1), {
            Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
        }):Play()
        
        TS:Create(sliderBtn, TweenInfo.new(0.1), {
            Position = UDim2.new((value - minVal) / (maxVal - minVal), -7, 0.5, -7)
        }):Play()
        
        func(value)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            TS:Create(sliderBtn, TweenInfo.new(0.12), {Size = UDim2.new(0, 18, 0, 18)}):Play()
            TS:Create(btnGlow, TweenInfo.new(0.12), {Size = UDim2.new(1, 12, 1, 12)}):Play()
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TS:Create(sliderBtn, TweenInfo.new(0.12), {Size = UDim2.new(0, 14, 0, 14)}):Play()
            TS:Create(btnGlow, TweenInfo.new(0.12), {Size = UDim2.new(1, 8, 1, 8)}):Play()
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

local function createKeybind(parent, name, description, defaultValue, func)
    local keybindFrame = Instance.new("Frame", parent)
    keybindFrame.Size = UDim2.new(1, 0, 0, description and 58 or 42)
    keybindFrame.BackgroundColor3 = theme.Surface
    keybindFrame.ZIndex = 12
    keybindFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", keybindFrame)
    corner.CornerRadius = UDim.new(0, 7)
    
    local stroke = Instance.new("UIStroke", keybindFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local keybindName = Instance.new("TextLabel", keybindFrame)
    keybindName.Size = UDim2.new(0.6, 0, description and 0.42 or 1, 0)
    keybindName.Position = UDim2.new(0, 14, 0, 4)
    keybindName.BackgroundTransparency = 1
    keybindName.Text = name
    keybindName.TextColor3 = theme.Text
    keybindName.Font = Enum.Font.GothamBold
    keybindName.TextSize = 13
    keybindName.TextXAlignment = Enum.TextXAlignment.Left
    keybindName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", keybindFrame)
        desc.Size = UDim2.new(0.6, 0, 0.5, -6)
        desc.Position = UDim2.new(0, 14, 0.5, 2)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local keybindBtn = Instance.new("TextButton", keybindFrame)
    keybindBtn.Size = UDim2.new(0, 58, 0, 28)
    keybindBtn.Position = UDim2.new(1, -66, 0.5, -14)
    keybindBtn.BackgroundColor3 = theme.Primary
    keybindBtn.Text = defaultValue
    keybindBtn.TextColor3 = theme.Text
    keybindBtn.Font = Enum.Font.GothamBold
    keybindBtn.TextSize = 12
    keybindBtn.AutoButtonColor = false
    keybindBtn.ZIndex = 13
    keybindBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", keybindBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", keybindBtn)
    btnStroke.Color = theme.Border
    btnStroke.Thickness = 1
    
    local listening = false
    
    local function updateKeybind(key)
        keybindBtn.Text = key
        func(key)
    end
    
    keybindBtn.MouseButton1Click:Connect(function()
        if not listening then
            listening = true
            keybindBtn.Text = "..."
            keybindBtn.BackgroundColor3 = theme.Highlight
            keybindBtn.TextColor3 = theme.Background
            btnStroke.Color = theme.Highlight
            
            local connection
            connection = UIS.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    connection:Disconnect()
                    
                    local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                    updateKeybind(keyName)
                    keybindBtn.BackgroundColor3 = theme.Primary
                    keybindBtn.TextColor3 = theme.Text
                    btnStroke.Color = theme.Border
                end
            end)
        end
    end)
    
    keybindBtn.MouseEnter:Connect(function()
        if not listening then
            TS:Create(keybindBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceLight}):Play()
            TS:Create(btnStroke, TweenInfo.new(0.15), {Color = theme.Accent}):Play()
        end
    end)
    
    keybindBtn.MouseLeave:Connect(function()
        if not listening then
            TS:Create(keybindBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Primary}):Play()
            TS:Create(btnStroke, TweenInfo.new(0.15), {Color = theme.Border}):Play()
        end
    end)
    
    return keybindFrame
end

local function createButton(parent, name, description, func)
    local buttonFrame = Instance.new("Frame", parent)
    buttonFrame.Size = UDim2.new(1, 0, 0, description and 58 or 42)
    buttonFrame.BackgroundColor3 = theme.Surface
    buttonFrame.ZIndex = 12
    buttonFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", buttonFrame)
    corner.CornerRadius = UDim.new(0, 7)
    
    local stroke = Instance.new("UIStroke", buttonFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local buttonName = Instance.new("TextLabel", buttonFrame)
    buttonName.Size = UDim2.new(0.6, 0, description and 0.42 or 1, 0)
    buttonName.Position = UDim2.new(0, 14, 0, 4)
    buttonName.BackgroundTransparency = 1
    buttonName.Text = name
    buttonName.TextColor3 = theme.Text
    buttonName.Font = Enum.Font.GothamBold
    buttonName.TextSize = 13
    buttonName.TextXAlignment = Enum.TextXAlignment.Left
    buttonName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", buttonFrame)
        desc.Size = UDim2.new(0.6, 0, 0.5, -6)
        desc.Position = UDim2.new(0, 14, 0.5, 2)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local actionBtn = Instance.new("TextButton", buttonFrame)
    actionBtn.Size = UDim2.new(0, 80, 0, 28)
    actionBtn.Position = UDim2.new(1, -88, 0.5, -14)
    actionBtn.BackgroundColor3 = theme.Highlight
    actionBtn.Text = "Execute"
    actionBtn.TextColor3 = theme.Background
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.TextSize = 11
    actionBtn.AutoButtonColor = false
    actionBtn.ZIndex = 13
    actionBtn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", actionBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    actionBtn.MouseButton1Click:Connect(function()
        func()
        TS:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 76, 0, 26)}):Play()
        task.wait(0.1)
        TS:Create(actionBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 80, 0, 28)}):Play()
    end)
    
    actionBtn.MouseEnter:Connect(function()
        TS:Create(actionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.AccentHover}):Play()
    end)
    
    actionBtn.MouseLeave:Connect(function()
        TS:Create(actionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Highlight}):Play()
    end)
    
    return buttonFrame
end

local function createDropdown(parent, name, description, options, defaultIndex, func)
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(1, 0, 0, description and 58 or 42)
    dropdownFrame.BackgroundColor3 = theme.Surface
    dropdownFrame.ZIndex = 12
    dropdownFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", dropdownFrame)
    corner.CornerRadius = UDim.new(0, 7)
    
    local stroke = Instance.new("UIStroke", dropdownFrame)
    stroke.Color = theme.Border
    stroke.Thickness = 1
    
    local dropdownName = Instance.new("TextLabel", dropdownFrame)
    dropdownName.Size = UDim2.new(0.5, 0, description and 0.42 or 1, 0)
    dropdownName.Position = UDim2.new(0, 14, 0, 4)
    dropdownName.BackgroundTransparency = 1
    dropdownName.Text = name
    dropdownName.TextColor3 = theme.Text
    dropdownName.Font = Enum.Font.GothamBold
    dropdownName.TextSize = 13
    dropdownName.TextXAlignment = Enum.TextXAlignment.Left
    dropdownName.ZIndex = 13
    
    if description then
        local desc = Instance.new("TextLabel", dropdownFrame)
        desc.Size = UDim2.new(0.5, 0, 0.5, -6)
        desc.Position = UDim2.new(0, 14, 0.5, 2)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = theme.TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.ZIndex = 13
    end
    
    local dropdownBtn = Instance.new("TextButton", dropdownFrame)
    dropdownBtn.Size = UDim2.new(0, 140, 0, 28)
    dropdownBtn.Position = UDim2.new(1, -148, 0.5, -14)
    dropdownBtn.BackgroundColor3 = theme.Primary
    dropdownBtn.Text = options[defaultIndex or 1] or "Select"
    dropdownBtn.TextColor3 = theme.Text
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 11
    dropdownBtn.AutoButtonColor = false
    dropdownBtn.ZIndex = 13
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    dropdownBtn.TextTruncate = Enum.TextTruncate.AtEnd
    
    local btnCorner = Instance.new("UICorner", dropdownBtn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    local btnPadding = Instance.new("UIPadding", dropdownBtn)
    btnPadding.PaddingLeft = UDim.new(0, 10)
    btnPadding.PaddingRight = UDim.new(0, 24)
    
    local arrow = Instance.new("TextLabel", dropdownBtn)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = theme.TextDim
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 10
    arrow.ZIndex = 14
    
    local dropdownList = Instance.new("Frame", gui)
    dropdownList.Size = UDim2.new(0, 140, 0, 0)
    dropdownList.BackgroundColor3 = theme.Surface
    dropdownList.Visible = false
    dropdownList.ZIndex = 100
    dropdownList.BorderSizePixel = 0
    
    local listCorner = Instance.new("UICorner", dropdownList)
    listCorner.CornerRadius = UDim.new(0, 6)
    
    local listStroke = Instance.new("UIStroke", dropdownList)
    listStroke.Color = theme.Border
    listStroke.Thickness = 1
    
    local listLayout = Instance.new("UIListLayout", dropdownList)
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local listPadding = Instance.new("UIPadding", dropdownList)
    listPadding.PaddingTop = UDim.new(0, 4)
    listPadding.PaddingBottom = UDim.new(0, 4)
    listPadding.PaddingLeft = UDim.new(0, 4)
    listPadding.PaddingRight = UDim.new(0, 4)
    
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton", dropdownList)
        optionBtn.Size = UDim2.new(1, -8, 0, 26)
        optionBtn.BackgroundColor3 = theme.Primary
        optionBtn.BackgroundTransparency = 1
        optionBtn.Text = option
        optionBtn.TextColor3 = theme.Text
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 11
        optionBtn.AutoButtonColor = false
        optionBtn.ZIndex = 101
        optionBtn.BorderSizePixel = 0
        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local optPadding = Instance.new("UIPadding", optionBtn)
        optPadding.PaddingLeft = UDim.new(0, 8)
        
        local optCorner = Instance.new("UICorner", optionBtn)
        optCorner.CornerRadius = UDim.new(0, 4)
        
        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundTransparency = 0
            TS:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = theme.SurfaceLight}):Play()
        end)
        
        optionBtn.MouseLeave:Connect(function()
            TS:Create(optionBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        end)
        
        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownList.Visible = false
            arrow.Text = "▼"
            func(option, i)
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        arrow.Text = dropdownList.Visible and "▲" or "▼"
        
        if dropdownList.Visible then
            local btnPos = dropdownBtn.AbsolutePosition
            dropdownList.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + 32)
            dropdownList.Size = UDim2.new(0, 140, 0, #options * 28 + 8)
        end
    end)
    
    dropdownBtn.MouseEnter:Connect(function()
        TS:Create(dropdownBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceLight}):Play()
    end)
    
    dropdownBtn.MouseLeave:Connect(function()
        TS:Create(dropdownBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Primary}):Play()
    end)
    
    return dropdownFrame
end

-- MAIN TAB
local playerList = {}
for _, player in pairs(P:GetPlayers()) do
    if player ~= LP then
        table.insert(playerList, player.Name)
    end
end

if #playerList == 0 then
    table.insert(playerList, "No Players")
end

createDropdown(mainTab, "Select Player", "Choose a player for actions", playerList, 1, function(playerName, index)
    for _, player in pairs(P:GetPlayers()) do
        if player.Name == playerName then
            settings.SELECTED_PLAYER = player
            sendNotification("Player Selected", playerName .. " has been selected.", 3)
            break
        end
    end
end)

createButton(mainTab, "Teleport To Me", "Bring selected player to you", function()
    if not settings.SELECTED_PLAYER then
        sendNotification("Error", "Please select a player first!", 3)
        return
    end
    
    if not settings.SELECTED_PLAYER.Character then
        sendNotification("Error", "Player has no character!", 3)
        return
    end
    
    if not LP.Character then
        sendNotification("Error", "You have no character!", 3)
        return
    end
    
    local targetRoot = getRootPart(settings.SELECTED_PLAYER.Character)
    local myRoot = getRootPart(LP.Character)
    
    if not targetRoot then
        sendNotification("Error", "Could not find player's HumanoidRootPart!", 3)
        return
    end
    
    if not myRoot then
        sendNotification("Error", "Could not find your HumanoidRootPart!", 3)
        return
    end
    
    -- Daha güvenilir teleport
    local success = pcall(function()
        targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -4)
        targetRoot.Anchored = false
    end)
    
    if success then
        sendNotification("Teleport", settings.SELECTED_PLAYER.Name .. " brought to you!", 3)
    else
        sendNotification("Error", "Teleport failed! FE might be blocking.", 3)
    end
end)

createButton(mainTab, "Teleport To Player", "Go to selected player", function()
    if not settings.SELECTED_PLAYER then
        sendNotification("Error", "Please select a player first!", 3)
        return
    end
    
    if not settings.SELECTED_PLAYER.Character then
        sendNotification("Error", "Player has no character!", 3)
        return
    end
    
    if not LP.Character then
        sendNotification("Error", "You have no character!", 3)
        return
    end
    
    local targetRoot = getRootPart(settings.SELECTED_PLAYER.Character)
    local myRoot = getRootPart(LP.Character)
    
    if not targetRoot then
        sendNotification("Error", "Could not find player's HumanoidRootPart!", 3)
        return
    end
    
    if not myRoot then
        sendNotification("Error", "Could not find your HumanoidRootPart!", 3)
        return
    end
    
    local success = pcall(function()
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
    end)
    
    if success then
        sendNotification("Teleport", "Teleported to " .. settings.SELECTED_PLAYER.Name .. "!", 3)
    else
        sendNotification("Error", "Teleport failed!", 3)
    end
end)

createButton(mainTab, "Set On Fire", "Set selected player on fire", function()
    if settings.SELECTED_PLAYER and settings.SELECTED_PLAYER.Character then
        local targetRoot = getRootPart(settings.SELECTED_PLAYER.Character)
        
        if targetRoot then
            local fire = Instance.new("Fire")
            fire.Parent = targetRoot
            fire.Size = 15
            fire.Heat = 15
            fire.Color = Color3.fromRGB(255, 100, 0)
            fire.SecondaryColor = Color3.fromRGB(255, 200, 0)
            
            sendNotification("Fire", settings.SELECTED_PLAYER.Name .. " is on fire! 🔥", 3)
            
            task.spawn(function()
                task.wait(10)
                if fire and fire.Parent then
                    fire:Destroy()
                end
            end)
        else
            sendNotification("Error", "Could not find character parts.", 3)
        end
    else
        sendNotification("Error", "Please select a player first!", 3)
    end
end)

local isSpectating = false
local spectateConnection = nil
local originalCamera = nil

createButton(mainTab, "Spectate Player", "Watch selected player's view", function()
    local camera = workspace.CurrentCamera
    
    if not isSpectating then
        if not settings.SELECTED_PLAYER then
            sendNotification("Error", "Please select a player first!", 3)
            return
        end
        
        if not settings.SELECTED_PLAYER.Character then
            sendNotification("Error", "Player has no character!", 3)
            return
        end
        
        local targetHumanoid = getHumanoid(settings.SELECTED_PLAYER.Character)
        if not targetHumanoid then
            sendNotification("Error", "Could not find player's humanoid!", 3)
            return
        end
        
        isSpectating = true
        originalCamera = camera.CameraSubject
        camera.CameraSubject = targetHumanoid
        
        sendNotification("Spectate", "Now spectating " .. settings.SELECTED_PLAYER.Name, 3)
        
        -- Oyuncu ayrılırsa veya ölürse spectate'i durdur
        spectateConnection = targetHumanoid.Died:Connect(function()
            if isSpectating then
                isSpectating = false
                camera.CameraSubject = originalCamera or LP.Character:FindFirstChildOfClass("Humanoid")
                sendNotification("Spectate", "Player died - spectate stopped", 3)
            end
        end)
        
    else
        isSpectating = false
        if spectateConnection then
            spectateConnection:Disconnect()
            spectateConnection = nil
        end
        
        if LP.Character then
            local myHumanoid = getHumanoid(LP.Character)
            camera.CameraSubject = myHumanoid or originalCamera
        else
            camera.CameraSubject = originalCamera
        end
        
        sendNotification("Spectate", "Stopped spectating", 3)
    end
end)

local isInvisible = false

createButton(mainTab, "Toggle Invisible", "Make yourself invisible/visible", function()
    if not LP.Character then
        sendNotification("Error", "You have no character!", 3)
        return
    end
    
    isInvisible = not isInvisible
    
    local function setInvisibility(state)
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 1 or 0
                end
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = state and 1 or 0
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    handle.Transparency = state and 1 or 0
                end
            end
        end
        
        -- Face'i gizle/göster
        local head = LP.Character:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChildOfClass("Decal")
            if face then
                face.Transparency = state and 1 or 0
            end
        end
    end
    
    setInvisibility(isInvisible)
    
    if isInvisible then
        sendNotification("Invisible", "You are now invisible! 👻", 3)
    else
        sendNotification("Visible", "You are now visible! 👤", 3)
    end
end)

createToggle(mainTab, "Speed Hack", "Increase your walk speed", settings.SPEED_HACK, function(v)
    settings.SPEED_HACK = v
    
    if LP.Character then
        local humanoid = getHumanoid(LP.Character)
        if humanoid then
            if v then
                humanoid.WalkSpeed = 16 * settings.SPEED_AMOUNT
                sendNotification("Speed Hack", "Speed increased to " .. humanoid.WalkSpeed, 3)
            else
                humanoid.WalkSpeed = 16
                sendNotification("Speed Hack", "Speed reset to normal", 3)
            end
        end
    end
end)

createSlider(mainTab, "Speed Multiplier", "Speed boost amount (2x - 10x)", 2, 10, settings.SPEED_AMOUNT, function(v)
    settings.SPEED_AMOUNT = v
    
    if settings.SPEED_HACK and LP.Character then
        local humanoid = getHumanoid(LP.Character)
        if humanoid then
            humanoid.WalkSpeed = 16 * v
        end
    end
end)

createToggle(mainTab, "Wallbang", "Shoot through walls", settings.WALLBANG, function(v)
    settings.WALLBANG = v
    
    if v then
        sendNotification("Wallbang", "Wallbang enabled! 🧱🔫", 3)
    else
        sendNotification("Wallbang", "Wallbang disabled", 3)
    end
end)

-- VISUAL TAB
createToggle(visualTab, "ESP", "Show the players from behind the walls.", settings.ESP, function(v)
    settings.ESP = v
    updateESP()
end)

createToggle(visualTab, "Health Bar", "Show health bars for ESP.", settings.ESP_HEALTHBAR, function(v)
    settings.ESP_HEALTHBAR = v
    updateESP()
end)

createToggle(visualTab, "Box ESP", "Show boxes around players.", settings.ESP_BOX, function(v)
    settings.ESP_BOX = v
    updateESP()
end)

createToggle(visualTab, "Weapon ESP", "Show player weapons.", settings.ESP_WEAPON, function(v)
    settings.ESP_WEAPON = v
    updateESP()
end)

createToggle(visualTab, "Skeleton ESP", "Show player skeletons.", settings.ESP_SKELETON, function(v)
    settings.ESP_SKELETON = v
    updateESP()
end)

createToggle(visualTab, "Distance ESP", "Show distance to players.", settings.ESP_DISTANCE_SHOW, function(v)
    settings.ESP_DISTANCE_SHOW = v
    updateESP()
end)

createSlider(visualTab, "ESP Distance", "Maximum display distance", 50, 2000, settings.ESP_DISTANCE, function(v)
    settings.ESP_DISTANCE = v
    updateESP()
end)

-- COMBAT TAB
createToggle(combatTab, "Aimbot", "Automatic aiming system.", settings.AIMBOT, function(v)
    settings.AIMBOT = v
    fovCircle.Visible = v
end)

createToggle(combatTab, "Silent Aim", "Invisible aimbot (no camera movement).", settings.SILENT_AIM, function(v)
    settings.SILENT_AIM = v
    if v then
        sendNotification("Silent Aim", "Silent aim enabled! No visible lock.", 3)
    else
        sendNotification("Silent Aim", "Silent aim disabled", 3)
    end
end)

createToggle(combatTab, "Trigger Bot", "Auto-shoot when aiming at enemy.", settings.TRIGGER_BOT, function(v)
    settings.TRIGGER_BOT = v
    if v then
        sendNotification("Trigger Bot", "Trigger bot enabled! 🎯", 3)
    else
        sendNotification("Trigger Bot", "Trigger bot disabled", 3)
    end
end)

createSlider(combatTab, "Trigger Delay", "Delay before auto-shoot (ms)", 0, 500, settings.TRIGGER_DELAY * 1000, function(v)
    settings.TRIGGER_DELAY = v / 1000
end)

createToggle(combatTab, "Team Check", "Don't target your teammates.", settings.AIM_TEAM_CHECK, function(v)
    settings.AIM_TEAM_CHECK = v
end)

createSlider(combatTab, "Smoothness", "Aiming smoothness. (Low = Fast)", 1, 20, settings.AIM_SMOOTH, function(v)
    settings.AIM_SMOOTH = v
end)

createSlider(combatTab, "FOV Radius", "Aiming area radius.", 50, 500, settings.AIM_FOV, function(v)
    settings.AIM_FOV = v
    fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)

-- MOVEMENT TAB
createKeybind(movementTab, "Fly", "It allows you to fly.", settings.FLY_BIND, function(v)
    settings.FLY_BIND = v
end)

createSlider(movementTab, "Fly Speed", "Fly movement speed.", 10, 200, settings.FLY_SPEED, function(v)
    settings.FLY_SPEED = v
end)

createKeybind(movementTab, "NoClip", "It allows you to pass through walls.", settings.NOCLIP_BIND, function(v)
    settings.NOCLIP_BIND = v
end)

createKeybind(movementTab, "GodMode", "It grants you immortality.", settings.GODMODE_BIND, function(v)
    settings.GODMODE_BIND = v
end)

-- SETTINGS TAB
local infoFrame = Instance.new("Frame", settingsTab)
infoFrame.Size = UDim2.new(1, 0, 0, 120)
infoFrame.BackgroundColor3 = theme.Surface
infoFrame.ZIndex = 12
infoFrame.BorderSizePixel = 0

local infoCorner = Instance.new("UICorner", infoFrame)
infoCorner.CornerRadius = UDim.new(0, 7)

local infoStroke = Instance.new("UIStroke", infoFrame)
infoStroke.Color = theme.Border
infoStroke.Thickness = 1

local infoTitle = Instance.new("TextLabel", infoFrame)
infoTitle.Size = UDim2.new(1, -28, 0, 26)
infoTitle.Position = UDim2.new(0, 14, 0, 10)
infoTitle.BackgroundTransparency = 1
infoTitle.Text = "KEYBOARD SHORTCUTS"
infoTitle.TextColor3 = theme.Text
infoTitle.Font = Enum.Font.GothamBold
infoTitle.TextSize = 12
infoTitle.TextXAlignment = Enum.TextXAlignment.Left
infoTitle.ZIndex = 13

local infoDivider = Instance.new("Frame", infoFrame)
infoDivider.Size = UDim2.new(1, -28, 0, 1)
infoDivider.Position = UDim2.new(0, 14, 0, 36)
infoDivider.BackgroundColor3 = theme.Border
infoDivider.BorderSizePixel = 0
infoDivider.ZIndex = 13

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Size = UDim2.new(1, -28, 1, -46)
infoText.Position = UDim2.new(0, 14, 0, 42)
infoText.BackgroundTransparency = 1
infoText.Text = "F1 - Open/Close Menu\n" .. settings.FLY_BIND .. " - Fly Mode\n" .. settings.NOCLIP_BIND .. " - Noclip Mode\n" .. settings.GODMODE_BIND .. " - GodMode Mode"
infoText.TextColor3 = theme.TextDim
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 11
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.ZIndex = 13

local creditFrame = Instance.new("Frame", settingsTab)
creditFrame.Size = UDim2.new(1, 0, 0, 70)
creditFrame.BackgroundColor3 = theme.Surface
creditFrame.ZIndex = 12
creditFrame.BorderSizePixel = 0

local creditCorner = Instance.new("UICorner", creditFrame)
creditCorner.CornerRadius = UDim.new(0, 7)

local creditStroke = Instance.new("UIStroke", creditFrame)
creditStroke.Color = theme.Border
creditStroke.Thickness = 1

local creditTitle = Instance.new("TextLabel", creditFrame)
creditTitle.Size = UDim2.new(1, -28, 0, 22)
creditTitle.Position = UDim2.new(0, 14, 0, 10)
creditTitle.BackgroundTransparency = 1
creditTitle.Text = "OBLIVION X v2.0"
creditTitle.TextColor3 = theme.Text
creditTitle.Font = Enum.Font.GothamBold
creditTitle.TextSize = 12
creditTitle.TextXAlignment = Enum.TextXAlignment.Left
creditTitle.ZIndex = 13

local creditText = Instance.new("TextLabel", creditFrame)
creditText.Size = UDim2.new(1, -28, 0, 18)
creditText.Position = UDim2.new(0, 14, 0, 30)
creditText.BackgroundTransparency = 1
creditText.Text = "Developed: @MytHirax"
creditText.TextColor3 = theme.TextDim
creditText.Font = Enum.Font.Gotham
creditText.TextSize = 10
creditText.TextXAlignment = Enum.TextXAlignment.Left
creditText.ZIndex = 13

local versionText = Instance.new("TextLabel", creditFrame)
versionText.Size = UDim2.new(1, -28, 0, 16)
versionText.Position = UDim2.new(0, 14, 0, 48)
versionText.BackgroundTransparency = 1
versionText.Text = "Ultimate Edition"
versionText.TextColor3 = theme.Accent
versionText.Font = Enum.Font.GothamMedium
versionText.TextSize = 10
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.ZIndex = 13

local espCache = {}
local healthbarCache = {}
local boxCache = {}
local weaponCache = {}
local skeletonCache = {}
local distanceCache = {}

function updateESP()
    -- Clear all caches
    for player, esp in pairs(espCache) do
        if esp and esp.Parent then esp:Destroy() end
    end
    for player, hb in pairs(healthbarCache) do
        if hb and hb.Parent then hb:Destroy() end
    end
    for player, box in pairs(boxCache) do
        if box and box.Parent then box:Destroy() end
    end
    for player, weapon in pairs(weaponCache) do
        if weapon and weapon.Parent then weapon:Destroy() end
    end
    for player, skeleton in pairs(skeletonCache) do
        if skeleton and skeleton.Parent then skeleton:Destroy() end
    end
    for player, distance in pairs(distanceCache) do
        if distance and distance.Parent then distance:Destroy() end
    end
    
    espCache = {}
    healthbarCache = {}
    boxCache = {}
    weaponCache = {}
    skeletonCache = {}
    distanceCache = {}
    
    if not settings.ESP then return end
    
    for _, player in pairs(P:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = getRootPart(player.Character)
            local humanoid = getHumanoid(player.Character)
            
            if root and humanoid and humanoid.Health > 0 then
                local myRoot = LP.Character and getRootPart(LP.Character)
                if myRoot then
                    local distance = (myRoot.Position - root.Position).Magnitude
                    if distance > settings.ESP_DISTANCE then continue end
                    
                    local teamColor = getTeamColor(player)
                    
                    -- Highlight ESP
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = gui
                    highlight.Adornee = player.Character
                    highlight.FillColor = teamColor
                    highlight.FillTransparency = 0.7
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0.5
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    espCache[player] = highlight
                    
                    -- Box ESP
                    if settings.ESP_BOX then
                        local boxGui = Instance.new("BillboardGui")
                        boxGui.Parent = gui
                        boxGui.Adornee = root
                        boxGui.Size = UDim2.new(4, 0, 5, 0)
                        boxGui.StudsOffset = Vector3.new(0, 0, 0)
                        boxGui.AlwaysOnTop = true
                        boxGui.MaxDistance = settings.ESP_DISTANCE
                        
                        local box = Instance.new("Frame", boxGui)
                        box.Size = UDim2.new(1, 0, 1, 0)
                        box.BackgroundTransparency = 1
                        box.BorderSizePixel = 2
                        box.BorderColor3 = teamColor
                        
                        boxCache[player] = boxGui
                    end
                    
                    -- Weapon ESP
                    if settings.ESP_WEAPON then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            local weaponGui = Instance.new("BillboardGui")
                            weaponGui.Parent = gui
                            weaponGui.Adornee = root
                            weaponGui.Size = UDim2.new(0, 100, 0, 20)
                            weaponGui.StudsOffset = Vector3.new(0, -3, 0)
                            weaponGui.AlwaysOnTop = true
                            weaponGui.MaxDistance = settings.ESP_DISTANCE
                            
                            local weaponText = Instance.new("TextLabel", weaponGui)
                            weaponText.Size = UDim2.new(1, 0, 1, 0)
                            weaponText.BackgroundTransparency = 1
                            weaponText.Text = "🔫 " .. tool.Name
                            weaponText.TextColor3 = Color3.fromRGB(255, 255, 0)
                            weaponText.Font = Enum.Font.GothamBold
                            weaponText.TextSize = 12
                            weaponText.TextStrokeTransparency = 0.5
                            
                            weaponCache[player] = weaponGui
                        end
                    end
                    
                    -- Skeleton ESP
                    if settings.ESP_SKELETON then
                        local skeletonGui = Instance.new("Folder")
                        skeletonGui.Name = "SkeletonESP"
                        skeletonGui.Parent = gui
                        
                        local function createLine(partA, partB, color)
                            local attach0 = Instance.new("Attachment", partA)
                            local attach1 = Instance.new("Attachment", partB)
                            local beam = Instance.new("Beam", skeletonGui)
                            beam.Attachment0 = attach0
                            beam.Attachment1 = attach1
                            beam.Color = ColorSequence.new(color)
                            beam.Width0 = 0.1
                            beam.Width1 = 0.1
                            beam.FaceCamera = true
                            return beam
                        end
                        
                        local char = player.Character
                        pcall(function()
                            if char:FindFirstChild("Head") and char:FindFirstChild("UpperTorso") then
                                createLine(char.Head, char.UpperTorso, teamColor)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("LowerTorso") then
                                createLine(char.UpperTorso, char.LowerTorso, teamColor)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("RightUpperArm") then
                                createLine(char.UpperTorso, char.RightUpperArm, teamColor)
                            end
                            if char:FindFirstChild("RightUpperArm") and char:FindFirstChild("RightLowerArm") then
                                createLine(char.RightUpperArm, char.RightLowerArm, teamColor)
                            end
                            if char:FindFirstChild("RightLowerArm") and char:FindFirstChild("RightHand") then
                                createLine(char.RightLowerArm, char.RightHand, teamColor)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("LeftUpperArm") then
                                createLine(char.UpperTorso, char.LeftUpperArm, teamColor)
                            end
                            if char:FindFirstChild("LeftUpperArm") and char:FindFirstChild("LeftLowerArm") then
                                createLine(char.LeftUpperArm, char.LeftLowerArm, teamColor)
                            end
                            if char:FindFirstChild("LeftLowerArm") and char:FindFirstChild("LeftHand") then
                                createLine(char.LeftLowerArm, char.LeftHand, teamColor)
                            end
                            if char:FindFirstChild("LowerTorso") and char:FindFirstChild("RightUpperLeg") then
                                createLine(char.LowerTorso, char.RightUpperLeg, teamColor)
                            end
                            if char:FindFirstChild("RightUpperLeg") and char:FindFirstChild("RightLowerLeg") then
                                createLine(char.RightUpperLeg, char.RightLowerLeg, teamColor)
                            end
                            if char:FindFirstChild("RightLowerLeg") and char:FindFirstChild("RightFoot") then
                                createLine(char.RightLowerLeg, char.RightFoot, teamColor)
                            end
                            if char:FindFirstChild("LowerTorso") and char:FindFirstChild("LeftUpperLeg") then
                                createLine(char.LowerTorso, char.LeftUpperLeg, teamColor)
                            end
                            if char:FindFirstChild("LeftUpperLeg") and char:FindFirstChild("LeftLowerLeg") then
                                createLine(char.LeftUpperLeg, char.LeftLowerLeg, teamColor)
                            end
                            if char:FindFirstChild("LeftLowerLeg") and char:FindFirstChild("LeftFoot") then
                                createLine(char.LeftLowerLeg, char.LeftFoot, teamColor)
                            end
                        end)
                        
                        skeletonCache[player] = skeletonGui
                    end
                    
                    -- Distance ESP
                    if settings.ESP_DISTANCE_SHOW then
                        local distGui = Instance.new("BillboardGui")
                        distGui.Parent = gui
                        distGui.Adornee = root
                        distGui.Size = UDim2.new(0, 100, 0, 20)
                        distGui.StudsOffset = Vector3.new(0, 4.5, 0)
                        distGui.AlwaysOnTop = true
                        distGui.MaxDistance = settings.ESP_DISTANCE
                        
                        local distText = Instance.new("TextLabel", distGui)
                        distText.Size = UDim2.new(1, 0, 1, 0)
                        distText.BackgroundTransparency = 1
                        distText.Text = math.floor(distance) .. " studs"
                        distText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        distText.Font = Enum.Font.GothamBold
                        distText.TextSize = 11
                        distText.TextStrokeTransparency = 0.5
                        
                        distanceCache[player] = distGui
                        
                        -- Update distance in real-time
                        task.spawn(function()
                            while distText and distText.Parent and settings.ESP_DISTANCE_SHOW do
                                if myRoot and root then
                                    local newDist = (myRoot.Position - root.Position).Magnitude
                                    distText.Text = math.floor(newDist) .. " studs"
                                end
                                task.wait(0.5)
                            end
                        end)
                    end
                    
                    -- Health Bar
                    if settings.ESP_HEALTHBAR then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Parent = gui
                        billboard.Adornee = root
                        billboard.Size = UDim2.new(0, 120, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
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
                        nameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameText.Font = Enum.Font.GothamBold
                        nameText.TextSize = 12
                        nameText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        nameText.TextStrokeTransparency = 0.5
                        
                        local healthText = Instance.new("TextLabel", background)
                        healthText.Size = UDim2.new(1, 0, 0, 12)
                        healthText.Position = UDim2.new(0, 0, 0.8, 0)
                        healthText.BackgroundTransparency = 1
                        healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
                        healthText.Font = Enum.Font.Gotham
                        healthText.TextSize = 10
                        healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        healthText.TextStrokeTransparency = 0.5
                        
                        healthbarCache[player] = billboard
                        
                        local healthConnection
                        healthConnection = humanoid.HealthChanged:Connect(function()
                            if healthBar and healthBar.Parent then
                                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
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
                            else
                                if healthConnection then
                                    healthConnection:Disconnect()
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(1) do
        if settings.ESP then
            updateESP()
        end
    end
end)

P.PlayerRemoving:Connect(function(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
    if healthbarCache[player] then
        healthbarCache[player]:Destroy()
        healthbarCache[player] = nil
    end
    if boxCache[player] then
        boxCache[player]:Destroy()
        boxCache[player] = nil
    end
    if weaponCache[player] then
        weaponCache[player]:Destroy()
        weaponCache[player] = nil
    end
    if skeletonCache[player] then
        skeletonCache[player]:Destroy()
        skeletonCache[player] = nil
    end
    if distanceCache[player] then
        distanceCache[player]:Destroy()
        distanceCache[player] = nil
    end
    
    -- Eğer spectate edilen oyuncu ayrıldıysa
    if isSpectating and settings.SELECTED_PLAYER == player then
        isSpectating = false
        if spectateConnection then
            spectateConnection:Disconnect()
            spectateConnection = nil
        end
        
        local camera = workspace.CurrentCamera
        if LP.Character then
            local myHumanoid = getHumanoid(LP.Character)
            if myHumanoid then
                camera.CameraSubject = myHumanoid
            end
        end
        
        sendNotification("Spectate", "Player left - spectate stopped", 3)
    end
end)

-- Player listesini güncelle
P.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    -- Dropdown'u güncelle
    playerList = {}
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP then
            table.insert(playerList, p.Name)
        end
    end
end)

local currentTarget = nil

local function getClosestPlayer()
    if not settings.AIMBOT then return nil end
    
    local camera = workspace.CurrentCamera
    if not camera then return nil end
    
    local closestPlayer = nil
    local closestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, player in pairs(P:GetPlayers()) do
        if player ~= LP and player.Character then
            if settings.AIM_TEAM_CHECK and LP.Team and player.Team and player.Team == LP.Team then
                continue
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
local flyConnection

local originalProperties = {}

local function restoreOriginalProperties()
    for part, properties in pairs(originalProperties) do
        if part and part.Parent then
            pcall(function()
                part.CanCollide = properties.CanCollide
            end)
        end
    end
    originalProperties = {}
end

local function startFly()
    if not LP.Character then return end
    local root = getRootPart(LP.Character)
    if not root then return end
    
    if flyBV then pcall(function() flyBV:Destroy() end) end
    if flyBG then pcall(function() flyBG:Destroy() end) end
    if flyConnection then pcall(function() flyConnection:Disconnect() end) end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.Parent = root
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    
    flyBG = Instance.new("BodyGyro")
    flyBG.Parent = root
    flyBG.MaxTorque = Vector3.new(10000, 10000, 10000)
    flyBG.P = 1000
    
    flying = true
    
    flyConnection = RS.Heartbeat:Connect(function()
        if not flying or not settings.FLY or not LP.Character or not flyBV or not flyBV.Parent then
            flying = false
            if flyBV then pcall(function() flyBV:Destroy() end) end
            if flyBG then pcall(function() flyBG:Destroy() end) end
            if flyConnection then pcall(function() flyConnection:Disconnect() end) end
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        if flyBG and flyBG.Parent then
            flyBG.CFrame = camera.CFrame
        end
        
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
        
        if flyBV and flyBV.Parent then
            flyBV.Velocity = velocity
        end
    end)
end

local function stopFly()
    flying = false
    if flyBV then 
        pcall(function() flyBV:Destroy() end)
        flyBV = nil
    end
    if flyBG then 
        pcall(function() flyBG:Destroy() end)
        flyBG = nil
    end
    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end
end

local godModeConnection = nil

local function startGodMode()
    if not LP.Character then return end
    local humanoid = getHumanoid(LP.Character)
    if not humanoid then return end
    
    if godModeConnection then
        pcall(function() godModeConnection:Disconnect() end)
        godModeConnection = nil
    end
    
    local maxHealth = humanoid.MaxHealth
    godModeConnection = RS.Heartbeat:Connect(function()
        if settings.GODMODE and humanoid and humanoid.Parent then
            if humanoid.Health < maxHealth then
                humanoid.Health = maxHealth
            end
        end
    end)
end

local function stopGodMode()
    if godModeConnection then
        pcall(function() godModeConnection:Disconnect() end)
        godModeConnection = nil
    end
end

RS.Stepped:Connect(function()
    pcall(function()
        -- Noclip
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
        
        -- Wallbang - Makes bullets go through walls
        if settings.WALLBANG then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.CanCollide and not obj:IsDescendantOf(LP.Character) then
                    -- Make walls transparent to bullets (game specific)
                    -- This is a basic implementation
                    obj.CanCollide = false
                end
            end
        end
        
        -- GodMode
        if settings.GODMODE and LP.Character then
            local humanoid = getHumanoid(LP.Character)
            if humanoid and not godModeConnection then
                startGodMode()
            end
        elseif not settings.GODMODE and godModeConnection then
            stopGodMode()
        end
    end)
end)

RS.RenderStepped:Connect(function()
    pcall(function()
        -- Silent Aim & Aimbot
        if settings.AIMBOT or settings.SILENT_AIM then
            local target = getClosestPlayer()
            currentTarget = target
            
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local camera = workspace.CurrentCamera
                    if camera then
                        -- Normal Aimbot (visible camera movement)
                        if settings.AIMBOT and not settings.SILENT_AIM then
                            local smoothness = math.max(settings.AIM_SMOOTH, 1)
                            local targetPos = head.Position
                            local currentCFrame = camera.CFrame
                            local targetCFrame = CFrame.new(camera.CFrame.Position, targetPos)
                            camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothness)
                        end
                        
                        -- Silent Aim (invisible - hooks into shooting mechanism)
                        if settings.SILENT_AIM then
                            -- This modifies the aim direction without moving camera
                            -- Game-specific implementation needed
                            local targetPos = head.Position
                            -- Store target position for when game checks aim
                            getgenv().silentAimTarget = targetPos
                        end
                        
                        -- Trigger Bot
                        if settings.TRIGGER_BOT then
                            local ray = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector * 1000)
                            local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {LP.Character})
                            
                            if hit and hit.Parent then
                                local hitPlayer = P:GetPlayerFromCharacter(hit.Parent)
                                if hitPlayer and hitPlayer ~= LP then
                                    if not settings.AIM_TEAM_CHECK or (LP.Team and hitPlayer.Team and hitPlayer.Team ~= LP.Team) then
                                        task.wait(settings.TRIGGER_DELAY)
                                        -- Auto-click simulation
                                        mouse1click()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- Fly
        if settings.FLY and not flying then
            startFly()
        elseif not settings.FLY and flying then
            stopFly()
        end
        
        -- Speed Hack maintenance
        if settings.SPEED_HACK and LP.Character then
            local humanoid = getHumanoid(LP.Character)
            if humanoid then
                humanoid.WalkSpeed = 16 * settings.SPEED_AMOUNT
            end
        end
    end)
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    pcall(function()
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
end)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    pcall(function()
        if settings.GODMODE then
            startGodMode()
        end
        if settings.ESP then
            updateESP()
        end
        
        -- Speed hack reapply
        if settings.SPEED_HACK then
            task.wait(0.2)
            local humanoid = getHumanoid(character)
            if humanoid then
                humanoid.WalkSpeed = 16 * settings.SPEED_AMOUNT
            end
        end
        
        -- Invisible durumu sıfırla
        if isInvisible then
            isInvisible = false
            sendNotification("Invisible", "Invisibility reset on respawn", 2)
        end
        
        -- Spectate durumu kontrol et
        if isSpectating then
            local camera = workspace.CurrentCamera
            if LP.Character then
                local myHumanoid = getHumanoid(LP.Character)
                if myHumanoid then
                    camera.CameraSubject = myHumanoid
                end
            end
            isSpectating = false
            if spectateConnection then
                spectateConnection:Disconnect()
                spectateConnection = nil
            end
        end
    end)
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LP then
        stopFly()
        stopGodMode()
        restoreOriginalProperties()
    end
end)

local hasOpenedOnce = false
task.spawn(function()
    repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    task.wait(1)
    
    if not hasOpenedOnce then
        hasOpenedOnce = true
        toggleMenu(true)
        
        if tabs["Main"] then
            for _, tab in pairs(tabs) do
                tab.content.Visible = false
                tab.button.BackgroundColor3 = theme.Surface
                tab.label.TextColor3 = theme.TextDim
                tab.stroke.Transparency = 1
                tab.indicator.Visible = false
            end
            tabs["Main"].button.BackgroundColor3 = theme.SurfaceLight
            tabs["Main"].label.TextColor3 = theme.Text
            tabs["Main"].stroke.Transparency = 0
            tabs["Main"].indicator.Visible = true
            tabs["Main"].content.Visible = true
            currentTab = "Main"
        end
    end
end)
