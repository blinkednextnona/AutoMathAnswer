--[[
    ╔═══════════════════════════════════════════════╗
    ║  NOTIFICATIONS — Toast popup system           ║
    ╚═══════════════════════════════════════════════╝
    
    Notify(title, message, duration, type)
    
    Types: "success" (green), "warning" (yellow), "error" (red), nil (accent)
    
    Notifications stack from the bottom-right corner
    and auto-dismiss after the specified duration.
]]

local NotifHolder = Create("Frame", {
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -20, 1, -20),
    Size = UDim2.new(0, 250, 0, 300),
    BackgroundTransparency = 1,
    Parent = ScreenGui
})

Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Parent = NotifHolder
})

local function Notify(title, message, duration, nType)
    local color = CONFIG.Accent
    if nType == "success" then color = CONFIG.Success
    elseif nType == "warning" then color = CONFIG.Warning
    elseif nType == "error" then color = CONFIG.Error end

    local n = Create("Frame", {
        Size = UDim2.new(0, 250, 0, 0),
        BackgroundColor3 = CONFIG.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotifHolder
    })
    AddCorner(n, CONFIG.SmallRadius)
    AddStroke(n, CONFIG.Border, 1)

    -- Colored accent bar on left
    Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = n
    })

    -- Title
    Create("TextLabel", {
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(1, -24, 0, 16),
        BackgroundTransparency = 1,
        Text = title or "",
        TextColor3 = CONFIG.TextPrimary,
        TextSize = 12,
        Font = CONFIG.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = n
    })

    -- Message
    Create("TextLabel", {
        Position = UDim2.new(0, 14, 0, 28),
        Size = UDim2.new(1, -24, 0, 28),
        BackgroundTransparency = 1,
        Text = message or "",
        TextColor3 = CONFIG.TextSecondary,
        TextSize = 11,
        Font = CONFIG.FontRegular,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = n
    })

    -- Animate in
    Tween(n, {Size = UDim2.new(0, 250, 0, 64)}, 0.35)

    -- Animate out + destroy
    task.delay(duration or 3, function()
        Tween(n, {Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        pcall(function() n:Destroy() end)
    end)
end
