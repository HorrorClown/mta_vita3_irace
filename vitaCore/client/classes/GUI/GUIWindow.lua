--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 19.12.2014 - Time: 18:07
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
GUIWindow = inherit(GUIManager)

function GUIWindow:constructor(sTitle, nPosX, nPosY, nWidth, nHeight, bClosable, bMovable)
    self.m_RenderTarget = DxRenderTarget(nWidth, nHeight, true)
    self.title = sTitle
    self.x = nPosX
    self.y = nPosY
    self.w = nWidth
    self.h = nHeight
    self.closable = bClosable
    self.movable = bMovable
    self.alpha = 255
    self.isActive = false
    self.m_Enabled = true

    self.subElements = {}

    self.onRenderFunc = bind(self.onRender, self)
    self.onCloseButtonClickFunc = bind(self.onCloseButtonClick, self)

    self:updateRenderTarget()
end

function GUIWindow:destructor()
    for _, subElement in pairs(self.subElements) do
        delete(subElement)
    end
    removeEventHandler("onClientRender", root, self.onRenderFunc)
    removeEventHandler("onClientClick", root, self.onCloseButtonClickFunc)
end

function GUIWindow:updateRenderTarget(tailCall)
    if not tailCall then
        for _, subElement in ipairs(self.subElements) do
            if subElement.updateRenderTarget then
                subElement:updateRenderTarget()
            end
        end
    end

    self.m_RenderTarget:setAsTarget(true)

    dxDrawRectangle(0, 0, self.w, self.h, tocolor(0, 0, 0, 220))
    dxDrawRectangle(0, 0, self.w, 22, tocolor(255, 80, 0, 200))
    dxDrawText(self.title, 0, 0, self.w, 20, tocolor(255, 255, 255), 1, "default-bold", "center", "center")
    if self.closable then dxDrawText("X", self.w - 22, 0, self.w, 22, tocolor(30, 30, 30), 1.1, "default-bold", "center", "center") end

    for _, subElement in ipairs(self.subElements) do
        subElement:render(0)
    end

    dxSetRenderTarget()
end

function GUIWindow:onRender()
    if self.moving then
        local cX, cY = getCursorPosition()
        self.x, self.y = cX*screenWidth-self.diff[1], cY*screenHeight-self.diff[2]
    end

    dxDrawImage(self.x, self.y, self.w, self.h, self.m_RenderTarget)
end

--[[function CDXWindow:onRender()


    --dxDrawRectangle(self.x, self.y, self.w, self.h, tocolor(150, 150, 150, 200))
    --dxDrawRectangle(self.x, self.y, self.w, 22, tocolor(255, 80, 0, 200))
    --dxDrawText(self.title, self.x, self.y, self.x + self.w, self.y + 22, tocolor(255, 255, 255), 1, "arial", "center", "center")

    dxDrawRectangle(self.x-10, self.y-10, self.w+20, self.h+20, tocolor(0, 0, 0, self.alpha/255*50))
    dxDrawRectangle(self.x, self.y, self.w, self.h, tocolor(50, 50, 50, self.alpha/255*200))
    dxDrawRectangle(self.x, self.y, self.w, 22, tocolor(255, 80, 0, self.alpha/255*200))
    dxDrawLine(self.x, self.y+22, self.x+self.w, self.y+22, tocolor(60, 60, 60, self.alpha), 1)
    dxDrawLine(self.x, self.y+23, self.x+self.w, self.y+23, tocolor(120, 120, 120, self.alpha), 1)
    dxDrawText(self.title, self.x, self.y, self.x + self.w, self.y + 22, tocolor(255, 255, 255, self.alpha), 1, "arial", "center", "center")
    if self.closable then
        --Todo: Use an image as close button not a text that contains 'X' o.O!
        if utils.isHover(self.x + self.w - 22, self.y, 22, 22) then self.hover = true else self.hover = false end
        dxDrawText("X", self.x + self.w - 22, self.y, self.x + self.w, self.y + 22, tocolor(self.hover and 255 or 0, 0, 0), 1, "arial", "center", "center")
    end

    for _, subElement in ipairs(self.subElements) do
        if subElement.alpha then subElement.alpha = self.alpha end
        subElement:render()
    end
end]]

function GUIWindow:onCloseButtonClick(btn, st)
    if btn == "left" and st == "down" then
        if self.closable and isHover(self.x + self.w - 22, self.y, 22, 22) then
            showCursor(false)
            self:destructor()
            return
        end
        if self.movable and not self.moving and isHover(self.x, self.y, self.w, 22) then
            local cX, cY = getCursorPosition()
            self.diff = {cX*screenWidth-self.x, cY*screenHeight-self.y}
            self.moving = true
        end
    else
        self.moving = false
    end
end

function GUIWindow:getPosition()
    return self.x, self.y
end

function GUIWindow:addSubElement(eSubElement)
    table.insert(self.subElements, eSubElement)
end

function GUIWindow:show()
    addEventHandler("onClientRender", root, self.onRenderFunc)
    if self.onCloseButtonClickFunc then addEventHandler("onClientClick", root, self.onCloseButtonClickFunc) end
    if self.subElements then
        for _, subElement in ipairs(self.subElements) do
            --subElement:addClickHandler()
        end
    end
    self.isVisible = true
end