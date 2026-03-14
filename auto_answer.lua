--[[
    ╔═══════════════════════════════════════════════╗
    ║  AUTO ANSWER — Main loop + state management   ║
    ╚═══════════════════════════════════════════════╝
    
    Polls every 0.5 seconds:
    1. Finds the QuestionText label (lazy, retries if not found)
    2. Reads the current math question
    3. Solves it with the math parser
    4. Types the answer into the TextBox (once per question)
    
    State variables:
    • autoEnabled   — Toggle from UI
    • lastAnswered  — Prevents re-answering same question
    • solveCount    — Running total for stats display
    • isTyping      — Lock to prevent overlapping inputs
    • typingSpeed   — {min, max} delay per character in seconds
]]

local autoEnabled = false
local lastAnswered = ""
local solveCount = 0
local typingSpeed = {min = 0.05, max = 0.15}
local isTyping = false

-- Main polling loop (non-blocking, runs in background)
task.spawn(function()
    while true do
        task.wait(0.5)

        -- Lazy-find question label
        if not QUESTION_LABEL or not QUESTION_LABEL.Parent then
            QUESTION_LABEL = FindQuestionLabel()
        end

        if not QUESTION_LABEL then
            questionPreview:SetText("Question: [Waiting for map...]")
            answerPreview:SetText("Answer: —")
            continue
        end

        -- Read question
        local ok, questionText = pcall(function() return QUESTION_LABEL.Text end)
        if not ok or not questionText or questionText == "" then
            questionPreview:SetText("Question: [Empty]")
            answerPreview:SetText("Answer: —")
            continue
        end

        questionPreview:SetText("Question: " .. questionText)

        if not questionText:find("=") then
            answerPreview:SetText("Answer: [No = sign]")
            continue
        end

        -- Solve
        local answer = SolveMath(questionText)
        if answer then
            answerPreview:SetText("Answer: " .. answer)
        else
            answerPreview:SetText("Answer: [Can't parse]")
            continue
        end

        -- Auto-type (once per question, only when enabled)
        if autoEnabled and questionText ~= lastAnswered and not isTyping and answer then
            lastAnswered = questionText
            solveCount = solveCount + 1
            statsLabel:SetText("Solved: " .. tostring(solveCount))
            statusLabel:SetText("Status: Typing #" .. solveCount .. "...")

            task.spawn(function()
                local box = FindAnswerBox()
                if box then
                    Notify("Solved", questionText .. " → " .. answer, 3, "success")
                    EmulateTyping(answer, box)
                    statusLabel:SetText("Status: Waiting for next...")
                else
                    Notify("Warning", "Answer: " .. answer .. " but no TextBox found!", 3, "warning")
                    statusLabel:SetText("Status: No input found!")
                end
            end)
        end
    end
end)
