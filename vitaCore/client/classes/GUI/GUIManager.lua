--
-- HorrorClown (PewX)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 19.12.2014 - Time: 18:19
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
GUIManager = inherit(Object)

function GUIManager:constructor()
    self.windows = {}
end

function GUIManager:destructor()

end

function GUIManager:show()
    addEventHandler("onClientRender", root, self.onRenderFunc)
    if self.onCloseButtonClickFunc then addEventHandler("onClientClick", root, self.onCloseButtonClickFunc) end
    if self.subElements then
        for _, subElement in ipairs(self.subElements) do
            subElement:addClickHandler()
        end
    end
    self.isVisible = true
end

function GUIManager:hide()
    removeEventHandler("onClientRender", root, self.onRenderFunc)
    removeEventHandler("onClientClick", root, self.onCloseButtonClickFunc)
    for _, subElement in ipairs(self.subElements) do
        subElement:removeClickHandler()
    end
    self.isVisible = false
end

function GUIManager:onClick(btn, st)
    if btn == "left" and st == "down" then
        if not self.parent.isActive then return end

        local startX, startY = self.parent:getPosition()
        if isHover(startX + self.diffX, startY + self.diffY, self.w, self.h) then
            for _, aFunc in ipairs(self.clickExecute) do
                aFunc(self)
            end
        end
    end
end

function GUIManager:performClick()
    for _, aFunc in ipairs(self.clickExecute) do
        aFunc(self)
    end
end

function GUIManager:addClickFunction(fCallFunc)
    table.insert(self.clickExecute, bind(fCallFunc, self))
    --if not self.onClickFunc then self.onClickFunc = bind(self.onClick, self) end
end

function GUIManager:removeClickFunction(fCallFunc)
    if self.clickExecute then
        for i, callFunc in ipairs(self.clickExecute) do
            if callFunc == fCallFunc then
                table.remove(self.clickExecute, i)
            end
        end
    end
end

function GUIManager:getProperty(sKey)
    return self[sKey]
end

function GUIManager:setProperty(sKey, nValue)
    self[sKey] = nValue
end

function GUIManager:addClickHandler()
    if not self.onClickFunc then self.onClickFunc = bind(self.onClick, self) end
    addEventHandler("onClientClick", root, self.onClickFunc)
end

function GUIManager:removeClickHandler()
    removeEventHandler("onClientClick", root, self.onClickFunc)
end

function GUIManager:registerWindow(eWindow)
    table.insert(self.windows, eWindow)
end

function GUIManager:unregisterWindow(eWindow)
    for i, window in ipairs(self.windows) do
        if window == eWindow then
            table.remove(self.windows, i)
        end
    end
end