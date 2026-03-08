local P = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = P.LocalPlayer
local SG = game:GetService("StarterGui")

local settings = {
    ESP = false,
    ESP_DISTANCE = 300,
    ESP_BOX = false,
    ESP_LINE = false,
    ESP_COLOR = Color3.fromRGB(255, 60, 60),
    ESP_BIND = "None",
    FLY = false,
    FLY_SPEED = 50,
    FLY_BIND = "G",
    SPEED_HACK = false,
    SPEED_AMOUNT = 2,
    SPEED_BIND = "None",
    NOCLIP = false,
    NOCLIP_BIND = "H",
    GODMODE = false,
    GODMODE_BIND = "None",
}

local theme = {
    Background   = Color3.fromRGB(18, 18, 20),
    Surface      = Color3.fromRGB(26, 26, 28),
    SurfaceLight = Color3.fromRGB(33, 33, 36),
    Primary      = Color3.fromRGB(42, 42, 45),
    Accent       = Color3.fromRGB(155, 155, 160),
    Text         = Color3.fromRGB(235, 235, 240),
    TextDim      = Color3.fromRGB(145, 145, 150),
    Border       = Color3.fromRGB(38, 38, 40),
    Success      = Color3.fromRGB(110, 175, 130),
    Error        = Color3.fromRGB(195, 115, 115),
    Highlight    = Color3.fromRGB(195, 195, 200)
}

local function sendNotification(title, text, duration)
    pcall(function()
        SG:SetCore("SendNotification", {
            Title = title, Text = text,
            Duration = duration or 3,
            Icon = "rbxassetid://7733993369"
        })
    end)
end

local function getHumanoid(c) return c:FindFirstChildOfClass("Humanoid") end
local function getRootPart(c)
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
end

-- ── GUI ──────────────────────────────────────────────────────────────────────
local gui = Instance.new("ScreenGui")
local parented = false
if not parented then pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(gui) end
    gui.Parent = game:GetService("CoreGui"); parented = true
end) end
if not parented then pcall(function() gui.Parent = gethui(); parented = true end) end
if not parented then gui.Parent = LP.PlayerGui end
gui.Name = tostring(math.random(1e6,9e6))
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function newFrame(parent, size, pos, color, zindex)
    local f = Instance.new("Frame", parent)
    f.Size = size; f.Position = pos or UDim2.new(0,0,0,0)
    f.BackgroundColor3 = color or Color3.fromRGB(0,0,0)
    f.BorderSizePixel = 0; f.ZIndex = zindex or 1
    return f
end

local shadow = newFrame(gui, UDim2.new(0,540,0,410), UDim2.new(0.5,3,0.5,3), Color3.fromRGB(0,0,0), 9)
shadow.AnchorPoint = Vector2.new(0.5,0.5); shadow.BackgroundTransparency = 0.65; shadow.Visible = false
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,12)

local main = newFrame(gui, UDim2.new(0,540,0,410), UDim2.new(0.5,0,0.5,0), theme.Background, 10)
main.AnchorPoint = Vector2.new(0.5,0.5); main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local mStroke = Instance.new("UIStroke", main); mStroke.Color = theme.Border; mStroke.Thickness = 1

-- title bar
local tBar = newFrame(main, UDim2.new(1,0,0,52), UDim2.new(0,0,0,0), theme.Surface, 11)
Instance.new("UICorner", tBar).CornerRadius = UDim.new(0,12)
local tFix = newFrame(tBar, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12), theme.Surface, 11)
local tDiv = newFrame(tBar, UDim2.new(1,0,0,1), UDim2.new(0,0,1,-1), theme.Border, 12)

local function lbl(parent, text, size, pos, font, tsize, color, xa, zi)
    local l = Instance.new("TextLabel", parent)
    l.Size = size; l.Position = pos; l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = color or theme.Text
    l.Font = font or Enum.Font.Gotham; l.TextSize = tsize or 12
    l.TextXAlignment = xa or Enum.TextXAlignment.Left; l.ZIndex = zi or 12
    return l
end

lbl(tBar,"Menu",UDim2.new(0.6,0,0,24),UDim2.new(0,18,0,8),Enum.Font.GothamBold,16,theme.Text)
lbl(tBar,"F1 to toggle",UDim2.new(0.6,0,0,14),UDim2.new(0,18,0,33),Enum.Font.Gotham,10,theme.TextDim)

local closeBtn = Instance.new("TextButton", tBar)
closeBtn.Size = UDim2.new(0,32,0,32); closeBtn.Position = UDim2.new(1,-42,0.5,-16)
closeBtn.BackgroundColor3 = theme.Primary; closeBtn.Text = "×"
closeBtn.TextColor3 = theme.Text; closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22; closeBtn.ZIndex = 12; closeBtn.AutoButtonColor = false; closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.15),{BackgroundColor3=theme.Error}):Play() end)
closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.15),{BackgroundColor3=theme.Primary}):Play() end)

-- drag
local drag, dragStart, dragPos = false, nil, nil
tBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag=true; dragStart=i.Position; dragPos=main.Position
    end
end)
tBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        main.Position   = UDim2.new(dragPos.X.Scale, dragPos.X.Offset+d.X, dragPos.Y.Scale, dragPos.Y.Offset+d.Y)
        shadow.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset+d.X+3, dragPos.Y.Scale, dragPos.Y.Offset+d.Y+3)
    end
end)

-- tab sidebar
local sidebar = newFrame(main, UDim2.new(0,130,1,-62), UDim2.new(0,12,0,62), theme.Background, 11)
sidebar.BackgroundTransparency = 1
local sbl = Instance.new("UIListLayout", sidebar); sbl.Padding = UDim.new(0,6); sbl.SortOrder = Enum.SortOrder.LayoutOrder

local contentArea = newFrame(main, UDim2.new(1,-158,1,-70), UDim2.new(0,150,0,62), theme.Background, 11)
contentArea.BackgroundTransparency = 1

local currentTabName = nil
local tabs = {}

local function createTab(name, order)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1,0,0,38); btn.BackgroundColor3 = theme.Surface
    btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 12; btn.LayoutOrder = order; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    local bStroke = Instance.new("UIStroke", btn); bStroke.Color = theme.Border; bStroke.Thickness = 1; bStroke.Transparency = 1
    local bLabel = lbl(btn, string.upper(name), UDim2.new(1,-20,1,0), UDim2.new(0,14,0,0),
        Enum.Font.GothamBold, 11, theme.TextDim, Enum.TextXAlignment.Left, 13)
    local ind = newFrame(btn, UDim2.new(0,3,1,-12), UDim2.new(0,4,0,6), theme.Highlight, 13)
    ind.Visible = false; Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)

    local scroll = Instance.new("ScrollingFrame", contentArea)
    scroll.Size = UDim2.new(1,0,1,0); scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = theme.Accent
    scroll.ZIndex = 11; scroll.Visible = false
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.BorderSizePixel = 0; scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    local sl = Instance.new("UIListLayout", scroll); sl.Padding = UDim.new(0,8); sl.SortOrder = Enum.SortOrder.LayoutOrder

    tabs[name] = {button=btn, content=scroll, label=bLabel, stroke=bStroke, indicator=ind}

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.button.BackgroundColor3=theme.Surface; t.label.TextColor3=theme.TextDim
            t.stroke.Transparency=1; t.indicator.Visible=false; t.content.Visible=false
        end
        btn.BackgroundColor3=theme.SurfaceLight; bLabel.TextColor3=theme.Text
        bStroke.Transparency=0; ind.Visible=true; scroll.Visible=true
        currentTabName = name
    end)
    btn.MouseEnter:Connect(function()
        if currentTabName~=name then TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=theme.Primary}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if currentTabName~=name then TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=theme.Surface}):Play() end
    end)
    return scroll
end

local visualTab   = createTab("Visual",   1)
local movementTab = createTab("Movement", 2)
local bindsTab    = createTab("Binds",    3)

-- ── UI COMPONENTS ─────────────────────────────────────────────────────────────
local function createSection(parent, text)
    local f = newFrame(parent, UDim2.new(1,0,0,24), UDim2.new(0,0,0,0), theme.Background, 12)
    f.BackgroundTransparency = 1
    lbl(f, string.upper(text), UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
        Enum.Font.GothamBold, 10, theme.TextDim, Enum.TextXAlignment.Left, 13)
    local line = newFrame(f, UDim2.new(1,0,0,1), UDim2.new(0,0,1,-1), theme.Border, 12)
end

local function createToggle(parent, name, desc, default, func)
    local h = desc and 56 or 40
    local f = newFrame(parent, UDim2.new(1,0,0,h), nil, theme.Surface, 12)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", f); s.Color = theme.Border; s.Thickness = 1

    lbl(f, name, UDim2.new(0.65,0,desc and 0.45 or 1,0), UDim2.new(0,12,0,desc and 4 or 0),
        Enum.Font.GothamBold, 12, theme.Text, Enum.TextXAlignment.Left, 13)
    if desc then
        lbl(f, desc, UDim2.new(0.65,0,0.45,0), UDim2.new(0,12,0.52,0),
            Enum.Font.Gotham, 10, theme.TextDim, Enum.TextXAlignment.Left, 13)
    end

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0,46,0,24); btn.Position = UDim2.new(1,-54,0.5,-12)
    btn.BackgroundColor3 = default and theme.Success or theme.Primary
    btn.Text = ""; btn.AutoButtonColor = false; btn.ZIndex = 13; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local knob = newFrame(btn, UDim2.new(0,18,0,18),
        default and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
        Color3.fromRGB(255,255,255), 14)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local state = default
    local obj = {}
    local function upd()
        TS:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=state and theme.Success or theme.Primary}):Play()
        TS:Create(knob,TweenInfo.new(0.18),{Position=state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
    end
    upd()
    function obj.setState(v, silent) state=v; upd(); if not silent then func(state) end end
    btn.MouseButton1Click:Connect(function() obj.setState(not state) end)
    btn.MouseEnter:Connect(function()
        TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=state and Color3.fromRGB(130,195,150) or theme.SurfaceLight}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=state and theme.Success or theme.Primary}):Play()
    end)
    return obj
end

local function createSlider(parent, name, desc, minV, maxV, default, func)
    local h = desc and 68 or 52
    local f = newFrame(parent, UDim2.new(1,0,0,h), nil, theme.Surface, 12)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", f); s.Color = theme.Border; s.Thickness = 1

    lbl(f, name, UDim2.new(0.65,0,0,20), UDim2.new(0,12,0,6),
        Enum.Font.GothamBold, 12, theme.Text, Enum.TextXAlignment.Left, 13)
    if desc then
        lbl(f, desc, UDim2.new(0.65,0,0,16), UDim2.new(0,12,0,24),
            Enum.Font.Gotham, 10, theme.TextDim, Enum.TextXAlignment.Left, 13)
    end

    local valBox = Instance.new("TextLabel", f)
    valBox.Size = UDim2.new(0,52,0,22); valBox.Position = UDim2.new(1,-60,0,4)
    valBox.BackgroundColor3 = theme.Primary; valBox.Text = tostring(default)
    valBox.TextColor3 = theme.Highlight; valBox.Font = Enum.Font.GothamBold
    valBox.TextSize = 12; valBox.ZIndex = 13; valBox.BorderSizePixel = 0
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0,5)

    local track = newFrame(f, UDim2.new(1,-24,0,4),
        UDim2.new(0,12,1,desc and -16 or -14), theme.Primary, 13)
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    local fill = newFrame(track, UDim2.new((default-minV)/(maxV-minV),0,1,0), nil, theme.Highlight, 14)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local knob = newFrame(track, UDim2.new(0,12,0,12),
        UDim2.new((default-minV)/(maxV-minV),-6,0.5,-6), theme.Highlight, 15)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local dragging = false
    local function upd(v)
        v = math.clamp(v,minV,maxV); valBox.Text = tostring(v)
        local pct = (v-minV)/(maxV-minV)
        fill.Size = UDim2.new(pct,0,1,0); knob.Position = UDim2.new(pct,-6,0.5,-6); func(v)
    end
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    RS.RenderStepped:Connect(function()
        if dragging then
            local mp = UIS:GetMouseLocation()
            local tp = track.AbsolutePosition; local ts = track.AbsoluteSize
            upd(math.floor(minV + math.clamp((mp.X-tp.X)/ts.X,0,1)*(maxV-minV)))
        end
    end)
end

local function createKeybind(parent, name, desc, default, func)
    local h = desc and 56 or 40
    local f = newFrame(parent, UDim2.new(1,0,0,h), nil, theme.Surface, 12)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", f); s.Color = theme.Border; s.Thickness = 1

    lbl(f, name, UDim2.new(0.6,0,desc and 0.45 or 1,0), UDim2.new(0,12,0,desc and 4 or 0),
        Enum.Font.GothamBold, 12, theme.Text, Enum.TextXAlignment.Left, 13)
    if desc then
        lbl(f, desc, UDim2.new(0.6,0,0.45,0), UDim2.new(0,12,0.52,0),
            Enum.Font.Gotham, 10, theme.TextDim, Enum.TextXAlignment.Left, 13)
    end

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0,60,0,26); btn.Position = UDim2.new(1,-68,0.5,-13)
    btn.BackgroundColor3 = theme.Primary; btn.Text = default
    btn.TextColor3 = theme.Text; btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11; btn.AutoButtonColor = false; btn.ZIndex = 13; btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    local bSt = Instance.new("UIStroke", btn); bSt.Color = theme.Border; bSt.Thickness = 1

    local listening = false
    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true; btn.Text = "..."; btn.BackgroundColor3 = theme.Highlight; btn.TextColor3 = theme.Background
        local conn
        conn = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false; conn:Disconnect()
                local key = tostring(input.KeyCode):gsub("Enum.KeyCode.","")
                btn.Text = key; btn.BackgroundColor3 = theme.Primary; btn.TextColor3 = theme.Text
                func(key)
            end
        end)
    end)
    btn.MouseEnter:Connect(function()
        if not listening then TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=theme.SurfaceLight}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if not listening then TS:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=theme.Primary}):Play() end
    end)
end

local function createColorPicker(parent, name, default, func)
    local f = newFrame(parent, UDim2.new(1,0,0,128), nil, theme.Surface, 12)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,7)
    local s = Instance.new("UIStroke", f); s.Color = theme.Border; s.Thickness = 1

    lbl(f, name, UDim2.new(0.6,0,0,20), UDim2.new(0,12,0,6),
        Enum.Font.GothamBold, 12, theme.Text, Enum.TextXAlignment.Left, 13)

    local preview = newFrame(f, UDim2.new(0,26,0,26), UDim2.new(1,-36,0,6), default, 13)
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0,6)

    local r,g,b = math.floor(default.R*255), math.floor(default.G*255), math.floor(default.B*255)
    local function fire() local c=Color3.fromRGB(r,g,b); preview.BackgroundColor3=c; func(c) end

    local chs = {{"R",function(v) r=v end},{"G",function(v) g=v end},{"B",function(v) b=v end}}
    local iv = {r,g,b}
    for i,ch in ipairs(chs) do
        local nm,setter = ch[1],ch[2]
        local yOff = 30+(i-1)*30
        local row = newFrame(f, UDim2.new(1,-24,0,20), UDim2.new(0,12,0,yOff), theme.Background, 13)
        row.BackgroundTransparency = 1
        lbl(row, nm, UDim2.new(0,14,1,0), UDim2.new(0,0,0,0), Enum.Font.GothamBold, 11, theme.TextDim, Enum.TextXAlignment.Left, 14)
        local track = newFrame(row, UDim2.new(1,-58,0,4), UDim2.new(0,18,0.5,-2), theme.Primary, 14)
        Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
        local fill = newFrame(track, UDim2.new(iv[i]/255,0,1,0), nil, theme.Highlight, 15)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
        local knob = newFrame(track, UDim2.new(0,12,0,12), UDim2.new(iv[i]/255,-6,0.5,-6), theme.Highlight, 16)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
        local valL = Instance.new("TextLabel", row)
        valL.Size=UDim2.new(0,32,1,0); valL.Position=UDim2.new(1,-32,0,0)
        valL.BackgroundColor3=theme.Primary; valL.Text=tostring(iv[i])
        valL.TextColor3=theme.Highlight; valL.Font=Enum.Font.GothamBold
        valL.TextSize=11; valL.ZIndex=14; valL.BorderSizePixel=0
        Instance.new("UICorner",valL).CornerRadius=UDim.new(0,4)

        local dragging=false
        track.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)
        RS.RenderStepped:Connect(function()
            if dragging then
                local mp=UIS:GetMouseLocation()
                local tp=track.AbsolutePosition; local ts=track.AbsoluteSize
                local pct=math.clamp((mp.X-tp.X)/ts.X,0,1)
                local v=math.floor(pct*255)
                fill.Size=UDim2.new(pct,0,1,0); knob.Position=UDim2.new(pct,-6,0.5,-6)
                valL.Text=tostring(v); setter(v); fire()
            end
        end)
    end
end

-- ── MENU TOGGLE ───────────────────────────────────────────────────────────────
local function openTab(name)
    for n,t in pairs(tabs) do
        local a = (n==name)
        t.content.Visible=a; t.button.BackgroundColor3=a and theme.SurfaceLight or theme.Surface
        t.label.TextColor3=a and theme.Text or theme.TextDim
        t.stroke.Transparency=a and 0 or 1; t.indicator.Visible=a
    end
    currentTabName = name
end

local menuVisible = false
local function toggleMenu(state)
    if state==nil then state=not menuVisible end
    menuVisible=state
    if state then
        main.Visible=true; shadow.Visible=true
        main.Size=UDim2.new(0,0,0,0); shadow.Size=UDim2.new(0,0,0,0)
        local ti=TweenInfo.new(0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
        TS:Create(main,ti,{Size=UDim2.new(0,540,0,410)}):Play()
        TS:Create(shadow,ti,{Size=UDim2.new(0,540,0,410)}):Play()
        openTab(currentTabName or "Visual")
    else
        local ti=TweenInfo.new(0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        TS:Create(main,ti,{Size=UDim2.new(0,0,0,0)}):Play()
        TS:Create(shadow,ti,{Size=UDim2.new(0,0,0,0)}):Play()
        task.wait(0.28)
        if not menuVisible then main.Visible=false; shadow.Visible=false end
    end
end
closeBtn.MouseButton1Click:Connect(function() toggleMenu(false) end)

-- ── ESP ───────────────────────────────────────────────────────────────────────
local espCache, boxCache, lineCache = {},{},{}

local function clearESP()
    for _,v in pairs(espCache) do pcall(function() v:Destroy() end) end
    for _,v in pairs(boxCache) do pcall(function() v:Destroy() end) end
    espCache,boxCache,lineCache = {},{},{}
end

local function updateESP()
    clearESP()
    if not settings.ESP then return end
    local myChar = LP.Character
    local myRoot = myChar and getRootPart(myChar)
    if not myRoot then return end

    for _,player in pairs(P:GetPlayers()) do
        if player==LP then continue end
        local char = player.Character
        if not char then continue end
        local root = getRootPart(char)
        local hum  = getHumanoid(char)
        if not root or not hum or hum.Health<=0 then continue end
        if (myRoot.Position-root.Position).Magnitude > settings.ESP_DISTANCE then continue end

        local col = settings.ESP_COLOR

        local hl = Instance.new("Highlight")
        hl.Adornee=char; hl.Parent=workspace
        hl.FillColor=col; hl.FillTransparency=0.65
        hl.OutlineColor=col; hl.OutlineTransparency=0.1
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        espCache[player]=hl

        if settings.ESP_BOX then
            local bb = Instance.new("BillboardGui")
            bb.Adornee=root; bb.Parent=workspace
            bb.Size=UDim2.new(0,52,0,82)
            bb.StudsOffset=Vector3.new(0,1,0)
            bb.AlwaysOnTop=true; bb.MaxDistance=settings.ESP_DISTANCE; bb.LightInfluence=0

            local border = Instance.new("Frame", bb)
            border.Size = UDim2.new(1,0,1,0)
            border.BackgroundTransparency = 1
            border.BorderSizePixel = 0
            border.ZIndex = 2

            local boxStroke = Instance.new("UIStroke", border)
            boxStroke.Color = col
            boxStroke.Thickness = 1
            boxStroke.Transparency = 0
            boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local nl = Instance.new("TextLabel", bb)
            nl.Size=UDim2.new(1,0,0,14); nl.Position=UDim2.new(0,0,0,-18)
            nl.BackgroundTransparency=1; nl.Text=player.Name
            nl.TextColor3=col; nl.Font=Enum.Font.GothamBold
            nl.TextSize=11; nl.TextStrokeTransparency=0.4; nl.ZIndex=3

            boxCache[player]=bb
        end

        if settings.ESP_LINE then
            lineCache[player]={root=root, color=col}
        end
    end
end

local lineObjects = {}
local function clearLines()
    for _,ln in pairs(lineObjects) do pcall(function() ln:Remove() end) end
    lineObjects={}
end

RS.RenderStepped:Connect(function()
    if not settings.ESP or not settings.ESP_LINE then clearLines(); return end
    clearLines()
    local cam = workspace.CurrentCamera; if not cam then return end
    local vp  = cam.ViewportSize
    local ori = Vector2.new(vp.X/2, vp.Y)
    for player,data in pairs(lineCache) do
        if data.root and data.root.Parent then
            local sp,onScreen = cam:WorldToViewportPoint(data.root.Position)
            if onScreen then
                pcall(function()
                    local ln = Drawing.new("Line")
                    ln.From=ori; ln.To=Vector2.new(sp.X,sp.Y)
                    ln.Color=data.color; ln.Thickness=1.5
                    ln.Transparency=1; ln.Visible=true
                    lineObjects[player]=ln
                end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do if settings.ESP then updateESP() end end
end)

P.PlayerRemoving:Connect(function(player)
    if espCache[player] then pcall(function() espCache[player]:Destroy() end) espCache[player]=nil end
    if boxCache[player] then pcall(function() boxCache[player]:Destroy() end) boxCache[player]=nil end
    lineCache[player]=nil
end)

-- ── FLY ───────────────────────────────────────────────────────────────────────
local flying=false; local flyBV,flyBG,flyConn

local function stopFly()
    flying=false
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV=nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG=nil end
    if flyConn then pcall(function() flyConn:Disconnect() end) flyConn=nil end
end

local function startFly()
    if not LP.Character then return end
    local root=getRootPart(LP.Character); if not root then return end
    stopFly()
    flyBV=Instance.new("BodyVelocity",root); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Velocity=Vector3.new(0,0,0)
    flyBG=Instance.new("BodyGyro",root); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1000
    flying=true
    flyConn=RS.Heartbeat:Connect(function()
        if not flying or not settings.FLY or not LP.Character or not flyBV or not flyBV.Parent then stopFly(); return end
        local cam=workspace.CurrentCamera; if not cam then return end
        if flyBG and flyBG.Parent then flyBG.CFrame=cam.CFrame end
        local vel=Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then vel+=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then vel-=cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then vel-=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then vel+=cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then vel+=Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vel-=Vector3.new(0,1,0) end
        if vel.Magnitude>0 then vel=vel.Unit*settings.FLY_SPEED end
        if flyBV and flyBV.Parent then flyBV.Velocity=vel end
    end)
end

RS.RenderStepped:Connect(function()
    pcall(function()
        if settings.FLY and not flying then startFly()
        elseif not settings.FLY and flying then stopFly() end
    end)
end)

-- ── GODMODE ───────────────────────────────────────────────────────────────────
-- Her frame'de can MaxHealth'e sabitlenir; ek olarak Humanoid.HealthChanged
-- ile anında restore edilir (daha hızlı tepki için).
local godmodeHealthConn = nil

local function applyGodMode()
    if not LP.Character then return end
    local h = getHumanoid(LP.Character)
    if not h then return end
    -- Anlık sağlık restore bağlantısı
    if godmodeHealthConn then godmodeHealthConn:Disconnect() godmodeHealthConn=nil end
    if settings.GODMODE then
        h.Health = h.MaxHealth
        godmodeHealthConn = h.HealthChanged:Connect(function()
            if settings.GODMODE then
                pcall(function() h.Health = h.MaxHealth end)
            end
        end)
    end
end

local function stopGodMode()
    if godmodeHealthConn then godmodeHealthConn:Disconnect() godmodeHealthConn=nil end
end

RS.Stepped:Connect(function()
    pcall(function()
        if settings.NOCLIP and LP.Character then
            for _,p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
        if settings.SPEED_HACK and LP.Character then
            local h=getHumanoid(LP.Character)
            if h then h.WalkSpeed=16*settings.SPEED_AMOUNT end
        end
        -- GodMode frame bazlı yedek
        if settings.GODMODE and LP.Character then
            local h=getHumanoid(LP.Character)
            if h and h.Health < h.MaxHealth then
                pcall(function() h.Health=h.MaxHealth end)
            end
        end
    end)
end)

-- ── BUILD TABS ────────────────────────────────────────────────────────────────
local flyToggleObj, noclipToggleObj, speedToggleObj, espToggleObj, godmodeToggleObj

-- VISUAL
createSection(visualTab, "ESP Options")
espToggleObj = createToggle(visualTab,"ESP","Show players through walls",settings.ESP,function(v)
    settings.ESP=v; updateESP()
end)
createToggle(visualTab,"Box ESP","Full rectangle around players",settings.ESP_BOX,function(v)
    settings.ESP_BOX=v; updateESP()
end)
createToggle(visualTab,"Line ESP","Lines from screen bottom to players",settings.ESP_LINE,function(v)
    settings.ESP_LINE=v; updateESP()
end)
createSlider(visualTab,"ESP Distance","Max render distance",50,2000,settings.ESP_DISTANCE,function(v)
    settings.ESP_DISTANCE=v; updateESP()
end)
createColorPicker(visualTab,"ESP Color",settings.ESP_COLOR,function(c)
    settings.ESP_COLOR=c; updateESP()
end)

-- MOVEMENT
createSection(movementTab,"Speed")
speedToggleObj = createToggle(movementTab,"Speed Hack","Increase walk speed",settings.SPEED_HACK,function(v)
    settings.SPEED_HACK=v
    if LP.Character then
        local h=getHumanoid(LP.Character)
        if h then h.WalkSpeed=v and (16*settings.SPEED_AMOUNT) or 16 end
    end
end)
createSlider(movementTab,"Speed Multiplier","2x – 10x boost",2,10,settings.SPEED_AMOUNT,function(v)
    settings.SPEED_AMOUNT=v
    if settings.SPEED_HACK and LP.Character then
        local h=getHumanoid(LP.Character); if h then h.WalkSpeed=16*v end
    end
end)

createSection(movementTab,"Fly")
flyToggleObj = createToggle(movementTab,"Fly","WASD + Space / Ctrl to move",settings.FLY,function(v)
    settings.FLY=v; if not v then stopFly() end
end)
createSlider(movementTab,"Fly Speed","Movement speed while flying",10,200,settings.FLY_SPEED,function(v)
    settings.FLY_SPEED=v
end)

createSection(movementTab,"NoClip")
noclipToggleObj = createToggle(movementTab,"NoClip","Pass through walls",settings.NOCLIP,function(v)
    settings.NOCLIP=v
end)

-- ── GOD MODE (Movement tab) ───────────────────────────────────────────────────
createSection(movementTab,"God Mode")
godmodeToggleObj = createToggle(movementTab,"God Mode","Infinite health / ölümsüzlük",settings.GODMODE,function(v)
    settings.GODMODE=v
    if v then
        applyGodMode()
    else
        stopGodMode()
    end
end)

-- BINDS
createSection(bindsTab,"ESP")
createKeybind(bindsTab,"ESP Bind","Key to toggle ESP",settings.ESP_BIND,function(k)
    settings.ESP_BIND=k
end)

createSection(bindsTab,"Speed")
createKeybind(bindsTab,"Speed Hack Bind","Key to toggle speed hack",settings.SPEED_BIND,function(k)
    settings.SPEED_BIND=k
end)

createSection(bindsTab,"Fly")
createKeybind(bindsTab,"Fly Bind","Key to toggle fly",settings.FLY_BIND,function(k)
    settings.FLY_BIND=k
end)

createSection(bindsTab,"NoClip")
createKeybind(bindsTab,"NoClip Bind","Key to toggle noclip",settings.NOCLIP_BIND,function(k)
    settings.NOCLIP_BIND=k
end)

-- ── GOD MODE BIND (Binds tab) ─────────────────────────────────────────────────
createSection(bindsTab,"God Mode")
createKeybind(bindsTab,"God Mode Bind","Key to toggle god mode",settings.GODMODE_BIND,function(k)
    settings.GODMODE_BIND=k
end)

-- ── INPUT ─────────────────────────────────────────────────────────────────────
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    pcall(function()
        if input.KeyCode==Enum.KeyCode.F1 then toggleMenu(); return end

        local key = tostring(input.KeyCode):gsub("Enum.KeyCode.","")

        if key==settings.FLY_BIND and key~="None" then
            settings.FLY=not settings.FLY
            if not settings.FLY then stopFly() end
            if flyToggleObj then flyToggleObj.setState(settings.FLY,true) end
        end

        if key==settings.NOCLIP_BIND and key~="None" then
            settings.NOCLIP=not settings.NOCLIP
            if noclipToggleObj then noclipToggleObj.setState(settings.NOCLIP,true) end
        end

        if key==settings.SPEED_BIND and key~="None" then
            settings.SPEED_HACK=not settings.SPEED_HACK
            if speedToggleObj then speedToggleObj.setState(settings.SPEED_HACK,true) end
            if LP.Character then
                local h=getHumanoid(LP.Character)
                if h then h.WalkSpeed=settings.SPEED_HACK and (16*settings.SPEED_AMOUNT) or 16 end
            end
        end

        if key==settings.ESP_BIND and key~="None" then
            settings.ESP=not settings.ESP
            if espToggleObj then espToggleObj.setState(settings.ESP,true) end
            updateESP()
        end

        if key==settings.GODMODE_BIND and key~="None" then
            settings.GODMODE=not settings.GODMODE
            if godmodeToggleObj then godmodeToggleObj.setState(settings.GODMODE,true) end
            if settings.GODMODE then
                applyGodMode()
            else
                stopGodMode()
            end
        end
    end)
end)

-- ── RESPAWN ───────────────────────────────────────────────────────────────────
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    pcall(function()
        flying=false; stopFly()
        stopGodMode()
        if settings.ESP then updateESP() end
        if settings.SPEED_HACK then
            task.wait(0.2)
            local h=getHumanoid(char); if h then h.WalkSpeed=16*settings.SPEED_AMOUNT end
        end
        if settings.GODMODE then
            task.wait(0.2)
            applyGodMode()
        end
    end)
end)

-- ── INIT ──────────────────────────────────────────────────────────────────────
task.spawn(function()
    repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    task.wait(0.8)
    toggleMenu(true)
end)

sendNotification("Menu","Loaded! F1 to toggle.",5)
