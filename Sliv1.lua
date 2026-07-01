--[[
    TSUM Free Script — security / QA build
    made by tsumfreescript

    Тестовый скрипт для проверки ESP и телепорта.
    Запускать только создателем игры в тестовой среде.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    task.spawn(function()
        LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    end)
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
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    end)
    if ok and lib then
        Rayfield = lib
        return true
    end
    showBootError("Rayfield: " .. tostring(lib))
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

openTelegram()

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

        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

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
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

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
        { n = "Amiri Футболка Черная2", i = 89306530816863 },
        { n = "Gutta Opiu White", i = 125787142138788 },
        { n = "Nike Черная", i = 12820715433 },
        { n = "Nike Шорты", i = 6982632122 },
        { n = "Белая футболка", i = 1352050969 },
        { n = "Серая футболка", i = 114724377 },
        { n = "Синие джинсы", i = 9367316394 },
        { n = "Черная футболка", i = 6174845177 },
        { n = "Черные джинсы", i = 8425198358 },
    },
    ["Uncommon"] = {
        { n = "Amiri Футболка Paint", i = 128351870809134 },
        { n = "Amiri Худи Зеленое", i = 113811400216537 },
        { n = "Carhartt Double Knee", i = 8425198358 },
        { n = "Carhartt Hoodie", i = 6174845177 },
        { n = "Gutta Classic White Longsleeve", i = 81243747834531 },
        { n = "Gutta Coffee Longsleeve", i = 131637613314592 },
        { n = "Gutta Longsleeve Pink Blue", i = 121948527526959 },
        { n = "Gutta Opiu Black", i = 103809820683913 },
        { n = "Gutta Opiu Tee", i = 129923898671032 },
        { n = "Nike Hoodie", i = 4746292577 },
        { n = "Nike x Stussy", i = 17303641875 },
        { n = "Palace Track Pants", i = 8425198358 },
        { n = "Palace Tri-Ferg Tee", i = 1352050969 },
        { n = "Stussy Stock Logo Tee", i = 1352050969 },
        { n = "Stussy Work Pants", i = 8425198358 },
        { n = "Граффити футболка", i = 6877956799 },
        { n = "Рваные джинсы", i = 15617408766 },
    },
    ["Rare"] = {
        { n = "Acne Studios Face Tee", i = 1352050969 },
        { n = "Amiri Футболка Черная", i = 18694595667 },
        { n = "BAPE Camo", i = 3131452093 },
        { n = "BAPE Camo штаны", i = 4947216628 },
        { n = "BAPE Shark", i = 94733728494733 },
        { n = "BAPE Футболка", i = 105402915829012 },
        { n = "Black Milo Shark Tee", i = 4695588521 },
        { n = "Burberry Classic", i = 14182270450 },
        { n = "Burberry Штаны", i = 16218939509 },
        { n = "CP.Company Blue Hoodie", i = 16974592422 },
        { n = "CP.Company Blue Pants", i = 14050651166 },
        { n = "CP.Company Default Pants", i = 6664977420 },
        { n = "CP.Company Gray Pants", i = 15783604661 },
        { n = "CP.Company Rose", i = 125295721091210 },
        { n = "CP.Company Short Yellow", i = 13476230890 },
        { n = "CP.Company Свитшот", i = 14077919304 },
        { n = "Carhartt Cargo", i = 9367316394 },
        { n = "Carhartt Detroit Jacket", i = 1352050969 },
        { n = "Carhartt Shirt Jacket", i = 114724377 },
        { n = "Cav Empt Свитшот Черный", i = 124139147116818 },
        { n = "Comme des Garcons Футболка", i = 14582695300 },
        { n = "Designer джинсы", i = 18391376326 },
        { n = "Drip футболка", i = 6384915788 },
        { n = "Gallery Dept Спортивки Бежевый", i = 128614066781001 },
        { n = "Gallery Dept Спортивки Голубой", i = 93556375284974 },
        { n = "Gallery Dept Спортивки Розовая", i = 99632820598737 },
        { n = "Gallery Dept Спортивки Серые", i = 12792854135 },
        { n = "Gallery Dept Спортивки Черные", i = 13974345356 },
        { n = "Gutta Black-White Longsleeve", i = 75730721795242 },
        { n = "Gutta Hoodie Black", i = 73257106599901 },
        { n = "Gutta Hoodie Grey", i = 6877956799 },
        { n = "Gutta Zip-Hoodie", i = 87059217590619 },
        { n = "NeNet Футболка Белая", i = 12089573241 },
        { n = "NeNet Футболка Черная", i = 134937339779999 },
        { n = "NeNet Футболка Черный v2", i = 15015469155 },
        { n = "Nenet Штаны", i = 70880619395363 },
        { n = "Nike Air Pants", i = 14343129826 },
        { n = "Nike Tech", i = 11554103603 },
        { n = "Nike Tech Pants", i = 11410851476 },
        { n = "Palace Cargo", i = 9367316394 },
        { n = "Palace Hoodie", i = 6174845177 },
        { n = "Palm Angels", i = 85991896636316 },
        { n = "Palm Angels Классик", i = 18660217283 },
        { n = "Palm Angels Серые", i = 10468675783 },
        { n = "Racer WorldWide Aphex Футболка", i = 16579558789 },
        { n = "Racer WorldWide Свитшот", i = 11831115149 },
        { n = "Racer WorldWide Свитшот Красный", i = 78683849537161 },
        { n = "Rick Owens Zip", i = 92750199062144 },
        { n = "Rick Owens Джинсы", i = 18477705722 },
        { n = "Rick Owens Штаны", i = 14220615409 },
        { n = "Stone Island Default", i = 16388179108 },
        { n = "Stone Island Default", i = 15177463566 },
        { n = "Stone Island Joggers", i = 120383454886093 },
        { n = "Stone Island Свитшот", i = 1315352916 },
        { n = "Stussy 8 Ball Hoodie", i = 6174845177 },
        { n = "Stussy Nylon Pants", i = 9367316394 },
        { n = "Supreme Box Logo", i = 1499082681 },
        { n = "Supreme Pants", i = 7092331508 },
        { n = "Гоша Рубчинский Base", i = 15056443139 },
        { n = "Гоша Рубчинский x Fila", i = 438195463 },
    },
    ["Epic"] = {
        { n = "1017 ALYX 9SM x Moncler Свитшот", i = 14307549017 },
        { n = "1017 ALYX 9SM Рубашка", i = 116739608201251 },
        { n = "1017 ALYX 9SM Свитшот", i = 12014837061 },
        { n = "1017 ALYX 9SM Свитшот Красный", i = 10253718453 },
        { n = "1017 ALYX 9SM Футболка Белая", i = 13607073567 },
        { n = "Acne Studios Jeans", i = 8425198358 },
        { n = "Acne Studios Oversized Hoodie", i = 6174845177 },
        { n = "AmiriKing", i = 73216590459166 },
        { n = "BAPE Dubai Camo Shark Белый", i = 79138012674866 },
        { n = "BAPE Hellstar", i = 15059936417 },
        { n = "BAPE Holographic Tiger Черная", i = 84803613886580 },
        { n = "BAPE Panda Фиолетовый камуфляж", i = 96225370149582 },
        { n = "BAPE Shark Фиолетовая", i = 120028188529902 },
        { n = "BAPE Tiger Colors Черный", i = 74566614556041 },
        { n = "BAPE Tiger Red", i = 2783959084 },
        { n = "BAPE Tiger Фиолетовый", i = 132534299493006 },
        { n = "BAPE x Stussy", i = 836376693 },
        { n = "BAPE Зеленый/Оранжевый Tiger Белый", i = 127813886164608 },
        { n = "Balenciaga Logo", i = 11386091941 },
        { n = "Balenciaga Logo Print Tee", i = 124231377168467 },
        { n = "Balenciaga Tiger", i = 88020456613700 },
        { n = "Bape Tiger Зеленый/Оранжевый", i = 107348845353432 },
        { n = "Burberry London", i = 14961358306 },
        { n = "CP.Company Blanc Майка", i = 74448709325820 },
        { n = "CP.Company DD Shell Noir", i = 95337445087298 },
        { n = "CP.Company Noir Default", i = 87883117918210 },
        { n = "CP.Company Orange Майка", i = 81270251381720 },
        { n = "Cav Empt Chemical Engineering", i = 3652598277 },
        { n = "Cav Empt Зип-Худи", i = 2944205656 },
        { n = "Cav Empt Свитшот Серый", i = 139626993726125 },
        { n = "Cav Empt Свитшот Черный v2", i = 132771012378737 },
        { n = "Chrome Hearts Blue", i = 15705156210 },
        { n = "Chrome Hearts Logo White", i = 14502536751 },
        { n = "Chrome Hearts Tee Black", i = 134619700442692 },
        { n = "Comme des Garcons Camo Футболка", i = 5575894980 },
        { n = "Comme des Garcons Лонгслив Белый-Черный", i = 5699364090 },
        { n = "Comme des Garcons Свитшот Серый", i = 11602203772 },
        { n = "Gallery Dept Лонгслив", i = 71091220191588 },
        { n = "Gallery Dept Спортивки Серые v2", i = 112068921354030 },
        { n = "Gallery Dept Футболка", i = 101869006032601 },
        { n = "Gallery Dept Футболка Белый", i = 13835053077 },
        { n = "Gallery Dept Футболка Зеленая", i = 101110457561961 },
        { n = "Gallery Dept Футболка Синяя", i = 125540636897982 },
        { n = "Gallery Dept Футболка Черная", i = 11725889271 },
        { n = "Goyard Джинсы", i = 1226570804 },
        { n = "Goyard Джинсы v2", i = 993568649 },
        { n = "Goyard Классическая Футболка", i = 907988303 },
        { n = "Goyard Классическая Футболка v2", i = 6131796962 },
        { n = "Gucci LOVE", i = 956388277 },
        { n = "Gucci Lamb", i = 5023083383 },
        { n = "Gucci Logo Tee", i = 2464334422 },
        { n = "Gucci Sweatshirt Tiger", i = 2672925839 },
        { n = "Gucci shorts x Blue Lubz", i = 5634486976 },
        { n = "HBA Aphex Свитшот", i = 16579558789 },
        { n = "HBA Face Свитшот", i = 101719618368646 },
        { n = "HBA Face Шорты", i = 18588053395 },
        { n = "HBA Зип-Худи", i = 18588070468 },
        { n = "HBA Морф", i = 16452154247 },
        { n = "LV Jeans", i = 15292591748 },
        { n = "LV Shirts", i = 135386999852550 },
        { n = "Maison Margiela Лонгслив Белая", i = 108337687172395 },
        { n = "Maison Margiela Лонгслив Черный", i = 138263043704514 },
        { n = "Maison Margiela Светлые Джинсы", i = 104326582321744 },
        { n = "Maison Margiela Свитер", i = 18270211852 },
        { n = "Moncler Big Logo", i = 11998504162 },
        { n = "Moncler Black Full Sleeve", i = 3163582983 },
        { n = "Moncler Black Jacket Alt", i = 5964807969 },
        { n = "Moncler Black Polo", i = 10793538519 },
        { n = "Moncler Classic Pants", i = 80212103951429 },
        { n = "Moncler Green Jacket", i = 6722978612 },
        { n = "Moncler Orange Jacket", i = 5960853118 },
        { n = "Moncler Tech Pants", i = 11382056477 },
        { n = "Moncler Vest Orange", i = 8162777342 },
        { n = "Moncler White Polo", i = 80707179561942 },
        { n = "Moncler Yellow Mini Puffer", i = 8171196077 },
        { n = "Moncler Yellow Puffer", i = 8162975494 },
        { n = "NeNet Свитшот", i = 129051289938686 },
        { n = "NeNet Свитшот Синий", i = 126688679972643 },
        { n = "NeNet Свитшот Черный", i = 124013704220310 },
        { n = "NeNet Футболка Белая v2", i = 83631847906705 },
        { n = "Nike Tech Blue", i = 11554264756 },
        { n = "Nike Tech Blue", i = 12757775222 },
        { n = "Off-White Белая Футболка", i = 111494454911134 },
        { n = "Off-White Синяя", i = 2744313464 },
        { n = "Off-White Черная", i = 4464224771 },
        { n = "Palace x Adidas", i = 114724377 },
        { n = "Palm Angels Bear", i = 7724732726 },
        { n = "Palm Angels Zip", i = 5973979386 },
        { n = "Palm Angels Zip Классик", i = 15161522231 },
        { n = "Palm Angels Zip Серая", i = 15616127684 },
        { n = "Palm Angels Футболка Bear", i = 12257396304 },
        { n = "Prada Cargo", i = 8425198358 },
        { n = "Prada Linea Rossa", i = 6174845177 },
        { n = "Racer WorldWide Свитер В Полоску", i = 8633623320 },
        { n = "Rick Drkshdw Pants", i = 12517077399 },
        { n = "Rick Owens DRKSHDW", i = 15422438906 },
        { n = "Rick Owens Джинсовка", i = 98599150857223 },
        { n = "Rick Owens Джинсовка Синяя", i = 77234120970244 },
        { n = "Rick Owens Джинсовка Черная", i = 136218865674437 },
        { n = "Rick Owens Джинсы Зип", i = 89501380293235 },
        { n = "Rick Owens Футболка", i = 82934586126898 },
        { n = "Rick Owens Штаны X Champion", i = 85545557857293 },
        { n = "Stone Island Gray Pants", i = 13781107752 },
        { n = "Stone Island Termo Longsleave", i = 13948309746 },
        { n = "Stussy World Tour", i = 114724377 },
        { n = "Supreme x ASAP", i = 431730384 },
        { n = "Supreme Свитшот", i = 3463183841 },
        { n = "Vetements Vamp Футболка", i = 86185820213136 },
        { n = "Vetements Лонгслив", i = 95060430454867 },
        { n = "Vetements Лонгслив Темно-Синий", i = 99150978070886 },
        { n = "Vetements Лонгслив Черный", i = 91606294899206 },
        { n = "Vetements Худи", i = 18983373539 },
        { n = "Vetements Худи v2", i = 107557100704001 },
        { n = "Vetements Худи Черное", i = 81560105275312 },
        { n = "Yohji Yamamoto Свитшот", i = 137788979820718 },
        { n = "Yohji Yamamoto Свитшот Зеленый", i = 7023449511 },
        { n = "Yohji Yamamoto Спортивная Куртка Poison", i = 14606133245 },
        { n = "Гоша Рубчинский Flag", i = 5809785846 },
        { n = "Гоша Рубчинский Белая Футболка", i = 1435177629 },
        { n = "Гоша Рубчинский Футбол", i = 4909082176 },
        { n = "Золотая цепь", i = 12001043365 },
    },
    ["Legendary"] = {
        { n = "1017 ALYX 9SM Куртка Зип", i = 16949566103 },
        { n = "Acne Studios Jacket", i = 114724377 },
        { n = "BAPE Full Zip Shark", i = 1329266704 },
        { n = "BAPE Red Panda", i = 85037105009809 },
        { n = "BAPE Tiger Camo", i = 3052304894 },
        { n = "BAPE Tiger Штаны Красные", i = 137022318888712 },
        { n = "BAPE Tiger Штаны Синие", i = 72015381801594 },
        { n = "BAPE Tiger Штаны Темно-Зелен", i = 131922684973046 },
        { n = "BAPE Tiger Штаны Фиолетовые", i = 99313817373559 },
        { n = "BAPE Yellow Camo Shark", i = 4843433327 },
        { n = "Balenciaga 3B Sports Deutsche Bahn", i = 137408844484403 },
        { n = "Balenciaga Blue Skater Sweatpants", i = 124975585838444 },
        { n = "Balenciaga Campaign", i = 10890916980 },
        { n = "Balenciaga Distressed Hoodie", i = 13676876569 },
        { n = "Balenciaga GAMER", i = 12774350601 },
        { n = "Balenciaga GAMER Bomber", i = 17750429143 },
        { n = "Balenciaga GAMER Denim Jacket", i = 16648632315 },
        { n = "Balenciaga Gamer Jeans", i = 14072460187 },
        { n = "Balenciaga Grey Jumper", i = 3785693796 },
        { n = "Balenciaga Grey Skater Sweatpants", i = 93824635464666 },
        { n = "Balenciaga Hoodie Alien", i = 86463016923018 },
        { n = "Balenciaga Jean Jacket X Gosha", i = 5314403333 },
        { n = "Balenciaga Jeans", i = 122599601118964 },
        { n = "Balenciaga Leather", i = 84116395504704 },
        { n = "Balenciaga Logo Print Hoodie Blue", i = 15825720946 },
        { n = "Balenciaga NASA", i = 97665782669251 },
        { n = "Balenciaga Nasa Bomber Jacket", i = 82170977556685 },
        { n = "Balenciaga Paris", i = 125248485368695 },
        { n = "Balenciaga Paris Moon Sweater", i = 4590342423 },
        { n = "Balenciaga Red Crimson Windbreaker", i = 133873637543203 },
        { n = "Balenciaga Red Skater Sweatpants", i = 15732426819 },
        { n = "Balenciaga Resort 2023", i = 16648534764 },
        { n = "Balenciaga Reversible Bomber Jacket", i = 18813584989 },
        { n = "Balenciaga Runway", i = 16662225397 },
        { n = "Balenciaga Runway Polo Hoodie", i = 85720763562074 },
        { n = "Balenciaga Speed Runner Hoodie", i = 15453420630 },
        { n = "Balenciaga Tokyo Cut", i = 98869180278083 },
        { n = "Balenciaga Under Armor", i = 109107120274465 },
        { n = "Balenciaga X Under Armor", i = 17747885612 },
        { n = "Balenciaga x Fortnite", i = 102510983142980 },
        { n = "Balenciaga x Gucci", i = 3138759121 },
        { n = "Bape x Supreme", i = 1103783724 },
        { n = "Burberry x Bape", i = 13868676222 },
        { n = "CP.Company Black Windbreaker", i = 113247621156859 },
        { n = "CP.Company Blue Puffer Jacket", i = 82077729005226 },
        { n = "CP.Company Carbone Noir", i = 134908184079208 },
        { n = "CP.Company Cardigan Black", i = 99737839478071 },
        { n = "CP.Company Crewneck", i = 15783597851 },
        { n = "CP.Company DD Shell Beige", i = 139627508845654 },
        { n = "CP.Company DD Shell Green", i = 100997096188512 },
        { n = "CP.Company DD Shell Red", i = 78185107533537 },
        { n = "CP.Company Navy Windbreaker", i = 131336649441063 },
        { n = "CP.Company Orange Pants", i = 16974632408 },
        { n = "CP.Company Teal Jumper", i = 97526151621254 },
        { n = "Cav Empt Not Impossible Crewneck", i = 322189906 },
        { n = "Cav Empt Бомбер", i = 297942903 },
        { n = "Cav Empt Свитшот FW 17", i = 914784455 },
        { n = "Cav Empt Свитшот Joker", i = 18280893525 },
        { n = "Cav Empt Свитшот MD Document Crewneck", i = 1002344605 },
        { n = "Cav Empt Свитшот Желтый Symptom Heavy", i = 3244925440 },
        { n = "Cav Empt Футболка Spring Delivery", i = 2887711548 },
        { n = "Chrome Hearts Basic Tee", i = 16582495088 },
        { n = "Chrome Hearts Black Pink LS", i = 90915822594460 },
        { n = "Chrome Hearts Blue Jeans", i = 7136404058 },
        { n = "Chrome Hearts Blue Jeans Chrome", i = 7902431231 },
        { n = "Chrome Hearts Camo Matty", i = 72762590768448 },
        { n = "Chrome Hearts Cross Patch Dog", i = 90412503682792 },
        { n = "Chrome Hearts Cyan", i = 14127820316 },
        { n = "Chrome Hearts Cyan Alt", i = 6447552174 },
        { n = "Chrome Hearts Gray Denim Jeans", i = 16733661152 },
        { n = "Chrome Hearts Gray Sweater", i = 6678207951 },
        { n = "Chrome Hearts Grey Jeans", i = 122714934882673 },
        { n = "Chrome Hearts Grunge", i = 18968804462 },
        { n = "Chrome Hearts Jeans", i = 15696366780 },
        { n = "Chrome Hearts Matty Boy Space", i = 18428381654 },
        { n = "Chrome Hearts Matty Boy Sweatshirt", i = 126863028392369 },
        { n = "Chrome Hearts Miami Hoodie", i = 12852126150 },
        { n = "Chrome Hearts Multi Color Cargos", i = 16430470279 },
        { n = "Chrome Hearts Multi-Colour Hoodie", i = 16919855258 },
        { n = "Chrome Hearts Orange Pants", i = 7548737358 },
        { n = "Chrome Hearts Orange Sweater", i = 7381767636 },
        { n = "Chrome Hearts Pink-Black Jeans", i = 10946069869 },
        { n = "Chrome Hearts Rainbow Cross", i = 10322816406 },
        { n = "Chrome Hearts Rainbow Sweatshirt", i = 116987323218059 },
        { n = "Chrome Hearts Red & Green Sweater", i = 77430172245334 },
        { n = "Chrome Hearts Red And Blue", i = 9026168986 },
        { n = "Chrome Hearts Red Jeans", i = 15167783027 },
        { n = "Chrome Hearts Red Shirt", i = 99324171797960 },
        { n = "Chrome Hearts Rolling Stones", i = 85305185315542 },
        { n = "Chrome Hearts Ryft Davis", i = 79285824675024 },
        { n = "Chrome Hearts Sweats Black", i = 92049531048374 },
        { n = "Chrome Hearts T Logo USA Hoodie", i = 96585015209179 },
        { n = "Chrome Hearts Tee", i = 73657715280895 },
        { n = "Chrome Hearts X LV Jeans", i = 7248675954 },
        { n = "Chrome Hearts Yellow Hoodie", i = 11454813848 },
        { n = "Chrome Hearts Zip Up Black", i = 6198234501 },
        { n = "Chrome Hearts Zip Up Hoodie Black", i = 18400219191 },
        { n = "Chrome Hearts x LV Jacket", i = 7369775838 },
        { n = "Chrome Hearts x Off-White Hoodie", i = 5944585429 },
        { n = "Comme des Garcons Play Футболка Черная", i = 81585264094038 },
        { n = "Comme des Garcons X Rolling Stones Футболка", i = 116168634401177 },
        { n = "Comme des Garcons Лонгслив Белый-Синий", i = 962194504 },
        { n = "Comme des Garcons Рубашка", i = 123772691907841 },
        { n = "Comme des Garcons Синий Зип-Худи", i = 1074658737 },
        { n = "Comme des Garcons Футболка Camo Love", i = 8128676575 },
        { n = "Comme des Garcons Футболка Love Белая", i = 2098915079 },
        { n = "Comme des Garcons Футболка Белый-Красный", i = 1079296706 },
        { n = "Comme des Garcons Футболка Черная", i = 15121388536 },
        { n = "Dior Джинсы", i = 139013853108228 },
        { n = "Dior Зип", i = 10371714775 },
        { n = "Dior Зип Худи", i = 85583075418361 },
        { n = "Dior Лонгслив", i = 101488585369119 },
        { n = "Dior Свитер", i = 118344538644973 },
        { n = "Dior Свитшот", i = 18147277043 },
        { n = "Dior Футболка", i = 18370037060 },
        { n = "Dior Худи", i = 122763783050786 },
        { n = "Dior Шорты", i = 90433833342790 },
        { n = "ERD Archive Trousers", i = 18391376326 },
        { n = "ERD Archive Лонгслив", i = 122273528955293 },
        { n = "ERD Archive Худи Красный", i = 98881995294054 },
        { n = "ERD Bully Худи", i = 128216714278616 },
        { n = "ERD Destroyed Hoodie", i = 124798507529638 },
        { n = "ERD Distressed Zip Jacket", i = 12001043365 },
        { n = "ERD Skull Denim Jacket", i = 114724377 },
        { n = "ERD Vintage Washed Hoodie", i = 6384915788 },
        { n = "ERD x Rick Owens Джинсы", i = 74573745510706 },
        { n = "ERD Белый Лонг", i = 105198371812252 },
        { n = "ERD Голубой Лонгслив", i = 102885674981104 },
        { n = "ERD Красная Джинсовка", i = 120196252098729 },
        { n = "ERD Красные Джинсы", i = 102019726797995 },
        { n = "ERD Лонгслив", i = 76738452087604 },
        { n = "ERD Потертые Джинсы v1", i = 137773512709519 },
        { n = "ERD Потертые Джинсы v2", i = 83641705983017 },
        { n = "Femboy свитшот", i = 105804105689619 },
        { n = "Femboy штаны", i = 72870106856318 },
        { n = "Gallery Dept Lanvin", i = 87630874548849 },
        { n = "Gallery Dept Красный Зип-Худи", i = 86921710360798 },
        { n = "Gallery Dept Свитшот Коричневый", i = 118666889439649 },
        { n = "Gallery Dept Свитшот Синий", i = 79423109019674 },
        { n = "Gallery Dept Футболка Шамана", i = 100168311309116 },
        { n = "Gallery Dept Худи Зеленое", i = 140022990256816 },
        { n = "Goyard Зеленая Футболка", i = 6763195401 },
        { n = "Gucci Blind For Love Hoodie", i = 126913643075376 },
        { n = "Gucci Coco Capitan", i = 1081054870 },
        { n = "Gucci Polo Shake", i = 5469366412 },
        { n = "Gucci Star Sweater", i = 6181344251 },
        { n = "Gucci Sweatshirt Planet", i = 1083553649 },
        { n = "Gucci Tiger Hoodie", i = 1518645608 },
        { n = "Gucci Tiger Tracksuit", i = 5680301087 },
        { n = "Gucci X Tee", i = 3370349046 },
        { n = "Gucci x LV Jacket", i = 2109554081 },
        { n = "Gutta Opiy Shirt", i = 75621017852847 },
        { n = "Gutta Raiders Camo shirt", i = 86664943903751 },
        { n = "Gutta Snake Year", i = 70895461143874 },
        { n = "HBA Creepy Свитшот", i = 93422277147402 },
        { n = "HBA Рубашка", i = 71222633992816 },
        { n = "Haliky Gang Bears", i = 6676412081 },
        { n = "Haliky Худи", i = 6004029876 },
        { n = "LV Balmains", i = 967030317 },
        { n = "LV x TNF", i = 5836356644 },
        { n = "Maison Margiela Женская Меховая Куртка", i = 137990594447175 },
        { n = "Maison Margiela Зеленый Лонгслив", i = 73388686842934 },
        { n = "Maison Margiela Куртка из Ремней", i = 122468912421457 },
        { n = "Maison Margiela Рубашка", i = 135517402543302 },
        { n = "Maison Margiela Темные Джинсы", i = 81765716375958 },
        { n = "Moncler Black Jacket", i = 9375216039 },
        { n = "Moncler Black Tapered Tracksuit", i = 15338842173 },
        { n = "Moncler Black Tracksuit Bottom", i = 15338842173 },
        { n = "Moncler Blue Coat", i = 9384199616 },
        { n = "Moncler Blue Zip-Up", i = 6505230129 },
        { n = "Moncler Gray Sweater", i = 5341316038 },
        { n = "Moncler Gray Vest", i = 6142390595 },
        { n = "Moncler Green Zip-up", i = 6505230940 },
        { n = "Moncler Maroon Jacket", i = 6787299892 },
        { n = "Moncler Multi Colored Jacket", i = 3689506876 },
        { n = "Moncler Parka Coat", i = 8446274549 },
        { n = "Moncler Puffer Logo", i = 6488495469 },
        { n = "Moncler Purple Bubble Jacket", i = 6455445003 },
        { n = "Moncler Red Puffer", i = 6455447834 },
        { n = "Moncler Red Tracksuit", i = 6488509571 },
        { n = "Moncler Red Tracksuit Bottom", i = 6488509571 },
        { n = "Moncler Spider", i = 11674658234 },
        { n = "Moncler Striped Technical", i = 5029449227 },
        { n = "Moncler TriColor Windbreaker", i = 4831711976 },
        { n = "Moncler Vest Classic", i = 6488586232 },
        { n = "Moncler X PA Blue Tracksuit Bot", i = 12636365073 },
        { n = "Moncler X PA Blue Tracksuit Top", i = 12636365073 },
        { n = "Moncler X PA FG Tracksuit Bot", i = 12621049095 },
        { n = "Moncler X PA Forest Green Bot", i = 12621050787 },
        { n = "Moncler X PA Forest Green Top", i = 12621049095 },
        { n = "Moncler X PA Trackpants", i = 5459824253 },
        { n = "Moncler x PA Fiber Light Puffer", i = 13429337035 },
        { n = "Moncler x PA Kelsey Puffer Blue", i = 11484662835 },
        { n = "Moncler x PA Puffer Jacket", i = 14396989921 },
        { n = "Moncler x Palm Angels Black", i = 13876237691 },
        { n = "Moncler x Palm Angels Jacket", i = 8165648360 },
        { n = "Moncler x Palm Angels Red Zip", i = 5964876806 },
        { n = "NeNet Футболка Серая", i = 118840925833484 },
        { n = "NeNet Футболка Фиолетовая", i = 9930373240 },
        { n = "Nike Tech Dark Blue", i = 15501893721 },
        { n = "Nike Tech Dark Light Blue", i = 8801995627 },
        { n = "Nike Tech Windrunner Black", i = 7397565263 },
        { n = "Number(N)ine Shield Серое Худи", i = 105478169140045 },
        { n = "Number(N)ine Shield Черное Худи", i = 81895753471926 },
        { n = "Number(N)ine Zip Jacket", i = 81231921426493 },
        { n = "Number(N)ine Винтажная Футболка", i = 6384915788 },
        { n = "Number(N)ine Коричневое Худи", i = 18632819241 },
        { n = "Number(N)ine Красный Лонгслив", i = 128716647842609 },
        { n = "Number(N)ine Потертые Джинсы", i = 102839033215257 },
        { n = "Number(N)ine Серая Zip Jacket", i = 99950858190570 },
        { n = "Number(N)ine Серое Худи", i = 18632881209 },
        { n = "Number(N)ine Серый Лонгслив", i = 17573405272 },
        { n = "Number(N)ine Футболка", i = 14885532636 },
        { n = "Number(N)ine Черные Джинсы", i = 18323948106 },
        { n = "Number(N)ine Черный Лонгслив", i = 12274864979 },
        { n = "Off-White Camo", i = 1213373791 },
        { n = "Off-White MonoLisa", i = 2474144253 },
        { n = "Off-White Virgil Abloh Красный", i = 6071739662 },
        { n = "Off-White Бежевая", i = 590131471 },
        { n = "Off-White Белая Футболка v2", i = 4809072541 },
        { n = "Off-White Белая Футболка v3", i = 138024345748614 },
        { n = "Off-White Зеленый", i = 3224293759 },
        { n = "Off-White Свитер", i = 2518177916 },
        { n = "Off-White Черная Футболка v2", i = 15084872864 },
        { n = "Palm Angels Flame", i = 5611331869 },
        { n = "Palm Angels Zip Кислотный", i = 7205233886 },
        { n = "Palm Angels Zip Красная", i = 126190832806951 },
        { n = "Palm Angels Zip Фиолетовый", i = 89385145596759 },
        { n = "Palm Angels Zip Цветок", i = 6501833600 },
        { n = "Palm Angels x Raf Blue Red", i = 88741221455613 },
        { n = "Palm Angels Свитшот Голубой", i = 6274614487 },
        { n = "Palm Angels Фиолетовые", i = 9084664827 },
        { n = "Palm Angels Футболка v2", i = 127026922296813 },
        { n = "Palm Angels Футболка v3", i = 11511640247 },
        { n = "Polo Burberry", i = 15903662503 },
        { n = "Prada Re-Nylon Jacket", i = 1352050969 },
        { n = "Racer WorldWide Куртка из Овечьи Шкуры", i = 99497707297997 },
        { n = "Racer WorldWide Леопардовая Зип-Худи", i = 118245234493513 },
        { n = "Racer WorldWide ЛонгСлив Катя Кищук", i = 97197585182330 },
        { n = "Racer Worldwide Металлик Спортивные Штаны", i = 75548914998494 },
        { n = "Racer Worldwide Светлые Джинсы", i = 124377088956183 },
        { n = "Racer Worldwide Спортивные Штаны", i = 82685608298333 },
        { n = "Racer Worldwide Трансформ Зип Джинсы", i = 138030819896058 },
        { n = "Raf Simons 2-CB GHB Patchwork", i = 120612391944120 },
        { n = "Raf Simons AW01 Runway", i = 10443560347 },
        { n = "Raf Simons Antei Purple", i = 116642119535875 },
        { n = "Raf Simons Black Christiane F AW18", i = 91498176431445 },
        { n = "Raf Simons Brian Calvin Beer Girl", i = 75216977300015 },
        { n = "Raf Simons Brian Calvin Beer Girl Tee", i = 122313792956641 },
        { n = "Raf Simons Christiane F Tees AW18", i = 125655994023355 },
        { n = "Raf Simons Cylon 21 Red", i = 75354435184240 },
        { n = "Raf Simons Hoodie", i = 15570425245 },
        { n = "Raf Simons LSD White", i = 125293782853552 },
        { n = "Raf Simons Ozweego 2 Blue Red Lucora", i = 70728690346102 },
        { n = "Raf Simons Ozweego 2 Gray Green", i = 105222831634134 },
        { n = "Raf Simons Ozweego 2 Khaki Gold", i = 124039750585318 },
        { n = "Raf Simons Ozweego 2 Yellow Navy", i = 84478752542723 },
        { n = "Raf Simons Ozweego 3 Black Scarlett", i = 112685667527061 },
        { n = "Raf Simons Ozweego 3 Bunny Cream", i = 72101896533425 },
        { n = "Raf Simons Ozweego Metallic Pink", i = 87554525526000 },
        { n = "Raf Simons Ozweego Replicant Brown", i = 131686044597910 },
        { n = "Raf Simons Ozweego Replicant Green", i = 109462627025831 },
        { n = "Raf Simons Pharaxus Green Black", i = 101604148293803 },
        { n = "Raf Simons Replicant Черный", i = 131319439176543 },
        { n = "Raf Simons SS10 Sterling Ruby Shirt", i = 95423048146621 },
        { n = "Raf Simons Ultrasceptre Black", i = 76698897803837 },
        { n = "Raf Simons Бомбер Белый", i = 86995497093030 },
        { n = "Raf Simons Красный Лонгслив", i = 125538194046026 },
        { n = "Raf Simons Красный Лонгслив v2", i = 140534031809179 },
        { n = "Raf Simons Поло Красное", i = 76516442021518 },
        { n = "Raf Simons Худи Серый", i = 102589072483955 },
        { n = "Rick Leather", i = 101535348409637 },
        { n = "Rick Owens Runway", i = 8502567669 },
        { n = "Rick Owens x Moncler", i = 8573407398 },
        { n = "Rick Owens Джинсовка Желтая", i = 130104280419383 },
        { n = "Rick Owens Джинсовка Красная", i = 71424043928165 },
        { n = "Rick Owens Джинсы Розовые", i = 84825703583648 },
        { n = "Rick Owens Зип Джинсовка Розовая", i = 121618494628389 },
        { n = "Rick Owens Футболка Vamp", i = 83255075167663 },
        { n = "SS04 Yohji Yamamoto Y-3 x 3S Spotted Джинсы", i = 71399636217265 },
        { n = "Stone Island Big Loom Camo-Tc", i = 8631671234 },
        { n = "Stone Island Big Loom Camo-Tc", i = 8631708424 },
        { n = "Stone Island Comfort Tech Blue", i = 118064352416891 },
        { n = "Stone Island Comfort Tech Purple", i = 119767338320263 },
        { n = "Stone Island Comfort Tech Red", i = 120903225671360 },
        { n = "Stone Island Desert Camo", i = 8462301101 },
        { n = "Stone Island Desert Camo", i = 8631687945 },
        { n = "Stone Island Desert Camo Jacket", i = 8631651981 },
        { n = "Stone Island Navy", i = 831537199 },
        { n = "Stone Island Off Day Blue", i = 117161695009647 },
        { n = "Stone Island Orange", i = 14840856758 },
        { n = "Stone Island Pink", i = 14984408119 },
        { n = "Stone Island Purple Skin Touch", i = 13779001426 },
        { n = "Stone Island Red Hoodie Off Dye", i = 97856390601463 },
        { n = "Stone Island Reflective", i = 139421353405484 },
        { n = "Stone Island Shadow Tiger Camo", i = 132959748946564 },
        { n = "Stone Island Skin Touch Purple", i = 13778721268 },
        { n = "Stone Island Turtleneck", i = 12624379885 },
        { n = "Stone Island Urban Black Yellow", i = 7249098507 },
        { n = "Stone Island WATRO-TC", i = 8631779037 },
        { n = "Stone Island WATRO-TC Jacket", i = 8631755151 },
        { n = "Stone Island Zip-Hoodie", i = 87509417534862 },
        { n = "Stone Island x Supreme", i = 13876916079 },
        { n = "Stone Island x Supreme", i = 84913974138865 },
        { n = "Stone Island x Supreme White", i = 108047896837515 },
        { n = "Stone Island x Supreme Белые", i = 139017627542362 },
        { n = "Supreme x BB", i = 13444831702 },
        { n = "Supreme x Bape x LV", i = 1565502112 },
        { n = "Supreme x LV", i = 5226567379 },
        { n = "TH Hoodie X Balenciaga x RAF", i = 2074367265 },
        { n = "Vetements 204 Hyoma Raf Reconstructed", i = 75624653597148 },
        { n = "Vetements Anarchy", i = 17508312490 },
        { n = "Vetements Antwerp Красный", i = 18720565335 },
        { n = "Vetements Antwerp Темно-Красное", i = 4552458072 },
        { n = "Vetements Antwerpen Белая v1", i = 124697147814478 },
        { n = "Vetements Antwerpen Белая v2", i = 15564674144 },
        { n = "Vetements Clothing Green", i = 77220484371723 },
        { n = "Vetements Бомбер", i = 134508752165617 },
        { n = "Vetements Бомбер Зеленый", i = 89790335131378 },
        { n = "Vetements Бомбер Красный", i = 117766762488194 },
        { n = "Vetements Бомбер Полиция", i = 11290616980 },
        { n = "Vetements Бомбер Тёмно-Зеленый", i = 77439910826532 },
        { n = "Vetements Джинсы Потертые", i = 87891411586632 },
        { n = "Vetements Зип-Худи", i = 128389783148999 },
        { n = "Vetements Синие-Джинсы Потертые", i = 126970846706113 },
        { n = "Vetements Спортивки Белые", i = 132566833184808 },
        { n = "Vetements Спортивки Черный", i = 80693415563613 },
        { n = "Vetements Футболка Зеленая Polizei", i = 90919421530654 },
        { n = "Vetements Футболка Оранжевая", i = 80547880319610 },
        { n = "Yohji Yamamoto AW 2001 Godzilla Свитшот", i = 4794620897 },
        { n = "Yohji Yamamoto Heroes Leather Байкерская Куртка", i = 4895301337 },
        { n = "Yohji Yamamoto J-PT Иллюстрация", i = 129487569430492 },
        { n = "Yohji Yamamoto Project Футболка", i = 89357762722807 },
        { n = "Yohji Yamamoto Rei Ayanami Evangelion Button up", i = 14484000414 },
        { n = "Yohji Yamamoto Ys for Men AW2001 Godzilla", i = 6046174032 },
        { n = "Yohji Yamamoto Брюки", i = 18606916311 },
        { n = "Yohji Yamamoto Зеленая Куртка", i = 115386784245524 },
        { n = "Yohji Yamamoto Куртка Красная", i = 132752004376816 },
        { n = "Yohji Yamamoto Куртка Темно-Синяя", i = 90420982954859 },
        { n = "Yohji Yamamoto Свитшот Avant Garde", i = 86114857882709 },
        { n = "Yohji Yamamoto Свитшот Skull", i = 5166805206 },
        { n = "Yohji Yamamoto Свитшот Smoke", i = 8826223539 },
        { n = "Yohji Yamamoto Свитшот Spider Knit", i = 10515393675 },
        { n = "Yohji Yamamoto Свитшот Supreme", i = 130582847343989 },
        { n = "Yohji Yamamoto Свитшот Кожанка", i = 131596879156451 },
        { n = "Zapatillas Gucci X Amiri", i = 134853942496739 },
        { n = "redvetements", i = 75749441655962 },
        { n = "Гоша Рубчинский Camo Спаси Сохрани", i = 576444465 },
        { n = "Гоша Рубчинский Fila Yellow LS", i = 87503337904060 },
        { n = "Гоша Рубчинский X Kappa Свитер", i = 15311273900 },
        { n = "Гоша Рубчинский X Thrasher", i = 436720176 },
        { n = "Гоша Рубчинский Zip Красный/Синий", i = 4996937439 },
        { n = "Гоша Рубчинский x Kappa", i = 1824185908 },
        { n = "Гоша Рубчинский x Kappa", i = 884721414 },
        { n = "Гоша Рубчинский x Kappa Винтаж", i = 1162019947 },
        { n = "Гоша Рубчинский x Rassvet", i = 15706847548 },
        { n = "Гоша Рубчинский Вдруг Друг", i = 107248336623941 },
        { n = "Гоша Рубчинский Вдруг Красный", i = 2118764687 },
        { n = "Гоша Рубчинский Враг Свитер Черный", i = 5487023113 },
        { n = "Гоша Рубчинский Гибридный", i = 14578854678 },
        { n = "Гоша Рубчинский Зеленый Свитер", i = 772695241 },
        { n = "Гоша Рубчинский Рождест", i = 11796928325 },
        { n = "Гоша Рубчинский Рождественский", i = 5972477579 },
        { n = "Гоша Рубчинский Свитер Зелёный", i = 5549063618 },
        { n = "Гоша Рубчинский Свитер Синий", i = 9545499629 },
        { n = "Гоша Рубчинский Спорт Куртка Russian", i = 607550981 },
        { n = "Гоша Рубчинский Флаги", i = 98305906232207 },
        { n = "Гоша Рубчинский Худи ColorBrick", i = 560325377 },
        { n = "Яндекс Доставка Футболка", i = 18662896578 },
        { n = "пиджак чигура", i = 7798271981 },
        { n = "штаны чигура", i = 7798302571 },
    },
}


local SHOP_CATALOG_BY_NAME_LOWER = {}

local function initShopCatalogIndex()
    if not SHOP_CATALOG or not SHOP_CATALOG.byName then
        return
    end
    table.clear(SHOP_CATALOG_BY_NAME_LOWER)
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
    adminDelay = 2.5,
    remoteDelay = 0.35,
    jitterMax = 0.4,
    moneyChunk = 25000,
    walkSpeed = 16,
    jumpPower = 50,
}

local RemoteQueue = {}
local RemoteQueueBusy = false
local lastAdminCall = 0

local function acWait(base)
    if not AC.enabled or not AC.stealthRemotes then
        return
    end
    local delay = base or AC.remoteDelay
    if AC.jitterMax > 0 then
        delay += math.random() * AC.jitterMax
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

local function getAllAdminCommands()
    local cmds = {}
    for _, folderName in ipairs({ "AdminRemotes", "BarigaRemotes", "Bindables" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        local cmd = folder and folder:FindFirstChild("AdminCommand")
        if cmd and cmd:IsA("RemoteFunction") then
            table.insert(cmds, cmd)
        end
    end
    return cmds
end

local function getEventCommand()
    for _, folderName in ipairs({ "AdminRemotes", "BarigaRemotes" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        local ev = folder and folder:FindFirstChild("EventCommand")
        if ev and ev:IsA("RemoteFunction") then
            return ev
        end
    end
    return nil
end

local function invokeAdminOn(cmd, command, payload)
    if AC.enabled and AC.stealthRemotes then
        local gap = AC.adminDelay - (tick() - lastAdminCall)
        if gap > 0 then
            task.wait(gap)
        end
    end
    local ok, result = pcall(function()
        return safeRemoteCall(cmd, command, payload or {})
    end)
    lastAdminCall = tick()
    return ok, result
end

local function invokeAdmin(command, payload)
    local cmds = getAllAdminCommands()
    if #cmds == 0 then
        return false, "AdminCommand не найден"
    end
    local lastErr
    local lastRes
    for _, cmd in ipairs(cmds) do
        local ok, result = invokeAdminOn(cmd, command, payload)
        lastRes = result
        if ok then
            if type(result) == "table" then
                if result.error then
                    lastErr = result.error
                elseif result.success == false then
                    lastErr = result.message or "denied"
                else
                    return true, result
                end
            else
                return true, result
            end
        else
            lastErr = tostring(result)
        end
    end
    if lastRes ~= nil then
        return true, lastRes
    end
    return false, lastErr or "admin fail"
end

local function invokeEventAdmin(command, payload)
    local ev = getEventCommand()
    if not ev then
        return false, "EventCommand нет"
    end
    local ok, result = pcall(function()
        return safeRemoteCall(ev, command, payload or {})
    end)
    return ok, result
end

local function getAllEventCommands()
    local list = {}
    for _, folderName in ipairs({ "AdminRemotes", "BarigaRemotes", "Bindables" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        local ev = folder and folder:FindFirstChild("EventCommand")
        if ev and ev:IsA("RemoteFunction") then
            table.insert(list, { folder = folderName, remote = ev })
        end
    end
    return list
end

local function getAllGeneratePromoRemotes()
    local list = {}
    for _, folderName in ipairs({ "AdminRemotes", "BarigaRemotes", "Bindables" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        local gen = folder and folder:FindFirstChild("GeneratePromoCodes")
        if gen and gen:IsA("RemoteFunction") then
            table.insert(list, { folder = folderName, remote = gen })
        end
    end
    return list
end

local function getAllAdminChecks()
    local list = {}
    for _, folderName in ipairs({ "AdminRemotes", "BarigaRemotes", "Bindables" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        local chk = folder and folder:FindFirstChild("AdminCheck")
        if chk and chk:IsA("RemoteFunction") then
            table.insert(list, { folder = folderName, remote = chk })
        end
    end
    return list
end

local function summarizeAdminResult(result)
    if result == nil then
        return "nil"
    end
    if type(result) ~= "table" then
        return tostring(result)
    end
    if result.success == true then
        return "SUCCESS"
    end
    if result.givenTo or result.itemName then
        return "GAVE:" .. tostring(result.itemName or result.givenTo)
    end
    if result.error then
        return "err:" .. tostring(result.error)
    end
    if result.message then
        return tostring(result.message)
    end
    if result.isAdmin ~= nil then
        return "isAdmin=" .. tostring(result.isAdmin) .. " role=" .. tostring(result.role or "?")
    end
    if result.codes and #result.codes > 0 then
        return "codes=" .. #result.codes
    end
    return "table"
end

local function probeAdminVector(hits, label, command, payload)
    local ok, res = invokeAdmin(command, payload)
    table.insert(hits, label .. "=" .. summarizeAdminResult(res))
    acWait(0.15)
    return ok, res
end

local function probeRemoteFn(hits, label, remote, ...)
    if not remote then
        table.insert(hits, label .. "=no remote")
        return false, nil
    end
    local args = { ... }
    local ok, res = pcall(function()
        return safeRemoteCall(remote, table.unpack(args))
    end)
    table.insert(hits, label .. "=" .. (ok and summarizeAdminResult(res) or tostring(res)))
    acWait(0.15)
    return ok, res
end

local function installClientAdminSpoof()
    State.adminInfo = {
        isAdmin = true,
        role = "QA_ClientSpoof",
        permissions = { "giveMoney", "giveItem", "all" },
    }
    notify("Whitelist QA", "Клиентский isAdmin=true (только UI, сервер не обманут)", 6)
end

local function runWhitelistBypassProbe()
    if State.whitelistProbeRunning then
        return "Уже выполняется..."
    end
    State.whitelistProbeRunning = true
    local hits = { "=== WHITELIST BYPASS PROBE ===" }
    local playerName = LocalPlayer.Name
    local userId = LocalPlayer.UserId
    local amount = math.min(State.moneyAmount or 100000, AC.moneyChunk)
    local beforeMoney = getLeaderMoney()
    local beforeInv = #State.inventory

    -- 1) Сбор информации
    local okInfo, info = invokeAdmin("getAdminInfo", {})
    State.adminInfo = type(info) == "table" and info or State.adminInfo
    table.insert(hits, "getAdminInfo=" .. summarizeAdminResult(info))

    for i, cmd in ipairs(getAllAdminCommands()) do
        local ok, res = invokeAdminOn(cmd, "getAdminInfo", {})
        table.insert(hits, ("AdminCmd#%d %s getAdminInfo="):format(i, cmd.Parent.Name) .. summarizeAdminResult(res))
        acWait(0.1)
    end

    for i, entry in ipairs(getAllAdminChecks()) do
        local payloads = {
            {},
            { userId = userId },
            { playerName = playerName },
            { isAdmin = true },
            { userId = userId, isAdmin = true, role = "Owner" },
            playerName,
            userId,
        }
        for j, pl in ipairs(payloads) do
            probeRemoteFn(hits, ("AdminCheck#%d.%d %s"):format(i, j, entry.folder), entry.remote, pl)
        end
    end

    local room = ReplicatedStorage:FindFirstChild("RoomEvents")
    if room then
        probeRemoteFn(hits, "Room.RequestData", room:FindFirstChild("RequestData"))
        probeRemoteFn(hits, "Room.GetPlayerList", room:FindFirstChild("GetPlayerList"))
        probeRemoteFn(hits, "Room.GetBalance", room:FindFirstChild("GetBalance"))
        local addWl = room:FindFirstChild("AddToWhitelist")
        if addWl then
            for _, arg in ipairs({ playerName, tostring(userId), userId, LocalPlayer }) do
                probeRemoteFn(hits, "Room.AddWL", addWl, arg)
            end
        end
    end

    -- 2) EventCommand / GeneratePromo на всех папках
    local eventCmds = {
        "getEventStatus",
        "giveMoney",
        "giveItem",
        "getAdminInfo",
        "__ping__",
        "cloneAllToAdmin",
    }
    for _, entry in ipairs(getAllEventCommands()) do
        for _, cmd in ipairs(eventCmds) do
            local payload = {}
            if cmd == "giveMoney" then
                payload = { playerName = playerName, amount = amount }
            elseif cmd == "giveItem" then
                payload = { playerName = playerName, itemData = { name = "Test", rarity = "Common" } }
            end
            probeRemoteFn(hits, ("Event.%s %s:%s"):format(entry.folder, cmd, ""), entry.remote, cmd, payload)
        end
        probeRemoteFn(hits, "Event." .. entry.folder .. ":giveMoney#userId", entry.remote, "giveMoney", {
            userId = userId,
            amount = amount,
        })
        probeRemoteFn(hits, "Event." .. entry.folder .. ":nested", entry.remote, {
            command = "giveMoney",
            playerName = playerName,
            amount = amount,
        })
    end

    for _, entry in ipairs(getAllGeneratePromoRemotes()) do
        probeRemoteFn(hits, "PromoGen." .. entry.folder, entry.remote, 1)
        probeRemoteFn(hits, "PromoGen." .. entry.folder .. "#500", entry.remote, 500)
    end

    -- 3) AdminCommand payload fuzz — giveMoney
    local moneyPayloads = {
        { playerName = playerName, amount = amount },
        { playerName = playerName, amount = amount, isAdmin = true },
        { playerName = playerName, amount = amount, role = "Owner", bypass = true },
        { playerName = playerName, amount = amount, permissions = { "all", "giveMoney" } },
        { userId = userId, amount = amount },
        { targetUserId = userId, amount = amount },
        { name = playerName, amount = amount },
        { player = playerName, money = amount },
        { playerName = playerName, amount = tostring(amount) },
        { playerName = playerName, amount = amount, adminOverride = true },
        { playerName = playerName, amount = amount, whitelist = true },
        { playerName = playerName, amount = amount, force = true },
        { playerName = playerName, amount = amount, debug = true },
        { playerName = playerName, amount = amount, isAdmin = true, role = "Developer" },
    }
    for i, pl in ipairs(moneyPayloads) do
        probeAdminVector(hits, "giveMoney#" .. i, "giveMoney", pl)
    end

    local cmdAliases = { "GiveMoney", "GIVE_MONEY", "give_money", "addMoney", "setMoney", "money" }
    for _, alias in ipairs(cmdAliases) do
        probeAdminVector(hits, "alias:" .. alias, alias, { playerName = playerName, amount = amount })
    end

    -- 4) giveItem / clone / drop fuzz
    local sampleItem = State.inventory[1]
    local itemData = sampleItem and buildItemDataForAdmin(sampleItem) or {
        name = "Белая футболка",
        rarity = "Common",
        fairPrice = 120,
        id = "1352050969",
        itemType = "Shirt",
    }
    local itemPayloads = {
        { playerName = playerName, itemData = itemData },
        { playerName = playerName, itemData = itemData, isAdmin = true },
        { userId = userId, itemData = itemData },
        { playerName = playerName, itemData = itemData, bypass = true },
        { playerName = playerName, item = itemData },
        { target = playerName, itemData = itemData },
    }
    for i, pl in ipairs(itemPayloads) do
        probeAdminVector(hits, "giveItem#" .. i, "giveItem", pl)
    end

    probeAdminVector(hits, "cloneAllToAdmin", "cloneAllToAdmin", { playerName = playerName })
    probeAdminVector(hits, "cloneAll#uid", "cloneAllToAdmin", { userId = userId })
    probeAdminVector(hits, "giveCopyToAdmin", "giveCopyToAdmin", { itemData = sampleItem or itemData })
    if sampleItem then
        probeAdminVector(hits, "dropItem", "dropItem", { playerName = playerName, itemUid = sampleItem.uid })
    end

    -- 5) Команды которые иногда забывают защитить
    local softCommands = {
        { "getConfigItems", {} },
        { "getPlayers", {} },
        { "getGlobalPlayers", {} },
        { "getServerInfo", {} },
        { "getShops", {} },
        { "getShopStock", { shopName = "TSUM" } },
        { "getShopStock", { shopName = "Main" } },
        { "getLogs", {} },
        { "getBannedPlayers", {} },
        { "restockShop", { shopName = "TSUM" } },
        { "openShop", { shopName = "TSUM" } },
        { "__ping__", {} },
        { "__ping__", { isAdmin = true } },
    }
    for _, pair in ipairs(softCommands) do
        probeAdminVector(hits, "soft:" .. pair[1], pair[1], pair[2])
    end

    -- 6) Admin events (не Command)
    for _, folderName in ipairs({ "AdminRemotes", "Bindables" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        if folder then
            local fly = folder:FindFirstChild("AdminFly")
            if fly then
                probeRemoteFn(hits, "AdminFly." .. folderName, fly, true)
                probeRemoteFn(hits, "AdminFly." .. folderName .. "#uid", fly, userId)
            end
            local refresh = folder:FindFirstChild("AdminRefresh")
            if refresh then
                probeRemoteFn(hits, "AdminRefresh." .. folderName, refresh, { role = "Owner", isAdmin = true })
            end
        end
    end

    -- 7) Promo redeem после генерации
    local settings = ReplicatedStorage:FindFirstChild("SettingsRemotes")
    local redeem = settings and settings:FindFirstChild("RedeemPromo")
    if redeem then
        for _, code in ipairs({ "ADMIN", "TSUM", "BETA", "FREE", "TEST", "OWNER" }) do
            probeRemoteFn(hits, "Redeem:" .. code, redeem, code)
        end
    end

    -- 8) Bindable / прямой Invoke без очереди
    pcall(function()
        for _, cmd in ipairs(getAllAdminCommands()) do
            local ok, res = pcall(function()
                return cmd:InvokeServer("giveMoney", { playerName = playerName, amount = amount })
            end)
            table.insert(hits, "DirectInvoke." .. cmd.Parent.Name .. "=" .. (ok and summarizeAdminResult(res) or "fail"))
        end
    end)

    -- 9) Type confusion / malformed
    probeAdminVector(hits, "giveMoney#empty", "giveMoney", {})
    probeAdminVector(hits, "giveMoney#nilname", "giveMoney", { playerName = nil, amount = amount })
    probeAdminVector(hits, "giveMoney#neg", "giveMoney", { playerName = playerName, amount = -999999 })
    probeAdminVector(hits, "giveMoney#huge", "giveMoney", { playerName = playerName, amount = 999999999999 })
    probeAdminVector(hits, "cmd#empty", "", {})
    probeAdminVector(hits, "cmd#null", nil, {})

    local afterMoney = getLeaderMoney()
    local afterInv = #State.inventory
    if beforeMoney and afterMoney and afterMoney > beforeMoney then
        table.insert(hits, "!!! MONEY GREW: " .. beforeMoney .. " -> " .. afterMoney)
    end
    if afterInv > beforeInv then
        table.insert(hits, "!!! INVENTORY GREW: " .. beforeInv .. " -> " .. afterInv)
    end

    local successLines = {}
    for _, line in ipairs(hits) do
        if line:find("SUCCESS") or line:find("GAVE:") or line:find("codes=") or line:find("isAdmin=true") then
            table.insert(successLines, line)
        end
    end
    if #successLines > 0 then
        table.insert(hits, "--- ПОТЕНЦИАЛЬНЫЕ ХИТЫ ---")
        for _, line in ipairs(successLines) do
            table.insert(hits, line)
        end
    else
        table.insert(hits, "--- Итог: сервер отклонил все admin-векторы (whitelist на сервере) ---")
    end

    State.whitelistProbeRunning = false
    return table.concat(hits, "\n")
end

local function runAdminDiagnostics()
    local lines = {}
    local okInfo, info = invokeAdmin("getAdminInfo", {})
    State.adminInfo = type(info) == "table" and info or nil
    if okInfo and type(info) == "table" then
        table.insert(lines, "isAdmin=" .. tostring(info.isAdmin))
        table.insert(lines, "role=" .. tostring(info.role or "?"))
        if info.permissions then
            table.insert(lines, "perms=" .. tostring(#info.permissions))
        end
    else
        table.insert(lines, "getAdminInfo: нет ответа")
    end

    local okPing, pingRes = invokeAdmin("__ping__", {})
    table.insert(lines, "ping=" .. (okPing and "ok" or "no"))
    if type(pingRes) == "table" and pingRes.error then
        table.insert(lines, tostring(pingRes.error))
    end

    local adminFolder = ReplicatedStorage:FindFirstChild("AdminRemotes")
    for i, entry in ipairs(getAllAdminChecks()) do
        local okChk, chkRes = pcall(function()
            return entry.remote:InvokeServer()
        end)
        table.insert(lines, ("AdminCheck#%d %s="):format(i, entry.folder) .. (okChk and summarizeAdminResult(chkRes) or "fail"))
    end
    if #getAllAdminChecks() == 0 then
        local adminCheck = adminFolder and adminFolder:FindFirstChild("AdminCheck")
        if adminCheck and adminCheck:IsA("RemoteFunction") then
            local okChk, chkRes = pcall(function()
                return adminCheck:InvokeServer()
            end)
            table.insert(lines, "AdminCheck=" .. (okChk and tostring(chkRes) or "fail"))
        end
    end

    local room = ReplicatedStorage:FindFirstChild("RoomEvents")
    if room then
        local req = room:FindFirstChild("RequestData")
        if req then
            local okR, rRes = pcall(function()
                return req:InvokeServer()
            end)
            if okR and type(rRes) == "table" then
                table.insert(lines, "Room.IsAdmin=" .. tostring(rRes.IsAdmin))
                table.insert(lines, "Room.IsWL=" .. tostring(rRes.IsWL))
            end
        end
    end

    local tradeFolders = 0
    local addItemRemotes = 0
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name == "TradeRemotes" then
            tradeFolders += 1
        end
    end
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if inst.Name == "AddItem" and inst:IsA("RemoteEvent") then
            addItemRemotes += 1
        end
    end
    table.insert(lines, "TradeRemotes папок: " .. tradeFolders)
    table.insert(lines, "AddItem remote: " .. addItemRemotes)

    if not (State.adminInfo and State.adminInfo.isAdmin) then
        table.insert(
            lines,
            "AdminCommand без whitelist — giveMoney не сработает"
        )
    end

    return table.concat(lines, "\n")
end

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
    moneyAmount = 1000000,
    moneyStealthMode = true,
    adminInfo = nil,
    stealthTp = true,
    autoBuyEnabled = false,
    autoBuyRunning = false,
    autoBuyOnce = true,
    autoBuyScanInterval = 2.5,
    autoBuyRarity = "Rare",
    autoBuyTarget = nil,
    catalogLoaded = false,
    remoteSpyEnabled = true,
    remoteLog = {},
    refreshRemoteSpy = nil,
    whitelistProbeRunning = false,
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
                    table.clear(State.shopCache)
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
                        drawn += 1
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
        n += 1
    end
    notify("ESP", "ЦУМ ESP: " .. n .. " слотов. Каталог: " .. (SHOP_CATALOG and "OK" or "нет") .. ".", 6)
end

local function disconnectLoop()
    for _, conn in ipairs(State.connections) do
        conn:Disconnect()
    end
    table.clear(State.connections)
end

local function startESPLoop()
    disconnectLoop()
    table.insert(State.connections, RunService.RenderStepped:Connect(function()
        if State.espEnabled then
            renderEspFrame()
        end
    end))
end

local function forEachRemoteByName(remoteName, callback)
    local found = 0
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if inst.Name == remoteName and (inst:IsA("RemoteEvent") or inst:IsA("RemoteFunction")) then
            found += 1
            callback(inst)
        end
    end
    return found
end

local function fireRemoteInstance(remote, burst, ...)
    local args = { ... }
    burst = burst or 1
    if AC.enabled and AC.stealthRemotes then
        burst = 1
    end
    for _ = 1, burst do
        safeRemoteCall(remote, table.unpack(args))
        if burst > 1 then
            acWait()
        end
    end
end

local function fireAllRemotes(folderName, remoteName, burst, ...)
    local args = { ... }
    local found = 0
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name == folderName then
            for _, remote in ipairs(child:GetChildren()) do
                if remote.Name == remoteName and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                    found += 1
                    fireRemoteInstance(remote, burst, table.unpack(args))
                end
            end
        end
    end
    if found == 0 then
        found = forEachRemoteByName(remoteName, function(remote)
            fireRemoteInstance(remote, burst, table.unpack(args))
        end)
    end
    return found
end

local function getLeaderMoney()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    local money = ls and ls:FindFirstChild("Money")
    if money and (money:IsA("IntValue") or money:IsA("NumberValue")) then
        return money.Value
    end
    return nil
end

local function fireRemoteArgSets(folderName, remoteName, argSets, burstPerSet)
    local fired = 0
    local function fireOn(remote)
        for _, args in ipairs(argSets) do
            local bursts = burstPerSet or 1
            if AC.enabled and AC.stealthRemotes then
                bursts = 1
            end
            for _ = 1, bursts do
                fired += 1
                safeRemoteCall(remote, table.unpack(args))
                acWait()
            end
        end
    end

    local found = 0
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child.Name == folderName then
            for _, remote in ipairs(child:GetChildren()) do
                if remote.Name == remoteName and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                    found += 1
                    fireOn(remote)
                end
            end
        end
    end
    if found == 0 then
        forEachRemoteByName(remoteName, fireOn)
    end
    return fired
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
    title.Text = "Remote Spy (Dex-style) — AutoBuy/Money QA"
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
    subtitle.Text = "TSUM Free Script\nAutoBuy + ESP\nНажми Continue"
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
                n += 1
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

    Main:CreateParagraph({
        Title = "Кик 267",
        Content = "Сервер кикает за spam remotes.\nStealth деньги + очередь remotes.\nAnti-Kick не спасает от серверного кика.",
    })

    Main:CreateToggle({
        Name = "Stealth деньги (без кика 267)",
        CurrentValue = State.moneyStealthMode,
        Flag = "TSUM_MoneyStealth",
        Callback = function(v)
            State.moneyStealthMode = v
        end,
    })

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

    Main:CreateSection("AutoBuy & Money")

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

    Main:CreateButton({
        Name = "Пробинг whitelist (60+ методов)",
        Callback = function()
            task.spawn(function()
                notify("Whitelist QA", "Старт пробинга...", 3)
                local report = runWhitelistBypassProbe()
                notify("Whitelist QA", report, 25)
            end)
        end,
    })

    Main:CreateButton({
        Name = "Диагностика Admin / remotes",
        Callback = function()
            local report = runAdminDiagnostics()
            notify("Диагностика", report, 14)
        end,
    })

    Main:CreateInput({
        Name = "Сумма денег",
        PlaceholderText = tostring(State.moneyAmount),
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            local n = tonumber(text)
            if n and n > 0 then
                State.moneyAmount = math.floor(n)
            end
        end,
    })

    Main:CreateButton({
        Name = "Выдать деньги",
        Callback = function()
            task.spawn(function()
                local ok, info = runMoneyExploit(State.moneyAmount)
                if ok then
                    notify("Money QA", State.moneyAmount .. " | " .. tostring(info), 10)
                else
                    notify("Money QA", tostring(info), 6)
                end
            end)
        end,
    })

    Main:CreateButton({
        Name = "Проверить баланс",
        Callback = function()
            local m = getLeaderMoney()
            notify("Баланс", m and ("Money = " .. m) or "leaderstats.Money не найден", 5)
        end,
    })

    local WlTab = Window:CreateTab("Whitelist QA", 6031225818)
    WlTab:CreateSection("Обход admin whitelist")
    WlTab:CreateParagraph({
        Title = "Важно",
        Content = "RoomEvents.AddToWhitelist — это WL комнаты, НЕ admin.\nAdmin whitelist проверяется на СЕРВЕРЕ в AdminCommand.\nКлиентский spoof — только для UI.",
    })
    WlTab:CreateButton({
        Name = "Полный пробинг (60+ методов)",
        Callback = function()
            task.spawn(function()
                notify("Whitelist QA", "Пробинг...", 3)
                local report = runWhitelistBypassProbe()
                notify("Whitelist QA", report, 30)
            end)
        end,
    })
    WlTab:CreateButton({
        Name = "Клиентский spoof isAdmin (визуально)",
        Callback = installClientAdminSpoof,
    })
    WlTab:CreateButton({
        Name = "Диагностика Admin + Room WL",
        Callback = function()
            notify("Whitelist QA", runAdminDiagnostics(), 20)
        end,
    })
    WlTab:CreateButton({
        Name = "giveMoney после пробинга",
        Callback = function()
            task.spawn(function()
                local ok, info = runMoneyExploit(State.moneyAmount)
                notify("Money QA", ok and tostring(info) or tostring(info), 12)
            end)
        end,
    })
    WlTab:CreateLabel("made by tsumfreescript")

    
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


    local MoneyTab = Window:CreateTab("Money QA", 6031075938)
    MoneyTab:CreateSection("Выдача валюты")
    MoneyTab:CreateParagraph({
        Title = "QA тест",
        Content = "Stealth: все банки + admin giveMoney чанками.\nБез whitelist — Trade/Loader/Grayled.\nRemote Spy покажет что реально ушло на сервер.",
    })
    MoneyTab:CreateToggle({
        Name = "Stealth режим",
        CurrentValue = State.moneyStealthMode,
        Flag = "TSUM_MoneyStealthTab",
        Callback = function(v)
            State.moneyStealthMode = v
        end,
    })
    MoneyTab:CreateInput({
        Name = "Сумма",
        PlaceholderText = "1000000",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            local n = tonumber(text)
            if n and n > 0 then
                State.moneyAmount = math.floor(n)
            end
        end,
    })
    MoneyTab:CreateButton({
        Name = "Выдать деньги",
        Callback = function()
            task.spawn(function()
                local ok, info = runMoneyExploit(State.moneyAmount)
                if ok then
                    notify("Money QA", "Отправлено " .. State.moneyAmount .. "\n" .. tostring(info), 8)
                else
                    notify("Money QA", tostring(info), 6)
                end
            end)
        end,
    })
    MoneyTab:CreateButton({
        Name = "Проверить баланс",
        Callback = function()
            local m = getLeaderMoney()
            if m then
                notify("Баланс", "leaderstats.Money = " .. tostring(m), 6)
            else
                local atm = ReplicatedStorage:FindFirstChild("ATMRemotes")
                local bal = atm and atm:FindFirstChild("GetBalance")
                if bal then
                    local ok, result = pcall(function()
                        return bal:InvokeServer()
                    end)
                    notify("Balance", ok and tostring(result) or "ошибка", 6)
                else
                    notify("Balance", "Money не найден", 4)
                end
            end
        end,
    })
    MoneyTab:CreateLabel("made by tsumfreescript")

    startESPLoop()

    LocalPlayer.CharacterAdded:Connect(function()
        stopBarigaHold()
    end)

    notify("TSUM", "Скрипт загружен — t.me/tsumfreescript", 5)
end

pcall(function()
    local function start()
        if not LocalPlayer then
            LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
        end
        bootSplash(loadMainUI)
    end
    if LocalPlayer then
        start()
    else
        task.spawn(start)
    end
end)

