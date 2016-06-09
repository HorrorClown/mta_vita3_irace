--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 19.12.2014 - Time: 22:57
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
GUIButton = inherit(GUIManager)

--Todo: Parameter >color< zum table machen mit dem Aufbau {["normal"] = {r,g,b,a}, ["hover"] = {r,g,b,a}, ["disabled"] = {r,g,b,a}}
function GUIButton:constructor(sTitle, nDiffX, nDiffY, nWidth, nHeight, color, parent)
    self.title = sTitle
    self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
    self.color = color
    self.drawColor = tocolor(unpack(self.color["normal"]))
    self.parent = parent
    self.m_Enabled = self.parent.m_Enabled
    self.clickExecute = {}
    self.m_Font = "default"
    self.m_Size = 1
    if self.parent.subElements then table.insert(self.parent.subElements, self) end

    self.hoverFunc = bind(self.onHover, self)
    addEventHandler("onClientCursorMove", root, self.hoverFunc)

    self:addClickHandler()
end

function GUIButton:destructor()
    removeEventHandler("onClientCursorMove", root, self.hoverFunc)
    self:removeClickHandler()
end

function GUIButton:onHover()
    if not self.m_Enabled then return end

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

function GUIButton:setFont(font)
    self.m_Font = font
end

function GUIButton:setSize(size)
    self.m_Size = size
end

function GUIButton:render(offset)
    dxDrawRectangle(self.diffX, self.diffY + offset, self.w, self.h, self.drawColor)
    dxDrawText(self.title, self.diffX, self.diffY + offset, self.diffX + self.w, self.diffY + self.h + offset, tocolor(255, 255, 255), self.m_Size, self.m_Font, "center", "center")
end