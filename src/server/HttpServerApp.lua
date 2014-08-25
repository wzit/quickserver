local HttpServerApp = class("HttpServerApp", cc.server.HttpServerBase)

function HttpServerApp:ctor(config)
    HttpServerApp.super.ctor(self, config)

    if self.config.debug then
        print("---------------- START -----------------")
        -- self:getComponent("components.behavior.EventProtocol"):setEventProtocolDebugEnabled(true)
    end

    self:addEventListener(HttpServerApp.CLIENT_ABORT_EVENT, self.onClientAbort, self)

end

function HttpServerApp:doRequest(actionName, data, userDefModule)
    if self.config.debug then
        --printLog("ACTION", ">> call [%s]", actionName)
        echoInfo("ACTION >> call [%s]", actionName)
    end

    local _, result = xpcall(function()
        return HttpServerApp.super.doRequest(self, actionName, data, userDefModule)
    end, function() return {error = "Handle http request failed: actions module or file not found"} end)

    if self.config.debug then
        local j = json.encode(result)
        --printLog("ACTION", "<< ret  [%s] = (%d bytes) %s", actionName, string.len(j), j)
        echoInfo("ACTION << ret  [%s] = (%d bytes) %s", actionName, string.len(j), j)
        --printLog("ACTION", "<<<<")
        --echoInfo("ACTION <<")
    end

    return result
end

-- events callback
-- dummy here
function HttpServerApp:onClientAbort(event)

end

return HttpServerApp