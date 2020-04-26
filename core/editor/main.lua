local lex = require("tevgit:core/editor/lexer.lua")
local theme = require("tevgit:core/editor/theme/default.lua")

local editor = teverse.construct("guiRichTextBox", {
    parent = teverse.interface,
    size = guiCoord(1, 0, 1, 0),
    position = guiCoord(0, 0, 0, 0),
    text = "local test = 10 + 10\n\n",
    textWrap = true,
    textFont = "tevurl:fonts/firaCodeRegular.otf",
    textEditable = true
})

local function doLex()
    editor:clearColours()
    editor.backgroundColour = theme.background
    editor.textColour = theme.foreground

    local lines = lex(editor.text)
    local index = 0
    for lineNumber, line in pairs(lines) do
        local lineCount = 0
        for _, token in pairs(line) do
            local c = theme[token.type]
            if c then
                editor:setColour(index + token.posFirst, c)
                lineCount = token.posLast
            else
                print("no token ", token.type)
            end
        end
        index = index + lineCount
    end
end

-- Highlight any pre-entered text
doLex()

local lastStroke = nil
editor:on("keyUp", function()
    if lastStroke then 
        return
    end

    -- Limit lexxer to once very 0.2 seconds (every keystroke is inefficient)
    lastStroke = true
    sleep(0.2)
    doLex()
    lastStroke = nil
end)