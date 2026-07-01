--[[ TSUM Inject Loader — инжекть ЭТОТ файл (~4KB). Подгружает tsum_free_script.lua ]]
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
if not LP then
    return warn("[TSUM] LocalPlayer nil")
end

local PATHS = {
    "tsum_free_script.lua",
    "tsum/tsum_free_script.lua",
    "scripts/tsum_free_script.lua",
}

local function showErr(msg)
    warn("[TSUM] " .. msg)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "TSUM_LoaderError"
        g.ResetOnSpawn = false
        g.DisplayOrder = 10001
        g.Parent = LP:WaitForChild("PlayerGui", 10)
        local t = Instance.new("TextLabel")
        t.Size = UDim2.fromScale(1, 1)
        t.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
        t.TextColor3 = Color3.fromRGB(255, 100, 100)
        t.Font = Enum.Font.Code
        t.TextSize = 14
        t.TextWrapped = true
        t.Text = "TSUM loader error:\n" .. msg
        t.Parent = g
    end)
end

if not (readfile and isfile and loadstring) then
    showErr("Executor needs readfile/isfile/loadstring.\nPut tsum_free_script.lua in workspace folder.")
    return
end

local src, usedPath
for _, p in ipairs(PATHS) do
    if isfile(p) then
        local ok, data = pcall(readfile, p)
        if ok and type(data) == "string" and #data > 1000 then
            src, usedPath = data, p
            break
        end
    end
end

if not src then
    showErr("tsum_free_script.lua not found.\nPaths tried:\n" .. table.concat(PATHS, "\n"))
    return
end

local fn, err = loadstring(src)
if not fn then
    showErr("Parse error in " .. usedPath .. ":\n" .. tostring(err))
    return
end

local ok, runErr = pcall(fn)
if not ok then
    showErr("Runtime error:\n" .. tostring(runErr))
end
