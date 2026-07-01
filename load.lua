--[[ TSUM Xeno Loader — вставь ТОЛЬКО ЭТО в Xeno и жми Execute ]]
local Players = game:GetService("Players")
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local URLIndices = {
    "tsum_free_script.lua",
    "Sliv1.lua",
    "tsum/Sliv1.lua",
    "scripts/Sliv1.lua",
}

local URLS = {
    "https://raw.githubusercontent.com/jnrnsw-star/Scripts/main/Sliv1.lua",
    "https://github.com/jnrnsw-star/Scripts/raw/refs/heads/main/Sliv1.lua",
}

local function show(text, color)
    color = color or Color3.fromRGB(255, 220, 120)
    warn("[TSUM] " .. text)
    pcall(function()
        local old = LP.PlayerGui:FindFirstChild("TSUM_XenoLoader")
        if old then
            old:Destroy()
        end
        local g = Instance.new("ScreenGui")
        g.Name = "TSUM_XenoLoader"
        g.ResetOnSpawn = false
        g.DisplayOrder = 10002
        g.Parent = LP.PlayerGui
        local l = Instance.new("TextLabel")
        l.Size = UDim2.fromScale(1, 1)
        l.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
        l.BackgroundTransparency = 0.1
        l.TextColor3 = color
        l.Font = Enum.Font.Code
        l.TextSize = 15
        l.TextWrapped = true
        l.Text = "TSUM Loader\n\n" .. text
        l.Parent = g
    end)
end

local function httpGet(url)
    if request then
        local res = request({ Url = url, Method = "GET" })
        if res and res.Body and #res.Body > 0 then
            return res.Body
        end
    end
    if syn and syn.request then
        local res = syn.request({ Url = url, Method = "GET" })
        if res and res.Body and #res.Body > 0 then
            return res.Body
        end
    end
    if http and http.request then
        local res = http.request({ Url = url, Method = "GET" })
        if res and res.Body and #res.Body > 0 then
            return res.Body
        end
    end
    if game.HttpGetAsync then
        return game:HttpGetAsync(url)
    end
    return game:HttpGet(url)
end

local compile = loadstring or load
if not compile then
    show("Нет loadstring/load — executor не поддерживается", Color3.fromRGB(255, 90, 90))
    return
end

show("Загрузка TSUM...")

local src, sourceName

if readfile and isfile then
    for _, path in ipairs(URLIndices) do
        if isfile(path) then
            local ok, body = pcall(readfile, path)
            if ok and type(body) == "string" and #body > 5000 then
                src, sourceName = body, "local: " .. path
                break
            end
        end
    end
end

if not src then
    show("Скачиваю с GitHub...\nПодожди 5–15 сек")
    for _, url in ipairs(URLS) do
        local ok, body = pcall(httpGet, url)
        if ok and type(body) == "string" and #body > 5000 and not body:find("<!DOCTYPE", 1, true) then
            src, sourceName = body, url
            break
        end
    end
end

if not src then
    show(
        "Не удалось загрузить скрипт.\n\n"
            .. "Вариант A: залей Sliv1.lua на GitHub\n"
            .. "Вариант B: положи tsum_free_script.lua в workspace Xeno\n"
            .. "Вариант C: включи HttpGet в настройках Xeno",
        Color3.fromRGB(255, 90, 90)
    )
    return
end

show("Парсинг " .. math.floor(#src / 1024) .. " KB...\n" .. tostring(sourceName))

local fn, parseErr = compile(src)
if not fn then
    show("Ошибка парсинга:\n" .. tostring(parseErr), Color3.fromRGB(255, 90, 90))
    return
end

local ok, runErr = pcall(fn)
if not ok then
    show("Ошибка запуска:\n" .. tostring(runErr), Color3.fromRGB(255, 90, 90))
    return
end

pcall(function()
    local g = LP.PlayerGui:FindFirstChild("TSUM_XenoLoader")
    if g then
        g:Destroy()
    end
end)
