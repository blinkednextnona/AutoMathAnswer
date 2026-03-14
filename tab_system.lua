--[[
    ╔═══════════════════════════════════════════════╗
    ║  TAB SYSTEM — Full tab library with elements  ║
    ╚═══════════════════════════════════════════════╝
    
    Library:AddTab(name, icon) → Tab object
    
    Tab methods:
        Tab:AddSection(text)                          → Section header
        Tab:AddToggle(text, default, callback)        → Toggle switch
        Tab:AddButton(text, callback)                 → Clickable button
        Tab:AddSlider(text, min, max, default, cb)    → Draggable slider
        Tab:AddLabel(text)                            → Info label (updatable via :SetText)
        Tab:AddSeparator()                            → Horizontal divider line
    
    Tabs appear in the Sidebar, pages appear in ContentArea.
    First tab is auto-selected on creation.
]]

local Library = {}
local Tabs = {}
local ActiveTab = nil
local TabButtons = {}
local TabPages = {}

function Library:AddTab(name, icon)
    local idx = #Tabs + 1

    -- Sidebar button
    local TabBtn = Create("TextButton", {
        Name = name, Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CONFIG.Accent, BackgroundTransparency = 1,
        BorderSizePixel = 0, Text = "", LayoutOrder = idx, Parent = Sidebar
    })
    AddCorner(TabBtn, CONFIG.SmallRadius)

    Create("TextLabel", {
        Name = "Icon", Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1,
        Text = icon or "•", TextColor3 = CONFIG.TextMuted,
        TextSize = 14, Font = CONFIG.FontRegular, Parent = TabBtn
    })

    local TabName = Create("TextLabel", {
        Name = "Label", Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -42, 1, 0), BackgroundTransparency = 1,
        Text = name, TextColor3 = CONFIG.TextSecondary,
        TextSize = 12, Font = CONFIG.FontMedium,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = TabBtn
    })

    -- Scrollable page
    local TabPage = Create("ScrollingFrame", {
        Name = name, Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = CONFIG.Accent,
        ScrollBarImageTransparency = 0.5, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, Parent = ContentArea
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), Parent = TabPage
    })
    AddPadding(TabPage, 10, 10, 14, 14)

    -- Hover effects
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

    -- Tab switching
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
            if c:IsA("TextLabel") then
                Tween(c, {TextColor3 = CONFIG.TextPrimary}, 0.2)
            end
        end
        TabPage.Visible = true
    end)

    TabButtons[idx] = TabBtn
    TabPages[idx] = TabPage
    table.insert(Tabs, name)

    -- Auto-select first tab
    if idx == 1 then
        ActiveTab = 1
        TabBtn.BackgroundTransparency = 0.85
        for _, c in pairs(TabBtn:GetChildren()) do
            if c:IsA("TextLabel") then c.TextColor3 = CONFIG.TextPrimary end
        end
        TabPage.Visible = true
    end

    -- ── Element Builders ──────────────────────────
    local Tab = {Page = TabPage}

    function Tab:AddSection(text)
        return Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1,
            Text = string.upper(text), TextColor3 = CONFIG.TextMuted,
            TextSize = 10, Font = CONFIG.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
    end

    function Tab:AddToggle(text, default, callback)
        callback = callback or function() end
        local toggled = default or false

        local Frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = CONFIG.Surface,
            BorderSizePixel = 0, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
        AddCorner(Frame, CONFIG.SmallRadius)

        Create("TextLabel", {
            Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -60, 1, 0),
            BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TextPrimary,
            TextSize = 12, Font = CONFIG.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame
        })

        local Track = Create("Frame", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.new(0, 36, 0, 20),
            BackgroundColor3 = toggled and CONFIG.Accent or CONFIG.Border,
            BorderSizePixel = 0, Parent = Frame
        })
        AddCorner(Track, UDim.new(1, 0))

        local Knob = Create("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16), BackgroundColor3 = CONFIG.TextPrimary,
            BorderSizePixel = 0, Parent = Track
        })
        AddCorner(Knob, UDim.new(1, 0))

        local Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = Frame
        })

        Btn.MouseEnter:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.SurfaceHover}, 0.15) end)
        Btn.MouseLeave:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.Surface}, 0.15) end)
        Btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            Tween(Track, {BackgroundColor3 = toggled and CONFIG.Accent or CONFIG.Border}, 0.2)
            Tween(Knob, {Position = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
            callback(toggled)
        end)
        return Frame
    end

    function Tab:AddButton(text, callback)
        callback = callback or function() end
        local Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = CONFIG.Surface,
            BorderSizePixel = 0, Text = text, TextColor3 = CONFIG.TextPrimary,
            TextSize = 12, Font = CONFIG.FontMedium,
            LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
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

        local Frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = CONFIG.Surface,
            BorderSizePixel = 0, LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
        AddCorner(Frame, CONFIG.SmallRadius)

        Create("TextLabel", {
            Position = UDim2.new(0, 12, 0, 6), Size = UDim2.new(1, -60, 0, 18),
            BackgroundTransparency = 1, Text = text, TextColor3 = CONFIG.TextPrimary,
            TextSize = 12, Font = CONFIG.FontMedium,
            TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame
        })

        local ValLabel = Create("TextLabel", {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 6),
            Size = UDim2.new(0, 40, 0, 18), BackgroundTransparency = 1,
            Text = tostring(default), TextColor3 = CONFIG.Accent,
            TextSize = 12, Font = CONFIG.Font,
            TextXAlignment = Enum.TextXAlignment.Right, Parent = Frame
        })

        local TrackBar = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 32),
            Size = UDim2.new(1, -24, 0, 4), BackgroundColor3 = CONFIG.Border,
            BorderSizePixel = 0, Parent = Frame
        })
        AddCorner(TrackBar, UDim.new(1, 0))

        local Fill = Create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0, Parent = TrackBar
        })
        AddCorner(Fill, UDim.new(1, 0))

        local SKnob = Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
            Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = CONFIG.TextPrimary,
            BorderSizePixel = 0, Parent = TrackBar
        })
        AddCorner(SKnob, UDim.new(1, 0))

        local sliding = false
        local SBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = Frame
        })

        local function update(input)
            local rel = math.clamp((input.Position.X - TrackBar.AbsolutePosition.X) / TrackBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            Tween(Fill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.08)
            Tween(SKnob, {Position = UDim2.new(rel, 0, 0.5, 0)}, 0.08)
            ValLabel.Text = tostring(val)
            callback(val)
        end

        SBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; update(i) end
        end)
        SBtn.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
        end)

        SBtn.MouseEnter:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.SurfaceHover}, 0.15) end)
        SBtn.MouseLeave:Connect(function() Tween(Frame, {BackgroundColor3 = CONFIG.Surface}, 0.15) end)
        return Frame
    end

    function Tab:AddLabel(text)
        local L = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
            Text = text, TextColor3 = CONFIG.TextSecondary,
            TextSize = 11, Font = CONFIG.FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
            LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
        return {SetText = function(_, t) L.Text = t end}
    end

    function Tab:AddSeparator()
        local S = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 8), BackgroundTransparency = 1,
            LayoutOrder = #TabPage:GetChildren(), Parent = TabPage
        })
        Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = CONFIG.Border,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0, Parent = S
        })
    end

    return Tab
end
