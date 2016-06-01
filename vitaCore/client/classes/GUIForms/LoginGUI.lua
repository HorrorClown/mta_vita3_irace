LoginGUI = inherit(Singleton)

-- Todo: neet to clean up :)

function LoginGUI:constructor()
    self.m_UsePasswordHash = false
    self.HEIGHT = screenHeight/3
    self.WHITE = tocolor(255, 255, 255)

    self.isActive = true
    self.startX = 0
    self.startY = screenHeight/3

    self.rt_Background = DxRenderTarget(screenWidth, self.HEIGHT, true)
    self.rt_Login = DxRenderTarget(screenWidth, self.HEIGHT, true)
    self.m_Browser = Browser(screenWidth, screenHeight, false)
    self.fn_Render = bind(self.render, self)

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
    self:updateRenderTarget()

    self.m_Button_Submit:addClickFunction(
        function()
            outputChatBox("SUBMIT :)")
        end
    )

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

    addEventHandler("onClientRender", root, self.fn_Render)

    showChat(true)
    showCursor(true)
    fadeCamera(true)
end

function LoginGUI:destructor()
    removeEventHandler("onClientRender", root, self.fn_Render)
    unbindKey("m", "down", self.fn_ToggleSound)
end

function LoginGUI:updateRenderTarget()
    self.rt_Login:setAsTarget(true)
    --Avatar
    local avatar = {startX = screenWidth/2-64, startY = 30, width = 128, height = 128}
    dxDrawRectangle(avatar.startX, avatar.startY, avatar.width, avatar.height, tocolor(0, 0, 0, 180))
    dxDrawRectangle(avatar.startX + 1, avatar.startY + 1, avatar.width - 2, avatar.height - 2, tocolor(255, 255, 255, 230))
    dxDrawImage(avatar.startX + 2, avatar.startY + 2, avatar.width - 4, avatar.height - 4, "files/avatar.png")

    self.m_Editbox_Username:render()
    self.m_Editbox_Password:render()
    self.m_Button_Submit:render()

    -- Toggle sound
    --dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, self.HEIGHT - 5, self.WHITE, 1, "clear", "center", "bottom")
    dxSetRenderTarget()
end

function LoginGUI:render()
    dxDrawImage(0, 0, screenWidth, screenHeight, self.m_Browser)
    dxDrawRectangle(0, 0, screenWidth, 15, tocolor(0, 0, 0))
    dxDrawRectangle(0, screenHeight-15, screenWidth, 15, tocolor(0, 0, 0))

    dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Background)
    dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Login)

    dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, screenHeight, self.WHITE, 1, "clear", "center", "bottom")
    dxDrawText("Powered by Vita3 (vita-online.eu)", 0, 0, screenWidth, screenHeight, self.WHITE, 1, "clear", "left", "bottom")
end

function LoginGUI:getPosition()
    return self.startX, self.startY
end