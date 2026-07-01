--[[
    TSUM Free Script — AutoFarm + AutoBuy
    made by tsumfreescript

    ESP, AutoBuy, AutoFarm, TP к барыге.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    LocalPlayer = Players.PlayerAdded:Wait()
end

local Rayfield = nil
local ACBridge = nil

local function showBootError(message)
    warn("[TSUM] " .. tostring(message))
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "TSUM_BootError"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 10000
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui", 10) or LocalPlayer.PlayerGui
        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        label.BackgroundTransparency = 0.15
        label.TextColor3 = Color3.fromRGB(255, 120, 120)
        label.Font = Enum.Font.Code
        label.TextSize = 14
        label.TextWrapped = true
        label.Text = "TSUM script error:\n" .. tostring(message)
        label.Parent = gui
    end)
end

local function waitChild(parent, name, timeout)
    if not parent then
        return nil
    end
    local found = parent:FindFirstChild(name)
    if found then
        return found
    end
    return parent:WaitForChild(name, timeout or 20)
end

local function loadRayfield()
    if Rayfield then
        return true
    end
    local urls = {
        "https://sirius.menu/rayfield",
        "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua",
    }
    for _, url in ipairs(urls) do
        local ok, lib = pcall(function()
            local src = game.HttpGetAsync and game:HttpGetAsync(url) or game:HttpGet(url)
            local compile = loadstring or load
            return compile(src)()
        end)
        if ok and lib and type(lib) == "table" and lib.CreateWindow then
            Rayfield = lib
            return true
        end
    end
    showBootError("Rayfield не загрузился — проверь HTTP в executor")
    return false
end

local TG_URL = "https://t.me/tsumfreescript"

local function openTelegram()
    local opened = false
    pcall(function()
        local guiService = game:GetService("GuiService")
        if guiService.OpenBrowserWindow then
            guiService:OpenBrowserWindow(TG_URL)
            opened = true
        end
    end)
    if not opened then
        pcall(function()
            if syn and syn.open_browser then
                syn.open_browser(TG_URL)
                opened = true
            end
        end)
    end
    if not opened then
        pcall(function()
            if fluxus and fluxus.openbrowser then
                fluxus.openbrowser(TG_URL)
                opened = true
            end
        end)
    end
    if not opened then
        pcall(function()
            if request then
                request({ Url = TG_URL, Method = "GET" })
            end
        end)
    end
    pcall(function()
        if setclipboard then
            setclipboard(TG_URL)
        end
    end)
end

-- Ранний splash (до тяжёлого кода) — виден сразу после парсинга
local BOOT_DONE = false
local function bootSplash(onContinue)
    local ok, err = pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "TSUM_Splash"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 999
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui", 15) or LocalPlayer.PlayerGui

        local card = Instance.new("Frame")
        card.Size = UDim2.fromOffset(320, 160)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        card.BorderSizePixel = 0
        card.Parent = gui

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 40)
        title.Position = UDim2.fromOffset(10, 16)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20
        title.Text = "TSUM | tsumfreescript"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -20, 0, 40)
        sub.Position = UDim2.fromOffset(10, 56)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 13
        sub.TextWrapped = true
        sub.Text = "Загрузка..."
        sub.TextColor3 = Color3.fromRGB(170, 175, 185)
        sub.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 36)
        btn.Position = UDim2.new(0.5, 0, 1, -48)
        btn.AnchorPoint = Vector2.new(0.5, 0)
        btn.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
        btn.Text = "Continue"
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = card
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            gui:Destroy()
            BOOT_DONE = true
            task.spawn(onContinue)
        end)
    end)
    if not ok then
        showBootError("Splash: " .. tostring(err))
        task.defer(onContinue)
    end
end

task.defer(openTelegram)

-- Rayfield загружается в loadMainUI (не блокируем старт)

-- Shop catalog: embedded payload, lazy decode after splash
local SHOP_CATALOG = { byName = {}, byId = {} }
local CatalogState = { started = false, done = false }

local CATALOG_FALLBACK = {
    byName = {
        ["Белая футболка"] = { rarity = "Common", fairPrice = 120, spawnChance = 55, id = "1352050969", type = "Shirt" },
        ["Drip футболка"] = { rarity = "Rare", fairPrice = 1200, spawnChance = 8, id = "6384915788", type = "Shirt" },
        ["Золотая цепь"] = { rarity = "Epic", fairPrice = 3800, spawnChance = 1.5, id = "12001043365", type = "Shirt" },
        ["BAPE Full Zip Shark"] = { rarity = "Legendary", fairPrice = 135000, spawnChance = 0.005, id = "1329266704", type = "Shirt" },
    },
    byId = {
        ["1352050969"] = { name = "Белая футболка", rarity = "Common", fairPrice = 120, spawnChance = 55 },
        ["6384915788"] = { name = "Drip футболка", rarity = "Rare", fairPrice = 1200, spawnChance = 8 },
    },
}

local function loadShopCatalogFromFile()
    if not (readfile and isfile and loadstring) then
        return nil
    end
    for _, path in ipairs({
        "shop_catalog_data.lua",
        "tsum/shop_catalog_data.lua",
        "tsum_free_script_catalog.lua",
    }) do
        if isfile(path) then
            local ok, data = pcall(function()
                return loadstring(readfile(path))()
            end)
            if ok and type(data) == "table" and data.byName then
                return data
            end
        end
    end
    return nil
end

function TSUM_loadEmbeddedCatalogAsync(callback)
    if CatalogState.done then
        if callback then callback(SHOP_CATALOG) end
        return
    end
    if CatalogState.started then
        task.spawn(function()
            while not CatalogState.done do task.wait(0.05) end
            if callback then callback(SHOP_CATALOG) end
        end)
        return
    end
    CatalogState.started = true
    task.spawn(function()
        local cat = loadShopCatalogFromFile()
        if type(EMBEDDED_CATALOG_B64) == "table" and #EMBEDDED_CATALOG_B64 > 0 and b64decode then
            local ok, result = pcall(function()
                local HttpService = game:GetService("HttpService")
                local raw = b64decode(table.concat(EMBEDDED_CATALOG_B64))
                local compact = HttpService:JSONDecode(raw)
                return expandCatalogCompact and expandCatalogCompact(compact) or compact
            end)
            if ok and type(result) == "table" and next(result.byName) then
                cat = result
            end
        end
        SHOP_CATALOG = cat or CATALOG_FALLBACK
        initShopCatalogIndex()
        State.catalogLoaded = true
        CatalogState.done = true
        if callback then callback(SHOP_CATALOG) end
    end)
end

--{{AUTOBUY_CATALOG}}
local AUTOBUY_ITEMS = {
    ["Common"] = {
        { n = "Белая футболка", i = 1352050969, s = 55.0, p = 120 },
        { n = "Черная футболка", i = 6174845177, s = 55.0, p = 120 },
        { n = "Синие джинсы", i = 9367316394, s = 50.0, p = 150 },
        { n = "Черные джинсы", i = 8425198358, s = 50.0, p = 150 },
        { n = "Серая футболка", i = 114724377, s = 45.0, p = 180 },
        { n = "Nike Черная", i = 12820715433, s = 40.0, p = 900 },
        { n = "Gutta Opiu White", i = 125787142138788, s = 38.0, p = 500 },
        { n = "Nike Шорты", i = 6982632122, s = 38.0, p = 800 },
        { n = "Amiri Футболка Черная2", i = 89306530816863, s = 20.0, p = 3200 },
    },
    ["Uncommon"] = {
        { n = "Gutta Classic White Longsleeve", i = 81243747834531, s = 35.0, p = 1200 },
        { n = "Gutta Longsleeve Pink Blue", i = 121948527526959, s = 35.0, p = 1200 },
        { n = "Gutta Opiu Tee", i = 129923898671032, s = 35.0, p = 1200 },
        { n = "Stussy Stock Logo Tee", i = 1352050969, s = 32.0, p = 1600 },
        { n = "Carhartt Hoodie", i = 6174845177, s = 30.0, p = 2000 },
        { n = "Palace Tri-Ferg Tee", i = 1352050969, s = 30.0, p = 2200 },
        { n = "Carhartt Double Knee", i = 8425198358, s = 28.0, p = 2500 },
        { n = "Nike x Stussy", i = 17303641875, s = 28.0, p = 1400 },
        { n = "Stussy Work Pants", i = 8425198358, s = 28.0, p = 2200 },
        { n = "Palace Track Pants", i = 8425198358, s = 25.0, p = 2800 },
        { n = "Граффити футболка", i = 6877956799, s = 25.0, p = 450 },
        { n = "Nike Hoodie", i = 4746292577, s = 22.0, p = 1800 },
        { n = "Рваные джинсы", i = 15617408766, s = 20.0, p = 550 },
        { n = "Gutta Opiu Black", i = 103809820683913, s = 10.0, p = 1000 },
        { n = "Gutta Coffee Longsleeve", i = 131637613314592, s = 6.0, p = 1800 },
        { n = "Amiri Худи Зеленое", i = 113811400216537, s = 3.0, p = 11000 },
        { n = "Amiri Футболка Paint", i = 128351870809134, s = 1.5, p = 7500 },
    },
    ["Rare"] = {
        { n = "Rick Owens Zip", i = 92750199062144, s = 25.0, p = 18500 },
        { n = "Rick Owens Штаны", i = 14220615409, s = 22.0, p = 22000 },
        { n = "BAPE Camo", i = 3131452093, s = 20.0, p = 4500 },
        { n = "BAPE Camo штаны", i = 4947216628, s = 20.0, p = 3800 },
        { n = "Carhartt Detroit Jacket", i = 1352050969, s = 20.0, p = 3500 },
        { n = "Gutta Hoodie Black", i = 73257106599901, s = 20.0, p = 3200 },
        { n = "Rick Owens Джинсы", i = 18477705722, s = 20.0, p = 25000 },
        { n = "Gutta Hoodie Grey", i = 6877956799, s = 18.0, p = 3200 },
        { n = "Nike Tech", i = 11554103603, s = 16.0, p = 2800 },
        { n = "Palace Hoodie", i = 6174845177, s = 16.0, p = 4800 },
        { n = "Stussy 8 Ball Hoodie", i = 6174845177, s = 16.0, p = 3800 },
        { n = "Supreme Box Logo", i = 1499082681, s = 15.0, p = 12000 },
        { n = "BAPE Shark", i = 94733728494733, s = 14.0, p = 6200 },
        { n = "Burberry Classic", i = 14182270450, s = 14.0, p = 11000 },
        { n = "Burberry Штаны", i = 16218939509, s = 14.0, p = 12500 },
        { n = "Carhartt Cargo", i = 9367316394, s = 14.0, p = 3800 },
        { n = "Cav Empt Свитшот Черный", i = 124139147116818, s = 14.0, p = 4500 },
        { n = "Palm Angels Классик", i = 18660217283, s = 14.0, p = 12000 },
        { n = "Palm Angels Серые", i = 10468675783, s = 14.0, p = 12000 },
        { n = "Stone Island Default", i = 16388179108, s = 14.0, p = 14500 },
        { n = "Stone Island Default", i = 15177463566, s = 14.0, p = 14500 },
        { n = "Acne Studios Face Tee", i = 1352050969, s = 12.0, p = 9500 },
        { n = "Amiri Футболка Черная", i = 18694595667, s = 12.0, p = 5500 },
        { n = "CP.Company Default Pants", i = 6664977420, s = 12.0, p = 12500 },
        { n = "Carhartt Shirt Jacket", i = 114724377, s = 12.0, p = 4200 },
        { n = "Nike Tech Pants", i = 11410851476, s = 12.0, p = 3200 },
        { n = "Palm Angels", i = 85991896636316, s = 12.0, p = 14500 },
        { n = "Stussy Nylon Pants", i = 9367316394, s = 12.0, p = 4000 },
        { n = "Supreme Pants", i = 7092331508, s = 12.0, p = 6500 },
        { n = "Гоша Рубчинский Base", i = 15056443139, s = 12.0, p = 9500 },
        { n = "Stone Island Joggers", i = 120383454886093, s = 11.0, p = 16500 },
        { n = "CP.Company Свитшот", i = 14077919304, s = 10.0, p = 16500 },
        { n = "Gallery Dept Спортивки Черные", i = 13974345356, s = 10.0, p = 4500 },
        { n = "Palace Cargo", i = 9367316394, s = 10.0, p = 4500 },
        { n = "Гоша Рубчинский x Fila", i = 438195463, s = 10.0, p = 12000 },
        { n = "CP.Company Rose", i = 125295721091210, s = 9.0, p = 15500 },
        { n = "NeNet Футболка Черная", i = 134937339779999, s = 9.0, p = 4500 },
        { n = "Black Milo Shark Tee", i = 4695588521, s = 8.0, p = 7800 },
        { n = "CP.Company Blue Hoodie", i = 16974592422, s = 8.0, p = 17500 },
        { n = "CP.Company Gray Pants", i = 15783604661, s = 8.0, p = 19500 },
        { n = "Comme des Garcons Футболка", i = 14582695300, s = 8.0, p = 11000 },
        { n = "Drip футболка", i = 6384915788, s = 8.0, p = 1200 },
        { n = "Gallery Dept Спортивки Голубой", i = 93556375284974, s = 8.0, p = 4200 },
        { n = "Gallery Dept Спортивки Серые", i = 12792854135, s = 8.0, p = 4200 },
        { n = "Gutta Zip-Hoodie", i = 87059217590619, s = 8.0, p = 3800 },
        { n = "Nike Air Pants", i = 14343129826, s = 7.0, p = 4200 },
        { n = "CP.Company Short Yellow", i = 13476230890, s = 6.0, p = 16000 },
        { n = "NeNet Футболка Черный v2", i = 15015469155, s = 6.0, p = 4800 },
        { n = "Nenet Штаны", i = 70880619395363, s = 6.0, p = 3800 },
        { n = "CP.Company Blue Pants", i = 14050651166, s = 5.0, p = 21000 },
        { n = "Designer джинсы", i = 18391376326, s = 5.0, p = 1400 },
        { n = "NeNet Футболка Белая", i = 12089573241, s = 5.0, p = 5200 },
        { n = "Racer WorldWide Свитшот", i = 11831115149, s = 3.5, p = 14500 },
        { n = "Stone Island Свитшот", i = 1315352916, s = 3.5, p = 32000 },
        { n = "Gallery Dept Спортивки Бежевый", i = 128614066781001, s = 3.0, p = 6500 },
        { n = "Gallery Dept Спортивки Розовая", i = 99632820598737, s = 3.0, p = 6500 },
        { n = "Racer WorldWide Свитшот Красный", i = 78683849537161, s = 3.0, p = 14500 },
        { n = "BAPE Футболка", i = 105402915829012, s = 2.5, p = 5500 },
        { n = "Gutta Black-White Longsleeve", i = 75730721795242, s = 2.5, p = 2800 },
        { n = "Racer WorldWide Aphex Футболка", i = 16579558789, s = 1.8, p = 9500 },
    },
    ["Epic"] = {
        { n = "Vetements Лонгслив", i = 95060430454867, s = 18.0, p = 13000 },
        { n = "Chrome Hearts Logo White", i = 14502536751, s = 15.0, p = 24000 },
        { n = "Maison Margiela Светлые Джинсы", i = 104326582321744, s = 15.0, p = 45000 },
        { n = "Prada Cargo", i = 8425198358, s = 15.0, p = 42000 },
        { n = "Prada Linea Rossa", i = 6174845177, s = 15.0, p = 38000 },
        { n = "Rick Owens Футболка", i = 82934586126898, s = 15.0, p = 28000 },
        { n = "CP.Company Orange Майка", i = 81270251381720, s = 12.0, p = 11500 },
        { n = "Gucci Logo Tee", i = 2464334422, s = 12.0, p = 32000 },
        { n = "Rick Drkshdw Pants", i = 12517077399, s = 12.0, p = 38000 },
        { n = "Rick Owens DRKSHDW", i = 15422438906, s = 12.0, p = 35000 },
        { n = "CP.Company Blanc Майка", i = 74448709325820, s = 11.0, p = 11500 },
        { n = "Balenciaga Logo Print Tee", i = 124231377168467, s = 10.0, p = 24000 },
        { n = "Chrome Hearts Tee Black", i = 134619700442692, s = 10.0, p = 36000 },
        { n = "Gucci Sweatshirt Tiger", i = 2672925839, s = 10.0, p = 28000 },
        { n = "LV Jeans", i = 15292591748, s = 10.0, p = 34000 },
        { n = "LV Shirts", i = 135386999852550, s = 10.0, p = 32000 },
        { n = "Rick Owens Джинсовка", i = 98599150857223, s = 10.0, p = 50000 },
        { n = "Balenciaga Logo", i = 11386091941, s = 8.0, p = 28000 },
        { n = "Cav Empt Зип-Худи", i = 2944205656, s = 8.0, p = 6200 },
        { n = "Chrome Hearts Blue", i = 15705156210, s = 8.0, p = 32000 },
        { n = "Gallery Dept Футболка Белый", i = 13835053077, s = 8.0, p = 5200 },
        { n = "Gallery Dept Футболка Черная", i = 11725889271, s = 8.0, p = 4800 },
        { n = "Gucci Lamb", i = 5023083383, s = 8.0, p = 34000 },
        { n = "Gucci shorts x Blue Lubz", i = 5634486976, s = 8.0, p = 36000 },
        { n = "Moncler Black Polo", i = 10793538519, s = 8.0, p = 26000 },
        { n = "Moncler Tech Pants", i = 11382056477, s = 8.0, p = 28000 },
        { n = "Moncler White Polo", i = 80707179561942, s = 8.0, p = 26000 },
        { n = "Rick Owens Джинсовка Черная", i = 136218865674437, s = 8.0, p = 55000 },
        { n = "Rick Owens Джинсы Зип", i = 89501380293235, s = 8.0, p = 45000 },
        { n = "Supreme Свитшот", i = 3463183841, s = 8.0, p = 18500 },
        { n = "Vetements Лонгслив Черный", i = 91606294899206, s = 8.0, p = 26000 },
        { n = "Vetements Худи", i = 18983373539, s = 8.0, p = 20000 },
        { n = "Maison Margiela Лонгслив Белая", i = 108337687172395, s = 7.0, p = 57000 },
        { n = "Maison Margiela Лонгслив Черный", i = 138263043704514, s = 7.0, p = 57000 },
        { n = "Vetements Худи Черное", i = 81560105275312, s = 7.0, p = 26000 },
        { n = "1017 ALYX 9SM Футболка Белая", i = 13607073567, s = 6.0, p = 9000 },
        { n = "Cav Empt Chemical Engineering", i = 3652598277, s = 6.0, p = 8500 },
        { n = "Gucci LOVE", i = 956388277, s = 6.0, p = 36000 },
        { n = "Moncler Big Logo", i = 11998504162, s = 6.0, p = 32000 },
        { n = "Moncler Yellow Mini Puffer", i = 8171196077, s = 6.0, p = 28000 },
        { n = "Off-White Черная", i = 4464224771, s = 6.0, p = 18500 },
        { n = "Palm Angels Bear", i = 7724732726, s = 6.0, p = 16000 },
        { n = "Rick Owens Джинсовка Синяя", i = 77234120970244, s = 6.0, p = 60000 },
        { n = "Vetements Vamp Футболка", i = 86185820213136, s = 6.0, p = 34000 },
        { n = "Гоша Рубчинский Flag", i = 5809785846, s = 6.0, p = 18500 },
        { n = "Гоша Рубчинский Белая Футболка", i = 1435177629, s = 6.0, p = 9500 },
        { n = "Off-White Белая Футболка", i = 111494454911134, s = 5.5, p = 18500 },
        { n = "1017 ALYX 9SM Свитшот", i = 12014837061, s = 5.0, p = 10000 },
        { n = "Acne Studios Jeans", i = 8425198358, s = 5.0, p = 22000 },
        { n = "BAPE Shark Фиолетовая", i = 120028188529902, s = 5.0, p = 8800 },
        { n = "BAPE Tiger Фиолетовый", i = 132534299493006, s = 5.0, p = 8500 },
        { n = "CP.Company Noir Default", i = 87883117918210, s = 5.0, p = 22000 },
        { n = "Cav Empt Свитшот Черный v2", i = 132771012378737, s = 5.0, p = 7200 },
        { n = "Maison Margiela Свитер", i = 18270211852, s = 5.0, p = 92000 },
        { n = "Moncler Black Full Sleeve", i = 3163582983, s = 5.0, p = 32000 },
        { n = "Moncler Classic Pants", i = 80212103951429, s = 5.0, p = 34000 },
        { n = "Moncler Vest Orange", i = 8162777342, s = 5.0, p = 34000 },
        { n = "NeNet Свитшот", i = 129051289938686, s = 5.0, p = 9500 },
        { n = "Rick Owens Штаны X Champion", i = 85545557857293, s = 5.0, p = 55000 },
        { n = "BAPE Holographic Tiger Черная", i = 84803613886580, s = 4.5, p = 9500 },
        { n = "Palm Angels Zip Классик", i = 15161522231, s = 4.5, p = 24000 },
        { n = "Stone Island Gray Pants", i = 13781107752, s = 4.5, p = 28000 },
        { n = "BAPE Зеленый/Оранжевый Tiger Белый", i = 127813886164608, s = 4.0, p = 7800 },
        { n = "Burberry London", i = 14961358306, s = 4.0, p = 26000 },
        { n = "Cav Empt Свитшот Серый", i = 139626993726125, s = 4.0, p = 9500 },
        { n = "Comme des Garcons Camo Футболка", i = 5575894980, s = 4.0, p = 12500 },
        { n = "Comme des Garcons Свитшот Серый", i = 11602203772, s = 4.0, p = 18500 },
        { n = "Gallery Dept Футболка Зеленая", i = 101110457561961, s = 4.0, p = 4800 },
        { n = "HBA Морф", i = 16452154247, s = 4.0, p = 12000 },
        { n = "Moncler Black Jacket Alt", i = 5964807969, s = 4.0, p = 34000 },
        { n = "Moncler Orange Jacket", i = 5960853118, s = 4.0, p = 34000 },
        { n = "Moncler Yellow Puffer", i = 8162975494, s = 4.0, p = 34000 },
        { n = "NeNet Свитшот Синий", i = 126688679972643, s = 4.0, p = 12000 },
        { n = "Palm Angels Zip Серая", i = 15616127684, s = 4.0, p = 26000 },
        { n = "Stussy World Tour", i = 114724377, s = 4.0, p = 7200 },
        { n = "Vetements Лонгслив Темно-Синий", i = 99150978070886, s = 4.0, p = 26000 },
        { n = "Acne Studios Oversized Hoodie", i = 6174845177, s = 3.5, p = 28000 },
        { n = "BAPE Tiger Colors Черный", i = 74566614556041, s = 3.5, p = 8200 },
        { n = "BAPE Tiger Red", i = 2783959084, s = 3.5, p = 11500 },
        { n = "Comme des Garcons Лонгслив Белый-Черный", i = 5699364090, s = 3.5, p = 14500 },
        { n = "Nike Tech Blue", i = 11554264756, s = 3.5, p = 4800 },
        { n = "1017 ALYX 9SM Рубашка", i = 116739608201251, s = 3.0, p = 18000 },
        { n = "Bape Tiger Зеленый/Оранжевый", i = 107348845353432, s = 3.0, p = 9200 },
        { n = "Gallery Dept Лонгслив", i = 71091220191588, s = 3.0, p = 6200 },
        { n = "Goyard Джинсы", i = 1226570804, s = 3.0, p = 55000 },
        { n = "Goyard Джинсы v2", i = 993568649, s = 3.0, p = 58000 },
        { n = "Moncler Green Jacket", i = 6722978612, s = 3.0, p = 34000 },
        { n = "NeNet Свитшот Черный", i = 124013704220310, s = 3.0, p = 10500 },
        { n = "Off-White Синяя", i = 2744313464, s = 3.0, p = 24000 },
        { n = "Palace x Adidas", i = 114724377, s = 3.0, p = 9500 },
        { n = "Palm Angels Zip", i = 5973979386, s = 3.0, p = 22000 },
        { n = "Palm Angels Футболка Bear", i = 12257396304, s = 3.0, p = 18000 },
        { n = "BAPE Dubai Camo Shark Белый", i = 79138012674866, s = 2.5, p = 11000 },
        { n = "Gallery Dept Футболка", i = 101869006032601, s = 2.5, p = 5200 },
        { n = "Gallery Dept Футболка Синяя", i = 125540636897982, s = 2.5, p = 5500 },
        { n = "Supreme x ASAP", i = 431730384, s = 2.5, p = 32000 },
        { n = "Yohji Yamamoto Спортивная Куртка Poison", i = 14606133245, s = 2.5, p = 38000 },
        { n = "1017 ALYX 9SM x Moncler Свитшот", i = 14307549017, s = 2.0, p = 18000 },
        { n = "1017 ALYX 9SM Свитшот Красный", i = 10253718453, s = 2.0, p = 18000 },
        { n = "BAPE Panda Фиолетовый камуфляж", i = 96225370149582, s = 2.0, p = 9800 },
        { n = "Balenciaga Tiger", i = 88020456613700, s = 2.0, p = 36000 },
        { n = "Goyard Классическая Футболка", i = 907988303, s = 2.0, p = 48000 },
        { n = "Goyard Классическая Футболка v2", i = 6131796962, s = 2.0, p = 48000 },
        { n = "HBA Face Свитшот", i = 101719618368646, s = 2.0, p = 14000 },
        { n = "HBA Face Шорты", i = 18588053395, s = 2.0, p = 14000 },
        { n = "HBA Зип-Худи", i = 18588070468, s = 2.0, p = 13000 },
        { n = "NeNet Футболка Белая v2", i = 83631847906705, s = 2.0, p = 11000 },
        { n = "Vetements Худи v2", i = 107557100704001, s = 2.0, p = 42000 },
        { n = "Гоша Рубчинский Футбол", i = 4909082176, s = 2.0, p = 22000 },
        { n = "BAPE x Stussy", i = 836376693, s = 1.8, p = 15000 },
        { n = "Gallery Dept Спортивки Серые v2", i = 112068921354030, s = 1.5, p = 9000 },
        { n = "HBA Aphex Свитшот", i = 16579558789, s = 1.5, p = 16000 },
        { n = "Nike Tech Blue", i = 12757775222, s = 1.5, p = 6500 },
        { n = "Stone Island Termo Longsleave", i = 13948309746, s = 1.5, p = 42000 },
        { n = "Золотая цепь", i = 12001043365, s = 1.5, p = 3800 },
        { n = "BAPE Hellstar", i = 15059936417, s = 1.2, p = 12500 },
        { n = "Racer WorldWide Свитер В Полоску", i = 8633623320, s = 1.2, p = 24000 },
        { n = "Yohji Yamamoto Свитшот Зеленый", i = 7023449511, s = 1.0, p = 65000 },
        { n = "Yohji Yamamoto Свитшот", i = 137788979820718, s = 0.8, p = 115000 },
        { n = "CP.Company DD Shell Noir", i = 95337445087298, s = 0.7, p = 45000 },
        { n = "AmiriKing", i = 73216590459166, s = 0.0, p = 220000 },
    },
    ["Legendary"] = {
        { n = "ERD Потертые Джинсы v1", i = 137773512709519, s = 14.0, p = 55000 },
        { n = "Number(N)ine Черные Джинсы", i = 18323948106, s = 14.0, p = 55000 },
        { n = "Vetements Джинсы Потертые", i = 87891411586632, s = 14.0, p = 20000 },
        { n = "Vetements Спортивки Белые", i = 132566833184808, s = 14.0, p = 16000 },
        { n = "ERD Белый Лонг", i = 105198371812252, s = 12.0, p = 38000 },
        { n = "Chrome Hearts Sweats Black", i = 92049531048374, s = 10.0, p = 38000 },
        { n = "ERD Лонгслив", i = 76738452087604, s = 10.0, p = 45000 },
        { n = "Number(N)ine Коричневое Худи", i = 18632819241, s = 10.0, p = 92000 },
        { n = "Number(N)ine Красный Лонгслив", i = 128716647842609, s = 10.0, p = 62000 },
        { n = "Vetements Синие-Джинсы Потертые", i = 126970846706113, s = 10.0, p = 24000 },
        { n = "Vetements Спортивки Черный", i = 80693415563613, s = 10.0, p = 16000 },
        { n = "Chrome Hearts Basic Tee", i = 16582495088, s = 8.0, p = 28000 },
        { n = "Dior Зип", i = 10371714775, s = 8.0, p = 72000 },
        { n = "Dior Зип Худи", i = 85583075418361, s = 8.0, p = 72000 },
        { n = "Dior Лонгслив", i = 101488585369119, s = 8.0, p = 72000 },
        { n = "Dior Свитер", i = 118344538644973, s = 8.0, p = 72000 },
        { n = "Dior Свитшот", i = 18147277043, s = 8.0, p = 72000 },
        { n = "Dior Футболка", i = 18370037060, s = 8.0, p = 72000 },
        { n = "Dior Худи", i = 122763783050786, s = 8.0, p = 72000 },
        { n = "Prada Re-Nylon Jacket", i = 1352050969, s = 8.0, p = 72000 },
        { n = "Chrome Hearts Grunge", i = 18968804462, s = 6.0, p = 45000 },
        { n = "Chrome Hearts Rainbow Cross", i = 10322816406, s = 6.0, p = 42000 },
        { n = "Chrome Hearts Tee", i = 73657715280895, s = 6.0, p = 32000 },
        { n = "Comme des Garcons Футболка Черная", i = 15121388536, s = 6.0, p = 8000 },
        { n = "Gucci Polo Shake", i = 5469366412, s = 6.0, p = 38000 },
        { n = "Raf Simons Replicant Черный", i = 131319439176543, s = 6.0, p = 62000 },
        { n = "Vetements Футболка Оранжевая", i = 80547880319610, s = 6.0, p = 36000 },
        { n = "Balenciaga Jeans", i = 122599601118964, s = 5.0, p = 38000 },
        { n = "CP.Company Cardigan Black", i = 99737839478071, s = 5.0, p = 24000 },
        { n = "Chrome Hearts Cyan Alt", i = 6447552174, s = 5.0, p = 38000 },
        { n = "Chrome Hearts Jeans", i = 15696366780, s = 5.0, p = 38000 },
        { n = "Chrome Hearts Red Shirt", i = 99324171797960, s = 5.0, p = 34000 },
        { n = "Chrome Hearts Zip Up Black", i = 6198234501, s = 5.0, p = 52000 },
        { n = "Chrome Hearts Zip Up Hoodie Black", i = 18400219191, s = 5.0, p = 34000 },
        { n = "ERD Потертые Джинсы v2", i = 83641705983017, s = 5.0, p = 8000 },
        { n = "Maison Margiela Зеленый Лонгслив", i = 73388686842934, s = 5.0, p = 65532 },
        { n = "Number(N)ine Потертые Джинсы", i = 102839033215257, s = 5.0, p = 42000 },
        { n = "Number(N)ine Серое Худи", i = 18632881209, s = 5.0, p = 98000 },
        { n = "Palm Angels Футболка v3", i = 11511640247, s = 5.0, p = 26000 },
        { n = "Raf Simons Antei Purple", i = 116642119535875, s = 5.0, p = 48000 },
        { n = "Vetements Футболка Зеленая Polizei", i = 90919421530654, s = 5.0, p = 30000 },
        { n = "Yohji Yamamoto Брюки", i = 18606916311, s = 5.0, p = 78000 },
        { n = "Гоша Рубчинский Свитер Синий", i = 9545499629, s = 5.0, p = 34000 },
        { n = "Balenciaga Campaign", i = 10890916980, s = 4.0, p = 45000 },
        { n = "Balenciaga Grey Jumper", i = 3785693796, s = 4.0, p = 34000 },
        { n = "Chrome Hearts Blue Jeans", i = 7136404058, s = 4.0, p = 42000 },
        { n = "Chrome Hearts Cyan", i = 14127820316, s = 4.0, p = 42000 },
        { n = "Chrome Hearts Gray Denim Jeans", i = 16733661152, s = 4.0, p = 38000 },
        { n = "Chrome Hearts Grey Jeans", i = 122714934882673, s = 4.0, p = 42000 },
        { n = "Chrome Hearts Orange Sweater", i = 7381767636, s = 4.0, p = 42000 },
        { n = "Comme des Garcons Футболка Love Белая", i = 2098915079, s = 4.0, p = 12000 },
        { n = "Palm Angels Футболка v2", i = 127026922296813, s = 4.0, p = 28000 },
        { n = "CP.Company Teal Jumper", i = 97526151621254, s = 3.5, p = 24000 },
        { n = "Balenciaga Distressed Hoodie", i = 13676876569, s = 3.0, p = 28000 },
        { n = "Balenciaga Hoodie Alien", i = 86463016923018, s = 3.0, p = 38000 },
        { n = "Chrome Hearts Blue Jeans Chrome", i = 7902431231, s = 3.0, p = 24000 },
        { n = "Chrome Hearts Multi Color Cargos", i = 16430470279, s = 3.0, p = 52000 },
        { n = "Chrome Hearts Pink-Black Jeans", i = 10946069869, s = 3.0, p = 45000 },
        { n = "Chrome Hearts Rainbow Sweatshirt", i = 116987323218059, s = 3.0, p = 45000 },
        { n = "Chrome Hearts Red & Green Sweater", i = 77430172245334, s = 3.0, p = 38000 },
        { n = "Chrome Hearts Red And Blue", i = 9026168986, s = 3.0, p = 28000 },
        { n = "Chrome Hearts X LV Jeans", i = 7248675954, s = 3.0, p = 42000 },
        { n = "Comme des Garcons Play Футболка Черная", i = 81585264094038, s = 3.0, p = 10000 },
        { n = "Comme des Garcons Футболка Белый-Красный", i = 1079296706, s = 3.0, p = 10000 },
        { n = "ERD Destroyed Hoodie", i = 124798507529638, s = 3.0, p = 92000 },
        { n = "Gucci Star Sweater", i = 6181344251, s = 3.0, p = 42000 },
        { n = "Gucci Tiger Tracksuit", i = 5680301087, s = 3.0, p = 72000 },
        { n = "LV x TNF", i = 5836356644, s = 3.0, p = 62000 },
        { n = "Maison Margiela Темные Джинсы", i = 81765716375958, s = 3.0, p = 49000 },
        { n = "Off-White Белая Футболка v3", i = 138024345748614, s = 3.0, p = 32000 },
        { n = "Raf Simons Ozweego 3 Black Scarlett", i = 112685667527061, s = 3.0, p = 68000 },
        { n = "Raf Simons Ozweego 3 Bunny Cream", i = 72101896533425, s = 3.0, p = 65000 },
        { n = "Raf Simons Ozweego Metallic Pink", i = 87554525526000, s = 3.0, p = 58000 },
        { n = "Balenciaga Blue Skater Sweatpants", i = 124975585838444, s = 2.5, p = 45000 },
        { n = "Balenciaga Grey Skater Sweatpants", i = 93824635464666, s = 2.5, p = 45000 },
        { n = "Balenciaga Red Skater Sweatpants", i = 15732426819, s = 2.5, p = 45000 },
        { n = "CP.Company Crewneck", i = 15783597851, s = 2.5, p = 28000 },
        { n = "Chrome Hearts Gray Sweater", i = 6678207951, s = 2.5, p = 62000 },
        { n = "Chrome Hearts Red Jeans", i = 15167783027, s = 2.5, p = 45000 },
        { n = "Off-White Белая Футболка v2", i = 4809072541, s = 2.5, p = 32000 },
        { n = "Off-White Черная Футболка v2", i = 15084872864, s = 2.5, p = 32000 },
        { n = "Balenciaga Logo Print Hoodie Blue", i = 15825720946, s = 2.0, p = 48000 },
        { n = "Balenciaga Under Armor", i = 109107120274465, s = 2.0, p = 52000 },
        { n = "Balenciaga X Under Armor", i = 17747885612, s = 2.0, p = 38000 },
        { n = "Balenciaga x Fortnite", i = 102510983142980, s = 2.0, p = 62000 },
        { n = "Chrome Hearts Orange Pants", i = 7548737358, s = 2.0, p = 48000 },
        { n = "Chrome Hearts Yellow Hoodie", i = 11454813848, s = 2.0, p = 62000 },
        { n = "ERD Vintage Washed Hoodie", i = 6384915788, s = 2.0, p = 110000 },
        { n = "Gucci X Tee", i = 3370349046, s = 2.0, p = 62000 },
        { n = "LV Balmains", i = 967030317, s = 2.0, p = 72000 },
        { n = "Maison Margiela Рубашка", i = 135517402543302, s = 2.0, p = 62000 },
        { n = "Moncler Gray Sweater", i = 5341316038, s = 2.0, p = 36000 },
        { n = "Moncler Gray Vest", i = 6142390595, s = 2.0, p = 38000 },
        { n = "Moncler Red Puffer", i = 6455447834, s = 2.0, p = 38000 },
        { n = "Moncler Red Tracksuit Bottom", i = 6488509571, s = 2.0, p = 36000 },
        { n = "Moncler Vest Classic", i = 6488586232, s = 2.0, p = 36000 },
        { n = "Number(N)ine Винтажная Футболка", i = 6384915788, s = 2.0, p = 110000 },
        { n = "Number(N)ine Черный Лонгслив", i = 12274864979, s = 2.0, p = 110000 },
        { n = "Raf Simons Cylon 21 Red", i = 75354435184240, s = 2.0, p = 70000 },
        { n = "Raf Simons Ozweego 2 Yellow Navy", i = 84478752542723, s = 2.0, p = 58000 },
        { n = "Raf Simons Ultrasceptre Black", i = 76698897803837, s = 2.0, p = 65000 },
        { n = "Raf Simons Поло Красное", i = 76516442021518, s = 2.0, p = 45000 },
        { n = "Rick Owens x Moncler", i = 8573407398, s = 2.0, p = 95000 },
        { n = "Rick Owens Джинсы Розовые", i = 84825703583648, s = 2.0, p = 85000 },
        { n = "Stone Island Navy", i = 831537199, s = 2.0, p = 34000 },
        { n = "Гоша Рубчинский Свитер Зелёный", i = 5549063618, s = 2.0, p = 25000 },
        { n = "Balenciaga Paris Moon Sweater", i = 4590342423, s = 1.5, p = 42000 },
        { n = "Balenciaga Speed Runner Hoodie", i = 15453420630, s = 1.5, p = 55000 },
        { n = "Balenciaga x Gucci", i = 3138759121, s = 1.5, p = 72000 },
        { n = "Cav Empt Футболка Spring Delivery", i = 2887711548, s = 1.5, p = 14000 },
        { n = "Comme des Garcons Лонгслив Белый-Синий", i = 962194504, s = 1.5, p = 14000 },
        { n = "ERD Bully Худи", i = 128216714278616, s = 1.5, p = 110000 },
        { n = "Gallery Dept Красный Зип-Худи", i = 86921710360798, s = 1.5, p = 7500 },
        { n = "Gucci Sweatshirt Planet", i = 1083553649, s = 1.5, p = 58000 },
        { n = "Moncler Black Jacket", i = 9375216039, s = 1.5, p = 38000 },
        { n = "Moncler Black Tracksuit Bottom", i = 15338842173, s = 1.5, p = 42000 },
        { n = "Moncler Puffer Logo", i = 6488495469, s = 1.5, p = 45000 },
        { n = "Moncler Red Tracksuit", i = 6488509571, s = 1.5, p = 42000 },
        { n = "Moncler TriColor Windbreaker", i = 4831711976, s = 1.5, p = 42000 },
        { n = "Number(N)ine Shield Серое Худи", i = 105478169140045, s = 1.5, p = 140000 },
        { n = "Number(N)ine Футболка", i = 14885532636, s = 1.5, p = 150000 },
        { n = "Palm Angels Свитшот Голубой", i = 6274614487, s = 1.5, p = 38000 },
        { n = "Raf Simons Brian Calvin Beer Girl", i = 75216977300015, s = 1.5, p = 135000 },
        { n = "Raf Simons Hoodie", i = 15570425245, s = 1.5, p = 150000 },
        { n = "Raf Simons Ozweego 2 Blue Red Lucora", i = 70728690346102, s = 1.5, p = 75000 },
        { n = "Raf Simons Ozweego 2 Gray Green", i = 105222831634134, s = 1.5, p = 68000 },
        { n = "Raf Simons Ozweego 2 Khaki Gold", i = 124039750585318, s = 1.5, p = 120000 },
        { n = "Raf Simons Худи Серый", i = 102589072483955, s = 1.5, p = 68000 },
        { n = "Rick Owens Джинсовка Красная", i = 71424043928165, s = 1.5, p = 110000 },
        { n = "Stone Island Orange", i = 14840856758, s = 1.5, p = 38000 },
        { n = "Stone Island Pink", i = 14984408119, s = 1.5, p = 38000 },
        { n = "Vetements Antwerpen Белая v2", i = 15564674144, s = 1.5, p = 34000 },
        { n = "Гоша Рубчинский Вдруг Красный", i = 2118764687, s = 1.5, p = 26000 },
        { n = "Гоша Рубчинский Враг Свитер Черный", i = 5487023113, s = 1.5, p = 28000 },
        { n = "Comme des Garcons Футболка Camo Love", i = 8128676575, s = 1.2, p = 16000 },
        { n = "Off-White Зеленый", i = 3224293759, s = 1.2, p = 42000 },
        { n = "Palm Angels Zip Красная", i = 126190832806951, s = 1.2, p = 42000 },
        { n = "Rick Owens Джинсовка Желтая", i = 130104280419383, s = 1.2, p = 115000 },
        { n = "Stone Island Zip-Hoodie", i = 87509417534862, s = 1.2, p = 48000 },
        { n = "Гоша Рубчинский Zip Красный/Синий", i = 4996937439, s = 1.2, p = 24000 },
        { n = "Balenciaga Runway Polo Hoodie", i = 85720763562074, s = 1.0, p = 72000 },
        { n = "Balenciaga Tokyo Cut", i = 98869180278083, s = 1.0, p = 52000 },
        { n = "Chrome Hearts Cross Patch Dog", i = 90412503682792, s = 1.0, p = 72000 },
        { n = "Chrome Hearts Matty Boy Space", i = 18428381654, s = 1.0, p = 95000 },
        { n = "Chrome Hearts Matty Boy Sweatshirt", i = 126863028392369, s = 1.0, p = 98000 },
        { n = "Chrome Hearts Rolling Stones", i = 85305185315542, s = 1.0, p = 72000 },
        { n = "ERD Skull Denim Jacket", i = 114724377, s = 1.0, p = 140000 },
        { n = "ERD Голубой Лонгслив", i = 102885674981104, s = 1.0, p = 150000 },
        { n = "Gucci Blind For Love Hoodie", i = 126913643075376, s = 1.0, p = 72000 },
        { n = "Moncler Black Tapered Tracksuit", i = 15338842173, s = 1.0, p = 52000 },
        { n = "Moncler Blue Coat", i = 9384199616, s = 1.0, p = 58000 },
        { n = "Moncler Blue Zip-Up", i = 6505230129, s = 1.0, p = 60000 },
        { n = "Moncler Maroon Jacket", i = 6787299892, s = 1.0, p = 62000 },
        { n = "Moncler Parka Coat", i = 8446274549, s = 1.0, p = 55000 },
        { n = "Moncler x Palm Angels Black", i = 13876237691, s = 1.0, p = 48000 },
        { n = "Moncler x Palm Angels Jacket", i = 8165648360, s = 1.0, p = 58000 },
        { n = "Moncler x Palm Angels Red Zip", i = 5964876806, s = 1.0, p = 58000 },
        { n = "Off-White Бежевая", i = 590131471, s = 1.0, p = 48000 },
        { n = "Raf Simons Ozweego Replicant Brown", i = 131686044597910, s = 1.0, p = 58000 },
        { n = "Raf Simons Ozweego Replicant Green", i = 109462627025831, s = 1.0, p = 62000 },
        { n = "Raf Simons Красный Лонгслив", i = 125538194046026, s = 1.0, p = 98000 },
        { n = "Raf Simons Красный Лонгслив v2", i = 140534031809179, s = 1.0, p = 82000 },
        { n = "Rick Leather", i = 101535348409637, s = 1.0, p = 125000 },
        { n = "Vetements Antwerp Красный", i = 18720565335, s = 1.0, p = 34000 },
        { n = "Vetements Antwerpen Белая v1", i = 124697147814478, s = 1.0, p = 34000 },
        { n = "Yohji Yamamoto Project Футболка", i = 89357762722807, s = 1.0, p = 45000 },
        { n = "Гоша Рубчинский Гибридный", i = 14578854678, s = 1.0, p = 32000 },
        { n = "Yohji Yamamoto Свитшот Supreme", i = 130582847343989, s = 0.9, p = 92000 },
        { n = "1017 ALYX 9SM Куртка Зип", i = 16949566103, s = 0.8, p = 22000 },
        { n = "Balenciaga 3B Sports Deutsche Bahn", i = 137408844484403, s = 0.8, p = 72000 },
        { n = "CP.Company Blue Puffer Jacket", i = 82077729005226, s = 0.8, p = 52000 },
        { n = "Gallery Dept Свитшот Синий", i = 79423109019674, s = 0.8, p = 14500 },
        { n = "Moncler X PA Trackpants", i = 5459824253, s = 0.8, p = 52000 },
        { n = "Polo Burberry", i = 15903662503, s = 0.8, p = 42000 },
        { n = "Rick Owens Зип Джинсовка Розовая", i = 121618494628389, s = 0.8, p = 135000 },
        { n = "Stone Island Desert Camo", i = 8462301101, s = 0.8, p = 45000 },
        { n = "Stone Island Turtleneck", i = 12624379885, s = 0.8, p = 55000 },
        { n = "Supreme x BB", i = 13444831702, s = 0.8, p = 28000 },
        { n = "Vetements Antwerp Темно-Красное", i = 4552458072, s = 0.8, p = 34000 },
        { n = "Vetements Зип-Худи", i = 128389783148999, s = 0.8, p = 72000 },
        { n = "Гоша Рубчинский Fila Yellow LS", i = 87503337904060, s = 0.8, p = 32000 },
        { n = "Гоша Рубчинский Спорт Куртка Russian", i = 607550981, s = 0.8, p = 32000 },
        { n = "Off-White Свитер", i = 2518177916, s = 0.7, p = 58000 },
        { n = "Гоша Рубчинский X Kappa Свитер", i = 15311273900, s = 0.7, p = 36000 },
        { n = "Acne Studios Jacket", i = 114724377, s = 0.6, p = 68000 },
        { n = "CP.Company Carbone Noir", i = 134908184079208, s = 0.6, p = 42000 },
        { n = "Cav Empt Свитшот Желтый Symptom Heavy", i = 3244925440, s = 0.6, p = 18500 },
        { n = "NeNet Футболка Серая", i = 118840925833484, s = 0.6, p = 22000 },
        { n = "Stone Island Urban Black Yellow", i = 7249098507, s = 0.6, p = 62000 },
        { n = "Yohji Yamamoto AW 2001 Godzilla Свитшот", i = 4794620897, s = 0.6, p = 95000 },
        { n = "Гоша Рубчинский Худи ColorBrick", i = 560325377, s = 0.6, p = 38000 },
        { n = "BAPE Red Panda", i = 85037105009809, s = 0.5, p = 18000 },
        { n = "BAPE Tiger Штаны Красные", i = 137022318888712, s = 0.5, p = 24000 },
        { n = "BAPE Tiger Штаны Синие", i = 72015381801594, s = 0.5, p = 24000 },
        { n = "Balenciaga GAMER", i = 12774350601, s = 0.5, p = 92000 },
        { n = "Balenciaga Gamer Jeans", i = 14072460187, s = 0.5, p = 95000 },
        { n = "Balenciaga Resort 2023", i = 16648534764, s = 0.5, p = 62000 },
        { n = "Chrome Hearts Black Pink LS", i = 90915822594460, s = 0.5, p = 110000 },
        { n = "Chrome Hearts Miami Hoodie", i = 12852126150, s = 0.5, p = 118000 },
        { n = "Chrome Hearts Ryft Davis", i = 79285824675024, s = 0.5, p = 85000 },
        { n = "Comme des Garcons Рубашка", i = 123772691907841, s = 0.5, p = 32000 },
        { n = "ERD Distressed Zip Jacket", i = 12001043365, s = 0.5, p = 170000 },
        { n = "ERD x Rick Owens Джинсы", i = 74573745510706, s = 0.5, p = 140000 },
        { n = "ERD Красные Джинсы", i = 102019726797995, s = 0.5, p = 145000 },
        { n = "Gallery Dept Lanvin", i = 87630874548849, s = 0.5, p = 32000 },
        { n = "Goyard Зеленая Футболка", i = 6763195401, s = 0.5, p = 75000 },
        { n = "Gucci Tiger Hoodie", i = 1518645608, s = 0.5, p = 135000 },
        { n = "Gucci x LV Jacket", i = 2109554081, s = 0.5, p = 95000 },
        { n = "HBA Creepy Свитшот", i = 93422277147402, s = 0.5, p = 32000 },
        { n = "Moncler Green Zip-up", i = 6505230940, s = 0.5, p = 55000 },
        { n = "Moncler Multi Colored Jacket", i = 3689506876, s = 0.5, p = 60000 },
        { n = "Moncler Purple Bubble Jacket", i = 6455445003, s = 0.5, p = 72000 },
        { n = "Moncler X PA Blue Tracksuit Bot", i = 12636365073, s = 0.5, p = 58000 },
        { n = "Moncler X PA Blue Tracksuit Top", i = 12636365073, s = 0.5, p = 72000 },
        { n = "Racer Worldwide Светлые Джинсы", i = 124377088956183, s = 0.5, p = 18000 },
        { n = "Racer Worldwide Спортивные Штаны", i = 82685608298333, s = 0.5, p = 18000 },
        { n = "Raf Simons Black Christiane F AW18", i = 91498176431445, s = 0.5, p = 92000 },
        { n = "Raf Simons Brian Calvin Beer Girl Tee", i = 122313792956641, s = 0.5, p = 145000 },
        { n = "Rick Owens Футболка Vamp", i = 83255075167663, s = 0.5, p = 150000 },
        { n = "SS04 Yohji Yamamoto Y-3 x 3S Spotted Джинсы", i = 71399636217265, s = 0.5, p = 85000 },
        { n = "Stone Island Desert Camo", i = 8631687945, s = 0.5, p = 52000 },
        { n = "Supreme x LV", i = 5226567379, s = 0.5, p = 92000 },
        { n = "Vetements 204 Hyoma Raf Reconstructed", i = 75624653597148, s = 0.5, p = 42000 },
        { n = "Vetements Бомбер", i = 134508752165617, s = 0.5, p = 95000 },
        { n = "Zapatillas Gucci X Amiri", i = 134853942496739, s = 0.5, p = 110000 },
        { n = "Гоша Рубчинский x Kappa", i = 884721414, s = 0.5, p = 38000 },
        { n = "BAPE Tiger Штаны Темно-Зелен", i = 131922684973046, s = 0.4, p = 26000 },
        { n = "CP.Company DD Shell Green", i = 100997096188512, s = 0.4, p = 65000 },
        { n = "CP.Company Orange Pants", i = 16974632408, s = 0.4, p = 48000 },
        { n = "Comme des Garcons Синий Зип-Худи", i = 1074658737, s = 0.4, p = 28000 },
        { n = "Gallery Dept Свитшот Коричневый", i = 118666889439649, s = 0.4, p = 11000 },
        { n = "Gutta Raiders Camo shirt", i = 86664943903751, s = 0.4, p = 18000 },
        { n = "Nike Tech Dark Blue", i = 15501893721, s = 0.4, p = 9500 },
        { n = "Nike Tech Dark Light Blue", i = 8801995627, s = 0.4, p = 9500 },
        { n = "Palm Angels Flame", i = 5611331869, s = 0.4, p = 52000 },
        { n = "Racer Worldwide Металлик Спортивные Штаны", i = 75548914998494, s = 0.4, p = 34000 },
        { n = "Vetements Anarchy", i = 17508312490, s = 0.4, p = 85000 },
        { n = "Vetements Clothing Green", i = 77220484371723, s = 0.4, p = 82000 },
        { n = "Yohji Yamamoto Ys for Men AW2001 Godzilla", i = 6046174032, s = 0.4, p = 135000 },
        { n = "Yohji Yamamoto Свитшот Smoke", i = 8826223539, s = 0.4, p = 125000 },
        { n = "Yohji Yamamoto Свитшот Spider Knit", i = 10515393675, s = 0.4, p = 98000 },
        { n = "Гоша Рубчинский x Kappa", i = 1824185908, s = 0.4, p = 45000 },
        { n = "Гоша Рубчинский x Kappa Винтаж", i = 1162019947, s = 0.4, p = 41000 },
        { n = "Stone Island Off Day Blue", i = 117161695009647, s = 0.35, p = 72000 },
        { n = "Stone Island Red Hoodie Off Dye", i = 97856390601463, s = 0.35, p = 68000 },
        { n = "Гоша Рубчинский Флаги", i = 98305906232207, s = 0.35, p = 48000 },
        { n = "BAPE Yellow Camo Shark", i = 4843433327, s = 0.3, p = 28000 },
        { n = "Balenciaga GAMER Denim Jacket", i = 16648632315, s = 0.3, p = 115000 },
        { n = "Balenciaga Red Crimson Windbreaker", i = 133873637543203, s = 0.3, p = 95000 },
        { n = "CP.Company DD Shell Red", i = 78185107533537, s = 0.3, p = 75000 },
        { n = "Chrome Hearts Multi-Colour Hoodie", i = 16919855258, s = 0.3, p = 125000 },
        { n = "Gallery Dept Худи Зеленое", i = 140022990256816, s = 0.3, p = 18000 },
        { n = "Gutta Snake Year", i = 70895461143874, s = 0.3, p = 15000 },
        { n = "Moncler X PA FG Tracksuit Bot", i = 12621049095, s = 0.3, p = 62000 },
        { n = "Moncler X PA Forest Green Bot", i = 12621050787, s = 0.3, p = 60000 },
        { n = "Moncler X PA Forest Green Top", i = 12621049095, s = 0.3, p = 75000 },
        { n = "Moncler x PA Puffer Jacket", i = 14396989921, s = 0.3, p = 85000 },
        { n = "Number(N)ine Zip Jacket", i = 81231921426493, s = 0.3, p = 220000 },
        { n = "Raf Simons Christiane F Tees AW18", i = 125655994023355, s = 0.3, p = 195000 },
        { n = "Raf Simons Бомбер Белый", i = 86995497093030, s = 0.3, p = 160000 },
        { n = "Rick Owens Runway", i = 8502567669, s = 0.3, p = 180000 },
        { n = "Stone Island Desert Camo Jacket", i = 8631651981, s = 0.3, p = 72000 },
        { n = "Yohji Yamamoto Rei Ayanami Evangelion Button up", i = 14484000414, s = 0.3, p = 145000 },
        { n = "Yohji Yamamoto Свитшот Avant Garde", i = 86114857882709, s = 0.3, p = 155000 },
        { n = "Yohji Yamamoto Свитшот Skull", i = 5166805206, s = 0.3, p = 110000 },
        { n = "CP.Company Black Windbreaker", i = 113247621156859, s = 0.25, p = 88000 },
        { n = "Off-White MonoLisa", i = 2474144253, s = 0.25, p = 75000 },
        { n = "Palm Angels Фиолетовые", i = 9084664827, s = 0.25, p = 62000 },
        { n = "Racer WorldWide Леопардовая Зип-Худи", i = 118245234493513, s = 0.25, p = 42000 },
        { n = "Stone Island WATRO-TC", i = 8631779037, s = 0.25, p = 68000 },
        { n = "Vetements Бомбер Зеленый", i = 89790335131378, s = 0.25, p = 110000 },
        { n = "Vetements Бомбер Красный", i = 117766762488194, s = 0.25, p = 110000 },
        { n = "Vetements Бомбер Тёмно-Зеленый", i = 77439910826532, s = 0.25, p = 110000 },
        { n = "Yohji Yamamoto J-PT Иллюстрация", i = 129487569430492, s = 0.25, p = 115000 },
        { n = "Balenciaga Jean Jacket X Gosha", i = 5314403333, s = 0.2, p = 110000 },
        { n = "Burberry x Bape", i = 13868676222, s = 0.2, p = 68000 },
        { n = "CP.Company DD Shell Beige", i = 139627508845654, s = 0.2, p = 78000 },
        { n = "HBA Рубашка", i = 71222633992816, s = 0.2, p = 28000 },
        { n = "Maison Margiela Женская Меховая Куртка", i = 137990594447175, s = 0.2, p = 100000 },
        { n = "Moncler Striped Technical", i = 5029449227, s = 0.2, p = 95000 },
        { n = "Гоша Рубчинский Camo Спаси Сохрани", i = 576444465, s = 0.2, p = 52000 },
        { n = "Balenciaga GAMER Bomber", i = 17750429143, s = 0.15, p = 140000 },
        { n = "CP.Company Navy Windbreaker", i = 131336649441063, s = 0.15, p = 92000 },
        { n = "Cav Empt Not Impossible Crewneck", i = 322189906, s = 0.15, p = 12000 },
        { n = "Comme des Garcons X Rolling Stones Футболка", i = 116168634401177, s = 0.15, p = 42000 },
        { n = "NeNet Футболка Фиолетовая", i = 9930373240, s = 0.15, p = 38000 },
        { n = "Number(N)ine Серая Zip Jacket", i = 99950858190570, s = 0.15, p = 245000 },
        { n = "Off-White Camo", i = 1213373791, s = 0.15, p = 92000 },
        { n = "Racer Worldwide Трансформ Зип Джинсы", i = 138030819896058, s = 0.15, p = 48000 },
        { n = "Stone Island WATRO-TC Jacket", i = 8631755151, s = 0.15, p = 88000 },
        { n = "Vetements Бомбер Полиция", i = 11290616980, s = 0.15, p = 135000 },
        { n = "Yohji Yamamoto Heroes Leather Байкерская Куртка", i = 4895301337, s = 0.15, p = 185000 },
        { n = "Гоша Рубчинский x Rassvet", i = 15706847548, s = 0.15, p = 45000 },
        { n = "Balenciaga NASA", i = 97665782669251, s = 0.1, p = 140000 },
        { n = "Balenciaga Reversible Bomber Jacket", i = 18813584989, s = 0.1, p = 150000 },
        { n = "Cav Empt Свитшот MD Document Crewneck", i = 1002344605, s = 0.1, p = 16000 },
        { n = "ERD Archive Trousers", i = 18391376326, s = 0.1, p = 220000 },
        { n = "Moncler Spider", i = 11674658234, s = 0.1, p = 105000 },
        { n = "Moncler x PA Kelsey Puffer Blue", i = 11484662835, s = 0.1, p = 110000 },
        { n = "Raf Simons LSD White", i = 125293782853552, s = 0.1, p = 225000 },
        { n = "Raf Simons SS10 Sterling Ruby Shirt", i = 95423048146621, s = 0.1, p = 280000 },
        { n = "Stone Island Comfort Tech Blue", i = 118064352416891, s = 0.1, p = 75000 },
        { n = "Stone Island Comfort Tech Red", i = 120903225671360, s = 0.1, p = 82000 },
        { n = "Stone Island Reflective", i = 139421353405484, s = 0.1, p = 85000 },
        { n = "Supreme x Bape x LV", i = 1565502112, s = 0.1, p = 140000 },
        { n = "Yohji Yamamoto Зеленая Куртка", i = 115386784245524, s = 0.1, p = 88000 },
        { n = "BAPE Tiger Штаны Фиолетовые", i = 99313817373559, s = 0.08, p = 38000 },
        { n = "Gallery Dept Футболка Шамана", i = 100168311309116, s = 0.08, p = 28000 },
        { n = "Racer WorldWide Куртка из Овечьи Шкуры", i = 99497707297997, s = 0.08, p = 68000 },
        { n = "Stone Island Purple Skin Touch", i = 13779001426, s = 0.08, p = 85000 },
        { n = "Stone Island Skin Touch Purple", i = 13778721268, s = 0.08, p = 98000 },
        { n = "Cav Empt Свитшот Joker", i = 18280893525, s = 0.07, p = 22000 },
        { n = "BAPE Tiger Camo", i = 3052304894, s = 0.06, p = 52000 },
        { n = "Гоша Рубчинский Рождест", i = 11796928325, s = 0.06, p = 62000 },
        { n = "Cav Empt Свитшот FW 17", i = 914784455, s = 0.05, p = 38000 },
        { n = "Chrome Hearts Camo Matty", i = 72762590768448, s = 0.05, p = 190000 },
        { n = "ERD Archive Лонгслив", i = 122273528955293, s = 0.05, p = 290000 },
        { n = "ERD Archive Худи Красный", i = 98881995294054, s = 0.05, p = 310000 },
        { n = "Nike Tech Windrunner Black", i = 7397565263, s = 0.05, p = 22000 },
        { n = "Number(N)ine Серый Лонгслив", i = 17573405272, s = 0.05, p = 310000 },
        { n = "Raf Simons 2-CB GHB Patchwork", i = 120612391944120, s = 0.05, p = 270000 },
        { n = "Cav Empt Бомбер", i = 297942903, s = 0.04, p = 42000 },
        { n = "Stone Island Shadow Tiger Camo", i = 132959748946564, s = 0.04, p = 125000 },
        { n = "Гоша Рубчинский X Thrasher", i = 436720176, s = 0.04, p = 88000 },
        { n = "Гоша Рубчинский Зеленый Свитер", i = 772695241, s = 0.03, p = 95000 },
        { n = "Balenciaga Paris", i = 125248485368695, s = 0.02, p = 245000 },
        { n = "Chrome Hearts T Logo USA Hoodie", i = 96585015209179, s = 0.02, p = 245000 },
        { n = "ERD Красная Джинсовка", i = 120196252098729, s = 0.02, p = 450000 },
        { n = "Gucci Coco Capitan", i = 1081054870, s = 0.02, p = 245000 },
        { n = "Gutta Opiy Shirt", i = 75621017852847, s = 0.02, p = 52000 },
        { n = "Palm Angels x Raf Blue Red", i = 88741221455613, s = 0.02, p = 110000 },
        { n = "Stone Island Comfort Tech Purple", i = 119767338320263, s = 0.02, p = 145000 },
        { n = "TH Hoodie X Balenciaga x RAF", i = 2074367265, s = 0.02, p = 220000 },
        { n = "Racer WorldWide ЛонгСлив Катя Кищук", i = 97197585182330, s = 0.015, p = 125000 },
        { n = "Гоша Рубчинский Вдруг Друг", i = 107248336623941, s = 0.015, p = 115000 },
        { n = "Гоша Рубчинский Рождественский", i = 5972477579, s = 0.015, p = 115000 },
        { n = "Balenciaga Leather", i = 84116395504704, s = 0.01, p = 320000 },
        { n = "Balenciaga Nasa Bomber Jacket", i = 82170977556685, s = 0.01, p = 350000 },
        { n = "Balenciaga Runway", i = 16662225397, s = 0.01, p = 300000 },
        { n = "Chrome Hearts x Off-White Hoodie", i = 5944585429, s = 0.01, p = 320000 },
        { n = "Number(N)ine Shield Черное Худи", i = 81895753471926, s = 0.01, p = 420000 },
        { n = "Stone Island x Supreme", i = 84913974138865, s = 0.01, p = 115000 },
        { n = "Stone Island x Supreme White", i = 108047896837515, s = 0.01, p = 115000 },
        { n = "Palm Angels Zip Фиолетовый", i = 89385145596759, s = 0.009, p = 145000 },
        { n = "Palm Angels Zip Цветок", i = 6501833600, s = 0.009, p = 145000 },
        { n = "Stone Island x Supreme", i = 13876916079, s = 0.008, p = 165000 },
        { n = "Stone Island x Supreme Белые", i = 139017627542362, s = 0.008, p = 165000 },
        { n = "Bape x Supreme", i = 1103783724, s = 0.007, p = 125000 },
        { n = "Palm Angels Zip Кислотный", i = 7205233886, s = 0.007, p = 155000 },
        { n = "BAPE Full Zip Shark", i = 1329266704, s = 0.005, p = 135000 },
        { n = "Chrome Hearts x LV Jacket", i = 7369775838, s = 0.005, p = 380000 },
        { n = "Maison Margiela Куртка из Ремней", i = 122468912421457, s = 0.005, p = 120000 },
        { n = "Moncler x PA Fiber Light Puffer", i = 13429337035, s = 0.005, p = 400000 },
        { n = "Off-White Virgil Abloh Красный", i = 6071739662, s = 0.005, p = 285000 },
        { n = "Raf Simons Pharaxus Green Black", i = 101604148293803, s = 0.005, p = 680000 },
        { n = "Stone Island Big Loom Camo-Tc", i = 8631708424, s = 0.005, p = 280000 },
        { n = "Yohji Yamamoto Свитшот Кожанка", i = 131596879156451, s = 0.005, p = 450000 },
        { n = "Yohji Yamamoto Куртка Красная", i = 132752004376816, s = 0.004, p = 480000 },
        { n = "Haliky Gang Bears", i = 6676412081, s = 0.003, p = 72000 },
        { n = "Yohji Yamamoto Куртка Темно-Синяя", i = 90420982954859, s = 0.003, p = 520000 },
        { n = "Raf Simons AW01 Runway", i = 10443560347, s = 0.002, p = 950000 },
        { n = "Stone Island Big Loom Camo-Tc", i = 8631671234, s = 0.002, p = 350000 },
        { n = "Haliky Худи", i = 6004029876, s = 0.001, p = 85000 },
        { n = "Dior Джинсы", i = 139013853108228, s = 0.0, p = 0 },
        { n = "Dior Шорты", i = 90433833342790, s = 0.0, p = 0 },
        { n = "Femboy свитшот", i = 105804105689619, s = 0.0, p = 0 },
        { n = "Femboy штаны", i = 72870106856318, s = 0.0, p = 0 },
        { n = "redvetements", i = 75749441655962, s = 0.0, p = 777 },
        { n = "Яндекс Доставка Футболка", i = 18662896578, s = 0.0, p = 0 },
        { n = "пиджак чигура", i = 7798271981, s = 0.0, p = 100000 },
        { n = "штаны чигура", i = 7798302571, s = 0.0, p = 100000 },
    },
}
local SHOP_CATALOG_BY_NAME_LOWER = {}

local function initShopCatalogIndex()
    if not SHOP_CATALOG or not SHOP_CATALOG.byName then
        return
    end
    for _k in pairs(SHOP_CATALOG_BY_NAME_LOWER) do SHOP_CATALOG_BY_NAME_LOWER[_k] = nil end
    for name, data in pairs(SHOP_CATALOG.byName) do
        SHOP_CATALOG_BY_NAME_LOWER[string.lower(name)] = {
            name = name,
            rarity = data.rarity,
            fairPrice = data.fairPrice,
            spawnChance = data.spawnChance,
            id = data.id,
            type = data.type,
        }
    end
end

task.defer(function()
    if not CatalogState.done and not next(SHOP_CATALOG.byName) then
        SHOP_CATALOG = CATALOG_FALLBACK
        initShopCatalogIndex()
    end
end)

local AC = {
    enabled = true,
    antiKick = true,
    antiSpeed = true,
    antiFling = true,
    antiAdonis = true,
    hideCoreGui = true,
    stealthTp = true,
    useRemoteQueue = true,
    stealthRemotes = true,
    remoteDelay = 0.35,
    jitterMax = 0.4,
    walkSpeed = 16,
    jumpPower = 50,
}

local RemoteQueue = {}
local RemoteQueueBusy = false
local function acWait(base)
    if not AC.enabled or not AC.stealthRemotes then
        return
    end
    local delay = base or AC.remoteDelay
    if AC.jitterMax > 0 then
        delay = delay + math.random() * AC.jitterMax
    end
    task.wait(delay)
end

local function drainRemoteQueue()
    if RemoteQueueBusy then
        return
    end
    RemoteQueueBusy = true
    while #RemoteQueue > 0 do
        local job = table.remove(RemoteQueue, 1)
        pcall(job)
        acWait(AC.remoteDelay)
    end
    RemoteQueueBusy = false
end

local function queueRemoteJob(fn)
    table.insert(RemoteQueue, fn)
    task.spawn(drainRemoteQueue)
end

local function safeRemoteCall(remote, ...)
    if not remote then
        return nil
    end
    local args = { ... }
    local ref = remote
    if cloneref then
        pcall(function()
            ref = cloneref(remote)
        end)
    end
    local function fire()
        local ok, res = pcall(function()
            if ref:IsA("RemoteEvent") then
                return ref:FireServer(table.unpack(args))
            end
            return ref:InvokeServer(table.unpack(args))
        end)
        logRemoteQA(ref.Name, ref, args, ok)
        if not ok then
            error(res)
        end
        return res
    end
    if AC.enabled and AC.useRemoteQueue then
        local result
        local done = false
        queueRemoteJob(function()
            result = fire()
            done = true
        end)
        local t0 = tick()
        while not done and tick() - t0 < 12 do
            task.wait(0.05)
        end
        return result
    end
    return fire()
end

local function logRemoteQA(label, remote, args, ok)
    if not State.remoteSpyEnabled then
        return
    end
    local summary = label
    if type(args) == "table" and #args > 0 then
        local parts = {}
        for i = 1, math.min(#args, 4) do
            local v = args[i]
            if type(v) == "table" and v.uid then
                table.insert(parts, "uid=" .. tostring(v.uid))
            elseif type(v) == "userdata" and typeof and typeof(v) == "Instance" then
                table.insert(parts, v.Name)
            else
                table.insert(parts, tostring(v):sub(1, 40))
            end
        end
        summary = summary .. " | " .. table.concat(parts, ", ")
    end
    table.insert(State.remoteLog, 1, {
        time = string.format("%d", math.floor(tick()) % 100000),
        text = summary,
        ok = ok,
        remote = remote and remote:GetFullName() or "?",
    })
    while #State.remoteLog > 100 do
        table.remove(State.remoteLog)
    end
    if State.refreshRemoteSpy then
        pcall(State.refreshRemoteSpy)
    end
end

local function installAntiCheatBypass()
    local function loadAcModule()
        if not (readfile and isfile and loadstring) then
            return nil
        end
        for _, path in ipairs({ "ac_bypass.lua", "tsum/ac_bypass.lua" }) do
            if isfile(path) then
                local ok, mod = pcall(function()
                    return loadstring(readfile(path))()
                end)
                if ok and type(mod) == "function" then
                    return mod({
                        AC = AC,
                        LocalPlayer = LocalPlayer,
                        RunService = RunService,
                        debug = false,
                    })
                end
            end
        end
        return nil
    end

    if TSUM_installEmbeddedAC then
        pcall(TSUM_installEmbeddedAC)
    end
    if ACBridge and ACBridge.install then
        ACBridge.install()
        return
    end

    ACBridge = loadAcModule()
    if ACBridge and ACBridge.install then
        ACBridge.install()
        return
    end

    if hookmetamethod and getnamecallmethod then
        pcall(function()
            local oldNc
            local ncFn = function(self, ...)
                local method = getnamecallmethod()
                if AC.enabled and AC.antiKick and method == "Kick" and self == LocalPlayer then
                    return nil
                end
                return oldNc(self, ...)
            end
            if newcclosure then
                ncFn = newcclosure(ncFn)
            end
            oldNc = hookmetamethod(game, "__namecall", ncFn)
        end)
    end
end


local RARITY_COLORS = {
    Common = Color3.fromRGB(140, 140, 145),
    Uncommon = Color3.fromRGB(80, 200, 80),
    Rare = Color3.fromRGB(60, 140, 255),
    Epic = Color3.fromRGB(180, 70, 255),
    Legendary = Color3.fromRGB(255, 180, 30),
    Exclusive = Color3.fromRGB(138, 43, 226),
    TokyoExclusive = Color3.fromRGB(255, 100, 200),
}

local RARITY_ORDER = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Exclusive", "TokyoExclusive" }

local BARIGA_PIVOT = Vector3.new(-3616.045, 324.111, -234.452)
local BARIGA_FALLBACK = CFrame.new(BARIGA_PIVOT)

local State = {
    espEnabled = false,
    espMaxDistance = 220,
    espScanInterval = 2.5,
    shopCache = {},
    espUi = nil,
    lastEspScan = 0,
    selectedRarities = {
        Common = true,
        Uncommon = true,
        Rare = true,
        Epic = true,
        Legendary = true,
        Exclusive = true,
        TokyoExclusive = true,
    },
    connections = {},
    inventory = {},
    equipped = {},
    barigaHoldSeconds = 3,
    barigaAutoOpen = true,
    barigaTpConn = nil,
    barigaTpRunning = false,
    barigaWasAnchored = nil,
    stealthTp = true,
    autoBuyEnabled = false,
    autoBuyRunning = false,
    autoBuyOnce = true,
    autoBuyScanInterval = 2.5,
    autoBuyRarity = "Rare",
    autoBuyTarget = nil,
    autoFarmEnabled = false,
    autoFarmRunning = false,
    autoFarmRarity = "Common",
    autoFarmTarget = nil,
    autoFarmUseBest = true,
    autoFarmScanInterval = 2.5,
    autoFarmDelay = 2,
    autoFarmMaxCycles = nil,
    inventoryHooksReady = false,
    requestInventoryRemote = nil,
    barigaRemotesFolder = nil,
    catalogLoaded = false,
    remoteSpyEnabled = true,
    remoteLog = {},
    refreshRemoteSpy = nil,
}

local function notify(title, text, duration)
    if Rayfield and Rayfield.Notify then
        Rayfield:Notify({
            Title = title,
            Content = text,
            Duration = duration or 4,
            Image = 4483362458,
        })
    else
        warn("[TSUM] " .. tostring(title) .. ": " .. tostring(text))
    end
end

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

local function restorePlayerMovement(char)
    char = char or LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
    if hrp then
        pcall(function()
            hrp:SetNetworkOwner(nil)
        end)
    end
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        if hum.WalkSpeed < 1 then
            hum.WalkSpeed = 16
        end
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
        task.defer(function()
            pcall(function()
                if hum and hum.Parent then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end)
    end
end

local function stopBarigaHold()
    if State.barigaTpConn then
        State.barigaTpConn:Disconnect()
        State.barigaTpConn = nil
    end
    State.barigaTpRunning = false
    State.barigaWasAnchored = nil
    restorePlayerMovement()
end

local function zeroCharacterVelocity(char)
    if not char then
        return
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

local function streamPosition(position)
    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(position, 40)
    end)
end

local function snapFeetToGround(pos, char, fallbackY)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { char }
    local origin = Vector3.new(pos.X, (fallbackY or pos.Y) + 6, pos.Z)
    local hit = workspace:Raycast(origin, Vector3.new(0, -18, 0), params)
    if hit then
        return Vector3.new(pos.X, hit.Position.Y + 3, pos.Z)
    end
    return Vector3.new(pos.X, fallbackY or pos.Y, pos.Z)
end

local function resolveBarigaTarget()
    local char = LocalPlayer.Character
    local pivotPos = BARIGA_PIVOT
    local lookFlat = Vector3.new(0, 0, 1)

    local npc = workspace:FindFirstChild("BarigaNPC", true)
    if npc and npc:IsA("Model") then
        local pivot = npc:GetPivot()
        pivotPos = pivot.Position
        lookFlat = Vector3.new(pivot.LookVector.X, 0, pivot.LookVector.Z)
        if lookFlat.Magnitude < 0.05 then
            lookFlat = Vector3.new(0, 0, 1)
        else
            lookFlat = lookFlat.Unit
        end
    end

    local standPos = pivotPos - lookFlat * 5
    standPos = snapFeetToGround(standPos, char, pivotPos.Y + 3)

    local faceTarget = pivotPos + Vector3.new(0, 2, 0)
    return CFrame.new(standPos, faceTarget), "BarigaNPC"
end

local function applyHardTeleport(targetCF, holdSeconds)
    stopBarigaHold()

    local char = getCharacter()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return false
    end

    holdSeconds = holdSeconds or State.barigaHoldSeconds or 3
    State.barigaTpRunning = true

    local function placeOnce(cf)
        zeroCharacterVelocity(char)
        char:PivotTo(cf)
    end

    streamPosition(targetCF.Position)

    if AC.enabled and AC.stealthTp and State.stealthTp then
        local startCF = hrp.CFrame
        local steps = 10
        for i = 1, steps do
            if not hrp.Parent then
                stopBarigaHold()
                return false
            end
            local alpha = i / steps
            local pos = startCF.Position:Lerp(targetCF.Position, alpha)
            streamPosition(pos)
            placeOnce(CFrame.new(pos) * (targetCF - targetCF.Position))
            task.wait(0.05)
        end
    else
        placeOnce(targetCF)
    end

    pcall(function()
        local adminFly = ReplicatedStorage:FindFirstChild("AdminRemotes")
        local fly = adminFly and adminFly:FindFirstChild("AdminFly")
        if fly and fly:IsA("RemoteEvent") then
            fly:FireServer(false)
        end
    end)

    local endTime = tick() + holdSeconds
    State.barigaTpConn = RunService.Heartbeat:Connect(function()
        if not hrp.Parent then
            stopBarigaHold()
            return
        end
        if tick() < endTime then
            placeOnce(targetCF)
        else
            stopBarigaHold()
        end
    end)

    task.delay(holdSeconds + 0.35, function()
        stopBarigaHold()
    end)

    return true
end

local function openBarigaMenu()
    local bariga = ReplicatedStorage:FindFirstChild("BarigaRemotes")
    local trigger = bariga and bariga:FindFirstChild("TriggerBariga")
    if trigger then
        trigger:FireServer()
        return true
    end
    return false
end

local function tryFireBarigaPrompt()
    local prompt = workspace:FindFirstChild("BarigaPrompt", true)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end
    local fired = false
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 1)
            fired = true
        end
    end)
    if not fired then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.08)
            prompt:InputHoldEnd()
            fired = true
        end)
    end
    return fired
end

local function teleportToBariga()
    if State.barigaTpRunning then
        notify("Барыга", "Телепорт уже идёт — подожди", 3)
        return
    end

    task.spawn(function()
        local targetCF, source = resolveBarigaTarget()
        notify("Барыга", "Загрузка зоны (" .. source .. ")…", 4)

        for _ = 1, 4 do
            streamPosition(targetCF.Position)
            task.wait(0.45)
        end

        if not applyHardTeleport(targetCF, State.barigaHoldSeconds) then
            notify("Ошибка", "Не найден персонаж для ТП", 5)
            return
        end

        task.wait(State.barigaHoldSeconds + 0.4)
        stopBarigaHold()

        local hrp = getHRP()
        local dist = hrp and (hrp.Position - targetCF.Position).Magnitude or 999

        if dist > 22 then
            notify("Барыга", "Откат — повтор 4 сек…", 3)
            streamPosition(targetCF.Position)
            task.wait(0.5)
            applyHardTeleport(targetCF, 4)
            task.wait(4.4)
            stopBarigaHold()
            hrp = getHRP()
            dist = hrp and (hrp.Position - targetCF.Position).Magnitude or 999
        end

        restorePlayerMovement()
        task.wait(0.15)
        tryFireBarigaPrompt()
        if State.barigaAutoOpen then
            task.wait(0.1)
            openBarigaMenu()
        end

        if dist <= 22 then
            notify("Барыга", "ТП успешен. Позиция удержана.", 5)
        else
            notify(
                "Барыга — откат",
                "Сервер возвращает назад (дист. " .. math.floor(dist) .. ").\nПроверь анти-ТП / NetworkOwner на сервере.",
                8
            )
        end
    end)
end

local function formatPrice(n)
    if not n or n <= 0 then
        return "—"
    end
    local s = tostring(math.floor(n))
    local out = s:reverse():gsub("(%d%d%d)", "%1 "):reverse():gsub("^ ", "")
    return "$" .. out
end

local function formatChance(pct)
    if not pct or pct <= 0 then
        return "0%"
    end
    if pct < 1 then
        return string.format("%.2f%%", pct)
    end
    if pct == math.floor(pct) then
        return tostring(math.floor(pct)) .. "%"
    end
    return string.format("%.1f%%", pct)
end

local function findCatalogEntry(name, assetId)
    if not SHOP_CATALOG then
        return nil
    end
    if assetId then
        local hit = SHOP_CATALOG.byId and SHOP_CATALOG.byId[tostring(assetId)]
        if hit then
            return hit
        end
    end
    if name and name ~= "" then
        if SHOP_CATALOG.byName and SHOP_CATALOG.byName[name] then
            local d = SHOP_CATALOG.byName[name]
            return {
                name = name,
                rarity = d.rarity,
                fairPrice = d.fairPrice,
                spawnChance = d.spawnChance,
                id = d.id,
                type = d.type,
            }
        end
        local lower = string.lower(name)
        if SHOP_CATALOG_BY_NAME_LOWER[lower] then
            return SHOP_CATALOG_BY_NAME_LOWER[lower]
        end
        if SHOP_CATALOG.byName then
            for catName, data in pairs(SHOP_CATALOG.byName) do
                local cl = string.lower(catName)
                if cl == lower or cl:find(lower, 1, true) or lower:find(cl, 1, true) then
                    return {
                        name = catName,
                        rarity = data.rarity,
                        fairPrice = data.fairPrice,
                        spawnChance = data.spawnChance,
                        id = data.id,
                        type = data.type,
                    }
                end
            end
        end
    end
    return nil
end

local function getAssetIdFromSlot(slot)
    local mannequin = slot:FindFirstChild("Mannequin")
    if mannequin then
        local shirt = mannequin:FindFirstChildOfClass("Shirt")
        if shirt and shirt.ShirtTemplate ~= "" then
            local id = shirt.ShirtTemplate:match("%d+")
            if id then
                return id
            end
        end
        local pants = mannequin:FindFirstChildOfClass("Pants")
        if pants and pants.PantsTemplate ~= "" then
            local id = pants.PantsTemplate:match("%d+")
            if id then
                return id
            end
        end
    end
    for _, desc in ipairs(slot:GetDescendants()) do
        if desc:IsA("MeshPart") or desc:IsA("SpecialMesh") then
            local tex = ""
            if desc:IsA("MeshPart") then
                tex = desc.TextureID
            elseif desc:IsA("SpecialMesh") then
                tex = desc.TextureId
            end
            local id = tostring(tex):match("%d+")
            if id and #id >= 5 then
                return id
            end
        end
        if desc:IsA("StringValue") and desc.Name:lower():find("id") then
            local id = tostring(desc.Value):match("%d+")
            if id then
                return id
            end
        end
    end
    return nil
end

local function enrichShopEntry(info, slot)
    if not info then
        return info
    end
    local assetId = info.assetId or (slot and getAssetIdFromSlot(slot))
    local cat = findCatalogEntry(info.name, assetId)
    if cat then
        info.name = cat.name or info.name
        info.rarity = cat.rarity or info.rarity
        info.price = info.price or cat.fairPrice
        info.fairPrice = cat.fairPrice or info.fairPrice
        info.spawnChance = cat.spawnChance or info.spawnChance
        info.catalogHit = true
    elseif assetId then
        info.assetId = assetId
    end
    return info
end

local function buildEspLabel(info, rarity)
    local chance = info.spawnChance
    local price = info.price or info.fairPrice
    local chanceStr = chance and formatChance(chance) or "?"
    local priceStr = price and formatPrice(price) or ""
    local itemName = info.name or "?"
    if #itemName > 28 then
        itemName = itemName:sub(1, 26) .. ".."
    end
    return string.format("[%s %s] %s  %s", rarity, chanceStr, itemName, priceStr)
end

local function isRaritySelected(rarity)
    return State.selectedRarities[rarity] == true
end

local function normalizeRarity(text)
    if not text or text == "" then
        return "Common"
    end
    for _, rarity in ipairs(RARITY_ORDER) do
        if string.lower(text) == string.lower(rarity) then
            return rarity
        end
    end
    return text
end

local function colorDistance(a, b)
    return (a.R - b.R) ^ 2 + (a.G - b.G) ^ 2 + (a.B - b.B) ^ 2
end

local function colorToRarity(color)
    local bestName = "Common"
    local bestDist = math.huge
    for _, rarity in ipairs(RARITY_ORDER) do
        local ref = RARITY_COLORS[rarity]
        local dist = colorDistance(color, ref)
        if dist < bestDist then
            bestDist = dist
            bestName = rarity
        end
    end
    return bestName
end

local function getRarityFromSlot(slot)
    local rarityValue = slot:FindFirstChild("Rarity")
    if rarityValue and rarityValue:IsA("StringValue") then
        return normalizeRarity(rarityValue.Value)
    end

    local attr = slot:GetAttribute("Rarity")
    if attr then
        return normalizeRarity(tostring(attr))
    end

    local highlight = slot:FindFirstChild("ItemHighlight")
    if highlight and highlight:IsA("Highlight") then
        return colorToRarity(highlight.OutlineColor)
    end

    for _, desc in ipairs(slot:GetDescendants()) do
        if desc.Name == "ItemInfo" and desc:IsA("TextLabel") then
            local text = desc.Text:lower()
            for _, rarity in ipairs(RARITY_ORDER) do
                if text:find(rarity:lower(), 1, true) then
                    return rarity
                end
            end
        end
    end

    return "Common"
end

local function getItemNameFromSlot(slot)
    local assetId = getAssetIdFromSlot(slot)
    if assetId then
        local cat = findCatalogEntry(nil, assetId)
        if cat and cat.name then
            return cat.name
        end
    end

    local mannequin = slot:FindFirstChild("Mannequin")
    if mannequin then
        local shirt = mannequin:FindFirstChildOfClass("Shirt")
        if shirt and shirt.ShirtTemplate ~= "" then
            return "Shirt #" .. (shirt.ShirtTemplate:match("%d+") or "?")
        end
        local pants = mannequin:FindFirstChildOfClass("Pants")
        if pants and pants.PantsTemplate ~= "" then
            return "Pants #" .. (pants.PantsTemplate:match("%d+") or "?")
        end
    end

    for _, desc in ipairs(slot:GetDescendants()) do
        if desc.Name == "ItemInfo" and desc:IsA("TextLabel") and desc.Text ~= "" then
            return desc.Text
        end
    end

    local prompt = slot:FindFirstChild("TakePrompt")
    if prompt and prompt.ObjectText ~= "" then
        return prompt.ObjectText
    end

    return slot.Name
end

local function getRarityFromShopInfo(info)
    if not info then
        return "Common"
    end
    if info.rarity then
        return normalizeRarity(info.rarity)
    end
    if typeof(info.rarityColor) == "Color3" then
        return colorToRarity(info.rarityColor)
    end
    return "Common"
end

local function getColorFromShopInfo(info, rarity)
    if info and typeof(info.rarityColor) == "Color3" then
        return info.rarityColor
    end
    return RARITY_COLORS[rarity] or RARITY_COLORS.Common
end

local PlayerGui = nil
local ShopRemotes = nil

local function ensureShopRemotes()
    if ShopRemotes then
        return ShopRemotes ~= nil
    end
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15) or LocalPlayer.PlayerGui
    ShopRemotes = waitChild(ReplicatedStorage, "ShopRemotes", 20)
    if ShopRemotes then
        pcall(function()
            local reveal = ShopRemotes:WaitForChild("SlotPriceReveal", 8)
            if reveal then
                reveal.OnClientEvent:Connect(ingestShopReveal)
            end
        end)
        pcall(function()
            local clear = ShopRemotes:WaitForChild("SlotInfoClear", 8)
            if clear then
                clear.OnClientEvent:Connect(function()
                    for _k in pairs(State.shopCache) do State.shopCache[_k] = nil end
                end)
            end
        end)
        pcall(function()
            local upd = ShopRemotes:WaitForChild("SlotInfoUpdate", 8)
            if upd then
                upd.OnClientEvent:Connect(function(data)
                    if data and data.zoneId then
                        task.defer(fallbackScanShopParts)
                    end
                end)
            end
        end)
    end
    return ShopRemotes ~= nil
end

local function resolveSlotPart(container)
    if not container then
        return nil
    end
    if container:IsA("BasePart") then
        return container
    end
    local interact = container:FindFirstChild("Interact")
    if interact and interact:IsA("BasePart") then
        return interact
    end
    for _, desc in ipairs(container:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and (desc.Name == "TakePrompt" or desc.Name == "Take") then
            local parent = desc.Parent
            if parent and parent:IsA("BasePart") then
                return parent
            end
        end
    end
    if container:IsA("Model") then
        if container.PrimaryPart then
            return container.PrimaryPart
        end
        return container:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end

local function scanSlotContainer(container)
    local part = resolveSlotPart(container)
    if not part or not part.Parent then
        return
    end
    local highlight = container:FindFirstChild("ItemHighlight", true)
    local rarity = getRarityFromSlot(container)
    local color = RARITY_COLORS[rarity] or RARITY_COLORS.Common
    if highlight and highlight:IsA("Highlight") then
        color = highlight.OutlineColor
        rarity = colorToRarity(color)
        pcall(function()
            highlight.Enabled = true
        end)
    end
    local key = "slot_" .. container:GetFullName()
    local entry = {
        slotId = key,
        slotRef = part,
        name = getItemNameFromSlot(container),
        rarity = rarity,
        rarityColor = color,
        assetId = getAssetIdFromSlot(container),
    }
    State.shopCache[key] = enrichShopEntry(entry, container)
end

local function harvestGameBillboards()
    ensureShopRemotes()
    if not PlayerGui then
        return
    end
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name:sub(1, 5) == "__SB_" then
            for _, bg in ipairs(gui:GetChildren()) do
                if bg:IsA("BillboardGui") and bg.Adornee and bg.Adornee:IsA("BasePart") then
                    local labels = {}
                    for _, ch in ipairs(bg:GetChildren()) do
                        if ch:IsA("TextLabel") and ch.Text ~= "" then
                            table.insert(labels, ch)
                        end
                    end
                    if #labels > 0 then
                        local nameLabel = labels[1]
                        local priceLabel = labels[2]
                        local color = nameLabel.TextColor3
                        local rarity = colorToRarity(color)
                        local price = nil
                        if priceLabel then
                            price = tonumber(priceLabel.Text:match("%d+"))
                        end
                        local part = bg.Adornee
                        local key = "bb_" .. part:GetFullName()
                        local entry = {
                            slotId = key,
                            slotRef = part,
                            name = nameLabel.Text,
                            rarity = rarity,
                            rarityColor = color,
                            price = price,
                        }
                        State.shopCache[key] = enrichShopEntry(entry, part.Parent)
                    end
                end
            end
        end
    end
end

local function ingestShopReveal(payload)
    if type(payload) ~= "table" then
        return
    end
    local list = payload
    if not payload[1] and payload.slotId then
        list = { payload }
    end
    for _, info in ipairs(list) do
        if info and info.slotId then
            local part = info.slotRef
            if part and not part:IsA("BasePart") then
                part = resolveSlotPart(part)
            end
            if part and part.Parent then
                info.slotRef = part
                enrichShopEntry(info, part.Parent)
                State.shopCache[tostring(info.slotId)] = info
            end
        end
    end
end

local function collectShopRoots()
    local roots = {}
    local seen = {}
    local function add(root)
        if root and not seen[root] then
            seen[root] = true
            table.insert(roots, root)
        end
    end
    add(workspace:FindFirstChild("NPCSpawn"))
    add(workspace:FindFirstChild("ShopZones"))
    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name:match("^Shop_ShopZone") or child.Name:match("^ShopZone") then
            add(child)
        end
    end
    return roots
end

local function fallbackScanShopParts()
    harvestGameBillboards()
    for _, root in ipairs(collectShopRoots()) do
        for _, desc in ipairs(root:GetDescendants()) do
            if desc.Name:match("^Slot_%d+$") and (desc:IsA("Model") or desc:IsA("Folder")) then
                scanSlotContainer(desc)
            elseif desc:IsA("Highlight") and desc.Name == "ItemHighlight" and desc.Parent then
                local slot = desc.Parent
                while slot and slot ~= root and not slot.Name:match("^Slot_%d+$") do
                    slot = slot.Parent
                end
                if slot and slot.Name:match("^Slot_%d+$") then
                    scanSlotContainer(slot)
                end
            end
        end
    end
end


-- ========== AutoBuy ==========
local function resolveShopZonePivot()
    local roots = collectShopRoots()
    for _, root in ipairs(roots) do
        if root and root:IsA("Model") then
            local ok, cf = pcall(function()
                return root:GetPivot()
            end)
            if ok and cf then
                return cf + Vector3.new(0, 0, 8)
            end
        end
        if root then
            local part = root:FindFirstChildWhichIsA("BasePart", true)
            if part then
                return part.CFrame + Vector3.new(0, 0, 6)
            end
        end
    end
    for _, root in ipairs(roots) do
        for _, desc in ipairs(root:GetDescendants()) do
            if desc:IsA("BasePart") and desc.Name:match("^Slot_") then
                return desc.CFrame + Vector3.new(0, 0, 5)
            end
        end
    end
    return nil
end

local function stealthTeleportToPart(part, holdSeconds)
    if not part or not part.Parent then
        return false
    end
    local targetCF = part.CFrame * CFrame.new(0, 0, 4)
    return applyHardTeleport(targetCF, holdSeconds or 1.8)
end

local function slotMatchesAutobuyTarget(entry, target)
    if not entry or not target then
        return false
    end
    if target.i and entry.assetId and tostring(entry.assetId) == tostring(target.i) then
        return true
    end
    if target.i and entry.id and tostring(entry.id) == tostring(target.i) then
        return true
    end
    if target.n and entry.name then
        local a = string.lower(entry.name)
        local b = string.lower(target.n)
        if a == b or a:find(b, 1, true) or b:find(a, 1, true) then
            return true
        end
    end
    return false
end

local function scanShopForTarget(target)
    ensureShopRemotes()
    harvestGameBillboards()
    fallbackScanShopParts()
    local hrp = getHRP()
    local best, bestDist = nil, math.huge
    for _, info in pairs(State.shopCache) do
        if slotMatchesAutobuyTarget(info, target) then
            local part = info.slotRef
            if part and part.Parent then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = info
                end
            end
        end
    end
    return best
end

local function fireSlotPrompts(part)
    if not part then
        return
    end
    local function tryPrompt(prompt)
        if not prompt or not prompt:IsA("ProximityPrompt") then
            return
        end
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(prompt, 1)
            else
                prompt:InputHoldBegin()
                task.wait(0.1)
                prompt:InputHoldEnd()
            end
        end)
    end
    for _, desc in ipairs(part:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            tryPrompt(desc)
        end
    end
    local parent = part.Parent
    if parent then
        for _, desc in ipairs(parent:GetDescendants()) do
            if desc:IsA("ProximityPrompt") then
                tryPrompt(desc)
            end
        end
    end
end

local function addItemToCart(part)
    if not ensureShopRemotes() or not part then
        return false
    end
    local takeMobile = ShopRemotes:FindFirstChild("TakeItemMobile")
    local take = ShopRemotes:FindFirstChild("TakeItem")
    local reqTake = ShopRemotes:FindFirstChild("RequestTakeItem")
    if takeMobile then
        safeRemoteCall(takeMobile, part)
    end
    if take then
        safeRemoteCall(take, part)
    end
    if reqTake then
        safeRemoteCall(reqTake, part)
    end
    fireSlotPrompts(part)
    return true
end

local function payShopCart()
    if not ensureShopRemotes() then
        return false
    end
    local confirm = ShopRemotes:FindFirstChild("ConfirmPurchase")
    if not confirm then
        return false
    end
    acWait(0.4)
    safeRemoteCall(confirm)
    return true
end

local function stopAutoBuy()
    State.autoBuyEnabled = false
end

local function runAutoBuyLoop()
    if State.autoBuyRunning then
        return
    end
    if not State.autoBuyTarget then
        notify("AutoBuy", "Выбери редкость и вещь", 4)
        return
    end
    State.autoBuyRunning = true
    State.autoBuyEnabled = true
    notify("AutoBuy", "Старт: " .. State.autoBuyTarget.n, 5)

    task.spawn(function()
        local target = State.autoBuyTarget
        local scans = 0
        while State.autoBuyEnabled do
            local hit = scanShopForTarget(target)
            if hit and hit.slotRef then
                notify("AutoBuy", "Найдено → " .. (hit.name or target.n), 4)
                stealthTeleportToPart(hit.slotRef, 2)
                task.wait(0.6)
                addItemToCart(hit.slotRef)
                task.wait(0.9)
                payShopCart()
                notify("AutoBuy", "Оплата отправлена", 4)
                if State.autoBuyOnce then
                    State.autoBuyEnabled = false
                    break
                end
                task.wait(2)
            else
                scans = scans + 1
                if scans % 3 == 1 then
                    notify("AutoBuy", "Скан ЦУМ (#" .. scans .. ")…", 3)
                end
                local zoneCF = resolveShopZonePivot()
                if zoneCF then
                    applyHardTeleport(zoneCF, 1.2)
                end
                task.wait(State.autoBuyScanInterval or 2.5)
            end
        end
        State.autoBuyRunning = false
        notify("AutoBuy", "Остановлен", 3)
    end)
end


-- ========== AutoFarm (ЦУМ -> Барыга) ==========
local function ensureInventoryHooks()
    if State.inventoryHooksReady then
        return true
    end
    local folder = ReplicatedStorage:FindFirstChild("InventoryRemotes")
    if not folder then
        return false
    end
    local updated = folder:FindFirstChild("InventoryUpdated")
    State.requestInventoryRemote = folder:FindFirstChild("RequestInventory")
    if updated and updated:IsA("RemoteEvent") then
        table.insert(
            State.connections,
            updated.OnClientEvent:Connect(function(payload)
                if type(payload) == "table" then
                    if payload.inventory then
                        State.inventory = payload.inventory
                    elseif payload[1] and type(payload[1]) == "table" and payload[1].uid then
                        State.inventory = payload
                    end
                end
            end)
        )
    end
    State.inventoryHooksReady = true
    return true
end

local function pullInventory()
    ensureInventoryHooks()
    if State.requestInventoryRemote then
        safeRemoteCall(State.requestInventoryRemote)
    end
    task.wait(0.65)
end

local function inventoryItemMatches(target, item)
    if not target or not item then
        return false
    end
    if target.i then
        local aid = item.id or item.assetId or item.templateId
        if aid and tonumber(aid) == tonumber(target.i) then
            return true
        end
    end
    if target.n and item.name then
        local a = string.lower(item.name)
        local b = string.lower(target.n)
        if a == b or a:find(b, 1, true) or b:find(a, 1, true) then
            return true
        end
    end
    return false
end

local function findItemUid(target)
    for _, item in ipairs(State.inventory or {}) do
        if inventoryItemMatches(target, item) and item.uid then
            return item.uid, item
        end
    end
    return nil
end

local function pickBestFarmItem(rarity)
    local items = getAutobuyItemsForRarity(rarity)
    local best, bestScore = nil, -1
    for _, it in ipairs(items) do
        local spawnChance = it.s or 0
        local fairPrice = it.p or 0
        if spawnChance > 0 and fairPrice > 0 then
            if spawnChance > bestScore then
                bestScore = spawnChance
                best = it
            end
        end
    end
    return best or items[1]
end

local function ensureBarigaRemotes()
    if State.barigaRemotesFolder then
        return true
    end
    local folder = ReplicatedStorage:FindFirstChild("BarigaRemotes")
    if not folder then
        return false
    end
    State.barigaRemotesFolder = folder
    return true
end

local function visitBarigaSync()
    local targetCF = resolveBarigaTarget()
    if not targetCF then
        return false, "BarigaNPC не найден"
    end
    for _ = 1, 3 do
        streamPosition(targetCF.Position)
        task.wait(0.4)
    end
    if not applyHardTeleport(targetCF, State.barigaHoldSeconds or 2) then
        return false, "ТП к барыге не удался"
    end
    task.wait((State.barigaHoldSeconds or 2) + 0.45)
    stopBarigaHold()
    restorePlayerMovement()
    tryFireBarigaPrompt()
    task.wait(0.15)
    openBarigaMenu()
    task.wait(0.9)
    return true
end

local function sellItemToBariga(target)
    if not ensureBarigaRemotes() then
        return false, "BarigaRemotes"
    end
    local folder = State.barigaRemotesFolder
    local getOffer = folder:FindFirstChild("GetBarigaOffer")
    local getInv = folder:FindFirstChild("GetBarigaInventory")
    local confirm = folder:FindFirstChild("ConfirmBarigaSale")
    local closeRemote = folder:FindFirstChild("CloseBariga")

    pullInventory()
    local uid = findItemUid(target)
    if not uid and getInv then
        local ok, inv = pcall(function()
            return getInv:InvokeServer()
        end)
        if ok and type(inv) == "table" then
            for _, item in ipairs(inv) do
                if inventoryItemMatches(target, item) and item.uid then
                    uid = item.uid
                    break
                end
            end
        end
    end
    if not uid then
        return false, "Вещь не найдена в инвентаре"
    end

    if getOffer then
        pcall(function()
            getOffer:InvokeServer({ uid })
        end)
        acWait(0.35)
    end
    if confirm then
        safeRemoteCall(confirm, true)
        acWait(0.45)
    else
        return false, "ConfirmBarigaSale"
    end
    if closeRemote then
        safeRemoteCall(closeRemote)
    end
    pullInventory()
    return true, uid
end

local function stopAutoFarm()
    State.autoFarmEnabled = false
end

local function runAutoFarmLoop()
    if State.autoFarmRunning then
        return
    end
    ensureInventoryHooks()
    local target = State.autoFarmTarget
    if not target and State.autoFarmUseBest then
        target = pickBestFarmItem(State.autoFarmRarity or State.autoBuyRarity or "Common")
        State.autoFarmTarget = target
    end
    if not target then
        notify("AutoFarm", "Выбери вещь или включи «Лучший шанс»", 4)
        return
    end

    State.autoFarmRunning = true
    State.autoFarmEnabled = true
    State.autoBuyEnabled = false
    notify("AutoFarm", "Старт: " .. target.n, 5)

    task.spawn(function()
        local cycles = 0
        while State.autoFarmEnabled do
            cycles = cycles + 1
            local activeTarget = State.autoFarmTarget or target
            local bought = false
            local scans = 0

            while State.autoFarmEnabled and not bought do
                local hit = scanShopForTarget(activeTarget)
                if hit and hit.slotRef then
                    notify("AutoFarm", "Покупка: " .. (hit.name or activeTarget.n), 3)
                    stealthTeleportToPart(hit.slotRef, 2)
                    task.wait(0.6)
                    addItemToCart(hit.slotRef)
                    task.wait(0.9)
                    payShopCart()
                    task.wait(1.1)
                    pullInventory()
                    bought = findItemUid(activeTarget) ~= nil
                else
                    scans = scans + 1
                    if scans % 3 == 1 then
                        notify("AutoFarm", "Скан ЦУМ (#" .. scans .. ")", 2)
                    end
                    local zoneCF = resolveShopZonePivot()
                    if zoneCF then
                        applyHardTeleport(zoneCF, 1.2)
                    end
                    task.wait(State.autoFarmScanInterval or 2.5)
                end
            end

            if not bought or not State.autoFarmEnabled then
                break
            end

            notify("AutoFarm", "Продажа барыге...", 3)
            local okVisit = visitBarigaSync()
            if not okVisit then
                notify("AutoFarm", "Не удалось дойти до барыги", 5)
                task.wait(2)
            else
                local okSell, info = sellItemToBariga(activeTarget)
                if okSell then
                    notify("AutoFarm", "Цикл #" .. cycles .. " OK", 4)
                else
                    notify("AutoFarm", "Продажа: " .. tostring(info), 5)
                end
            end

            if State.autoFarmUseBest then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity or "Common")
                activeTarget = State.autoFarmTarget
            end

            if State.autoFarmMaxCycles and cycles >= State.autoFarmMaxCycles then
                State.autoFarmEnabled = false
                State.autoFarmMaxCycles = nil
            end

            task.wait(State.autoFarmDelay or 2)
        end
        State.autoFarmRunning = false
        notify("AutoFarm", "Остановлен", 3)
    end)
end


local function getAutobuyItemsForRarity(rarity)
    if not AUTOBUY_ITEMS then
        return {}
    end
    return AUTOBUY_ITEMS[rarity] or {}
end

local function buildAutobuyItemNames(rarity)
    local names = {}
    for _, it in ipairs(getAutobuyItemsForRarity(rarity)) do
        table.insert(names, it.n)
    end
    table.sort(names)
    return names
end

local function resolveAutobuyTargetByName(name, rarity)
    for _, it in ipairs(getAutobuyItemsForRarity(rarity)) do
        if it.n == name then
            return it
        end
    end
    return nil
end

local function ensureEspScreen()
    if State.espUi and State.espUi.screen and State.espUi.screen.Parent then
        State.espUi.pool = State.espUi.pool or {}
        State.espUi.live = State.espUi.live or {}
        return State.espUi
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "TSUM_ESP_Overlay"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 500
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = PlayerGui
    State.espUi = { screen = gui, pool = {}, live = {} }
    return State.espUi
end

local function releaseEspWidget(ui, holder)
    local w = ui.live[holder]
    if w then
        holder.Visible = false
        ui.live[holder] = nil
        table.insert(ui.pool, w)
    end
end

local function acquireEspWidgets(ui)
    local w = table.remove(ui.pool)
    if w then
        return w
    end
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(0, 0)
    holder.Visible = false
    holder.Parent = ui.screen

    local tracer = Instance.new("Frame")
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.ZIndex = 2
    tracer.Parent = holder

    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.ZIndex = 3
    box.Parent = holder
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Parent = box

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromOffset(300, 36)
    label.TextWrapped = true
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextStrokeTransparency = 0.3
    label.ZIndex = 4
    label.Parent = holder

    return { holder = holder, tracer = tracer, box = box, stroke = stroke, label = label }
end

local function drawLine(frame, fromPos, toPos, thickness, color)
    local dx = toPos.X - fromPos.X
    local dy = toPos.Y - fromPos.Y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < 2 then
        frame.Visible = false
        return
    end
    frame.Visible = true
    frame.BackgroundColor3 = color
    frame.Size = UDim2.fromOffset(dist, thickness)
    frame.Position = UDim2.fromOffset((fromPos.X + toPos.X) * 0.5, (fromPos.Y + toPos.Y) * 0.5)
    frame.Rotation = math.deg(math.atan2(dy, dx))
end

local function clearAllESP()
    if State.espUi and State.espUi.screen then
        State.espUi.screen:Destroy()
    end
    State.espUi = nil
end

local function renderEspFrame()
    if not State.espEnabled then
        return
    end
    ensureShopRemotes()
    local camera = workspace.CurrentCamera
    local hrp = getHRP()
    if not camera or not hrp then
        return
    end
    if tick() - State.lastEspScan >= State.espScanInterval then
        fallbackScanShopParts()
        State.lastEspScan = tick()
    end
    local ui = ensureEspScreen()
    local active = {}
    local tracerFrom = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y - 6)
    local drawn = 0

    for slotId, info in pairs(State.shopCache) do
        if drawn >= 48 then
            break
        end
        local part = info.slotRef
        if part and part.Parent then
            local rarity = getRarityFromShopInfo(info)
            if isRaritySelected(rarity) then
                local worldPos = part.Position + Vector3.new(0, 2.2, 0)
                if (worldPos - hrp.Position).Magnitude <= State.espMaxDistance then
                    local screenPos, onScreen = camera:WorldToViewportPoint(worldPos)
                    if onScreen and screenPos.Z > 0 then
                        drawn = drawn + 1
                        local color = getColorFromShopInfo(info, rarity)
                        local w = acquireEspWidgets(ui)
                        ui.live[w.holder] = w
                        active[w.holder] = true
                        local center = Vector2.new(screenPos.X, screenPos.Y)
                        local boxSize = math.clamp(3200 / math.max(screenPos.Z, 1), 24, 140)
                        drawLine(w.tracer, tracerFrom, center, 2, color)
                        w.box.Visible = true
                        w.box.Size = UDim2.fromOffset(boxSize, boxSize)
                        w.box.Position = UDim2.fromOffset(center.X - boxSize * 0.5, center.Y - boxSize * 0.5)
                        w.stroke.Color = color
                        w.label.Visible = true
                        w.label.Position = UDim2.fromOffset(center.X, center.Y - boxSize * 0.5 - 4)
                        w.label.TextColor3 = color
                        w.label.Text = buildEspLabel(info, rarity)
                        w.holder.Visible = true
                    end
                end
            end
        else
            State.shopCache[slotId] = nil
        end
    end

    for holder in pairs(ui.live) do
        if not active[holder] then
            releaseEspWidget(ui, holder)
        end
    end
end

local function refreshESP()
    if State.espEnabled then
        fallbackScanShopParts()
    end
end

local function setESP(enabled)
    ensureShopRemotes()
    State.espEnabled = enabled
    if not enabled then
        clearAllESP()
        notify("ESP", "Подсветка выключена", 3)
        return
    end
    fallbackScanShopParts()
    local n = 0
    for _ in pairs(State.shopCache) do
        n = n + 1
    end
    notify("ESP", "ЦУМ ESP: " .. n .. " слотов. Каталог: " .. (SHOP_CATALOG and "OK" or "нет") .. ".", 6)
end

local function disconnectLoop()
    for _, conn in ipairs(State.connections) do
        conn:Disconnect()
    end
    for _k in pairs(State.connections) do State.connections[_k] = nil end
end

local function startESPLoop()
    disconnectLoop()
    table.insert(State.connections, RunService.RenderStepped:Connect(function()
        if State.espEnabled then
            renderEspFrame()
        end
    end))
end

local function destroyRemoteSpyGui()
    if State.remoteSpyGui and State.remoteSpyGui.screen then
        State.remoteSpyGui.screen:Destroy()
    end
    State.remoteSpyGui = nil
    State.refreshRemoteSpy = nil
end

local function createRemoteSpyGui()
    destroyRemoteSpyGui()

    local gui = Instance.new("ScreenGui")
    gui.Name = "TSUM_RemoteSpy"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 997
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local root = Instance.new("Frame")
    root.Size = UDim2.fromOffset(480, 300)
    root.Position = UDim2.new(0, 12, 1, -312)
    root.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
    root.BorderSizePixel = 0
    root.Parent = gui
    Instance.new("UICorner", root).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", root)
    stroke.Color = Color3.fromRGB(80, 180, 255)
    stroke.Thickness = 1.2

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.fromOffset(10, 6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(120, 200, 255)
    title.Text = "Remote Spy (Dex-style) — AutoBuy"
    title.Parent = root

    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(24, 24)
    close.Position = UDim2.new(1, -30, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.Parent = root
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -44)
    scroll.Position = UDim2.fromOffset(10, 36)
    scroll.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.fromOffset(0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = root
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function paint()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        if #State.remoteLog == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -8, 0, 24)
            empty.BackgroundTransparency = 1
            empty.Font = Enum.Font.Code
            empty.TextSize = 11
            empty.TextXAlignment = Enum.TextXAlignment.Left
            empty.TextColor3 = Color3.fromRGB(140, 145, 155)
            empty.Text = "Ожидание remote-вызовов..."
            empty.Parent = scroll
            return
        end
        for i, entry in ipairs(State.remoteLog) do
            local row = Instance.new("TextLabel")
            row.Size = UDim2.new(1, -8, 0, 18)
            row.BackgroundTransparency = 1
            row.Font = Enum.Font.Code
            row.TextSize = 10
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.TextTruncate = Enum.TextTruncate.AtEnd
            row.TextColor3 = entry.ok and Color3.fromRGB(120, 220, 140) or Color3.fromRGB(255, 130, 130)
            row.Text = string.format("[%s] %s", entry.time, entry.text)
            row.LayoutOrder = i
            row.Parent = scroll
        end
    end

    State.refreshRemoteSpy = paint
    State.remoteSpyGui = { screen = gui }
    paint()

    close.MouseButton1Click:Connect(function()
        destroyRemoteSpyGui()
    end)
end


local function createSplash(onContinue)
    local gui = Instance.new("ScreenGui")
    gui.Name = "TSUM_Splash"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local dim = Instance.new("Frame")
    dim.Size = UDim2.fromScale(1, 1)
    dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 0.35
    dim.BorderSizePixel = 0
    dim.Parent = gui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(360, 220)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    card.BorderSizePixel = 0
    card.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 130, 255)
    stroke.Thickness = 1.5
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 48)
    title.Position = UDim2.fromOffset(12, 20)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "made by tsumfreescript"
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -24, 0, 60)
    subtitle.Position = UDim2.fromOffset(12, 72)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.TextWrapped = true
    subtitle.TextColor3 = Color3.fromRGB(180, 185, 195)
    subtitle.Text = "TSUM Free Script\nAutoFarm + AutoBuy + ESP\nНажми Continue"
    subtitle.Parent = card

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -48, 0, 42)
    button.Position = UDim2.new(0.5, 0, 1, -58)
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    button.Text = "Continue"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = true
    button.BorderSizePixel = 0
    button.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        gui:Destroy()
        onContinue()
    end)
end

local function loadMainUI()
    if not loadRayfield() then
        return
    end
    task.spawn(function()
        pcall(installAntiCheatBypass)
    end)
    if State.remoteSpyEnabled then
        task.defer(createRemoteSpyGui)
    end
    TSUM_loadEmbeddedCatalogAsync(function())
        if State.espEnabled then
            refreshESP()
        end
    end)

    local Window = Rayfield:CreateWindow({
        Name = "TSUM | tsumfreescript",
        LoadingTitle = "TSUM Free Script",
        LoadingSubtitle = "made by tsumfreescript",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "TSUMFreeScript",
            FileName = "settings",
        },
        KeySystem = false,
    })

    local Main = Window:CreateTab("Main", 4483362458)
    Main:CreateSection("ESP — магазин ЦУМ")

    Main:CreateParagraph({
        Title = "Каталог",
        Content = "584 вещи из SHOP_ITEMS.\nФормат: [Редкость %] Название $Цена",
    })

    Main:CreateToggle({
        Name = "ESP ЦУМ (tracer + box)",
        CurrentValue = false,
        Flag = "TSUM_ESP",
        Callback = setESP,
    })

    Main:CreateButton({
        Name = "Обновить ESP (скан ЦУМ)",
        Callback = function()
            refreshESP()
            local n = 0
            for _ in pairs(State.shopCache) do
                n = n + 1
            end
            notify("ESP", "Скан: " .. n .. " слотов в кэше", 4)
        end,
    })

    Main:CreateSection("Редкость для подсветки")

    for _, rarity in ipairs(RARITY_ORDER) do
        Main:CreateToggle({
            Name = rarity,
            CurrentValue = State.selectedRarities[rarity] == true,
            Flag = "TSUM_Rarity_" .. rarity,
            Callback = function(value)
                State.selectedRarities[rarity] = value
                if State.espEnabled then
                    refreshESP()
                end
            end,
        })
    end

    Main:CreateSection("Барыга — телепорт")

    Main:CreateButton({
        Name = "ТП к Барыге (усиленный)",
        Callback = teleportToBariga,
    })

    Main:CreateButton({
        Name = "Открыть меню Барыги",
        Callback = function()
            if openBarigaMenu() or tryFireBarigaPrompt() then
                notify("Барыга", "TriggerBariga отправлен", 3)
            else
                notify("Барыга", "BarigaRemotes / BarigaPrompt не найден", 4)
            end
        end,
    })

    Main:CreateButton({
        Name = "Снять блокировку движения",
        Callback = function()
            stopBarigaHold()
            restorePlayerMovement()
            notify("Барыга", "Движение восстановлено", 3)
        end,
    })

    Main:CreateToggle({
        Name = "Авто-открыть UI после ТП",
        CurrentValue = State.barigaAutoOpen,
        Flag = "TSUM_BarigaAutoOpen",
        Callback = function(v)
            State.barigaAutoOpen = v
        end,
    })

    Main:CreateSlider({
        Name = "Удержание позиции (сек)",
        Range = { 1, 8 },
        Increment = 1,
        Suffix = "s",
        CurrentValue = State.barigaHoldSeconds,
        Flag = "TSUM_BarigaHold",
        Callback = function(v)
            State.barigaHoldSeconds = v
        end,
    })

    Main:CreateParagraph({
        Title = "Барыга",
        Content = "Pivot Y=324 у BarigaNPC.\nСтрим зоны 2 сек → ТП к ногам NPC.\nFallback: -3616, 324, -234",
    })
    Main:CreateLabel("made by tsumfreescript")
    Main:CreateParagraph({
        Title = "ESP",
        Content = "Каталог: название, цена, % спавна.\nСкан Slot_* + billboard + SlotPriceReveal.",
    })

    Main:CreateSection("Обход античита")

    Main:CreateToggle({
        Name = "Очередь remotes (anti-spam)",
        CurrentValue = AC.useRemoteQueue,
        Flag = "TSUM_RemoteQueue",
        Callback = function(v)
            AC.useRemoteQueue = v
            AC.stealthRemotes = v
        end,
    })

    Main:CreateToggle({
        Name = "Anti-Kick (hook Kick)",
        CurrentValue = AC.antiKick,
        Flag = "TSUM_AntiKick",
        Callback = function(v)
            AC.antiKick = v
        end,
    })

    Main:CreateToggle({
        Name = "Anti-Speed reset",
        CurrentValue = AC.antiSpeed,
        Flag = "TSUM_AntiSpeed",
        Callback = function(v)
            AC.antiSpeed = v
        end,
    })

    Main:CreateToggle({
        Name = "Anti-Fling",
        CurrentValue = AC.antiFling,
        Flag = "TSUM_AntiFling",
        Callback = function(v)
            AC.antiFling = v
        end,
    })

    Main:CreateToggle({
        Name = "Stealth TP (микро-шаги)",
        CurrentValue = State.stealthTp,
        Flag = "TSUM_StealthTp",
        Callback = function(v)
            State.stealthTp = v
            AC.stealthTp = v
        end,
    })

    Main:CreateToggle({
        Name = "Anti-Adonis (Detected/Kill)",
        CurrentValue = AC.antiAdonis,
        Flag = "TSUM_AntiAdonis",
        Callback = function(v)
            AC.antiAdonis = v
            if v and ACBridge and ACBridge.refreshAdonis then
                pcall(ACBridge.refreshAdonis)
            end
        end,
    })

    Main:CreateButton({
        Name = "Перескан Adonis / AC",
        Callback = function()
            pcall(installAntiCheatBypass)
            if ACBridge and ACBridge.refreshAdonis then
                pcall(ACBridge.refreshAdonis)
            end
            notify("AC", "Перескан выполнен", 4)
        end,
    })

    Main:CreateSection("AutoBuy")

    Main:CreateButton({
        Name = "Старт AutoBuy",
        Callback = function()
            runAutoBuyLoop()
        end,
    })

    Main:CreateButton({
        Name = "Стоп AutoBuy",
        Callback = stopAutoBuy,
    })

    Main:CreateToggle({
        Name = "Remote Spy (Dex-style лог)",
        CurrentValue = State.remoteSpyEnabled,
        Flag = "TSUM_RemoteSpy",
        Callback = function(v)
            State.remoteSpyEnabled = v
            if v then
                createRemoteSpyGui()
            else
                destroyRemoteSpyGui()
            end
        end,
    })

    Main:CreateButton({
        Name = "Открыть Remote Spy",
        Callback = function()
            State.remoteSpyEnabled = true
            createRemoteSpyGui()
        end,
    })


    local AutoTab = Window:CreateTab("AutoBuy", 6031255555)
    AutoTab:CreateSection("Автопокупка в ЦУМ")
    AutoTab:CreateParagraph({
        Title = "Как работает",
        Content = "Выбери редкость → вещь → Старт.\nСканирует магазин, ТП к слоту, в корзину, оплата.\nStealth TP как у Барыги.",
    })

    local rarityOpts = {}
    for _, r in ipairs(RARITY_ORDER) do
        if AUTOBUY_ITEMS and AUTOBUY_ITEMS[r] and #AUTOBUY_ITEMS[r] > 0 then
            table.insert(rarityOpts, r)
        end
    end
    if #rarityOpts == 0 then
        rarityOpts = { "Common", "Uncommon", "Rare", "Epic", "Legendary" }
    end

    if not State.autoBuyRarity then
        State.autoBuyRarity = rarityOpts[1] or "Rare"
    end

    local itemDropdown

    local function applyAutobuyItemSelection(name)
        State.autoBuyTarget = resolveAutobuyTargetByName(name, State.autoBuyRarity)
    end

    local function refreshAutobuyItemDropdown(pickFirst)
        local itemNames = buildAutobuyItemNames(State.autoBuyRarity)
        if #itemNames == 0 then
            itemNames = { "— нет в каталоге —" }
        end
        if itemDropdown and itemDropdown.Refresh then
            itemDropdown:Refresh(itemNames)
        end
        if pickFirst and itemNames[1] and itemNames[1] ~= "— нет в каталоге —" then
            applyAutobuyItemSelection(itemNames[1])
        end
    end

    AutoTab:CreateDropdown({
        Name = "Редкость",
        Options = rarityOpts,
        CurrentOption = State.autoBuyRarity,
        Flag = "TSUM_AutoBuyRarity",
        Callback = function(v)
            State.autoBuyRarity = type(v) == "table" and v[1] or v
            State.autoBuyTarget = nil
            refreshAutobuyItemDropdown(true)
        end,
    })

    local initialItems = buildAutobuyItemNames(State.autoBuyRarity)
    if #initialItems == 0 then
        initialItems = { "— нет в каталоге —" }
    end

    itemDropdown = AutoTab:CreateDropdown({
        Name = "Вещь",
        Options = initialItems,
        CurrentOption = initialItems[1] or "—",
        Flag = "TSUM_AutoBuyItem",
        Callback = function(v)
            local name = type(v) == "table" and v[1] or v
            applyAutobuyItemSelection(name)
        end,
    })

    if initialItems[1] and initialItems[1] ~= "— нет в каталоге —" then
        applyAutobuyItemSelection(initialItems[1])
    end

    AutoTab:CreateInput({
        Name = "Поиск вещи (имя)",
        PlaceholderText = "часть названия…",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            State.autoBuySearch = text
        end,
    })

    AutoTab:CreateButton({
        Name = "Найти в каталоге",
        Callback = function()
            local query = string.lower(tostring(State.autoBuySearch or ""))
            if query == "" then
                notify("AutoBuy", "Введи часть названия", 3)
                return
            end
            local matches = {}
            for _, it in ipairs(getAutobuyItemsForRarity(State.autoBuyRarity)) do
                if string.find(string.lower(it.n), query, 1, true) then
                    table.insert(matches, it.n)
                end
            end
            table.sort(matches)
            if #matches == 0 then
                notify("AutoBuy", "Не найдено в " .. State.autoBuyRarity, 4)
                return
            end
            if itemDropdown and itemDropdown.Refresh then
                itemDropdown:Refresh(matches)
            end
            applyAutobuyItemSelection(matches[1])
            notify("AutoBuy", "Выбрано: " .. matches[1], 5)
        end,
    })

    AutoTab:CreateToggle({
        Name = "Купить один раз",
        CurrentValue = State.autoBuyOnce,
        Flag = "TSUM_AutoBuyOnce",
        Callback = function(v)
            State.autoBuyOnce = v
        end,
    })

    AutoTab:CreateToggle({
        Name = "Stealth TP",
        CurrentValue = State.stealthTp,
        Flag = "TSUM_AutoStealthTp",
        Callback = function(v)
            State.stealthTp = v
            AC.stealthTp = v
        end,
    })

    AutoTab:CreateButton({
        Name = "Старт AutoBuy",
        Callback = function()
            local items = getAutobuyItemsForRarity(State.autoBuyRarity)
            if not State.autoBuyTarget and items[1] then
                State.autoBuyTarget = items[1]
            end
            runAutoBuyLoop()
        end,
    })

    AutoTab:CreateButton({
        Name = "Стоп AutoBuy",
        Callback = stopAutoBuy,
    })

    AutoTab:CreateButton({
        Name = "Скан + найти сейчас",
        Callback = function()
            if not State.autoBuyTarget then
                notify("AutoBuy", "Выбери вещь", 3)
                return
            end
            local hit = scanShopForTarget(State.autoBuyTarget)
            if hit then
                notify("AutoBuy", "В магазине: " .. (hit.name or "?"), 6)
            else
                notify("AutoBuy", "Не найдено — продолай скан", 4)
            end
        end,
    })
    AutoTab:CreateLabel("made by tsumfreescript")



    local FarmTab = Window:CreateTab("AutoFarm", 6031266666)
    FarmTab:CreateSection("Ферма ЦУМ → Барыга")
    FarmTab:CreateParagraph({
        Title = "Как работает",
        Content = "Скан ЦУМ → покупка → в корзину → ТП к барыге → ConfirmBarigaSale.\nКаталог из message.txt (spawnChance + fairPrice).\nStealth TP как у Барыги.",
    })

    if not State.autoFarmRarity then
        State.autoFarmRarity = State.autoBuyRarity or "Common"
    end

    local farmItemDropdown
    local farmRarityOpts = {}
    for _, r in ipairs(RARITY_ORDER) do
        if AUTOBUY_ITEMS and AUTOBUY_ITEMS[r] and #AUTOBUY_ITEMS[r] > 0 then
            table.insert(farmRarityOpts, r)
        end
    end

    local function applyFarmItemSelection(name)
        State.autoFarmTarget = resolveAutobuyTargetByName(name, State.autoFarmRarity)
    end

    local function refreshFarmItemDropdown(pickBest)
        local names = buildAutobuyItemNames(State.autoFarmRarity)
        if #names == 0 then
            names = { "— нет —" }
        end
        if farmItemDropdown and farmItemDropdown.Refresh then
            farmItemDropdown:Refresh(names)
        end
        if pickBest then
            if State.autoFarmUseBest then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity)
            elseif names[1] and names[1] ~= "— нет —" then
                applyFarmItemSelection(names[1])
            end
        end
    end

    FarmTab:CreateToggle({
        Name = "Лучший шанс (spawnChance)",
        CurrentValue = State.autoFarmUseBest ~= false,
        Flag = "TSUM_AutoFarmBest",
        Callback = function(v)
            State.autoFarmUseBest = v
            if v then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity)
            end
        end,
    })

    FarmTab:CreateDropdown({
        Name = "Редкость",
        Options = farmRarityOpts,
        CurrentOption = State.autoFarmRarity,
        Flag = "TSUM_AutoFarmRarity",
        Callback = function(v)
            State.autoFarmRarity = type(v) == "table" and v[1] or v
            refreshFarmItemDropdown(true)
        end,
    })

    local farmInitial = buildAutobuyItemNames(State.autoFarmRarity)
    farmItemDropdown = FarmTab:CreateDropdown({
        Name = "Вещь",
        Options = #farmInitial > 0 and farmInitial or { "— нет —" },
        CurrentOption = farmInitial[1] or "—",
        Flag = "TSUM_AutoFarmItem",
        Callback = function(v)
            local name = type(v) == "table" and v[1] or v
            applyFarmItemSelection(name)
            State.autoFarmUseBest = false
        end,
    })
    refreshFarmItemDropdown(true)

    FarmTab:CreateToggle({
        Name = "Stealth TP",
        CurrentValue = State.stealthTp,
        Flag = "TSUM_AutoFarmStealth",
        Callback = function(v)
            State.stealthTp = v
            AC.stealthTp = v
        end,
    })

    FarmTab:CreateButton({
        Name = "Старт AutoFarm",
        Callback = function()
            if State.autoFarmUseBest then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity)
            elseif not State.autoFarmTarget then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity)
            end
            runAutoFarmLoop()
        end,
    })

    FarmTab:CreateButton({
        Name = "Стоп AutoFarm",
        Callback = stopAutoFarm,
    })

    FarmTab:CreateButton({
        Name = "1 цикл (купить + продать)",
        Callback = function()
            State.autoFarmMaxCycles = 1
            State.autoFarmDelay = 0
            if State.autoFarmUseBest or not State.autoFarmTarget then
                State.autoFarmTarget = pickBestFarmItem(State.autoFarmRarity)
            end
            runAutoFarmLoop()
        end,
    })
    FarmTab:CreateLabel("made by tsumfreescript")


    startESPLoop()

    LocalPlayer.CharacterAdded:Connect(function()
        stopBarigaHold()
    end)

    notify("TSUM", "Скрипт загружен — t.me/tsumfreescript", 5)
end

pcall(function()
    local ok, err = pcall(function()
        bootSplash(loadMainUI)
    end)
    if not ok then
        warn("[TSUM] Startup failed: " .. tostring(err))
        showBootError(tostring(err))
    end
end)
