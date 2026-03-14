--[[
    ╔═══════════════════════════════════════════════╗
    ║  UTILITY — Helper functions used everywhere   ║
    ╚═══════════════════════════════════════════════╝
    
    Tween()       — Smooth property animations
    Create()      — Quick Instance.new wrapper
    AddCorner()   — UICorner shorthand
    AddStroke()   — UIStroke shorthand
    AddPadding()  — UIPadding shorthand
]]

local TweenService = game:GetService("TweenService")

-- Animate any property on any instance
local function Tween(object, props, duration, style, direction)
    local tween = TweenService:Create(object, TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), props)
    tween:Play()
    return tween
end

-- Create an Instance with properties and optional children
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

-- Add rounded corners
local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or UDim.new(0, 10),
        Parent = parent
    })
end

-- Add a border stroke
local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(40, 40, 55),
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
end

-- Add padding to a container
local function AddPadding(parent, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
        PaddingLeft = UDim.new(0, left or 8),
        PaddingRight = UDim.new(0, right or 8),
        Parent = parent
    })
end

return {
    Tween = Tween,
    Create = Create,
    AddCorner = AddCorner,
    AddStroke = AddStroke,
    AddPadding = AddPadding,
}
