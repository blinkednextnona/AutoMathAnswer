--[[
    ╔═══════════════════════════════════════════════╗
    ║  GUI CORE — ScreenGui, MainFrame, Shadow      ║
    ╚═══════════════════════════════════════════════╝
    
    Creates the base GUI container with:
    • Executor-specific protection (syn, gethui)
    • Drop shadow behind the window
    • Main clipped frame with rounded corners
    • Auto-destroys old GUI if script is re-run
]]

-- Destroy old instance if re-running
local pg = Player:WaitForChild("PlayerGui")
if pg:FindFirstChild("CleanUI") then
    pg.CleanUI:Destroy()
end

-- Create the ScreenGui
local ScreenGui = Create("ScreenGui", {
    Name = "CleanUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- Executor-specific GUI protection
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

-- Drop shadow
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

-- Main window frame
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
