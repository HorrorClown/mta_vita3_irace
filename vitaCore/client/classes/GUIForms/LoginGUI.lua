LoginGUI = inherit(Singleton)

-- Todo: neet to clean up :)

function LoginGUI:constructor()
    self.m_UsePasswordHash = false
    showCursor(true)

    self.HEIGHT = screenHeight/3
    self.WHITE = tocolor(255, 255, 255)

    self.m_SubAlpha = 0
    self.m_OffsetY = -self.HEIGHT
    self.isActive = false
    self.m_ContentStartX = 0
    self.m_ContentStartY = self.HEIGHT

    self.rt_Background = DxRenderTarget(screenWidth, self.HEIGHT, true)
    self.rt_Login = DxRenderTarget(screenWidth, self.HEIGHT, true)
    self.m_Browser = Browser(screenWidth, screenHeight, false)

    self:createGUI()
    self:initAnimations()
    self.fn_Render = bind(self.render, self)

    addEventHandler("onClientBrowserCreated", self.m_Browser,
        function()
            self.m_Browser:loadURL("http://pewx.de/res/irace/GUI/backgrounds/background.html")
            self.m_Browser:setVolume(0)
        end
    )

    self.fn_ToggleSound =
        function()
            if self.m_Browser:getVolume() == 1 then
                self.m_Browser:setVolume(0)
            else
                self.m_Browser:setVolume(1)
            end
        end
    bindKey("m", "down", self.fn_ToggleSound)

    self.fn_PerformLogin = bind(self.m_Button_Submit.performClick, self.m_Button_Submit)
    bindKey("enter", "down", self.fn_PerformLogin)

    self.HEIGHT = 0
    self:updateRenderTarget()
    addEventHandler("onClientRender", root, self.fn_Render)

    self.m_MainAnimation:startAnimation(1500, "OutQuad", screenHeight/3)

    setTimer(function()
        self.m_MovingAnimation:startAnimation(750, "OutQuad", 0, 255)
        self.isActive = true
    end, 750, 1)
end

function LoginGUI:destructor()
    removeEventHandler("onClientRender", root, self.fn_Render)
    unbindKey("m", "down", self.fn_ToggleSound)
end

function LoginGUI:initAnimations()
    self.m_MovingAnimation = CAnimation:new(self, "m_OffsetY", "m_SubAlpha")
    self.m_MainAnimation = CAnimation:new(self, "HEIGHT")
end

function LoginGUI:createGUI()
    self.rt_Background:setAsTarget()
    dxDrawRectangle(0, 0, screenWidth, self.HEIGHT, tocolor(20, 20, 20, 200))
    dxDrawRectangle(0, 0, screenWidth, 1, self.WHITE)
    dxDrawRectangle(0, self.HEIGHT-1, screenWidth, 1, self.WHITE)
    dxSetRenderTarget()

    -- Username & Password
    self.m_EditStartX = screenWidth/2-128
    self.m_EditStartY = 175
    self.m_EditWidth = 256
    self.m_EditHeight = 24

    self.m_Editbox_Username = GUIEdit:new("// Username", self.m_EditStartX, self.m_EditStartY, self.m_EditWidth, self.m_EditHeight, false, false, self)
    self.m_Editbox_Password = GUIEdit:new("// Password", self.m_EditStartX, self.m_EditStartY + self.m_EditHeight + 12, self.m_EditWidth - self.m_EditHeight, self.m_EditHeight, false, true, self)
    self.m_Button_Submit = GUIButton:new(">", self.m_EditStartX + self.m_EditWidth - self.m_EditHeight, self.m_EditStartY + self.m_EditHeight + 12, self.m_EditHeight, self.m_EditHeight, {["normal"] = {180, 180, 180}, ["hover"] = {150, 150, 150}}, self)
    self.m_Label_Register = GUILabel:new("Visit 'www.irace-mta.de' to register an account or #ff7000click here #ffffffto open the ingame Browser.", 0, self.HEIGHT - 20, screenWidth, 20, self)
    self.m_Label_Register:setAlign("center", "center")

    self.m_Button_Submit:addClickFunction(
        function()
            outputChatBox("SUBMIT :)")
        end
    )

    self.m_Label_Register:addClickFunction(
        function()
            self.isActive = false
            self.m_BrowserWidth = screenWidth - screenWidth/5
            self.m_BrowserHeight = screenHeight - screenHeight/5
            self.m_RegisterBrowser = Browser(self.m_BrowserWidth, self.m_BrowserHeight, false, false)

            addEventHandler("onClientBrowserCreated", self.m_RegisterBrowser,
                function()
                    self.m_RegisterBrowser:loadURL("http://ir2.pewx.de/index.php?disclaimer/")
                    self.m_ShowRegisterBrowser = true
                end
            )
        end
    )
end

function LoginGUI:updateRenderTarget()
    self.rt_Login:setAsTarget(true)
    --Avatar
    local avatar = {startX = screenWidth/2-64, startY = 30 + self.m_OffsetY, width = 128, height = 128}
    dxDrawRectangle(avatar.startX, avatar.startY, avatar.width, avatar.height, tocolor(0, 0, 0, 180, self.m_SubAlpha))
    dxDrawRectangle(avatar.startX + 1, avatar.startY + 1, avatar.width - 2, avatar.height - 2, tocolor(255, 255, 255, 230/255*self.m_SubAlpha))
    dxDrawImage(avatar.startX + 2, avatar.startY + 2, avatar.width - 4, avatar.height - 4, "files/avatar.png", 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))

    self.m_Editbox_Username:render(self.m_OffsetY)
    self.m_Editbox_Password:render(self.m_OffsetY)
    self.m_Button_Submit:render(self.m_OffsetY)
    self.m_Label_Register:render(self.m_OffsetY)

    -- Toggle sound
    --dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, self.HEIGHT - 5, self.WHITE, 1, "clear", "center", "bottom")
    dxSetRenderTarget()
end

function LoginGUI:render()
    dxDrawImage(0, 0, screenWidth, screenHeight, self.m_Browser)
    dxDrawRectangle(0, 0, screenWidth, 15, tocolor(0, 0, 0))
    dxDrawRectangle(0, screenHeight-15, screenWidth, 15, tocolor(0, 0, 0))


    if self.m_ShowRegisterBrowser then
        dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 220))

        local browserStartX = screenWidth/2 - self.m_BrowserWidth/2
        local browserStartY = screenHeight/2 - self.m_BrowserHeight/2
        dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Background, 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))
        dxDrawRectangle(browserStartX - 6, browserStartY - 6, self.m_BrowserWidth + 12, self.m_BrowserHeight + 12, tocolor(255, 255, 255, 255))
        dxDrawRectangle(browserStartX - 5, browserStartY - 5, self.m_BrowserWidth + 10, self.m_BrowserHeight + 10, tocolor(20, 20, 20, 200))
        dxDrawImage(browserStartX, browserStartY, self.m_BrowserWidth, self.m_BrowserHeight, self.m_RegisterBrowser)
    else
        dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Background, 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))
        dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Login, 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))
    end

    dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, screenHeight, self.WHITE, 1, "clear", "center", "bottom")
    dxDrawText("Powered by Vita3 (vita-online.eu)", 0, 0, screenWidth, screenHeight, self.WHITE, 1, "clear", "left", "bottom")
end

function LoginGUI:getPosition()
    return self.m_ContentStartX, self.m_ContentStartY
end