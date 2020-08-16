LoginBackground = inherit(Singleton)

function LoginBackground:constructor()
    self.m_HEIGHT = 0
    self.m_ALPHA = 0

    self.rt_Background = DxRenderTarget(screenWidth, LOGIN_HEIGHT, true)
    self.m_Browser = Browser(screenWidth, screenHeight, false)
    self.m_MainAnimation = CAnimation:new(self, "m_HEIGHT", "m_ALPHA")

    self.rt_Background:setAsTarget(true)
    LoginBackground.drawBackground()
    dxSetRenderTarget()

    addEventHandler("onClientBrowserCreated", self.m_Browser,
        function()
            local url = core:get("Login", "video", "http://pewx.de/res/irace/GUI/backgrounds/background.html")
            self.m_Browser:loadURL(url)
            self.m_Browser:setVolume(0.1)
            self.m_MainAnimation:startAnimation(1500, "OutQuad", LOGIN_HEIGHT, 255)
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

    self.fn_Render = bind(self.render, self)
    addEventHandler("onClientRender", root, self.fn_Render)
end

function LoginBackground:destructor()
    self.m_MainAnimation:delete()
    self.m_Browser:destroy()
    removeEventHandler("onClientRender", root, self.fn_Render)
    unbindKey("m", "down", self.fn_ToggleSound)
end

function LoginBackground:updateRenderTarget()
end

function LoginBackground:render()
    dxDrawImage(0, 0, screenWidth, screenHeight, self.m_Browser)
    dxDrawRectangle(0, 0, screenWidth, 15, tocolor(0, 0, 0))
    dxDrawRectangle(0, screenHeight-15, screenWidth, 15, tocolor(0, 0, 0))
    dxDrawText("Press 'm' to toggle sound", 0, 0, screenWidth, screenHeight, nil, 1, "clear", "center", "bottom")
    dxDrawText("irace-mta.de", 0, 0, screenWidth, screenHeight, nil, 1, "clear", "left", "bottom")

    dxDrawImage(0, screenHeight/2-self.m_HEIGHT/2, screenWidth, self.m_HEIGHT, self.rt_Background, 0, 0, 0, tocolor(255, 255, 255, self.m_ALPHA))
end

function LoginBackground.drawBackground()
    dxDrawRectangle(0, 0, screenWidth, LOGIN_HEIGHT, tocolor(20, 20, 20, 220))
    dxDrawRectangle(0, 0, screenWidth, 1, tocolor(255, 255, 255))
    dxDrawRectangle(0, LOGIN_HEIGHT-1, screenWidth, 1, tocolor(255, 255, 255))
end