--
-- PewX (HorrorClown)
-- Using: IntelliJ IDEA 15 Ultimate
-- Date: 08.06.2016 - Time: 22:51
-- pewx.de // pewbox.org // iGaming-mta.de // iRace-mta.de // iSurvival.de // mtasa.de
--
MigratorGUI = inherit(Singleton)
addRemoteEvents{"migrationLoginFailed", "migrationLoginSuccess", "migrationSuccess", "migrationFailed"}

function MigratorGUI:constructor()
    self.m_CurrentStep = 1

    self:createGUI()
    self.m_Window:show()
    showCursor(true)
end

function MigratorGUI:destructor()
    showCursor(false)
    delete(self.m_Window)
end

function MigratorGUI:createGUI()
    local width, height = 400, 250
    self.m_Window = GUIWindow:new("iRace Migration", 500, 200, width, height, true, true)
    self.m_Label_CurrentStep = GUILabel:new("Step 1 of 2", 10, 30, 100, 100, self.m_Window)
    self.m_Button_NextStep = GUIButton:new("Next", width - 70, height - 30, 60, 20, {["normal"] = {220, 80, 0}, ["hover"] = {220, 50, 0}}, self.m_Window)
    self.m_Label_Error = GUILabel:new("", 10, height - 30, 300, 30, self.m_Window)
    self.m_Label_Error:setAlign("left", "center")

    self.m_Step1 = GUIArea:new(0, 50, width, 160, self.m_Window)
    self.m_Step2 = GUIArea:new(0, 50, width, 160, self.m_Window)

    -- Step1
    self.m_Label_login = GUILabel:new("Please enter your old login credentials.", 10, 5, 300, 20, self.m_Step1)
    self.m_Editbox_Username = GUIEdit:new("Username", 10, 30, 180, 20, false, false, self.m_Step1)
    self.m_Editbox_Password = GUIEdit:new("Password", 10, 55, 180, 20, false, true, self.m_Step1)

    -- Step2
    self.m_Label_Selection = GUILabel:new("Please select ...", 10, 5, 300, 20, self.m_Step2)
    self.m_CB_Playtime = GUICheckbox:new("Migrate playtime (%s)", 10, 30, 180, 14, self.m_Step2)
    self.m_CB_Jointimes = GUICheckbox:new("Migrate jointimes (%s)", 10, 50, 180, 14, self.m_Step2)
    self.m_CB_Money = GUICheckbox:new("Migrate money (300000 $)", 10, 70, 180, 14, self.m_Step2)
    self.m_CB_DM = GUICheckbox:new("Migrate DM stats (%s)", 10, 90, 180, 14, self.m_Step2)
    self.m_CB_DD = GUICheckbox:new("Migrate DD stats (%s)", 10, 110, 180, 14, self.m_Step2)
    self.m_CB_Accept = GUICheckbox:new("I accept, that this action cannot be reverted.", 10, 140, 180, 14, self.m_Step2)

    self.m_CB_Playtime:setProperty("m_Checked", true)
    self.m_CB_Jointimes:setProperty("m_Checked", true)
    -- Step3

    self.m_Step2:setEnabled(false)

    self.fn_NextStep = bind(self.nextStep, self)
    self.m_Button_NextStep:addClickFunction(self.fn_NextStep)

   self.m_Window:updateRenderTarget()
end

function MigratorGUI:nextStep()
    if self.m_CurrentStep == 1 then
        triggerServerEvent("requestMigration", resourceRoot, self.m_Editbox_Username:getText(), self.m_Editbox_Password:getText())
        self.m_Label_Error:setText("#009000Sending request..")
        self.m_Button_NextStep:setEnabled(false)
        self.m_Window:updateRenderTarget()
    else
        if not self.m_CB_Accept:getSelected() then
            self.m_Label_Error:setText("#ff0000You have to accept the conditions.!")
            self.m_Window:updateRenderTarget()
            return
        end

        local doMigrate = {}
        doMigrate.playtime = self.m_CB_Playtime:getSelected()
        doMigrate.jointimes = self.m_CB_Jointimes:getSelected()
        doMigrate.money =  self.m_CB_Money:getSelected()
        doMigrate.dmstats = self.m_CB_DM:getSelected()
        doMigrate.ddstats = self.m_CB_DD:getSelected()
        triggerServerEvent("startMigration", resourceRoot, self.m_Editbox_Username:getText(), self.m_Editbox_Password:getText(), doMigrate)

        self.m_Label_Error:setText("#009000Sending request..")
        --self.m_Button_NextStep:setEnabled(false)
        self.m_Window:updateRenderTarget()
    end
end

addEventHandler("migrationLoginFailed", localPlayer,
    function(message, enableButton)
        local mgi = MigratorGUI:getSingleton()
        mgi.m_Label_Error:setText("#ff0000"..message)
        if enableButton then mgi.m_Button_NextStep:setEnabled(true) end
        mgi.m_Window:updateRenderTarget()
    end
)

addEventHandler("migrationLoginSuccess", localPlayer,
    function(receivedDatas)
        local mgi = MigratorGUI:getSingleton()
        mgi.m_Label_Error:setText("")
        mgi.m_Step1:setEnabled(false)
        mgi.m_Step2:setEnabled(true)
        mgi.m_Button_NextStep:setEnabled(true)
        mgi.m_CurrentStep = 2
        mgi.m_Label_CurrentStep:setText("Step 2 of 2")

        local default = mgi.m_CB_Playtime:getText()
        mgi.m_CB_Playtime:setText(default:format(receivedDatas.playtime))

        local default = mgi.m_CB_Jointimes:getText()
        mgi.m_CB_Jointimes:setText(default:format(receivedDatas.jointimes))

        local DMWinrate = 100/receivedDatas.DMPlayed*receivedDatas.DMWon
        local DDWinrate = 100/receivedDatas.DDPlayed*receivedDatas.DDWon
        local DMText = ("Played: %s | Wins: %s | Rate: %.0f%%"):format(receivedDatas.DMPlayed, receivedDatas.DMWon, DMWinrate)
        local DDText = ("Played: %s | Wins: %s | Rate: %.0f%%"):format(receivedDatas.DDPlayed, receivedDatas.DDWon, DDWinrate)

        local default = mgi.m_CB_DM:getText()
        mgi.m_CB_DM:setText(default:format(DMText))

        local default = mgi.m_CB_DD:getText()
        mgi.m_CB_DD:setText(default:format(DDText))

        mgi.m_Window:updateRenderTarget()
    end
)

addEventHandler("migrationSuccess", localPlayer,
    function()
        local mgi = MigratorGUI:getSingleton()
        delete(mgi)
        removeCommandHandler("migrate", localPlayer.fn_Migrate)
    end
)

addEventHandler("migrationFailed", localPlayer,
    function(message)
        local mgi = MigratorGUI:getSingleton()
        mgi.m_Label_Error:setText("#ff0000"..message)
        mgi.m_Button_NextStep:setEnabled(false)
        mgi.m_Window:updateRenderTarget()
    end
)