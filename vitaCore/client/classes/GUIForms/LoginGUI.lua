LoginGUI = inherit(Singleton)

-- Todo: neet to clean up :)

function LoginGUI:constructor()
    self.usePasswordHash = false
    self.useCustomAvatar = false
    showCursor(true)

    self.HEIGHT = screenHeight/3
    self.WHITE = tocolor(255, 255, 255)

    self.m_SubAlpha = 0
    self.m_OffsetY = -self.HEIGHT
    self.m_ContentStartX = 0
    self.m_ContentStartY = self.HEIGHT

    self.rt_Login = DxRenderTarget(screenWidth, self.HEIGHT, true)

    self:createGUI()
    self:initAnimations()

    self.HEIGHT = 0
    --self:updateRenderTarget()

   -- self.fn_Render = bind(self.render, self)
    --addEventHandler("onClientRender", root, self.fn_Render)

    self.m_MainAnimation:startAnimation(1500, "OutQuad", screenHeight/3)

    setTimer(function()
        self.m_MovingAnimation:startAnimation(750, "OutQuad", 0, 255)
    end, 750, 1)
end

function LoginGUI:destructor()
    self.m_Editbox_Username:destructor()
    self.m_Editbox_Password:destructor()
    self.m_Button_Submit:destructor()
    self.m_Label_Register:destructor()

    self.m_MovingAnimation:delete()
    self.m_MainAnimation:delete()
    self.rt_Login:destroy()
    removeEventHandler("onClientKey", root, self.fn_SubmitEnter)
end

function LoginGUI:initAnimations()
    self.m_MovingAnimation = CAnimation:new(self, "m_OffsetY", "m_SubAlpha")
    self.m_MainAnimation = CAnimation:new(self, "HEIGHT")
end

function LoginGUI:createGUI()
    -- Username & Password
    self.m_EditStartX = screenWidth/2-128
    self.m_EditStartY = 175
    self.m_EditWidth = 256
    self.m_EditHeight = 24

    self.m_Editbox_Username = GUIEdit:new("// Username", self.m_EditStartX, self.m_EditStartY, self.m_EditWidth, self.m_EditHeight, false, false, self)
    self.m_Editbox_Password = GUIEdit:new("// Password", self.m_EditStartX, self.m_EditStartY + self.m_EditHeight + 12, self.m_EditWidth - self.m_EditHeight, self.m_EditHeight, false, true, self)
    self.m_Button_Submit = GUIButton:new(">", self.m_EditStartX + self.m_EditWidth - self.m_EditHeight, self.m_EditStartY + self.m_EditHeight + 12, self.m_EditHeight, self.m_EditHeight, {["normal"] = {180, 180, 180}, ["hover"] = {150, 150, 150}}, self)
    --self.m_Label_Register = GUILabel:new("Visit 'www.irace-mta.de' to register an account or #ff7000click here #ffffffto open the ingame Browser", 0, self.HEIGHT - 20, screenWidth, 20, self)
    self.m_Label_Register = GUILabel:new("#ffffffVisit '#ff7000www.irace-mta.de#ffffff' to register an account", 0, self.HEIGHT - 30, screenWidth, 30, self)
    self.m_Label_Register:setAlign("center", "center")
    self.m_Label_Register:setFont(irFont(25))

    self.m_Button_Submit:addClickFunction(
        function()
            local username = self.m_Editbox_Username:getText()
            local pw = self.m_Editbox_Password:getText()

            if self.usePasswordHash and self.usePasswordHash == pw then -- User has not changed the password
                triggerServerEvent("accountlogin", root, username, "", pw)
            else
                triggerServerEvent("accountlogin", root, username, pw)
            end

            -- Disable login button to avoid several events
            self.m_Button_Submit:setEnabled(false)
        end
    )

    -- Currently disabled cause mta cef problems (if it works sometime, don't forget the "Go Back" button and remove the events)
    self.m_Label_Register:addClickFunction(
        function()
            if true then return end
            self.isActive = false
            self.m_BrowserWidth = screenWidth - screenWidth/5
            self.m_BrowserHeight = screenHeight - screenHeight/5
            self.m_BrowserStartX = screenWidth/2 - self.m_BrowserWidth/2
            self.m_BrowserStartY = screenHeight/2 - self.m_BrowserHeight/2
            self.m_RegisterBrowser = Browser(self.m_BrowserWidth, self.m_BrowserHeight, false, false)

            self.fn_BrowserCursorClick =
                function(sButton, sState)
                    if isHover(self.m_BrowserStartX, self.m_BrowserStartY, self.m_BrowserWidth, self.m_BrowserHeight) then

                        if sState == "down" then self.m_RegisterBrowser:injectMouseDown(sButton) else self.m_RegisterBrowser:injectMouseUp(sButton) end
                        --guiSetInputEnabled(true)
                        self.m_RegisterBrowser:focus()
                    end
                end

            self.fn_BrowserCursorMove =
                function(_, _, cpx, cpy)
                    if isHover(self.m_BrowserStartX, self.m_BrowserStartY, self.m_BrowserWidth, self.m_BrowserHeight) then
                        self.m_RegisterBrowser:injectMouseMove(cpx - self.m_BrowserStartX, cpy - self.m_BrowserStartY)
                    end
                end

            --showChat(true)
            self.fn_BrowserScroll =
                function(sButton)
                    local scrollDirection = sButton == "mouse_wheel_up" and 1 or -1
                    self.m_RegisterBrowser:injectMouseWheel(scrollDirection*80, 0)
                end

            addEventHandler("onClientBrowserCreated", self.m_RegisterBrowser,
                function()
                    self.m_RegisterBrowser:loadURL("http://ir2.pewx.de/index.php?register")
                    self.m_ShowRegisterBrowser = true
                end
            )

            addEventHandler("onClientClick", root, self.fn_BrowserCursorClick)
            addEventHandler("onClientCursorMove", root, self.fn_BrowserCursorMove)
            bindKey("mouse_wheel_down", "down", self.fn_BrowserScroll)
            bindKey("mouse_wheel_up", "down", self.fn_BrowserScroll)
        end
    )

    --    self.fn_PerformLogin = bind(self.m_Button_Submit.performClick, self.m_Button_Submit)
    --    bindKey("enter", "down", self.fn_PerformLogin)

    -- Workaround for above
    self.fn_SubmitEnter = function(sButton, sState) if sButton == "enter" and sState then self.m_Button_Submit:performClick() end end
    addEventHandler("onClientKey", root, self.fn_SubmitEnter)
end

function LoginGUI:updateRenderTarget()
    outputChatBox("update loginGUI rendertarget")
    LoginBackground:getSingleton().rt_Background:setAsTarget(true)
    LoginBackground.drawBackground()
    --Avatar
    local avatar = {startX = screenWidth/2-64, startY = 30 + self.m_OffsetY, width = 128, height = 128}
    dxDrawRectangle(avatar.startX, avatar.startY, avatar.width, avatar.height, tocolor(0, 0, 0, 180, self.m_SubAlpha))
    dxDrawRectangle(avatar.startX + 1, avatar.startY + 1, avatar.width - 2, avatar.height - 2, tocolor(255, 255, 255, 230/255*self.m_SubAlpha))
    dxDrawImage(avatar.startX + 2, avatar.startY + 2, avatar.width - 4, avatar.height - 4, self.useCustomAvatar and "files/_avatar.png" or "files/avatar.png", 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))

    if self.usePasswordHash ~= "" and self.usePasswordHash == self.m_Editbox_Password:getText() then
        self.m_Editbox_Password:setProperty("diffY", self.m_EditStartY)
        self.m_Button_Submit:setProperty("diffY", self.m_EditStartY)
        self.m_Label_Register:setText(("Welcome back %s!"):format(localPlayer.name))
        self.m_Editbox_Username:setEnabled(false)
    else
        self.m_Editbox_Password:setProperty("diffY", self.m_EditStartY + self.m_EditHeight + 12)
        self.m_Button_Submit:setProperty("diffY", self.m_EditStartY + self.m_EditHeight + 12)
        self.m_Editbox_Username:render(self.m_OffsetY)
        self.m_Label_Register:setText("#ffffffVisit '#ff7000www.irace-mta.de#ffffff' to register an account")
        self.m_Editbox_Username:setEnabled(true)
    end
    self.m_Editbox_Password:render(self.m_OffsetY)
    self.m_Button_Submit:render(self.m_OffsetY)
    self.m_Label_Register:render(self.m_OffsetY)

    -- Toggle sound
    --dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, self.HEIGHT - 5, self.WHITE, 1, "clear", "center", "bottom")
    dxSetRenderTarget()
end

--[[function LoginGUI:render()
    if self.m_ShowRegisterBrowser then
        dxDrawRectangle(0, 0, screenWidth, screenHeight, tocolor(0, 0, 0, 220))
        local browserStartX = screenWidth/2 - self.m_BrowserWidth/2
        local browserStartY = screenHeight/2 - self.m_BrowserHeight/2
        dxDrawRectangle(browserStartX - 6, browserStartY - 6, self.m_BrowserWidth + 12, self.m_BrowserHeight + 12, tocolor(255, 255, 255, 255))
        dxDrawRectangle(browserStartX - 5, browserStartY - 5, self.m_BrowserWidth + 10, self.m_BrowserHeight + 10, tocolor(20, 20, 20, 200))
        dxDrawImage(browserStartX, browserStartY, self.m_BrowserWidth, self.m_BrowserHeight, self.m_RegisterBrowser)
    else
        dxDrawImage(0, screenHeight/2-self.HEIGHT/2, screenWidth, self.HEIGHT, self.rt_Login, 0, 0, 0, tocolor(255, 255, 255, self.m_SubAlpha))
    end
end]]

function LoginGUI:getPosition()
    return self.m_ContentStartX, self.m_ContentStartY
end

function LoginGUI.receiveAvatar(avatar, error)
    avatar = dxConvertPixels(avatar, "png")
    local file = File.new("files/_avatar.png")
    file:write(avatar)
    file:close()
end

function LoginGUI.downloadAvatar(ID, fileHash)
    if core:get("Login", "avatar", "") == fileHash then return true end

    local directory = fileHash:sub(1, 2)
    local fileString = ("%s-%s-%s.jpg"):format(ID, fileHash, 128)   --> avatarID-fileHash-size.jpg
    --local downloadString = ("http://ir2.pewx.de/wcf/images/avatars/%s/%s"):format(directory, fileString)
    local downloadString = ("http://192.168.178.24/wbb/wcf/images/avatars/%s/%s"):format(directory, fileString)

    fetchRemote(downloadString, LoginGUI.receiveAvatar)
    core:set("Login", "avatar", fileHash)
end

addEvent("loginfailed", true)
addEventHandler("loginfailed", root,
    function(text)
        --LoginGUI:getSingleton().m_Button_Submit:setEnabled(true)
        addNotification(1, 200, 50, 50, text)
    end
)

addEvent("loginsuccess", true)
addEventHandler("loginsuccess", root,
    function(pwhash, avatarFileHash, avatarID)
        initSettings()
        addNotification(2, 50, 200, 50, "Successfully logged in")

        if not core:get("Login", "video", false) then
            addNotification(3, 200, 200, 50, "You can change the login background video!\nType /bg")
        end

        core:set("Login", "username", LoginGUI:getSingleton().m_Editbox_Username:getText())
        core:set("Login", "password", pwhash)

        delete(LoginGUI:getSingleton())
        delete(DownloadGUI:getSingleton())
        delete(LoginBackground:getSingleton())

        showChat(true)
        bindKey("m", "down", toggleVitaMusic)

        LoginGUI.downloadAvatar(avatarID, avatarFileHash)
    end
)