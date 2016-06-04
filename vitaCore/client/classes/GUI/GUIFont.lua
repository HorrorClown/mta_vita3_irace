-- This rescales our font to look good on a certain pixel height
local irFonts = {}
function irFont(height, bold)
    local fontsize = math.floor(height/2)
    if not irFonts[fontsize] then
        irFonts[fontsize] = dxCreateFont("files/fonts/segoeui.ttf", fontsize, bold or false, "antialiased")
    end

    return irFonts[fontsize]
end

-- This gets the text width for a font which is 'height' pixels high
function irTextWidth(text, height)
    return dxGetTextWidth(text, 1, irFont(height))
end

local FontAwesomes = {}
function FontAwesome(height)
    local fontsize = math.floor(height/2)
    if not FontAwesomes[fontsize] then
        FontAwesomes[fontsize] = dxCreateFont("files/fonts/FontAwesome.otf", fontsize)
    end

    return FontAwesomes[fontsize]
end

FontAwesomeSymbols = {
    CartPlus = "",
    Cart = "",
    Phone = "",
    Book = "",
    Back = "",
    Player = "",
    Group = "",
    Money = "",
    Info = ""
}
