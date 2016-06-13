Main = {}

function Main.resourceStart()
    -- Request Domains
    if isBrowserDomainBlocked("pewx.de") then
        Main.requestDomains()
        return
    end

    -- Instantiate Core
    core = Core:new()
end
addEventHandler("onClientResourceStart", resourceRoot, Main.resourceStart, true, "high+99999")

function Main.resourceStop()
    core:delete()
end
addEventHandler("onClientResourceStop", resourceRoot, Main.resourceStop, true, "low-999999")

function Main.requestDomains()
    requestBrowserDomains{"pewx.de", "irace-mta.de"}

    Main.domainsTimer = setTimer(
        function()
            if not isBrowserDomainBlocked("pewx.de") then
                showChat(false)
                killTimer(Main.domainsTimer)
                Main.resourceStart()
            else
                showChat(true)
                outputChatBox("Please accept our requested domains! Otherwise you will not be able to play!", 255, 0, 0)
            end
        end, 500, 0
    )
end