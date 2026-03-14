--[[
    ╔═══════════════════════════════════════════════╗
    ║  GAME FINDER — Locates question + answer box  ║
    ╚═══════════════════════════════════════════════╝
    
    FindQuestionLabel()  → TextLabel or nil
    FindAnswerBox()      → TextBox or nil
    
    Both use pcall so they never crash the script.
    Called lazily from the main loop — if the map isn't
    loaded yet, they return nil and get retried next tick.
    
    ── Question Path ──
    workspace.Map.Functional.Screen.SurfaceGui
        .MainFrame.MainGameContainer.MainTxtContainer.QuestionText
    
    ── Answer Path ──
    PlayerGui.MainGui.MainFrame.GameFrame.PCTextBoxContainer.TextBox
    
    If your game has different paths, edit these two functions.
]]

local QUESTION_LABEL = nil

local function FindQuestionLabel()
    local ok, result = pcall(function()
        return workspace.Map.Functional.Screen.SurfaceGui
            .MainFrame.MainGameContainer.MainTxtContainer.QuestionText
    end)
    if ok and result then return result end
    return nil
end

local function FindAnswerBox()
    -- Try the exact known path (works for any account via Player.PlayerGui)
    local ok, box = pcall(function()
        return Player.PlayerGui.MainGui.MainFrame.GameFrame.PCTextBoxContainer.TextBox
    end)
    if ok and box and box:IsA("TextBox") then return box end

    -- Fallback: search for TextBox inside PCTextBox* parent
    for _, gui in pairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "CleanUI" then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextBox") and desc.Parent and desc.Parent.Name:find("PCTextBox") then
                    return desc
                end
            end
        end
    end

    -- Last resort: any TextBox not in skins/navigation
    for _, gui in pairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "CleanUI" then
            for _, desc in pairs(gui:GetDescendants()) do
                if desc:IsA("TextBox")
                and not desc:GetFullName():find("Skin")
                and not desc:GetFullName():find("Navigation") then
                    return desc
                end
            end
        end
    end

    return nil
end
