--[[
    ╔═══════════════════════════════════════════════╗
    ║  TOP BAR — Title, Close, Minimize, Dragging   ║
    ╚═══════════════════════════════════════════════╝
    
    • Accent line at the top
    • Title + subtitle labels
    • Close (✕) and Minimize (─) buttons with hover
    • Drag-to-move from the top bar area
]]

local Dragging, DragInput, DragStart, StartPos

local function DragUpdate(input)
    local delta = input.Position - DragStart
    local targetPos = UDim2.new(
        StartPos.X.Scale, StartPos.X.Offset + delta.X,
        StartPos.Y.Scale, StartPos.Y.Offset + delta.Y
    )
    Tween(MainFrame, {Position = targetPos}, 0.08, Enum.EasingStyle.Quart)
    Shadow.Position = targetPos
end

local TopBar = Create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = CONFIG.Background,
    BorderSizePixel = 0,
    Parent = MainFrame
})

-- Accent line
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = CONFIG.Accent,
    BorderSizePixel = 0,
    Parent = TopBar
})

-- Title
Create("TextLabel", {
    Position = UDim2.new(0, 16, 0, 2),
    Size = UDim2.new(0, 200, 1, -2),
    BackgroundTransparency = 1,
    Text = CONFIG.Title,
    TextColor3 = CONFIG.TextPrimary,
    TextSize = 14,
    Font = CONFIG.Font,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

-- Subtitle
Create("TextLabel", {
    Position = UDim2.new(0, 100, 0, 2),
    Size = UDim2.new(0, 100, 1, -2),
    BackgroundTransparency = 1,
    Text = CONFIG.Subtitle,
    TextColor3 = CONFIG.TextMuted,
    TextSize = 11,
    Font = CONFIG.FontRegular,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

-- Close button
local CloseBtn = Create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 1),
    Size = UDim2.new(0, 28, 0, 28),
    BackgroundTransparency = 1,
    Text = "✕",
    TextColor3 = CONFIG.TextSecondary,
    TextSize = 14,
    Font = CONFIG.Font,
    Parent = TopBar
})
AddCorner(CloseBtn, CONFIG.SmallRadius)

-- Minimize button
local MinBtn = Create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -42, 0.5, 1),
    Size = UDim2.new(0, 28, 0, 28),
    BackgroundTransparency = 1,
    Text = "─",
    TextColor3 = CONFIG.TextSecondary,
    TextSize = 14,
    Font = CONFIG.Font,
    Parent = TopBar
})
AddCorner(MinBtn, CONFIG.SmallRadius)

-- Hover effects
for _, btn in pairs({CloseBtn, MinBtn}) do
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.5, TextColor3 = CONFIG.TextPrimary}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundTransparency = 1, TextColor3 = CONFIG.TextSecondary}, 0.15)
    end)
end

-- Drag handling
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        DragUpdate(input)
    end
end)

-- Divider line under top bar
Create("Frame", {
    Position = UDim2.new(0, 0, 0, 44),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = CONFIG.Border,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    Parent = MainFrame
})
