--[[
    ╔═══════════════════════════════════════════════╗
    ║  MATH PARSER — Recursive descent solver       ║
    ╚═══════════════════════════════════════════════╝
    
    SolveMath("4 + 4 =")     → "8"
    SolveMath("12 * 3 + 1 =") → "37"
    SolveMath("(5+3) * 2 =")  → "16"
    SolveMath("2 ^ 10 =")     → "1024"
    SolveMath("10 / 3 =")     → "3.33"
    
    Supports: +  -  *  /  ^  ()  negative numbers  decimals
    Also converts x/X to * (some games use "x" for multiply)
    
    Does NOT use loadstring — fully manual parsing.
    Works on all executors regardless of sandbox restrictions.
    
    Operator precedence (low → high):
    1. Addition / Subtraction
    2. Multiplication / Division
    3. Exponentiation
    4. Unary minus / Parentheses
]]

local function SolveMath(expression)
    -- Extract everything before the "=" sign
    local mathPart = expression:match("(.-)%s*=") or expression

    -- Normalize: x/X → *, strip non-math chars
    mathPart = mathPart:gsub("[xX]", "*")
    mathPart = mathPart:gsub("[^%d%+%-%*/%.%(%)%^]", "")

    if not mathPart or mathPart == "" then return nil end

    local pos = 1

    local function peek()
        return mathPart:sub(pos, pos)
    end

    local function advance()
        local c = peek()
        pos = pos + 1
        return c
    end

    -- Forward declaration for recursion
    local parseExpr

    -- Parse a number: digits and decimal point
    local function parseNumber()
        local s = pos
        while pos <= #mathPart and mathPart:sub(pos, pos):match("[%d%.]") do
            pos = pos + 1
        end
        if pos == s then return nil end
        return tonumber(mathPart:sub(s, pos - 1))
    end

    -- Parse atom: number, parenthesized expression, or unary +/-
    local function parseAtom()
        local c = peek()
        if c == "(" then
            advance()
            local v = parseExpr()
            if peek() == ")" then advance() end
            return v
        end
        if c == "-" then
            advance()
            local v = parseAtom()
            return v and -v
        end
        if c == "+" then
            advance()
            return parseAtom()
        end
        return parseNumber()
    end

    -- Parse exponentiation (right-associative: 2^3^2 = 2^9 = 512)
    local function parsePower()
        local b = parseAtom()
        if not b then return nil end
        if peek() == "^" then
            advance()
            local e = parsePower()
            if e then return b ^ e end
        end
        return b
    end

    -- Parse multiplication and division (left-associative)
    local function parseTerm()
        local left = parsePower()
        if not left then return nil end
        while true do
            local c = peek()
            if c == "*" then
                advance()
                local r = parsePower()
                if r then left = left * r else break end
            elseif c == "/" then
                advance()
                local r = parsePower()
                if r and r ~= 0 then left = left / r else break end
            else
                break
            end
        end
        return left
    end

    -- Parse addition and subtraction (left-associative)
    parseExpr = function()
        local left = parseTerm()
        if not left then return nil end
        while true do
            local c = peek()
            if c == "+" then
                advance()
                local r = parseTerm()
                if r then left = left + r else break end
            elseif c == "-" then
                advance()
                local r = parseTerm()
                if r then left = left - r else break end
            else
                break
            end
        end
        return left
    end

    -- Run the parser safely
    local ok, result = pcall(function()
        pos = 1
        return parseExpr()
    end)

    if ok and result then
        -- Clean output: integer if whole, otherwise 2 decimal places
        if result == math.floor(result) then
            return tostring(math.floor(result))
        else
            return tostring(math.floor(result * 100 + 0.5) / 100)
        end
    end
    return nil
end
