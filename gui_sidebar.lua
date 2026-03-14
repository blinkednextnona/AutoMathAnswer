--[[
    ╔═══════════════════════════════════════════════╗
    ║  SIDEBAR — Tab buttons + Content area         ║
    ╚═══════════════════════════════════════════════╝
    
    • Left sidebar with vertical list layout
    • Right-side border separator
    • Content area where tab pages are displayed
]]

local Sidebar = Create("Frame", {
    Position = UDim2.new(0, 0, 0, 45),
    Size = UDim2.new(0, 130, 1, -45),
    BackgroundColor3 = CONFIG.BackgroundSecond,
    BorderSizePixel = 0,
    Parent = MainFrame
})

Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
    Parent = Sidebar
})

AddPadding(Sidebar, 8, 8, 6, 6)

-- Right border on sidebar
Create("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    BackgroundColor3 = CONFIG.Border,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    Parent = Sidebar
})

-- Content area (tab pages go here)
local ContentArea = Create("Frame", {
    Position = UDim2.new(0, 131, 0, 45),
    Size = UDim2.new(1, -131, 1, -45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = MainFrame
})
