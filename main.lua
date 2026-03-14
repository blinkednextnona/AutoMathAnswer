--[[
    ╔═══════════════════════════════════════════════╗
    ║           CLEAN UI - Auto Answer              ║
    ╚═══════════════════════════════════════════════╝
]]

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- ═══════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════
local CONFIG = {
    Background        = Color3.fromRGB(15, 15, 20),
    BackgroundSecond  = Color3.fromRGB(20, 20, 28),
    Surface           = Color3.fromRGB(25, 25, 35),
    SurfaceHover      = Color3.fromRGB(32, 32, 45),
    Border            = Color3.fromRGB(40, 40, 55),
    Accent            = Color3.fromRGB(88, 101, 242),
    AccentHover       = Color3.fromRGB(108, 121, 255),
    TextPrimary       = Color3.fromRGB(235, 235, 245),
    TextSecondary     = Color3.fromRGB(145, 145, 165),
    TextMuted         = Color3.fromRGB(90, 90, 110),
    Success           = Color3.fromRGB(72, 199, 142),
    Warning           = Color3.fromRGB(250, 176, 67),
    Error             = Color3.fromRGB(237, 95, 95),
    WindowWidth       = 520,
    WindowHeight      = 380,
    CornerRadius      = UDim.new(0, 10),
    SmallRadius       = UDim.new(0, 6),
    TweenSpeed        = 0.3,
    TweenEase         = Enum.EasingStyle.Quint,
    Font              = Enum.Font.GothamBold,
    FontMedium        = Enum.Font.GothamMedium,
    FontRegular       = Enum.Font.Gotham,
    ToggleKey         = Enum.KeyCode.RightShift,
    Title             = "CLEAN UI",
    Subtitle          = "Auto Answer",
}

-- ═══════════════════════════════════════
-- UTILITY
-- ═══════════════════════════════════════
local function Tween(object, props, duration, style, direction)
    local tween = TweenService:Create(object, TweenInfo.new(
        duration or CONFIG.TweenSpeed,
        style or CONFIG.TweenEase,
        direction or Enum.EasingDirection.Out
    ), props)
    tween:Play()
    return tween
end

local function Create(className, props, children)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, c in pairs(children or {}) do
        c.Parent = inst
    end
    return inst
end

local function AddCorner(p, r)
    return Create("UICorner", {CornerRadius = r or CONFIG.CornerRadius, Parent = p})
end

local function AddStroke(p, c, t)
    return Create("UIStroke", {Color = c or CONFIG.Border, Thickness = t or 1, Transparency = 0.5, Parent = p})
end

local function AddPadding(p, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8), PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 8), PaddingRight = UDim.new(0, r or 8), Parent = p
    })
end

-- ═══════════════════════════════════════
-- DESTROY OLD GUI IF RE-RUNNING
-- ═══════════════════════════════════════
local pg = Player:WaitForChild("PlayerGui")
if pg:FindFirstChild("CleanUI") then
    pg.CleanUI:Destroy()
end

-- ═══════════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════════
local ScreenGui = Create("ScreenGui", {
    Name = "CleanUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- Try executor-specific GUI protection
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
        return
    end
end)
pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
        return
    end
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = pg
end

local Shadow = Create("ImageLabel", {
    Name = "Shadow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, CONFIG.WindowWidth + 40, 0, CONFIG.WindowHeight + 40),
    BackgroundTransparency = 1,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.4,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    Parent = ScreenGui
})

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, CONFIG.WindowWidth, 0, CONFIG.WindowHeight),
    BackgroundColor3 = CONFIG.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})
AddCorner(MainFrame)
AddStroke(MainFrame, CONFIG.Border, 1)

-- ═══════════════════════════════════════
-- DRAGGING
-- ═══════════════════════════════════════
local Dragging, DragInput, DragStart, StartPos

local function DragUpdate(input)
    local delta = input.Position - DragStart
    local targetPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    Tween(MainFrame, {Position = targetPos}, 0.08, Enum.EasingStyle.Quart)
    Shadow.Position = targetPos
end

-- ═══════════════════════════════════════
-- TOP BAR
-- ═══════════════════════════════════════
local TopBar = Create("Frame", {
    Name = "TopBar", Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = CONFIG.Background, BorderSizePixel = 0, Parent = MainFrame
})

Create("Frame", {Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0, Parent = TopBar})

Create("TextLabel", {
    Position = UDim2.new(0, 16, 0, 2), Size = UDim2.new(0, 200, 1, -2),
    BackgroundTransparency = 1, Text = CONFIG.Title,
    TextColor3 = CONFIG.TextPrimary, TextSize = 14, Font = CONFIG.Font,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar
})

Create("TextLabel", {
    Position = UDim2.new(0, 100, 0, 2), Size = UDim2.new(0, 100, 1, -2),
    BackgroundTransparency = 1, Text = CONFIG.Subtitle,
    TextColor3 = CONFIG.TextMuted, TextSize = 11, Font = CONFIG.FontRegular,
    TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar
})

local CloseBtn = Create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 1),
    Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1,
    Text = "✕", TextColor3 = CONFIG.TextSecondary, TextSize = 14, Font = CONFIG.Font, Parent = TopBar
})
AddCorner(CloseBtn, CONFIG.SmallRadius)

local MinBtn = Create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 1),
    Size = UDim2.new(0, 28, 0, 28), BackgroundTransparency = 1,
    Text = "─", TextColor3 = CONFIG.TextSecondary, TextSize = 14, Font = CONFIG.Font, Parent = TopBar
})
AddCorner(MinBtn, CONFIG.SmallRadius)

for _, btn in pairs({CloseBtn, MinBtn}) do
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0.5, TextColor3 = CONFIG.TextPrimary}, 0.15) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 1, TextColor3 = CONFIG.TextSecondary}, 0.15) end)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then DragUpdate(input) end
end)

Create("Frame", {Position = UDim2.new(0,0,0,44), Size = UDim2.new(1,0,0,1), BackgroundColor3 = CONFIG.Border, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = MainFrame})

-- ═══════════════════════════════════════
-- SIDEBAR
-- ═══════════════════════════════════════
local Sidebar = Create("Frame", {
    Position = UDim2.new(0,0,0,45), Size = UDim2.new(0,130,1,-45),
    BackgroundColor3 = CONFIG.BackgroundSecond, BorderSizePixel = 0, Parent = MainFrame
})
Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,2), Parent = Sidebar})
AddPadding(Sidebar, 8, 8, 6, 6)
Create("Frame", {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,0,0,0), Size = UDim2.new(0,1,1,0), BackgroundColor3 = CONFIG.Border, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = Sidebar})

local ContentArea = Create("Frame", {
    Position = UDim2.new(0,131,0,45), Size = UDim2.new(1,-131,1,-45),
    BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Parent = MainFrame
})

-- ═══════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════
local NotifHolder = Create("Frame", {
    AnchorPoint = Vector2.new(1,1), Position = UDim2.new(1,-20,1,-20),
    Size = UDim2.new(0,250,0,300), BackgroundTransparency = 1, Parent = ScreenGui
})
Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,6), VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = NotifHolder})

local function Notify(title, message, duration, nType)
    local color = CONFIG.Accent
    if nType == "success" then color = CONFIG.Success
    elseif nType == "warning" then color = CONFIG.Warning
    elseif nType == "error" then color = CONFIG.Error end

    local n = Create("Frame", {Size = UDim2.new(0,250,0,0), BackgroundColor3 = CONFIG.Surface, BorderSizePixel = 0, ClipsDescendants = true, Parent = NotifHolder})
    AddCorner(n, CONFIG.SmallRadius)
    AddStroke(n, CONFIG.Border, 1)
    Create("Frame", {Size = UDim2.new(0,3,1,0), BackgroundColor3 = color, BorderSizePixel = 0, Parent = n})
    Create("TextLabel", {Position = UDim2.new(0,14,0,10), Size = UDim2.new(1,-24,0,16), BackgroundTransparency = 1, Text = title or "", TextColor3 = CONFIG.TextPrimary, TextSize = 12, Font = CONFIG.Font, TextXAlignment = Enum.TextXAlignment.Left, Parent = n})
    Create("TextLabel", {Position = UDim2.new(0,14,0,28), Size = UDim2.new(1,-24,0,28), BackgroundTransparency = 1, Text = message or "", TextColor3 = CONFIG.TextSecondary, TextSize = 11, Font = CONFIG.FontRegular, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = n})
    Tween(n, {Size = UDim2.new(0,250,0,64)}, 0.35)
    task.delay(duration or 3, function()
        Tween(n, {Size = UDim2.new(0,250,0,0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        pcall(function() n:Destroy() end)
    end)
end

-- ═══════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════
local Library = {}
local Tabs = {}
local ActiveTab = nil
local TabButtons = {}
local TabPages = {}

function Library:AddTab(name, icon)
    local idx = #Tabs + 1

    local TabBtn = Create("TextButton", {
        Name = name, Size = UDim2.new(1,0,0,34), BackgroundColor3 = CONFIG.Accent,
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", LayoutOrder = idx, Parent = Sidebar
    })
    AddCorner(TabBtn, CONFIG.SmallRadius)

    Create("TextLabel", {
        Name = "Icon", Position = UDim2.new(0,10,0,0), Size = UDim2.new(0,20,1,0),
        BackgroundTransparency = 1, Text = icon or "•", TextColor3 = CONFIG.TextMuted,
        TextSize = 14, Font = CONFIG.FontRegular, Parent = TabBtn
    })
    local TabName = Create("TextLabel", {
        Name = "Label", Position = UDim2.new(0,32,0,0), Size = UDim2.new(1,-42,1,0),
        BackgroundTransparency = 1, Text = name, TextColor3 = CONFIG.TextSecondary,
        TextSize = 12, Font = CONFIG.FontMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = TabBtn
    })

    local TabPage = Create("ScrollingFrame", {
        Name = name, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = CONFIG.Accent, ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, Parent = ContentArea
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,4), Parent = TabPage})
    AddPadding(TabPage, 10, 10, 14, 14)

    TabBtn.MouseEnter:Connect(function()
        if ActiveTab ~= idx then
            Tween(TabBtn, {BackgroundTransparency = 0.85}, 0.15)
            Tween(TabName, {TextColor3 = CONFIG.TextPrimary}, 0.15)
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if ActiveTab ~= idx then
            Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            Tween(TabName, {TextColor3 = CONFIG.TextSecondary}, 0.15)
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        if ActiveTab == idx then return end
        if ActiveTab then
            Tween(TabButtons[ActiveTab], {BackgroundTransparency = 1}, 0.2)
            for _, c in pairs(TabButtons[ActiveTab]:GetChildren()) do
                if c:IsA("TextLabel") then
                    Tween(c, {TextColor3 = c.Name == "Icon" and CONFIG.TextMuted or CONFIG.TextSecondary}, 0.2)
                end
            end
            TabPages[ActiveTab].Visible = false
        end
        ActiveTab = idx
        Tween(TabBtn, {BackgroundTransparency = 0.85}, 0.2)
        for _, c in pairs(TabBtn:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c, {TextColor3 = CONFIG.TextPrimary}, 0.2) end
        end
        TabPage.Visible = true
    end)

    TabButtons[idx] = TabBtn
    TabPages[idx] = TabPage
    table.insert(Tabs, name)

    if idx == 1 then
        ActiveTab = 1
        TabBtn.BackgroundTransparency = 0.85
        for _, c in pairs(TabBtn:GetChildren()) do
            if c:IsA("TextLabel") then c.TextColor3 = CONFIG.TextPrimary end
        end
        TabPage.Visible = true
    end

    local Tab = {Page = TabPage}

    function Tab:AddSection(text)
        return Create("TextLabel", {
            Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1, Text = string.upper(text),
            TextColor3 = CONFIG.TextMuted, TextSize = 10, Font = CONFIG.Font,
            TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
    end

    function Tab:AddToggle(text, default, callback)
        callback = callback or function() end
        local toggled = default or false

        local Frame = Create("Frame", {Size = UDim2.new(1,0,0,38), BackgroundColor3 = CONFIG.Surface, BorderSizePixel = 0, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage})
        AddCorner(Frame, CONFIG.SmallRadius)
        Create("TextLabel", {Position = UDim2.new(0,12,0,0), Size = UDim2.new(1,-60,1,0), BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TextPrimary, TextSize = 12, Font = CONFIG.FontMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})

        local Track = Create("Frame", {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.new(0,36,0,20), BackgroundColor3 = toggled and CONFIG.Accent or CONFIG.Border, BorderSizePixel = 0, Parent = Frame})
        AddCorner(Track, UDim.new(1,0))
        local Knob = Create("Frame", {AnchorPoint = Vector2.new(0,0.5), Position = toggled and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0), Size = UDim2.new(0,16,0,16), BackgroundColor3 = CONFIG.TextPrimary, BorderSizePixel = 0, Parent = Track})
        AddCorner(Knob, UDim.new(1,0))

        local Btn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = Frame})
        Btn.MouseEnter:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.SurfaceHover}, 0.15) end)
        Btn.MouseLeave:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.Surface}, 0.15) end)
        Btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            Tween(Track, {BackgroundColor3 = toggled and CONFIG.Accent or CONFIG.Border}, 0.2)
            Tween(Knob, {Position = toggled and UDim2.new(1,-18,0.5,0) or UDim2.new(0,2,0.5,0)}, 0.2)
            callback(toggled)
        end)
        return Frame
    end

    function Tab:AddButton(text, callback)
        callback = callback or function() end
        local Btn = Create("TextButton", {Size = UDim2.new(1,0,0,36), BackgroundColor3 = CONFIG.Surface, BorderSizePixel = 0, Text = text, TextColor3 = CONFIG.TextPrimary, TextSize = 12, Font = CONFIG.FontMedium, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage})
        AddCorner(Btn, CONFIG.SmallRadius)
        Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = CONFIG.SurfaceHover}, 0.15) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = CONFIG.Surface}, 0.15) end)
        Btn.MouseButton1Click:Connect(function()
            Tween(Btn, {BackgroundColor3 = CONFIG.Accent}, 0.1)
            task.wait(0.12)
            Tween(Btn, {BackgroundColor3 = CONFIG.Surface}, 0.2)
            callback()
        end)
        return Btn
    end

    function Tab:AddSlider(text, min, max, default, callback)
        callback = callback or function() end
        min = min or 0; max = max or 100; default = default or min

        local Frame = Create("Frame", {Size = UDim2.new(1,0,0,50), BackgroundColor3 = CONFIG.Surface, BorderSizePixel = 0, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage})
        AddCorner(Frame, CONFIG.SmallRadius)
        Create("TextLabel", {Position = UDim2.new(0,12,0,6), Size = UDim2.new(1,-60,0,18), BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TextPrimary, TextSize = 12, Font = CONFIG.FontMedium, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
        local ValLabel = Create("TextLabel", {AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-12,0,6), Size = UDim2.new(0,40,0,18), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = CONFIG.Accent, TextSize = 12, Font = CONFIG.Font, TextXAlignment = Enum.TextXAlignment.Right, Parent = Frame})

        local TrackBar = Create("Frame", {AnchorPoint = Vector2.new(0.5,0), Position = UDim2.new(0.5,0,0,32), Size = UDim2.new(1,-24,0,4), BackgroundColor3 = CONFIG.Border, BorderSizePixel = 0, Parent = Frame})
        AddCorner(TrackBar, UDim.new(1,0))
        local Fill = Create("Frame", {Size = UDim2.new((default-min)/(max-min),0,1,0), BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0, Parent = TrackBar})
        AddCorner(Fill, UDim.new(1,0))
        local SKnob = Create("Frame", {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new((default-min)/(max-min),0,0.5,0), Size = UDim2.new(0,12,0,12), BackgroundColor3 = CONFIG.TextPrimary, BorderSizePixel = 0, Parent = TrackBar})
        AddCorner(SKnob, UDim.new(1,0))

        local sliding = false
        local SBtn = Create("TextButton", {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "", Parent = Frame})

        local function update(input)
            local rel = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            Tween(Fill, {Size = UDim2.new(rel,0,1,0)}, 0.08)
            Tween(SKnob, {Position = UDim2.new(rel,0,0.5,0)}, 0.08)
            ValLabel.Text = tostring(val)
            callback(val)
        end

        SBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; update(i) end end)
        SBtn.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
        UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
        SBtn.MouseEnter:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.SurfaceHover}, 0.15) end)
        SBtn.MouseLeave:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.Surface}, 0.15) end)
        return Frame
    end

    function Tab:AddLabel(text)
        local L = Create("TextLabel", {Size = UDim2.new(1,0,0,22), BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TextSecondary, TextSize = 11, Font = CONFIG.FontRegular, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage})
        return {SetText = function(_, t) L.Text = t end}
    end

    function Tab:AddSeparator()
        local S = Create("Frame", {Size = UDim2.new(1,0,0,8), BackgroundTransparency = 1, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage})
        Create("Frame", {AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,0,1), BackgroundColor3 = CONFIG.Border, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = S})
    end

    return Tab
end

-- ═══════════════════════════════════════
-- OPEN / CLOSE
-- ═══════════════════════════════════════
local isOpen = true

local function CloseUI()
    isOpen = false
    Tween(MainFrame, {Size = UDim2.new(0, CONFIG.WindowWidth, 0, 0)}, 0.35)
    Tween(Shadow, {ImageTransparency = 1}, 0.3)
    task.wait(0.35)
    MainFrame.Visible = false
    Shadow.Visible = false
end

local function OpenUI()
    MainFrame.Visible = true
    Shadow.Visible = true
    MainFrame.Size = UDim2.new(0, CONFIG.WindowWidth, 0, 0)
    isOpen = true
    Tween(MainFrame, {Size = UDim2.new(0, CONFIG.WindowWidth, 0, CONFIG.WindowHeight)}, 0.4, Enum.EasingStyle.Back)
    Tween(Shadow, {ImageTransparency = 0.4}, 0.35)
end

CloseBtn.MouseButton1Click:Connect(CloseUI)
MinBtn.MouseButton1Click:Connect(CloseUI)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CONFIG.ToggleKey then
        if isOpen then CloseUI() else OpenUI() end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- MATH PARSER (no loadstring needed)
-- ═══════════════════════════════════════════════════════════
local function SolveMath(expression)
    local mathPart = expression:match("(.-)%s*=") or expression
    mathPart = mathPart:gsub("[xX]", "*")
    mathPart = mathPart:gsub("[^%d%+%-%*/%.%(%)%^]", "")

    if not mathPart or mathPart == "" then return nil end

    local pos = 1
    local function peek() return mathPart:sub(pos, pos) end
    local function advance() local c = peek(); pos = pos + 1; return c end

    local parseExpr

    local function parseNumber()
        local s = pos
        while pos <= #mathPart and mathPart:sub(pos,pos):match("[%d%.]") do pos = pos + 1 end
        if pos == s then return nil end
        return tonumber(mathPart:sub(s, pos - 1))
    end

    local function parseAtom()
        local c = peek()
        if c == "(" then
            advance()
            local v = parseExpr()
            if peek() == ")" then advance() end
            return v
        end
        if c == "-" then advance(); local v = parseAtom(); return v and -v end
        if c == "+" then advance(); return parseAtom() end
        return parseNumber()
    end

    local function parsePower()
        local b = parseAtom()
        if not b then return nil end
        if peek() == "^" then advance(); local e = parsePower(); if e then return b ^ e end end
        return b
    end

    local function parseTerm()
        local left = parsePower()
        if not left then return nil end
        while true do
            local c = peek()
            if c == "*" then advance(); local r = parsePower(); if r then left = left * r else break end
            elseif c == "/" then advance(); local r = parsePower(); if r and r ~= 0 then left = left / r else break end
            else break end
        end
        return left
    end

    parseExpr = function()
        local left = parseTerm()
        if not left then return nil end
        while true do
            local c = peek()
            if c == "+" then advance(); local r = parseTerm(); if r then left = left + r else break end
            elseif c == "-" then advance(); local r = parseTerm(); if r then left = left - r else break end
            else break end
        end
        return left
    end

    local ok, result = pcall(function() pos = 1; return parseExpr() end)
    if ok and result then
        if result == math.floor(result) then
            return tostring(math.floor(result))
        else
            return tostring(math.floor(result * 100 + 0.5) / 100)
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- LAZY FINDERS (non-blocking, pcall wrapped)
-- ═══════════════════════════════════════════════════════════
local QUESTION_LABEL = nil

local function FindQuestionLabel()
    local ok, result = pcall(function()
        return workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer.QuestionText
    end)
    if ok and result then return result end
    return nil
end

local function FindAnswerBox()
    -- Try the exact known path first (works for any account)
    local ok, box = pcall(function()
        return Player.PlayerGui.MainGui.MainFrame.GameFrame.PCTextBoxContainer.TextBox
    end)
    if ok and box and box:IsA("TextBox") then return box end

    -- Fallback: search all ScreenGuis for a TextBox named "TextBox" inside anything with "PCTextBox" or "GameFrame"
    for _, gui in pairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "CleanUI" then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextBox") and desc.Parent and desc.Parent.Name:find("PCTextBox") then
                    return desc
                end
            end
        end
    end

    -- Last resort: just grab any TextBox that isn't in our UI or a skin/search bar
    for _, gui in pairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "CleanUI" then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextBox") and not desc:GetFullName():find("Skin") and not desc:GetFullName():find("Navigation") then
                    return desc
                end
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════════════════════
local autoEnabled = false
local lastAnswered = ""
local solveCount = 0
local typingSpeed = {min = 0.05, max = 0.15}
local isTyping = false

-- Try to get VirtualInputManager for real key simulation
local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)

local function PressEnter()
    -- Method 1: VirtualInputManager (most reliable)
    if VIM then
        pcall(function()
            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end)
        return true
    end

    -- Method 2: VirtualUser
    local vu = nil
    pcall(function() vu = game:GetService("VirtualUser") end)
    if vu then
        pcall(function()
            vu:SetKeyDown(Enum.KeyCode.Return)
            task.wait(0.05)
            vu:SetKeyUp(Enum.KeyCode.Return)
        end)
        return true
    end

    return false
end

local function EmulateTyping(text, textbox)
    if not textbox or not textbox:IsA("TextBox") then return end
    isTyping = true

    -- Focus the textbox
    pcall(function() textbox:CaptureFocus() end)
    task.wait(0.2)

    -- Clear and type character by character
    textbox.Text = ""
    task.wait(0.05)

    for i = 1, #text do
        textbox.Text = textbox.Text .. text:sub(i, i)
        task.wait(typingSpeed.min + math.random() * (typingSpeed.max - typingSpeed.min))
    end

    -- Wait a moment so the game registers the full text
    task.wait(0.3)

    -- Make sure text is still there before submitting
    local finalText = textbox.Text
    if finalText ~= text then
        textbox.Text = text
        task.wait(0.1)
    end

    -- Try pressing Enter via VIM first
    local pressedEnter = PressEnter()

    -- Then also fire FocusLost manually with enterPressed = true
    -- This is what most Roblox games actually listen for
    pcall(function()
        -- firesignal is available in most executors (Synapse, Script-Ware, Fluxus, etc.)
        if firesignal then
            firesignal(textbox.FocusLost, true) -- true = enterPressed
        end
    end)

    -- Also try the normal ReleaseFocus as backup
    task.wait(0.05)
    pcall(function() textbox:ReleaseFocus(true) end)

    -- Final safety: if text got wiped, set it back and refire
    task.wait(0.15)
    if textbox.Text == "" and finalText ~= "" then
        textbox:CaptureFocus()
        task.wait(0.1)
        textbox.Text = text
        task.wait(0.2)
        PressEnter()
        task.wait(0.05)
        pcall(function()
            if firesignal then
                firesignal(textbox.FocusLost, true)
            end
        end)
        pcall(function() textbox:ReleaseFocus(true) end)
    end

    isTyping = false
end

-- ═══════════════════════════════════════════════════════════
-- BUILD TABS (statusLabel defined BEFORE main loop uses it)
-- ═══════════════════════════════════════════════════════════
local HomeTab = Library:AddTab("Home", "🏠")
HomeTab:AddSection("Auto Answer")
HomeTab:AddLabel("Reads math questions and auto-types the answer.")
HomeTab:AddSeparator()

local statusLabel = HomeTab:AddLabel("Status: Disabled")
local questionPreview = HomeTab:AddLabel("Question: Waiting...")
local answerPreview = HomeTab:AddLabel("Answer: —")

HomeTab:AddSeparator()

HomeTab:AddToggle("Auto Answer", false, function(state)
    autoEnabled = state
    if state then
        lastAnswered = ""
        statusLabel:SetText("Status: Enabled — Watching...")
        Notify("Auto Answer", "Enabled!", 3, "success")
    else
        statusLabel:SetText("Status: Disabled")
        Notify("Auto Answer", "Disabled.", 2, "error")
    end
end)

HomeTab:AddSeparator()
HomeTab:AddSection("Typing Speed")

HomeTab:AddSlider("Min Delay (ms)", 20, 200, 50, function(v)
    typingSpeed.min = v / 1000
end)

HomeTab:AddSlider("Max Delay (ms)", 50, 500, 150, function(v)
    typingSpeed.max = v / 1000
end)

local SettingsTab = Library:AddTab("Settings", "⚙️")
SettingsTab:AddSection("UI Settings")
SettingsTab:AddButton("Reset Position", function()
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Notify("Settings", "Position reset.", 2)
end)
SettingsTab:AddButton("Destroy UI", function()
    autoEnabled = false
    ScreenGui:Destroy()
end)
SettingsTab:AddSeparator()
SettingsTab:AddLabel("Toggle UI: RightShift")
SettingsTab:AddLabel("Drag the top bar to move.")
SettingsTab:AddSeparator()
local statsLabel = SettingsTab:AddLabel("Solved: 0")

-- ═══════════════════════════════════════════════════════════
-- MAIN LOOP (polls every 0.5s, completely non-blocking)
-- ═══════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(0.5)

        -- Lazy-find the question label (retries each loop if not found)
        if not QUESTION_LABEL or not QUESTION_LABEL.Parent then
            QUESTION_LABEL = FindQuestionLabel()
        end

        if not QUESTION_LABEL then
            questionPreview:SetText("Question: [Waiting for map...]")
            answerPreview:SetText("Answer: —")
            continue
        end

        -- Read question text safely
        local ok, questionText = pcall(function() return QUESTION_LABEL.Text end)
        if not ok or not questionText or questionText == "" then
            questionPreview:SetText("Question: [Empty]")
            answerPreview:SetText("Answer: —")
            continue
        end

        questionPreview:SetText("Question: " .. questionText)

        if not questionText:find("=") then
            answerPreview:SetText("Answer: [No = sign]")
            continue
        end

        local answer = SolveMath(questionText)
        if answer then
            answerPreview:SetText("Answer: " .. answer)
        else
            answerPreview:SetText("Answer: [Can't parse]")
            continue
        end

        -- Auto-type if enabled, new question, not currently typing
        if autoEnabled and questionText ~= lastAnswered and not isTyping and answer then
            lastAnswered = questionText
            solveCount = solveCount + 1
            statsLabel:SetText("Solved: " .. tostring(solveCount))
            statusLabel:SetText("Status: Typing #" .. solveCount .. "...")

            task.spawn(function()
                local box = FindAnswerBox()
                if box then
                    Notify("Solved", questionText .. " → " .. answer, 3, "success")
                    EmulateTyping(answer, box)
                    statusLabel:SetText("Status: Waiting for next...")
                else
                    Notify("Warning", "Answer: " .. answer .. " but no TextBox found!", 3, "warning")
                    statusLabel:SetText("Status: No input found!")
                end
            end)
        end
    end
end)

-- Startup
task.wait(0.3)
Notify("Clean UI", "Loaded! Toggle Auto Answer in Home tab.", 4, "success")
