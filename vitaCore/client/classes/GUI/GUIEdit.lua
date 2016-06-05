--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 14 Ultimate
-- Date: 17.01.2015 - Time: 20:01
-- pewx.de // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
string.sub = utf8.sub
string.len = utf8.len

GUIEdit = inherit(GUIManager)

function GUIEdit:constructor(sTitle, nDiffX, nDiffY, nWidth, nHeight, bNumeric, bMasked, parent)
    self.m_Enabled = true
    self.title = sTitle
    self.text = ""
    self.caretPos = 0
    self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
    self.parent = parent or false
    self.clickExecute = {}
    self.numeric = bNumeric
    self.masked = bMasked
    self.alpha = 255
    self.color = tocolor()

    --local pX, pY = self.parent:getPosition()
    --self.x = pX + self.diffX
    --self.y = pY + self.diffY

    self.clickFunc = bind(self.onEditClick, self)
    self.editFunc = bind(self.onEdit, self)
    self.keyFunc = bind(self.onEditKey, self)
    self.updateFunc = bind(self.parent.updateRenderTarget, self.parent)

    self:addClickFunction(
        function()
            if not self.clicked then
                addEventHandler("onClientClick", root, self.clickFunc)
                addEventHandler("onClientCharacter", root, self.editFunc)
                addEventHandler("onClientKey", root, self.keyFunc)
            end
        end
    )
    self:addClickHandler()

    --table.insert(self.parent.subElements, self)
end

function GUIEdit:destructor()
    if isTimer(self.updateTimer) then killTimer(self.updateTimer) end
    removeEventHandler("onClientClick", root, self.clickFunc)
    removeEventHandler("onClientCharacter", root, self.editFunc)
    removeEventHandler("onClientKey", root, self.keyFunc)
    self:removeClickHandler()
end

function GUIEdit:getText()
    return self.numeric and tonumber(self.text) or self.text
end

function GUIEdit:setText(sText)
    self.text = sText
    self.caretPos = self.text:len()
    self.parent:updateRenderTarget()
end

function GUIEdit:onEditClick()
    local startX, startY = self.parent:getPosition()

    if not isHover(startX + self.diffX, startY + self.diffY, self.w, self.h) then
        if isTimer(self.updateTimer) then killTimer(self.updateTimer) end
        guiSetInputEnabled(false)
        self.clicked = false
        removeEventHandler("onClientClick", root, self.clickFunc)
        removeEventHandler("onClientCharacter", root, self.editFunc)
        removeEventHandler("onClientKey", root, self.keyFunc)
        self.parent:updateRenderTarget()
    elseif not self.clicked then
        self.clicked = true
        self.updateTimer = setTimer(self.updateFunc, 500, 0)
        self.caretPos = self.text:len()
        self.markedAll = false
        self.lctrl = false
        guiSetInputEnabled(true)
        self.parent:updateRenderTarget()
    end
end

function GUIEdit:checkCaret()
    if self.caretPos > self.text:len() then self.caretPos = self.text:len() end
    if self.caretPos < 0 then self.caretPos = 0 end
end

function GUIEdit:onEdit(key)
    if self.markedAll then self.text = "" end
    self.markedAll = false
    self.lctrl = false

    if self.numeric and tonumber(key) then
        local fistPart = self.text:sub(0, self.caretPos)
        local lastPart = self.text:sub(self.caretPos + 1, self.text:len())
        self.text = fistPart..key..lastPart
    elseif not self.numeric then
        local fistPart = self.text:sub(0, self.caretPos)
        local lastPart = self.text:sub(self.caretPos + 1, self.text:len())
        self.text = fistPart..key..lastPart
    end
    self.caretPos = self.caretPos + 1
    self:checkCaret()

    self.parent:updateRenderTarget()
end

function GUIEdit:onEditKey(key, bDown)
    if key == "backspace" and not bDown then if isTimer(self.doTimer) then killTimer(self.doTimer) end end
    if key == "arrow_l" and not bDown then if isTimer(self.doTimer) then killTimer(self.doTimer) end end
    if key == "arrow_r" and not bDown then if isTimer(self.doTimer) then killTimer(self.doTimer) end end
    if key == "delete" and not bDown then if isTimer(self.doTimer) then killTimer(self.doTimer) end end

    if key == "lctrl" then self.lctrl = true end
    if self.lctrl and key == "a" then
        self.markedAll = true
        self.parent:updateRenderTarget()
        return
    end

    if bDown and key == "backspace" then
        if self.markedAll then self.text = "" end
        self.markedAll = false
        self.lctrl = false

        if self.caretPos == 0 then return end -- because otherwise we do not have anything to delete
        local firstPart = self.text:sub(0, self.caretPos - 1)
        local lastPart = self.text:sub(self.caretPos + 1, self.text:len())
        self.text = ("%s%s"):format(firstPart, lastPart)
        self.caretPos = self.caretPos - 1
        self:checkCaret()
        self.timer = setTimer(
            function()
                if getKeyState("backspace") then
                    if not isTimer(self.doTimer) then
                        self.doTimer = setTimer(
                            function()
                                if self.caretPos == 0 then return end
                                local firstPart = self.text:sub(0, self.caretPos - 1)
                                local lastPart = self.text:sub(self.caretPos + 1, self.text:len())
                                self.caretPos = self.caretPos - 1
                                self.text = ("%s%s"):format(firstPart, lastPart)
                                self:checkCaret()
                                self.parent:updateRenderTarget()
                            end
                        , 50, 0)
                    end
                end
            end
            , 200, 1)

        self.parent:updateRenderTarget()
        return
    end

    if bDown and key == "delete" then
        if self.markedAll then self.text = "" end
        self.markedAll = false
        self.lctrl = false

        if self.caretPos == self.text:len() then return end -- because otherwise we do not have anything to delete

        local firstPart = self.text:sub(0, self.caretPos)
        local lastPart = self.text:sub(self.caretPos + 2, self.text:len())
        self.text = ("%s%s"):format(firstPart, lastPart)
        self:checkCaret()

        self.timer = setTimer(
            function()
                if getKeyState("delete") then
                    if not isTimer(self.doTimer) then
                        self.doTimer = setTimer(
                            function()
                                if self.caretPos == self.text:len() then return end
                                local firstPart = self.text:sub(0, self.caretPos)
                                local lastPart = self.text:sub(self.caretPos + 2, self.text:len())
                                self.text = ("%s%s"):format(firstPart, lastPart)
                                self:checkCaret()
                                self.parent:updateRenderTarget()
                            end
                        , 50, 0)
                    end
                end
            end
        , 200, 1)

        self.parent:updateRenderTarget()
        return
    end

    if bDown and (key == "home" or key == "end") then
        self.markedAll = false
        self.lctrl = false

        if key == "home" then
            self.caretPos = 0
        elseif key == "end" then
            self.caretPos = self.text:len()
        end

        self.parent:updateRenderTarget()
        return
    end

    if bDown and (key == "arrow_l" or key == "arrow_r") then
        self.markedAll = false
        self.lctrl = false

        if not self.caretPos then self.caretPos = self.text:len() end
        if key == "arrow_l" then -- caret moves to the right
            self.caretPos = self.caretPos - 1
        elseif key == "arrow_r" then -- caret moves to the left
            self.caretPos = self.caretPos + 1
        end
            self:checkCaret()
        if not isTimer(self.doTimer) then
            self.timer = setTimer(
                function()
                    if getKeyState("arrow_l") or getKeyState("arrow_r") then
                        if not isTimer(self.doTimer) then
                            self.doTimer = setTimer(
                                function()
                                    if getKeyState("arrow_l") then -- caret moves to the right
                                    self.caretPos = self.caretPos - 1
                                    elseif getKeyState("arrow_r") then -- caret moves to the left
                                    self.caretPos = self.caretPos + 1
                                    end
                                    self:checkCaret()
                                    self.parent:updateRenderTarget()
                                end
                                , 50, 0)
                        end
                    end
                end
                , 200, 1)
        end

        self.parent:updateRenderTarget()
        return
    end
end

function GUIEdit:render(offset)
    dxDrawRectangle(self.diffX, self.diffY + offset, self.w, self.h, tocolor(255, 255, 255, self.alpha))

    self.lineColor = tocolor(100, 100, 100, self.alpha)
    self.textColor = tocolor(0, 0, 0, self.alpha)
    if self.clicked then
        self.lineColor = tocolor(255, 80, 0, self.alpha)
        local tw = dxGetTextWidth(self.masked and string.rep("•", self.text:len()) or self.text, 1, "default")
        if self.markedAll then
            self.textColor = tocolor(255, 255, 255, self.alpha)
            dxDrawRectangle(self.diffX + 5, self.diffY + 4 + offset, tw, self.h - 8, tocolor(0, 170, 255, self.alpha))
        else
            if getTickCount()%1000 > 500 or isTimer(self.doTimer) then
                local cp = dxGetTextWidth(self.masked and string.rep("•", self.caretPos) or self.text:sub(0, self.caretPos), 1, "default")
                dxDrawRectangle(self.diffX + 5 + cp, self.diffY + 4 + offset, 1, self.h - 8, tocolor(0, 0, 0, self.alpha))
            end
        end
    else
        if isTimer(self.doTimer) then killTimer(self.doTimer) end
    end

    --dxDrawLine(self.diffX, self.diffY + self.h, self.diffY + self.w, self.diffY + self.h, self.lineColor, 2)
    if self.text == "" and not self.clicked then dxDrawText(self.title, self.diffX + 5, self.diffY + offset, self.diffX + self.w, self.diffY + self.h + offset, tocolor(120, 120, 120, self.alpha), 1, "default", "left", "center") end
    dxDrawText(self.masked and string.rep("•", self.text:len()) or self.text, self.diffX + 5, self.diffY + offset, self.diffX + self.w, self.diffY + self.h + offset, self.textColor, 1, "default", "left", "center", true)
end