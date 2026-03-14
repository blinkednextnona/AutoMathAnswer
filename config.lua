--[[
    ╔═══════════════════════════════════════════════╗
    ║  CONFIG — Colors, Layout, Fonts, Keybinds     ║
    ╚═══════════════════════════════════════════════╝
    
    Edit these values to customize the look and feel.
    All other files reference this CONFIG table.
]]

local CONFIG = {
    -- ── Background & Surface ──────────────────────
    Background        = Color3.fromRGB(15, 15, 20),     -- Main window background
    BackgroundSecond  = Color3.fromRGB(20, 20, 28),     -- Sidebar background
    Surface           = Color3.fromRGB(25, 25, 35),     -- Element backgrounds (toggles, buttons)
    SurfaceHover      = Color3.fromRGB(32, 32, 45),     -- Element hover state
    Border            = Color3.fromRGB(40, 40, 55),     -- Borders & dividers

    -- ── Accent Colors ─────────────────────────────
    Accent            = Color3.fromRGB(88, 101, 242),   -- Primary accent (soft indigo)
    AccentHover       = Color3.fromRGB(108, 121, 255),  -- Accent hover state

    -- ── Text Colors ───────────────────────────────
    TextPrimary       = Color3.fromRGB(235, 235, 245),  -- Main text
    TextSecondary     = Color3.fromRGB(145, 145, 165),  -- Secondary/label text
    TextMuted         = Color3.fromRGB(90, 90, 110),    -- Muted/section headers

    -- ── Semantic Colors ───────────────────────────
    Success           = Color3.fromRGB(72, 199, 142),   -- Green (toggles on, success notifs)
    Warning           = Color3.fromRGB(250, 176, 67),   -- Yellow (warnings)
    Error             = Color3.fromRGB(237, 95, 95),    -- Red (errors, toggle off)

    -- ── Layout ────────────────────────────────────
    WindowWidth       = 520,                             -- Window width in pixels
    WindowHeight      = 380,                             -- Window height in pixels
    CornerRadius      = UDim.new(0, 10),                 -- Main corner rounding
    SmallRadius       = UDim.new(0, 6),                  -- Small element rounding

    -- ── Animation ─────────────────────────────────
    TweenSpeed        = 0.3,                             -- Default animation duration
    TweenEase         = Enum.EasingStyle.Quint,          -- Default easing style

    -- ── Fonts ─────────────────────────────────────
    Font              = Enum.Font.GothamBold,            -- Titles, headers
    FontMedium        = Enum.Font.GothamMedium,          -- Labels, toggle text
    FontRegular       = Enum.Font.Gotham,                -- Body text, descriptions

    -- ── Keybind ───────────────────────────────────
    ToggleKey         = Enum.KeyCode.RightShift,         -- Key to show/hide UI

    -- ── Window Title ──────────────────────────────
    Title             = "CLEAN UI",
    Subtitle          = "Auto Answer",
}

return CONFIG
