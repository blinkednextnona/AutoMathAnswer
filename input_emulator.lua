--[[
    ╔═══════════════════════════════════════════════╗
    ║  INPUT EMULATOR — Typing + Enter key          ║
    ╚═══════════════════════════════════════════════╝
    
    EmulateTyping(text, textbox)
    
    Types the answer character by character with random delays,
    then submits by pressing Enter. Tries multiple methods:
    
    1. VirtualInputManager.SendKeyEvent  (most reliable)
    2. VirtualUser.SetKeyDown/Up         (fallback)
    3. firesignal(FocusLost, true)       (executor-specific)
    4. TextBox:ReleaseFocus(true)        (last resort)
    
    Also has a safety net: if the game wipes the text after
    submit, it re-enters and re-submits.
]]

local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)

local function PressEnter()
    -- Method 1: VirtualInputManager
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

    -- Focus
    pcall(function() textbox:CaptureFocus() end)
    task.wait(0.2)

    -- Type character by character
    textbox.Text = ""
    task.wait(0.05)

    for i = 1, #text do
        textbox.Text = textbox.Text .. text:sub(i, i)
        task.wait(typingSpeed.min + math.random() * (typingSpeed.max - typingSpeed.min))
    end

    -- Let game register the text
    task.wait(0.3)

    -- Ensure text survived
    local finalText = textbox.Text
    if finalText ~= text then
        textbox.Text = text
        task.wait(0.1)
    end

    -- Submit: try all methods
    local pressedEnter = PressEnter()

    pcall(function()
        if firesignal then
            firesignal(textbox.FocusLost, true)
        end
    end)

    task.wait(0.05)
    pcall(function() textbox:ReleaseFocus(true) end)

    -- Safety net: if text got wiped, redo
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
