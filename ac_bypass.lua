--[[
    Universal anti-cheat bypass layer for TSUM QA script.
    Covers: Adonis, namecall/index detectors, kick hooks, movement resets.
]]

return function(ctx)
    local AC = ctx.AC
    local LocalPlayer = ctx.LocalPlayer
    local RunService = ctx.RunService
    local hooked = {}
    local detectedRef, killRef

    local function log(msg)
        if ctx.debug then
            warn("[TSUM-AC] " .. tostring(msg))
        end
    end

    local function wrapCclosure(fn)
        if newcclosure then
            return newcclosure(fn)
        end
        return fn
    end

    -- Adonis: Detected + Kill via table patch and hookfunction
    local function bypassAdonis()
        if not getgc then
            return 0
        end
        local count = 0
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" then
                local det = rawget(v, "Detected")
                local kill = rawget(v, "Kill")
                if type(det) == "function" and not hooked[det] then
                    hooked[det] = true
                    detectedRef = det
                    local replacement = wrapCclosure(function(action, info)
                        if action ~= "_" and ctx.debug then
                            log("Adonis Detected: " .. tostring(action))
                        end
                        return true
                    end)
                    v.Detected = replacement
                    if hookfunction then
                        pcall(function()
                            hookfunction(det, replacement)
                        end)
                    end
                    count += 1
                end
                if type(kill) == "function" and rawget(v, "Process") and not hooked[kill] then
                    hooked[kill] = true
                    killRef = kill
                    local replacement = wrapCclosure(function(info)
                        log("Adonis Kill blocked: " .. tostring(info))
                    end)
                    v.Kill = replacement
                    if hookfunction then
                        pcall(function()
                            hookfunction(kill, replacement)
                        end)
                    end
                    count += 1
                end
            end
        end
        return count
    end

    -- Adonis debug.info sanity check bypass
    local function bypassDebugInfo()
        if not (getrenv and detectedRef) then
            return false
        end
        local renv = getrenv()
        local dbg = renv and renv.debug
        if not (dbg and dbg.info) then
            return false
        end
        local oldInfo = dbg.info
        if hooked[oldInfo] then
            return true
        end
        hooked[oldInfo] = true
        local replacement = wrapCclosure(function(levelOrFunc, ...)
            if detectedRef and levelOrFunc == detectedRef then
                return coroutine.yield(coroutine.running())
            end
            return oldInfo(levelOrFunc, ...)
        end)
        dbg.info = replacement
        if hookfunction then
            pcall(function()
                hookfunction(oldInfo, replacement)
            end)
        end
        return true
    end

    -- Adonis indexInstance detector (always return false)
    local function bypassIndexInstance()
        if not getgc then
            return false
        end
        for _, v in ipairs(getgc(true)) do
            if type(v) == "table" then
                local idx = rawget(v, "indexInstance")
                if type(idx) == "table" then
                    for key, val in pairs(idx) do
                        if type(val) == "function" and not hooked[val] then
                            hooked[val] = true
                            local noop = wrapCclosure(function()
                                return false
                            end)
                            idx[key] = noop
                            if hookfunction then
                                pcall(function()
                                    hookfunction(val, noop)
                                end)
                            end
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    -- NamecallInstance kick detector
    local function bypassNamecallDetector()
        if not (getgc and hookfunction and getconstants) then
            return false
        end
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" and rawget(tbl, "namecallInstance") then
                for _, stack in pairs(tbl) do
                    if type(stack) == "table" then
                        for i, val in ipairs(stack) do
                            if val == "kick" and type(stack[i + 1]) == "function" then
                                local fn = stack[i + 1]
                                if not hooked[fn] then
                                    hooked[fn] = true
                                    hookfunction(fn, wrapCclosure(function()
                                        return false
                                    end))
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
    end

    -- Disable client kick listeners (getconnections)
    local function disableKickConnections()
        if not getconnections then
            return 0
        end
        local n = 0
        pcall(function()
            for _, conn in ipairs(getconnections(LocalPlayer:GetPropertyChangedSignal("Parent"))) do
                pcall(function()
                    conn:Disable()
                    n += 1
                end)
            end
        end)
        return n
    end

    -- Disable suspicious anti-cheat connections on Humanoid
    local function disableMovementChecks()
        if not getconnections then
            return
        end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then
            return
        end
        for _, prop in ipairs({ "WalkSpeed", "JumpPower", "PlatformStand" }) do
            pcall(function()
                for _, conn in ipairs(getconnections(hum:GetPropertyChangedSignal(prop))) do
                    pcall(function()
                        conn:Disable()
                    end)
                end
            end)
        end
    end

    local function installKickHooks()
        if not hookmetamethod then
            return
        end

        local oldNc
        local ncFn = wrapCclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            if checkcaller and checkcaller() then
                return oldNc(self, ...)
            end
            if AC.enabled and AC.antiKick then
                if method == "Kick" and self == LocalPlayer then
                    return nil
                end
                if method == "Shutdown" and self == game then
                    return nil
                end
            end
            return oldNc(self, ...)
        end)
        oldNc = hookmetamethod(game, "__namecall", ncFn)

        -- Block LocalPlayer.Kick via __index (Adonis anti-kick trick)
        pcall(function()
            local oldIdx
            local idxFn = wrapCclosure(function(self, key)
                if AC.enabled and AC.antiKick and self == LocalPlayer then
                    if type(key) == "string" and key:lower() == "kick" then
                        return error("Expected ':' not '.' calling member function Kick", 2)
                    end
                end
                return oldIdx(self, key)
            end)
            oldIdx = hookmetamethod(game, "__index", idxFn)
        end)
    end

    local function installIndexHook()
        if not hookmetamethod then
            return
        end
        local oldIdx
        local idxFn = wrapCclosure(function(self, key)
            if checkcaller and checkcaller() then
                return oldIdx(self, key)
            end
            if AC.enabled and AC.hideCoreGui and key == "CoreGui" and self == game then
                if gethui then
                    return gethui()
                end
            end
            return oldIdx(self, key)
        end)
        pcall(function()
            oldIdx = hookmetamethod(game, "__index", idxFn)
        end)
    end

    local function installMovementGuards()
        RunService.Heartbeat:Connect(function()
            if not AC.enabled then
                return
            end
            local char = LocalPlayer.Character
            if not char then
                return
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and AC.antiSpeed then
                if hum.WalkSpeed > 0 and hum.WalkSpeed < 12 then
                    hum.WalkSpeed = AC.walkSpeed
                end
                if hum.JumpPower > 0 and hum.JumpPower < 20 then
                    hum.JumpPower = AC.jumpPower
                end
                if hum.PlatformStand then
                    hum.PlatformStand = false
                end
            end
            if AC.antiFling then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.AssemblyLinearVelocity.Magnitude > 80 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end

    local function hideExecutorGui(gui)
        if not gui then
            return
        end
        pcall(function()
            if gethui then
                gui.Parent = gethui()
            elseif syn and syn.protect_gui then
                syn.protect_gui(gui)
            end
        end)
    end

    local function fullBypassPass()
        local n = bypassAdonis()
        bypassDebugInfo()
        bypassIndexInstance()
        bypassNamecallDetector()
        disableKickConnections()
        disableMovementChecks()
        return n
    end

    return {
        install = function()
            if setthreadidentity then
                pcall(function()
                    setthreadidentity(2)
                end)
            end
            pcall(installKickHooks)
            pcall(installIndexHook)
            pcall(installMovementGuards)
            task.spawn(function()
                for i = 1, 6 do
                    task.wait(i == 1 and 0.5 or 2)
                    pcall(fullBypassPass)
                end
                if setthreadidentity then
                    pcall(function()
                        setthreadidentity(7)
                    end)
                end
            end)
        end,
        hideGui = hideExecutorGui,
        refreshAdonis = fullBypassPass,
    }
end
