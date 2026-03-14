--[[
    ╔═══════════════════════════════════════════════╗
    ║  TABS SETUP — Home, Settings, Open/Close      ║
    ╚═══════════════════════════════════════════════╝
    
    Wires up all the UI elements:
    
    Home Tab:
    • Status label, question preview, answer preview
    • Auto Answer toggle
    • Typing speed sliders (min/max delay)
    
    Settings Tab:
    • Reset position button
    • Destroy UI button
    • Keybind info labels
    • Solve count stats
    
    Also handles:
    • Open/close animations
    • RightShift keybind toggle
    • Startup notification
]]

-- ── Open / Close Animations ───────────────────
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

-- ── Home Tab ──────────────────────────────────
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

-- ── Settings Tab ──────────────────────────────
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

-- ── Startup ───────────────────────────────────
task.wait(0.3)
Notify("Clean UI", "Loaded! Toggle Auto Answer in Home tab.", 4, "success")
