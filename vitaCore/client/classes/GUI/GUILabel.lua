--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 19.12.2014 - Time: 22:57
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
GUILabel = inherit(GUIManager)

--Todo: Parameter >color< zum table machen mit dem Aufbau {["normal"] = {r,g,b,a}, ["hover"] = {r,g,b,a}, ["disabled"] = {r,g,b,a}}
function GUILabel:constructor(sText, nDiffX, nDiffY, nWidth, nHeight, parent)
    self.text = sText
    self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
    self.parent = parent
    self.m_AlignX = "left"
    self.m_AlignY = "top"
    self.m_Font = "default"
    self.m_Size = 1
    self.clickExecute = {}

    self.hoverFunc = bind(self.onHover, self)
    --addEventHandler("onClientCursorMove", root, self.hoverFunc)
    self:addClickHandler()
end

function GUILabel:destructor()
    removeEventHandler("onClientCursorMove", root, self.hoverFunc)
    self:removeClickHandler()
end

function GUILabel:onHover()
    local startX, startY = self.parent:getPosition()
    local oldColor = self.drawColor

    if isHover(startX + self.diffX, startY + self.diffY, self.w, self.h) then
        self.drawColor = tocolor(unpack(self.color["hover"]))
    else
        self.drawColor = tocolor(unpack(self.color["normal"]))
    end

    if oldColor ~= self.drawColor then
        self.parent:updateRenderTarget()
    end
end

function GUILabel:setAlignX(alignX)
    self.m_AlignX = alignX
end

function GUILabel:setAlignY(alignY)
    self.m_AlignY = alignY
end

function GUILabel:setAlign(x, y)
    self.m_AlignX = x or self.m_AlignX
    self.m_AlignY = y or self.m_AlignY
end

function GUILabel:setFont(font)
    self.m_Font = font
end

function GUILabel:setSize(size)
    self.m_Size = size
end

function GUILabel:setText(text)
    self.text = text
end

function GUILabel:render(offset)
    dxDrawText(self.text, self.diffX, self.diffY + offset, self.diffX + self.w, self.diffY + self.h + offset, tocolor(255, 255, 255), self.m_Size, self.m_Font, self.m_AlignX, self.m_AlignY, false, false, false, true)
end