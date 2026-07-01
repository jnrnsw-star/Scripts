-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__TweenService__3 = game:GetService("TweenService");
local l__RunService__4 = game:GetService("RunService");
local l__UserInputService__5 = game:GetService("UserInputService");
local l__PlayerGui__6 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui");
local l__CurrentCamera__7 = workspace.CurrentCamera;
local l__ShopRemotes__8 = l__ReplicatedStorage__2:WaitForChild("ShopRemotes");
local l__ClothingConfig__9 = require(l__ReplicatedStorage__2:WaitForChild("ClothingConfig"));
local u1 = l__ReplicatedStorage__2:FindFirstChild("PhoneModels");
local u2 = l__ReplicatedStorage__2:FindFirstChild("AccessoryCache") or l__ReplicatedStorage__2:WaitForChild("AccessoryCache", 10);
local u3 = nil;
pcall(function() --[[ Line: 36 ]]
    -- upvalues: u3 (ref), l__ShopRemotes__8 (copy)
    u3 = l__ShopRemotes__8:WaitForChild("LoadAccessoryModel", 5);
end);
local v4 = l__ReplicatedStorage__2:WaitForChild("InventoryRemotes"):FindFirstChild("InventoryFull");
local v5 = l__ReplicatedStorage__2:FindFirstChild("TokyoRemotes");
local u6;
if v5 then
    u6 = v5:FindFirstChild("TokyoConfirmPurchase");
else
    u6 = v5;
end;
local v7;
if v5 then
    v7 = v5:FindFirstChild("TokyoPurchaseResult");
else
    v7 = v5;
end;
if v5 then
    v5 = v5:FindFirstChild("TokyoEndDialogue");
end;
local l__SlotInfoUpdate__10 = l__ShopRemotes__8:WaitForChild("SlotInfoUpdate", 10);
local l__SlotInfoClear__11 = l__ShopRemotes__8:WaitForChild("SlotInfoClear", 10);
local l__SlotPriceReveal__12 = l__ShopRemotes__8:WaitForChild("SlotPriceReveal", 10);
local u8 = nil;
pcall(function() --[[ Line: 53 ]]
    -- upvalues: l__ReplicatedStorage__2 (copy), u8 (ref)
    local v9 = l__ReplicatedStorage__2:FindFirstChild("Shared");
    local v10 = v9 and v9:FindFirstChild("SharedPreviewLib");
    if v10 then
        u8 = require(v10);
    end;
end);
local l__TouchEnabled__13 = l__UserInputService__5.TouchEnabled;
if l__TouchEnabled__13 then
    l__TouchEnabled__13 = not l__UserInputService__5.MouseEnabled;
end;
local l__ShopGUI__14 = l__PlayerGui__6:WaitForChild("ShopGUI");
local l__CartFrame__15 = l__ShopGUI__14:WaitForChild("CartFrame");
local l__ItemsScroll__16 = l__CartFrame__15:WaitForChild("ItemsScroll");
local l__ItemTemplate__17 = l__ItemsScroll__16:WaitForChild("ItemTemplate");
l__ItemTemplate__17.Visible = false;
local l__TotalFrame__18 = l__CartFrame__15:WaitForChild("TotalFrame");
local l__NotifyFrame__19 = l__ShopGUI__14:WaitForChild("NotifyFrame");
local l__DialogueFrame__20 = l__ShopGUI__14:WaitForChild("DialogueFrame");
local l__Count__21 = l__CartFrame__15:WaitForChild("Count");
local u11 = u8;
local u12 = u3;
for _, v13 in ipairs(l__PlayerGui__6:GetChildren()) do
    if v13.Name:sub(1, 5) == "__SB_" then
        v13:Destroy();
    end;
end;
local u14 = Instance.new("ScreenGui");
u14.Name = "__SB_" .. tostring(math.random(100000, 999999));
u14.ResetOnSpawn = false;
u14.DisplayOrder = 5;
u14.Parent = l__PlayerGui__6;
local function v19() --[[ Line: 96 ]]
    -- upvalues: l__TouchEnabled__13 (copy), l__CartFrame__15 (copy), l__NotifyFrame__19 (copy), l__DialogueFrame__20 (copy), l__ItemTemplate__17 (copy)
    if l__TouchEnabled__13 then
        l__CartFrame__15.Size = UDim2.new(0.92, 0, 0, 280);
        l__CartFrame__15.AnchorPoint = Vector2.new(0.5, 1);
        l__NotifyFrame__19.Size = UDim2.new(0.9, 0, 0, 56);
        l__NotifyFrame__19.AnchorPoint = Vector2.new(0.5, 0);
        l__DialogueFrame__20.Size = UDim2.new(0.96, 0, 0, 160);
        l__DialogueFrame__20.AnchorPoint = Vector2.new(0.5, 1);
        local v15 = l__ItemTemplate__17:FindFirstChild("NameLabel");
        if v15 then
            v15.TextSize = 16;
        end;
        local v16 = l__ItemTemplate__17:FindFirstChild("RarLabel");
        if v16 then
            v16.TextSize = 13;
        end;
        local v17 = l__ItemTemplate__17:FindFirstChild("PriceLabel");
        if v17 then
            v17.TextSize = 14;
        end;
        local v18 = l__ItemTemplate__17:FindFirstChild("RemoveBtn");
        if v18 then
            v18.Size = UDim2.new(0, 44, 0, 44);
        end;
    end;
end;
local u20 = false;
local u21 = nil;
local u22 = {};
local u23 = {};
local u24 = nil;
local u25 = {};
local u26 = {};
local u27 = false;
local u28 = {};
local u29 = {};
local u30 = nil;
local u31 = false;
local u32 = {
    Common = {
        displayName = "Common",
        color = Color3.fromRGB(180, 180, 180)
    },
    Uncommon = {
        displayName = "Uncommon",
        color = Color3.fromRGB(80, 200, 80)
    },
    Rare = {
        displayName = "Rare",
        color = Color3.fromRGB(80, 150, 255)
    },
    Epic = {
        displayName = "Epic",
        color = Color3.fromRGB(180, 80, 255)
    },
    Legendary = {
        displayName = "Legendary",
        color = Color3.fromRGB(255, 180, 0)
    },
    Exclusive = {
        displayName = "EXCLUSIVE",
        color = Color3.fromRGB(138, 43, 226)
    }
};
local u33 = {
    Shoes = 4.2,
    Hat = 2.5,
    Back = 3,
    Face = 2.2,
    Neck = 2.2,
    Waist = 2.5,
    Shoulder = 2.5,
    Front = 2.2,
    Bottom = 6,
    Outerwear = 6,
    DEFAULT = 2.5
};
local function u35(p34) --[[ Line: 158 ]]
    if p34 then
        return (p34.itemType == "Accessory" or (p34.itemType == "Shoes" or (p34.itemType == "Bottom" or (p34.itemType == "Outerwear" or (p34.type == "Accessory" or (p34.type == "Shoes" or (p34.type == "Bottom" or p34.type == "Outerwear"))))))) and true or p34.accessoryType ~= nil;
    else
        return false;
    end;
end;
local function u38() --[[ Line: 189 ]]
    local v36 = "_";
    for _ = 1, 6 do
        local v37 = math.random(1, 26);
        v36 = v36 .. ("abcdefghijklmnopqrstuvwxyz"):sub(v37, v37);
    end;
    return v36 .. tostring(math.random(1000, 9999));
end;
if u2 then
    u2.ChildAdded:Connect(function(p39) --[[ Line: 248 ]]
        -- upvalues: u27 (ref), l__CartFrame__15 (copy), u23 (ref)
        if p39 and (p39.Name and (p39.Name:match("^ACC_") or p39.Name:match("^CUSTOM_"))) then
            if u27 then
                return;
            end;
            u27 = true;
            task.delay(0.25, function() --[[ Line: 239 ]]
                -- upvalues: u27 (ref), l__CartFrame__15 (ref), u23 (ref)
                u27 = false;
                if l__CartFrame__15.Visible and (#u23 > 0 and _G.__ShopClientRenderCart) then
                    _G.__ShopClientRenderCart(false);
                end;
            end);
        end;
    end);
end;
local function u54(p40, p41) --[[ Line: 269 ]]
    local v42 = Instance.new("Model");
    v42.Name = "PreviewMannequin";
    local v43 = Instance.new("Part");
    v43.Name = "Center";
    v43.Size = Vector3.new(0.1, 0.1, 0.1);
    v43.Transparency = 1;
    v43.Anchored = true;
    v43.CanCollide = false;
    v43.CFrame = CFrame.new(0, 0, 0);
    v43.Parent = v42;
    v42.PrimaryPart = v43;
    if (p40 == "Shirt" and "Shirts" or p40) == "Shirts" then
        local v44 = Instance.new("Part");
        v44.Name = "Torso";
        v44.Size = Vector3.new(2, 2, 1);
        v44.Anchored = true;
        v44.CanCollide = false;
        v44.Color = Color3.fromRGB(180, 180, 180);
        v44.Material = Enum.Material.SmoothPlastic;
        v44.CFrame = CFrame.new(0, 0, 0);
        v44.Parent = v42;
        local v45 = Instance.new("Part");
        v45.Name = "Left Arm";
        v45.Size = Vector3.new(1, 2, 1);
        v45.Anchored = true;
        v45.CanCollide = false;
        v45.Color = Color3.fromRGB(180, 180, 180);
        v45.Material = Enum.Material.SmoothPlastic;
        v45.CFrame = CFrame.new(-1.5, 0, 0);
        v45.Parent = v42;
        local v46 = Instance.new("Part");
        v46.Name = "Right Arm";
        v46.Size = Vector3.new(1, 2, 1);
        v46.Anchored = true;
        v46.CanCollide = false;
        v46.Color = Color3.fromRGB(180, 180, 180);
        v46.Material = Enum.Material.SmoothPlastic;
        v46.CFrame = CFrame.new(1.5, 0, 0);
        v46.Parent = v42;
        Instance.new("Humanoid", v42);
        local v47;
        if p41 then
            v47 = tostring(p41);
            if v47 == "" then
                v47 = nil;
            elseif not v47:find("rbxassetid://") then
                v47 = "rbxassetid://" .. v47;
            end;
        else
            v47 = nil;
        end;
        if v47 then
            local v48 = Instance.new("Shirt");
            v48.ShirtTemplate = v47;
            v48.Parent = v42;
            return v42;
        end;
    else
        local v49 = Instance.new("Part");
        v49.Name = "Torso";
        v49.Size = Vector3.new(2, 2, 1);
        v49.Anchored = true;
        v49.CanCollide = false;
        v49.Transparency = 1;
        v49.CFrame = CFrame.new(0, 1, 0);
        v49.Parent = v42;
        local v50 = Instance.new("Part");
        v50.Name = "Left Leg";
        v50.Size = Vector3.new(1, 2, 1);
        v50.Anchored = true;
        v50.CanCollide = false;
        v50.Color = Color3.fromRGB(180, 180, 180);
        v50.Material = Enum.Material.SmoothPlastic;
        v50.CFrame = CFrame.new(-0.5, -1, 0);
        v50.Parent = v42;
        local v51 = Instance.new("Part");
        v51.Name = "Right Leg";
        v51.Size = Vector3.new(1, 2, 1);
        v51.Anchored = true;
        v51.CanCollide = false;
        v51.Color = Color3.fromRGB(180, 180, 180);
        v51.Material = Enum.Material.SmoothPlastic;
        v51.CFrame = CFrame.new(0.5, -1, 0);
        v51.Parent = v42;
        Instance.new("Humanoid", v42);
        local v52;
        if p41 then
            v52 = tostring(p41);
            if v52 == "" then
                v52 = nil;
            elseif not v52:find("rbxassetid://") then
                v52 = "rbxassetid://" .. v52;
            end;
        else
            v52 = nil;
        end;
        if v52 then
            local v53 = Instance.new("Pants");
            v53.PantsTemplate = v52;
            v53.Parent = v42;
        end;
    end;
    return v42;
end;
local function u58() --[[ Line: 295 ]]
    local v55 = Instance.new("Model");
    v55.Name = "PhonePlaceholder";
    local v56 = Instance.new("Part");
    v56.Name = "Body";
    v56.Anchored = true;
    v56.CanCollide = false;
    v56.Size = Vector3.new(0.4, 0.8, 0.05);
    v56.Color = Color3.fromRGB(30, 30, 30);
    v56.Material = Enum.Material.SmoothPlastic;
    v56.CFrame = CFrame.new(0, 0, 0);
    v56.Parent = v55;
    local v57 = Instance.new("Part");
    v57.Name = "Screen";
    v57.Anchored = true;
    v57.CanCollide = false;
    v57.Size = Vector3.new(0.35, 0.7, 0.01);
    v57.Color = Color3.fromRGB(20, 20, 25);
    v57.Material = Enum.Material.Neon;
    v57.CFrame = CFrame.new(0, 0, 0.03);
    v57.Parent = v55;
    v55.PrimaryPart = v56;
    return v55;
end;
local function u65(p59) --[[ Line: 302 ]]
    -- upvalues: u58 (copy), u1 (copy)
    if not p59 or p59 == "" then
        return u58();
    end;
    local v60 = u1 and u1:FindFirstChild((tostring(p59)));
    if v60 then
        local v61 = v60:Clone();
        if v61:IsA("Model") then
            if not v61.PrimaryPart then
                for _, v62 in ipairs(v61:GetDescendants()) do
                    if v62:IsA("BasePart") then
                        v61.PrimaryPart = v62;
                        break;
                    end;
                end;
            end;
            if v61.PrimaryPart then
                local l__Position__22 = v61.PrimaryPart.Position;
                for _, v63 in ipairs(v61:GetDescendants()) do
                    if v63:IsA("BasePart") then
                        v63.CFrame = v63.CFrame - l__Position__22;
                        v63.Anchored = true;
                        v63.CanCollide = false;
                    end;
                end;
            end;
            return v61;
        end;
        if v61:IsA("BasePart") then
            local v64 = Instance.new("Model");
            v64.Name = tostring(p59);
            v61.Name = "Body";
            v61.Anchored = true;
            v61.CanCollide = false;
            v61.CFrame = CFrame.new(0, 0, 0);
            v61.Parent = v64;
            v64.PrimaryPart = v61;
            return v64;
        end;
    end;
    return u58();
end;
local function u69(p66) --[[ Line: 320 ]]
    local v67 = Instance.new("Model");
    v67.Name = "AccessoryPlaceholder";
    local v68 = Instance.new("Part");
    v68.Name = "Body";
    v68.Anchored = true;
    v68.CanCollide = false;
    v68.Material = Enum.Material.SmoothPlastic;
    if p66 == "Shoes" then
        v68.Size = Vector3.new(1.6, 0.5, 2.2);
        v68.Color = Color3.fromRGB(255, 150, 40);
        v68.Material = Enum.Material.Neon;
    elseif p66 == "Hat" then
        v68.Size = Vector3.new(1.2, 0.6, 1.2);
        v68.Color = Color3.fromRGB(80, 80, 80);
    elseif p66 == "Back" then
        v68.Size = Vector3.new(1, 1.5, 0.5);
        v68.Color = Color3.fromRGB(60, 60, 60);
    elseif p66 == "Face" then
        v68.Size = Vector3.new(1.2, 0.4, 0.2);
        v68.Color = Color3.fromRGB(40, 40, 40);
    elseif p66 == "Neck" then
        v68.Size = Vector3.new(0.8, 0.2, 0.8);
        v68.Color = Color3.fromRGB(200, 180, 50);
        v68.Material = Enum.Material.Neon;
    elseif p66 == "Waist" then
        v68.Size = Vector3.new(1, 0.5, 0.3);
        v68.Color = Color3.fromRGB(70, 70, 70);
    elseif p66 == "Shoulder" then
        v68.Size = Vector3.new(0.8, 0.8, 0.8);
        v68.Color = Color3.fromRGB(90, 90, 100);
    elseif p66 == "Front" then
        v68.Size = Vector3.new(1, 1, 0.35);
        v68.Color = Color3.fromRGB(80, 80, 90);
    elseif p66 == "Bottom" then
        v68.Size = Vector3.new(2, 3, 0.5);
        v68.Color = Color3.fromRGB(60, 80, 140);
    elseif p66 == "Outerwear" then
        v68.Size = Vector3.new(2.5, 3, 0.5);
        v68.Color = Color3.fromRGB(80, 60, 40);
    else
        v68.Size = Vector3.new(1, 1, 1);
        v68.Shape = Enum.PartType.Ball;
        v68.Color = Color3.fromRGB(100, 100, 100);
    end;
    v68.CFrame = CFrame.new(0, 0, 0);
    v68.Parent = v67;
    v67.PrimaryPart = v68;
    return v67;
end;
local function u74(p70) --[[ Line: 352 ]]
    if not (p70 and p70:IsA("Model")) then
        return p70;
    end;
    for _, v71 in ipairs(p70:GetDescendants()) do
        if v71:IsA("BasePart") then
            v71.Anchored = true;
            v71.CanCollide = false;
        end;
    end;
    if not p70.PrimaryPart then
        for _, v72 in ipairs(p70:GetDescendants()) do
            if v72:IsA("BasePart") then
                p70.PrimaryPart = v72;
                break;
            end;
        end;
    end;
    if p70.PrimaryPart then
        local l__Position__23 = p70.PrimaryPart.Position;
        for _, v73 in ipairs(p70:GetDescendants()) do
            if v73:IsA("BasePart") then
                v73.CFrame = v73.CFrame - l__Position__23;
            end;
        end;
    end;
    return p70;
end;
local function u83(p75) --[[ Line: 360 ]]
    if not p75 then
        return nil;
    end;
    if p75:IsA("Accessory") then
        local v76 = p75:FindFirstChild("Handle");
        if v76 and v76:IsA("BasePart") then
            local v77 = v76:Clone();
            v77.Anchored = true;
            v77.CanCollide = false;
            return v77;
        end;
    elseif p75:IsA("Model") then
        local v78 = p75:FindFirstChild("Handle");
        if v78 and v78:IsA("BasePart") then
            local v79 = v78:Clone();
            v79.Anchored = true;
            v79.CanCollide = false;
            return v79;
        end;
        for _, v80 in ipairs(p75:GetDescendants()) do
            if v80:IsA("BasePart") then
                local v81 = v80:Clone();
                v81.Anchored = true;
                v81.CanCollide = false;
                return v81;
            end;
        end;
    elseif p75:IsA("BasePart") then
        local v82 = p75:Clone();
        v82.Anchored = true;
        v82.CanCollide = false;
        return v82;
    end;
    return nil;
end;
local function u95(p84) --[[ Line: 368 ]]
    -- upvalues: u11 (ref), u2 (ref), u26 (copy), l__ReplicatedStorage__2 (copy), u74 (copy)
    if not (p84 and p84.customModelName) then
        return nil;
    end;
    local v85 = u11 and u11.getCustomPreviewModel and u11.getCustomPreviewModel(p84);
    if v85 then
        return v85;
    end;
    local l__customModelName__24 = p84.customModelName;
    local v86;
    if l__customModelName__24 and u2 then
        v86 = u2:FindFirstChild("CUSTOM_" .. tostring(l__customModelName__24));
    else
        v86 = nil;
    end;
    if not v86 then
        if p84 and p84.customModelName then
            local v87 = "CUSTOM_" .. tostring(p84.customModelName);
            if not u26[v87] then
                u26[v87] = true;
                task.spawn(function() --[[ Line: 227 ]]
                    -- upvalues: l__ReplicatedStorage__2 (ref)
                    local v88 = l__ReplicatedStorage__2:FindFirstChild("InventoryRemotes");
                    local u89 = v88 and v88:FindFirstChild("RequestInventory");
                    if u89 then
                        pcall(function() --[[ Line: 231 ]]
                            -- upvalues: u89 (copy)
                            u89:FireServer();
                        end);
                    end;
                end);
            end;
        end;
        return nil;
    end;
    local v90 = v86:Clone();
    if v90:IsA("Model") then
        return u74(v90);
    end;
    if not v90:IsA("Accessory") then
        if not v90:IsA("BasePart") then
            v90:Destroy();
            return nil;
        end;
        local v91 = Instance.new("Model");
        v91.Name = "CustomPreview";
        v90.Anchored = true;
        v90.CanCollide = false;
        v90.CFrame = CFrame.new(0, 0, 0);
        v90.Parent = v91;
        v91.PrimaryPart = v90;
        return v91;
    end;
    local v92 = v90:FindFirstChild("Handle");
    if not (v92 and v92:IsA("BasePart")) then
        v90:Destroy();
        return nil;
    end;
    local v93 = v92:Clone();
    v90:Destroy();
    local v94 = Instance.new("Model");
    v94.Name = "CustomPreview";
    v93.Anchored = true;
    v93.CanCollide = false;
    v93.CFrame = CFrame.new(0, 0, 0);
    v93.Parent = v94;
    v94.PrimaryPart = v93;
    return v94;
end;
local function u105(u96, p97) --[[ Line: 380 ]]
    -- upvalues: u69 (copy), u2 (ref), u74 (copy), u25 (copy), u12 (ref)
    if not u96 then
        return u69(p97);
    end;
    local v98;
    if u96 and u2 then
        v98 = u2:FindFirstChild("ACC_" .. tostring(u96));
    else
        v98 = nil;
    end;
    if v98 then
        local v99 = v98:Clone();
        if v99:IsA("Accessory") then
            local v100 = v99:FindFirstChild("Handle");
            if not (v100 and v100:IsA("BasePart")) then
                v99:Destroy();
                return u69(p97);
            end;
            local v101 = v100:Clone();
            v99:Destroy();
            local v102 = Instance.new("Model");
            v102.Name = "AccessoryPreview";
            v101.Anchored = true;
            v101.CanCollide = false;
            v101.CFrame = CFrame.new(0, 0, 0);
            v101.Parent = v102;
            v102.PrimaryPart = v101;
            return v102;
        end;
        if v99:IsA("Model") then
            return u74(v99);
        end;
        if v99:IsA("BasePart") then
            local v103 = Instance.new("Model");
            v103.Name = "AccessoryPreview";
            v99.Anchored = true;
            v99.CanCollide = false;
            v99.CFrame = CFrame.new(0, 0, 0);
            v99.Parent = v103;
            v103.PrimaryPart = v99;
            return v103;
        end;
        v99:Destroy();
    end;
    if u96 then
        local v104 = tostring(u96);
        if not u25[v104] then
            u25[v104] = true;
            if u12 then
                task.spawn(function() --[[ Line: 219 ]]
                    -- upvalues: u12 (ref), u96 (copy)
                    pcall(function() --[[ Line: 219 ]]
                        -- upvalues: u12 (ref), u96 (ref)
                        u12:InvokeServer(u96);
                    end);
                end);
            end;
        end;
    end;
    return u69(p97);
end;
local function u126(p106) --[[ Line: 400 ]]
    -- upvalues: u105 (copy), u2 (ref), u83 (copy), u25 (copy), u12 (ref)
    local v107;
    if p106 then
        v107 = p106.assetIds;
    else
        v107 = p106;
    end;
    if not v107 or #v107 == 0 then
        if p106 then
            p106 = p106.assetId;
        end;
        if p106 then
            return u105(p106, "Shoes");
        end;
        local v108 = Instance.new("Model");
        v108.Name = "AccessoryPlaceholder";
        local v109 = Instance.new("Part");
        v109.Name = "Body";
        v109.Anchored = true;
        v109.CanCollide = false;
        v109.Material = Enum.Material.SmoothPlastic;
        v109.Size = Vector3.new(1.6, 0.5, 2.2);
        v109.Color = Color3.fromRGB(255, 150, 40);
        v109.Material = Enum.Material.Neon;
        v109.CFrame = CFrame.new(0, 0, 0);
        v109.Parent = v108;
        v108.PrimaryPart = v109;
        return v108;
    end;
    local v110 = Instance.new("Model");
    v110.Name = "ShoesPairPreview";
    local v111 = {};
    for v112, u113 in ipairs(v107) do
        local v114;
        if u113 then
            local v115;
            if u113 and u2 then
                v115 = u2:FindFirstChild("ACC_" .. tostring(u113));
            else
                v115 = nil;
            end;
            if v115 then
                v114 = u83(v115);
            elseif u113 then
                local v116 = tostring(u113);
                if u25[v116] then
                    v114 = nil;
                else
                    u25[v116] = true;
                    if u12 then
                        task.spawn(function() --[[ Line: 219 ]]
                            -- upvalues: u12 (ref), u113 (copy)
                            pcall(function() --[[ Line: 219 ]]
                                -- upvalues: u12 (ref), u113 (ref)
                                u12:InvokeServer(u113);
                            end);
                        end);
                        v114 = nil;
                    else
                        v114 = nil;
                    end;
                end;
            else
                v114 = nil;
            end;
        else
            v114 = nil;
        end;
        if v114 then
            v114.Name = v112 == 1 and "RightShoe" or "LeftShoe";
            table.insert(v111, {
                part = v114,
                idx = v112
            });
        end;
    end;
    if #v111 ~= 0 then
        for _, v117 in ipairs(v111) do
            local l__part__25 = v117.part;
            local v118 = math.max(l__part__25.Size.X, l__part__25.Size.Y, l__part__25.Size.Z);
            if v118 > 1.6 then
                l__part__25.Size = l__part__25.Size * (1.6 / v118);
            end;
        end;
        local v119 = 0;
        for _, v120 in ipairs(v111) do
            v119 = v119 + v120.part.Size.X;
        end;
        local v121 = -(v119 + math.max(#v111 - 1, 0) * 0.2) / 2;
        for _, v122 in ipairs(v111) do
            local l__part__26 = v122.part;
            local v123 = v122.idx == 1 and -12 or 12;
            l__part__26.CFrame = CFrame.new(v121 + l__part__26.Size.X / 2, 0, 0) * CFrame.Angles(0, math.rad(v123), 0);
            l__part__26.Parent = v110;
            v121 = v121 + (l__part__26.Size.X + 0.2);
        end;
        if v111[1] and v111[1].part.Parent then
            v110.PrimaryPart = v111[1].part;
        end;
        return v110;
    end;
    v110:Destroy();
    local v124 = Instance.new("Model");
    v124.Name = "AccessoryPlaceholder";
    local v125 = Instance.new("Part");
    v125.Name = "Body";
    v125.Anchored = true;
    v125.CanCollide = false;
    v125.Material = Enum.Material.SmoothPlastic;
    v125.Size = Vector3.new(1.6, 0.5, 2.2);
    v125.Color = Color3.fromRGB(255, 150, 40);
    v125.Material = Enum.Material.Neon;
    v125.CFrame = CFrame.new(0, 0, 0);
    v125.Parent = v124;
    v124.PrimaryPart = v125;
    return v124;
end;
local function u139(p127) --[[ Line: 413 ]]
    -- upvalues: u58 (copy), u35 (copy), u33 (copy), u95 (copy), u69 (copy), u126 (copy), u105 (copy), u65 (copy), u54 (copy)
    if p127 then
        local v128;
        if p127 then
            v128 = p127.itemType or p127.type;
        else
            v128 = nil;
        end;
        local v129 = v128 or "Shirt";
        if u35(p127) then
            local v130 = p127.accessoryType or "Hat";
            local v131 = u33[v130] or u33.DEFAULT;
            local v132;
            if p127 == nil then
                v132 = false;
            else
                v132 = p127.sourceType == "Custom";
            end;
            if v132 then
                local v133 = u95(p127);
                if v133 then
                    return v133, 0, v131;
                else
                    return u69(v130), 0, v131;
                end;
            else
                local v134;
                if p127 and (p127.accessoryType ~= "Bottom" and p127.accessoryType ~= "Outerwear") then
                    if p127.accessoryType == "Shoes" or (p127.itemType == "Shoes" or p127.type == "Shoes") then
                        v134 = true;
                    else
                        v134 = p127.assetIds;
                        if v134 then
                            v134 = #p127.assetIds >= 2;
                        end;
                    end;
                else
                    v134 = false;
                end;
                if v134 then
                    return u126(p127), 0, v131;
                end;
                if p127 and (p127.assetIds and #p127.assetIds > 0) then
                    p127 = p127.assetIds[1];
                elseif p127 then
                    p127 = p127.assetId;
                end;
                return u105(p127, v130), 0, v131;
            end;
        else
            if v129 == "Phone" then
                return u65(p127.id or (p127.phoneId or p127.name)), 0, 2;
            end;
            local v135 = p127.type or "Shirt";
            local v136 = (v135 == "Shirt" or v135 == "Shirts") and "Shirts" or "Pants";
            local v137 = v136 == "Shirts" and 0 or -0.5;
            local v138 = v136 == "Shirts" and 5.5 or 6.5;
            return u54(v136, p127.templateId or p127.id), v137, v138;
        end;
    else
        return u58(), 0, 2;
    end;
end;
l__RunService__4.RenderStepped:Connect(function(p140) --[[ Line: 432 ]]
    -- upvalues: u22 (copy)
    local v141 = 0;
    local v142 = {};
    for v143, v144 in pairs(u22) do
        if v143 and (v143.Parent and v143.CurrentCamera) then
            if v141 < 20 then
                v144.angle = v144.angle + 40 * p140;
                local v145 = v144.radius or 5;
                local v146 = v144.centerY or 0;
                local v147 = math.rad(v144.angle);
                local v148 = math.sin(v147) * v145;
                local v149 = math.rad(v144.angle);
                local v150 = math.cos(v149) * v145;
                v143.CurrentCamera.CFrame = CFrame.new(Vector3.new(v148, v146, v150), (Vector3.new(0, v146, 0)));
                v141 = v141 + 1;
            end;
        else
            table.insert(v142, v143);
        end;
    end;
    for _, v151 in ipairs(v142) do
        u22[v151] = nil;
    end;
end);
local function u154() --[[ Line: 456 ]]
    -- upvalues: u28 (ref), u29 (ref)
    for v152 in pairs(u28) do
        local v153 = u28[v152];
        if v153 and v153.Parent then
            v153:Destroy();
        end;
        u28[v152] = nil;
    end;
    u28 = {};
    u29 = {};
end;
local function u162(p155) --[[ Line: 466 ]]
    -- upvalues: u28 (ref), u32 (copy), u38 (copy), u14 (copy), l__TweenService__3 (copy)
    local l__slotRef__27 = p155.slotRef;
    if l__slotRef__27 and (l__slotRef__27:IsA("BasePart") and l__slotRef__27.Parent) then
        local l__slotId__28 = p155.slotId;
        local v156 = u28[l__slotId__28];
        if v156 and v156.Parent then
            v156:Destroy();
        end;
        u28[l__slotId__28] = nil;
        local v157 = u32[p155.rarity] or u32.Common;
        local v158 = typeof(p155.rarityColor) == "Color3" and p155.rarityColor or v157.color;
        local v159 = Instance.new("BillboardGui");
        v159.Name = u38();
        v159.Size = UDim2.new(0, 120, 0, 50);
        v159.StudsOffset = Vector3.new(0, 2.5, 0);
        v159.AlwaysOnTop = false;
        v159.MaxDistance = 25;
        v159.LightInfluence = 0;
        v159.Adornee = l__slotRef__27;
        v159.ResetOnSpawn = false;
        v159.Active = false;
        v159.Parent = u14;
        local v160 = Instance.new("TextLabel");
        v160.Name = u38();
        v160.Size = UDim2.new(1, 0, 0.5, 0);
        v160.BackgroundTransparency = 1;
        v160.Text = p155.name or "???";
        v160.TextColor3 = v158;
        v160.TextStrokeTransparency = 0;
        v160.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
        v160.TextSize = 14;
        v160.Font = Enum.Font.FredokaOne;
        v160.TextScaled = true;
        v160.TextTransparency = 1;
        v160.TextStrokeTransparency = 1;
        v160.Parent = v159;
        local v161 = Instance.new("TextLabel");
        v161.Name = u38();
        v161.Size = UDim2.new(1, 0, 0.4, 0);
        v161.Position = UDim2.new(0, 0, 0.55, 0);
        v161.BackgroundTransparency = 1;
        v161.Text = tostring(p155.price or 0) .. " R$";
        v161.TextColor3 = Color3.fromRGB(100, 255, 100);
        v161.TextStrokeTransparency = 1;
        v161.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
        v161.TextSize = 12;
        v161.Font = Enum.Font.FredokaOne;
        v161.TextScaled = true;
        v161.TextTransparency = 1;
        v161.Parent = v159;
        l__TweenService__3:Create(v160, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            TextTransparency = 0,
            TextStrokeTransparency = 0
        }):Play();
        l__TweenService__3:Create(v161, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            TextTransparency = 0,
            TextStrokeTransparency = 0
        }):Play();
        u28[l__slotId__28] = v159;
    end;
end;
local function u166(u163) --[[ Line: 531 ]]
    -- upvalues: u28 (ref), l__TweenService__3 (copy)
    local u164 = u28[u163];
    if u164 and u164.Parent then
        for _, v165 in ipairs(u164:GetChildren()) do
            if v165:IsA("TextLabel") then
                l__TweenService__3:Create(v165, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1
                }):Play();
            end;
        end;
        task.delay(0.25, function() --[[ Line: 546 ]]
            -- upvalues: u164 (copy), u28 (ref), u163 (copy)
            if u164 and u164.Parent then
                u164:Destroy();
            end;
            u28[u163] = nil;
        end);
    else
        u28[u163] = nil;
    end;
end;
if l__SlotInfoUpdate__10 then
    l__SlotInfoUpdate__10.OnClientEvent:Connect(function(p167) --[[ Line: 558 ]]
        -- upvalues: u30 (ref), u31 (ref)
        if p167 and p167.zoneId then
            u30 = p167.zoneId;
            u31 = true;
        end;
    end);
end;
if l__SlotInfoClear__11 then
    l__SlotInfoClear__11.OnClientEvent:Connect(function(p168) --[[ Line: 566 ]]
        -- upvalues: u154 (copy), u31 (ref), u30 (ref)
        if p168 then
            u154();
            u31 = false;
            u30 = nil;
        end;
    end);
end;
if l__SlotPriceReveal__12 then
    l__SlotPriceReveal__12.OnClientEvent:Connect(function(p169) --[[ Line: 576 ]]
        -- upvalues: u154 (copy), u29 (ref), u166 (copy), u162 (copy)
        if p169 then
            local v170 = {};
            for _, v171 in ipairs(p169) do
                if v171.slotId then
                    v170[v171.slotId] = true;
                end;
            end;
            for v172 in pairs(u29) do
                if not v170[v172] then
                    u166(v172);
                end;
            end;
            for _, v173 in ipairs(p169) do
                if v173.slotId and not u29[v173.slotId] then
                    u162(v173);
                end;
            end;
            u29 = v170;
        else
            u154();
        end;
    end);
end;
local function u177(p174) --[[ Line: 618 ]]
    -- upvalues: l__CurrentCamera__7 (copy)
    if p174 then
        local v175, v176 = l__CurrentCamera__7:WorldToScreenPoint(p174.Position);
        if v176 then
            return UDim2.new(0, v175.X, 0, v175.Y);
        else
            return UDim2.new(0.5, 0, 0.5, 0);
        end;
    else
        return UDim2.new(0.5, 0, 0.5, 0);
    end;
end;
local function u178() --[[ Line: 625 ]]
    -- upvalues: l__TouchEnabled__13 (copy), l__CartFrame__15 (copy), l__TweenService__3 (copy)
    if l__TouchEnabled__13 then
        l__CartFrame__15.AnchorPoint = Vector2.new(0.5, 1);
        l__CartFrame__15.Position = UDim2.new(0.5, 0, 1, 50);
        l__CartFrame__15.Visible = true;
        l__TweenService__3:Create(l__CartFrame__15, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1, -10)
        }):Play();
    else
        l__CartFrame__15.Position = UDim2.new(1, -270, 1, 50);
        l__CartFrame__15.Visible = true;
        l__TweenService__3:Create(l__CartFrame__15, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -270, 1, -350)
        }):Play();
    end;
end;
local function u179() --[[ Line: 640 ]]
    -- upvalues: l__TouchEnabled__13 (copy), l__TweenService__3 (copy), l__CartFrame__15 (copy), u23 (ref)
    if l__TouchEnabled__13 then
        l__TweenService__3:Create(l__CartFrame__15, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, 0, 1, 50)
        }):Play();
    else
        l__TweenService__3:Create(l__CartFrame__15, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -270, 1, 50)
        }):Play();
    end;
    task.delay(0.3, function() --[[ Line: 648 ]]
        -- upvalues: u23 (ref), l__CartFrame__15 (ref)
        if #u23 == 0 then
            l__CartFrame__15.Visible = false;
        end;
    end);
end;
local function u180() --[[ Line: 653 ]]
    -- upvalues: l__ItemsScroll__16 (copy), u23 (ref)
    local l__AbsolutePosition__29 = l__ItemsScroll__16.AbsolutePosition;
    if l__AbsolutePosition__29 == Vector2.zero then
        return UDim2.new(0.5, 0, 0.5, 0);
    else
        return UDim2.new(0, l__AbsolutePosition__29.X + 37, 0, l__AbsolutePosition__29.Y + #u23 * 71 + 32);
    end;
end;
local function u214(p181, p182, u183) --[[ Line: 659 ]]
    -- upvalues: l__PlayerGui__6 (copy), u177 (copy), u139 (copy), l__CartFrame__15 (copy), u178 (copy), u180 (copy), l__RunService__4 (copy)
    if p181 then
        local u184 = Instance.new("ScreenGui");
        u184.Name = "FlyingClothing";
        u184.DisplayOrder = 100;
        u184.ResetOnSpawn = false;
        u184.Parent = l__PlayerGui__6;
        local u185 = u177(p182);
        local v186 = p181.rarityColor or Color3.fromRGB(180, 180, 180);
        local u187 = Instance.new("Frame");
        u187.Size = UDim2.new(0, 80, 0, 80);
        u187.Position = u185;
        u187.AnchorPoint = Vector2.new(0.5, 0.5);
        u187.BackgroundTransparency = 1;
        u187.Parent = u184;
        local v188 = Instance.new("ViewportFrame");
        v188.Size = UDim2.new(1, 0, 1, 0);
        v188.BackgroundColor3 = Color3.fromRGB(35, 35, 42);
        v188.BackgroundTransparency = 0;
        v188.BorderSizePixel = 0;
        v188.Parent = u187;
        Instance.new("UICorner", v188).CornerRadius = UDim.new(0, 8);
        local v189 = Instance.new("UIStroke");
        v189.Color = v186;
        v189.Thickness = 3;
        v189.Parent = v188;
        local u190 = Instance.new("ImageLabel");
        u190.Size = UDim2.new(2, 0, 2, 0);
        u190.Position = UDim2.new(0.5, 0, 0.5, 0);
        u190.AnchorPoint = Vector2.new(0.5, 0.5);
        u190.BackgroundTransparency = 1;
        u190.Image = "rbxassetid://5028857084";
        u190.ImageColor3 = v186;
        u190.ImageTransparency = 0.5;
        u190.ZIndex = 0;
        u190.Parent = u187;
        local v191 = Instance.new("WorldModel");
        v191.Parent = v188;
        local v192, u193, u194 = u139(p181);
        v192.Parent = v191;
        local u195 = Instance.new("Camera");
        u195.FieldOfView = 50;
        u195.CFrame = CFrame.new(Vector3.new(0, u193, u194), (Vector3.new(0, u193, 0)));
        u195.Parent = v188;
        v188.CurrentCamera = u195;
        if not l__CartFrame__15.Visible then
            u178();
        end;
        task.wait(0.15);
        local u196 = u180();
        local u197 = tick();
        local u198 = 0;
        local u199 = false;
        local u200 = nil;
        u200 = l__RunService__4.RenderStepped:Connect(function(p201) --[[ Line: 674 ]]
            -- upvalues: u199 (ref), u197 (copy), u185 (copy), u196 (copy), u187 (copy), u198 (ref), u195 (copy), u194 (copy), u193 (copy), u190 (copy), u200 (ref), u184 (copy), u183 (copy)
            if u199 then
            else
                local v202 = (tick() - u197) / 0.45;
                local v203 = math.min(v202, 1);
                local v204 = 1 - math.pow(1 - v203, 2.5);
                local v205 = u185.X.Offset + (u196.X.Offset - u185.X.Offset) * v204;
                local v206 = u185.Y.Offset + (u196.Y.Offset - u185.Y.Offset) * v204 - math.sin(v203 * 3.141592653589793) * 50;
                u187.Position = UDim2.new(0, v205, 0, v206);
                local v207 = 1 - v203 * 0.35;
                u187.Size = UDim2.new(0, v207 * 80, 0, v207 * 80);
                u198 = u198 + p201 * 300;
                local v208 = u195;
                local l__new__30 = CFrame.new;
                local v209 = math.rad(u198);
                local v210 = math.sin(v209) * u194;
                local v211 = u193;
                local v212 = math.rad(u198);
                local v213 = math.cos(v212) * u194;
                v208.CFrame = l__new__30(Vector3.new(v210, v211, v213), (Vector3.new(0, u193, 0)));
                u190.ImageTransparency = v203 * 0.4 + 0.5;
                u190.Rotation = u198 * 0.3;
                if v203 >= 1 then
                    u199 = true;
                    if u200 then
                        u200:Disconnect();
                        u200 = nil;
                    end;
                    u184:Destroy();
                    if u183 then
                        task.spawn(u183);
                    end;
                end;
            end;
        end);
        task.delay(2, function() --[[ Line: 685 ]]
            -- upvalues: u184 (copy), u199 (ref), u200 (ref), u183 (copy)
            if u184 and u184.Parent then
                u199 = true;
                if u200 then
                    pcall(function() --[[ Line: 686 ]]
                        -- upvalues: u200 (ref)
                        u200:Disconnect();
                    end);
                    u200 = nil;
                end;
                u184:Destroy();
                if u183 then
                    task.spawn(u183);
                end;
            end;
        end);
    else
        if u183 then
            task.spawn(u183);
        end;
    end;
end;
local function u217(p215) --[[ Line: 694 ]]
    if p215 then
        for _, v216 in ipairs(p215:GetChildren()) do
            if v216:IsA("WorldModel") or v216:IsA("Camera") then
                v216:Destroy();
            end;
        end;
        p215.CurrentCamera = nil;
    end;
end;
local function u236(u218, p219) --[[ Line: 700 ]]
    -- upvalues: l__ItemTemplate__17 (copy), l__ItemsScroll__16 (copy), l__ClothingConfig__9 (copy), u32 (copy), u217 (copy), u139 (copy), u22 (copy), l__TouchEnabled__13 (copy), l__ShopRemotes__8 (copy)
    local v220 = l__ItemTemplate__17:Clone();
    v220.Name = "Item_" .. tostring(u218.uid or p219);
    v220.Visible = true;
    v220.Parent = l__ItemsScroll__16;
    local v221;
    if l__ClothingConfig__9.RARITIES then
        v221 = l__ClothingConfig__9.RARITIES[u218.rarity];
    else
        v221 = nil;
    end;
    local v222 = v221 or (u32[u218.rarity] or u32.Common);
    local v223 = v222.color or Color3.fromRGB(180, 180, 180);
    local v224 = v220:FindFirstChild("RarBar");
    if v224 then
        v224.BackgroundColor3 = v223;
    end;
    local v225 = v220:FindFirstChild("ItemViewport");
    if v225 then
        u217(v225);
        local v226 = Instance.new("WorldModel");
        v226.Parent = v225;
        local v227, v228, v229 = u139(u218);
        v227.Parent = v226;
        local v230 = Instance.new("Camera");
        v230.FieldOfView = 50;
        v230.CFrame = CFrame.new(Vector3.new(0, v228, v229), (Vector3.new(0, v228, 0)));
        v230.Parent = v225;
        v225.CurrentCamera = v230;
        u22[v225] = {
            angle = p219 * 45,
            radius = v229,
            centerY = v228
        };
    end;
    local v231 = v220:FindFirstChild("NameLabel");
    if v231 then
        v231.Text = u218 and (u218.name or "???") or "???";
    end;
    local v232 = v220:FindFirstChild("RarLabel");
    if v232 then
        v232.Text = v222.displayName or (u218.rarity or "Common");
        v232.TextColor3 = v223;
    end;
    local v233 = v220:FindFirstChild("PriceLabel");
    if v233 then
        v233.Text = tostring(u218.price or 0) .. " R$";
    end;
    local u234 = v220:FindFirstChild("RemoveBtn");
    if u234 then
        if l__TouchEnabled__13 then
            u234.Size = UDim2.new(0, 44, 0, 44);
        end;
        u234.MouseButton1Click:Connect(function() --[[ Line: 715 ]]
            -- upvalues: u234 (copy), u218 (copy), l__ShopRemotes__8 (ref)
            if u234.Active then
                u234.Active = false;
                local v235 = u218;
                if v235 then
                    local l__purchaseSource__31 = v235.purchaseSource;
                    if l__purchaseSource__31 then
                        l__purchaseSource__31 = v235.purchaseSource:find("Tokyo");
                    end;
                    if l__purchaseSource__31 and _G.TokyoRemoveItem then
                        _G.TokyoRemoveItem(v235.uid);
                    else
                        l__ShopRemotes__8.RemoveFromCart:FireServer(v235.uid);
                    end;
                end;
                task.delay(0.5, function() --[[ Line: 718 ]]
                    -- upvalues: u234 (ref)
                    if u234 and u234.Parent then
                        u234.Active = true;
                    end;
                end);
            end;
        end);
    end;
    return v220;
end;
local function u248(p237) --[[ Line: 724 ]]
    -- upvalues: l__ItemsScroll__16 (copy), u22 (copy), u23 (ref), l__Count__21 (copy), l__TotalFrame__18 (copy), l__CartFrame__15 (copy), u179 (copy), u178 (copy), u236 (copy), l__TweenService__3 (copy)
    for _, v238 in ipairs(l__ItemsScroll__16:GetChildren()) do
        if v238:IsA("Frame") and v238.Name ~= "ItemTemplate" then
            local v239 = v238:FindFirstChild("ItemViewport");
            if v239 then
                u22[v239] = nil;
            end;
            v238:Destroy();
        end;
    end;
    if #u23 == 0 then
        l__Count__21.Text = "0/15";
        local v240 = l__TotalFrame__18:FindFirstChild("TotalLabel");
        if v240 then
            v240.Text = "TOTAL: 0 R$";
        end;
        if l__CartFrame__15.Visible then
            u179();
        end;
    else
        if not l__CartFrame__15.Visible then
            u178();
        end;
        local v241 = 0;
        for v242, v243 in ipairs(u23) do
            local u244 = u236(v243, v242);
            if p237 and v242 == #u23 then
                u244.Size = UDim2.new(1, 0, 0, 0);
                u244.BackgroundTransparency = 1;
                for _, v245 in ipairs(u244:GetChildren()) do
                    if v245:IsA("GuiObject") and v245.Name ~= "RarBar" then
                        v245.Visible = false;
                    end;
                end;
                task.delay(0.05, function() --[[ Line: 741 ]]
                    -- upvalues: u244 (copy), l__TweenService__3 (ref)
                    if u244 and u244.Parent then
                        l__TweenService__3:Create(u244, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0,
                            Size = UDim2.new(1, 0, 0, 65)
                        }):Play();
                        task.delay(0.15, function() --[[ Line: 745 ]]
                            -- upvalues: u244 (ref)
                            if u244 and u244.Parent then
                                for _, v246 in ipairs(u244:GetChildren()) do
                                    if v246:IsA("GuiObject") then
                                        v246.Visible = true;
                                    end;
                                end;
                            end;
                        end);
                    end;
                end);
            end;
            v241 = v241 + (v243.price or 0);
        end;
        l__ItemsScroll__16.CanvasSize = UDim2.new(0, 0, 0, #u23 * 71);
        local v247 = l__TotalFrame__18:FindFirstChild("TotalLabel");
        if v247 then
            v247.Text = "TOTAL: " .. tostring(v241) .. " R$";
        end;
        l__Count__21.Text = tostring(#u23) .. "/15";
    end;
end;
_G.__ShopClientRenderCart = u248;
local function u259(p249, p250, p251) --[[ Line: 761 ]]
    -- upvalues: l__NotifyFrame__19 (copy), l__TouchEnabled__13 (copy), l__TweenService__3 (copy)
    local u252 = p251 or 3;
    l__NotifyFrame__19.Visible = true;
    local v253 = "!";
    local v254 = Color3.fromRGB(220, 180, 80);
    if p250 == "success" then
        p250 = Color3.fromRGB(80, 200, 80);
        v253 = "✓";
    elseif p250 == "error" then
        p250 = Color3.fromRGB(200, 80, 80);
        v253 = "✕";
    elseif typeof(p250) ~= "Color3" then
        p250 = v254;
    end;
    local v255 = l__NotifyFrame__19:FindFirstChild("Icon");
    local v256 = l__NotifyFrame__19:FindFirstChild("Text");
    local u257 = l__NotifyFrame__19:FindFirstChild("ProgressBar");
    if v255 then
        v255.Text = v253;
        v255.TextColor3 = p250;
    end;
    if v256 then
        v256.Text = tostring(p249 or "");
    end;
    if u257 then
        u257.BackgroundColor3 = p250;
        u257.Size = UDim2.new(1, 0, 0, 3);
    end;
    if l__TouchEnabled__13 then
        l__NotifyFrame__19.AnchorPoint = Vector2.new(0.5, 0);
        l__NotifyFrame__19.Position = UDim2.new(0.5, 0, 0, -65);
        l__TweenService__3:Create(l__NotifyFrame__19, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, 0, 0, 10)
        }):Play();
    else
        l__NotifyFrame__19.Position = UDim2.new(0.5, -150, 0, -65);
        l__TweenService__3:Create(l__NotifyFrame__19, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -150, 0, 15)
        }):Play();
    end;
    if u257 then
        task.delay(0.35, function() --[[ Line: 774 ]]
            -- upvalues: u257 (copy), l__TweenService__3 (ref), u252 (ref)
            if u257 and u257.Parent then
                l__TweenService__3:Create(u257, TweenInfo.new(u252, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(0, 0, 0, 3)
                }):Play();
            end;
        end);
    end;
    task.delay(u252 + 0.35, function() --[[ Line: 775 ]]
        -- upvalues: l__NotifyFrame__19 (ref), l__TouchEnabled__13 (ref), l__TweenService__3 (ref)
        if l__NotifyFrame__19 and l__NotifyFrame__19.Parent then
            local v258 = l__TouchEnabled__13 and UDim2.new(0.5, 0, 0, -65) or UDim2.new(0.5, -150, 0, -65);
            l__TweenService__3:Create(l__NotifyFrame__19, TweenInfo.new(0.25), {
                Position = v258
            }):Play();
            task.wait(0.25);
            if l__NotifyFrame__19 then
                l__NotifyFrame__19.Visible = false;
            end;
        end;
    end);
end;
local function u271(p260, p261, u262, p263, p264) --[[ Line: 783 ]]
    -- upvalues: u20 (ref), l__DialogueFrame__20 (copy), l__TouchEnabled__13 (copy), l__TweenService__3 (copy)
    u20 = true;
    l__DialogueFrame__20.Visible = true;
    local v265 = l__DialogueFrame__20:FindFirstChild("NPCName");
    local u266 = l__DialogueFrame__20:FindFirstChild("DialogueText");
    local v267 = l__DialogueFrame__20:FindFirstChild("Buttons");
    local v268;
    if v267 then
        v268 = v267:FindFirstChild("BuyButton");
    else
        v268 = v267;
    end;
    if v267 then
        v267 = v267:FindFirstChild("CancelButton");
    end;
    if v265 then
        v265.Text = tostring(p260 or "NPC");
        v265.TextColor3 = p261 or Color3.new(1, 1, 1);
    end;
    if u266 then
        u266.Text = "";
    end;
    if v268 and v267 then
        if p264 then
            v268.Visible = true;
            v268.Text = "PAY (" .. tostring(p263 or 0) .. " R$)";
            v267.Size = UDim2.new(0.48, 0, 1, 0);
            v267.Position = UDim2.new(0.52, 0, 0, 0);
        else
            v268.Visible = false;
            v267.Size = UDim2.new(1, 0, 1, 0);
            v267.Position = UDim2.new(0, 0, 0, 0);
        end;
    end;
    if l__TouchEnabled__13 then
        l__DialogueFrame__20.AnchorPoint = Vector2.new(0.5, 1);
        l__DialogueFrame__20.Position = UDim2.new(0.5, 0, 1, 50);
        l__TweenService__3:Create(l__DialogueFrame__20, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, 0, 1, -10)
        }):Play();
    else
        l__DialogueFrame__20.Position = UDim2.new(0.5, -225, 1, 50);
        l__TweenService__3:Create(l__DialogueFrame__20, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.5, -225, 1, -150)
        }):Play();
    end;
    task.spawn(function() --[[ Line: 797 ]]
        -- upvalues: u262 (copy), u20 (ref), u266 (copy)
        local v269 = tostring(u262 or "");
        for v270 = 1, #v269 do
            if not u20 then
                break;
            end;
            if u266 then
                u266.Text = string.sub(v269, 1, v270);
            end;
            task.wait(0.02);
        end;
    end);
end;
local function u273() --[[ Line: 800 ]]
    -- upvalues: u20 (ref), l__TouchEnabled__13 (copy), l__TweenService__3 (copy), l__DialogueFrame__20 (copy), u21 (ref), l__CurrentCamera__7 (copy)
    if u20 then
        u20 = false;
        local v272 = l__TouchEnabled__13 and UDim2.new(0.5, 0, 1, 50) or UDim2.new(0.5, -225, 1, 50);
        l__TweenService__3:Create(l__DialogueFrame__20, TweenInfo.new(0.25), {
            Position = v272
        }):Play();
        task.delay(0.25, function() --[[ Line: 804 ]]
            -- upvalues: l__DialogueFrame__20 (ref)
            l__DialogueFrame__20.Visible = false;
        end);
        if u21 then
            l__CurrentCamera__7.CameraType = u21;
            u21 = nil;
        end;
    end;
end;
local v274 = l__DialogueFrame__20:FindFirstChild("Buttons");
local v275;
if v274 then
    v275 = v274:FindFirstChild("BuyButton");
else
    v275 = v274;
end;
if v274 then
    v274 = v274:FindFirstChild("CancelButton");
end;
if v275 then
    v275.MouseButton1Click:Connect(function() --[[ Line: 809 ]]
        -- upvalues: u20 (ref), u6 (copy), l__ShopRemotes__8 (copy)
        if u20 then
            if _G.IsInTokyoShop and u6 then
                u6:FireServer();
            else
                l__ShopRemotes__8.ConfirmPurchase:FireServer();
            end;
        end;
    end);
end;
if v274 then
    v274.MouseButton1Click:Connect(function() --[[ Line: 810 ]]
        -- upvalues: u20 (ref), l__ShopRemotes__8 (copy), u273 (copy)
        if u20 then
            l__ShopRemotes__8.EndNPCDialogue:FireServer();
            u273();
        end;
    end);
end;
l__ShopRemotes__8.ItemTaken.OnClientEvent:Connect(function(p276, p277) --[[ Line: 816 ]]
    -- upvalues: u24 (ref)
    u24 = {
        clothingData = p276,
        slotPart = p277
    };
end);
l__ShopRemotes__8.CartUpdated.OnClientEvent:Connect(function(p278) --[[ Line: 820 ]]
    -- upvalues: u23 (ref), u24 (ref), u214 (copy), u248 (copy)
    local v279 = p278 or {};
    local v280 = #v279 > #u23;
    u23 = v279;
    if v280 and u24 then
        local v281 = u24;
        u24 = nil;
        u214(v281.clothingData, v281.slotPart, function() --[[ Line: 826 ]]
            -- upvalues: u248 (ref)
            u248(true);
        end);
    else
        u248(false);
    end;
end);
l__ShopRemotes__8.PurchaseResult.OnClientEvent:Connect(function(p282, p283) --[[ Line: 832 ]]
    -- upvalues: u259 (copy), u273 (copy)
    if p282 then
        u259(p283 or "Куплено!", "success", 3);
    else
        local v284 = p283 or "Ошибка покупки";
        u259(v284, "error", (v284:find("Инвентарь") or (v284:find("инвентарь") or v284:find("место"))) and 5 or 3);
    end;
    u273();
end);
if v7 then
    v7.OnClientEvent:Connect(function(p285, p286) --[[ Line: 843 ]]
        -- upvalues: u259 (copy), u273 (copy)
        if p285 then
            u259(p286 or "Куплено!", "success", 3);
        else
            local v287 = p286 or "Purchase failed";
            u259(v287, "error", (v287:find("nventor") or (v287:find("space") or v287:find("full"))) and 5 or 3);
        end;
        u273();
    end);
end;
if v5 then
    v5.OnClientEvent:Connect(function() --[[ Line: 851 ]]
        -- upvalues: u273 (copy)
        u273();
    end);
end;
if v4 then
    v4.OnClientEvent:Connect(function(p288) --[[ Line: 854 ]]
        -- upvalues: u259 (copy)
        local v289 = p288 and (p288.current or "?") or "?";
        local v290 = p288 and (p288.max or 50) or 50;
        u259(string.format("Инвентарь заполнен! Нет места для: %s (%s/%s)", p288 and p288.itemName or "предмет", tostring(v289), (tostring(v290))), "error", 5);
    end);
end;
l__ShopRemotes__8.ShowNotify.OnClientEvent:Connect(u259);
l__ShopRemotes__8.StartNPCDialogue.OnClientEvent:Connect(function(p291, p292, u293, u294, u295, u296, u297) --[[ Line: 862 ]]
    -- upvalues: u20 (ref), u21 (ref), l__CurrentCamera__7 (copy), l__TweenService__3 (copy), u271 (copy)
    if u20 then
    else
        u21 = l__CurrentCamera__7.CameraType;
        l__CurrentCamera__7.CameraType = Enum.CameraType.Scriptable;
        local v298 = p291 + p292 * 4 + Vector3.new(0, 0.5, 0);
        l__TweenService__3:Create(l__CurrentCamera__7, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
            CFrame = CFrame.new(v298, p291)
        }):Play();
        task.delay(0.5, function() --[[ Line: 867 ]]
            -- upvalues: u20 (ref), u271 (ref), u293 (copy), u294 (copy), u295 (copy), u296 (copy), u297 (copy)
            if u20 then
            else
                u271(u293, u294, u295, u296, u297);
            end;
        end);
    end;
end);
l__ShopRemotes__8.EndNPCDialogue.OnClientEvent:Connect(u273);
l__CartFrame__15.Visible = false;
l__NotifyFrame__19.Visible = false;
l__DialogueFrame__20.Visible = false;
v19();
print("========================================");
print("[ShopClient] V15.15 LOADED!");
print("  ✅ Визуал V15.12 (FredokaOne, TextStroke, зелёная цена)");
print("  ✅ BillboardGui только вблизи (proximity)");
print("  ✅ Далеко = ничего, чистые полки");
print("  ✅ Близко = плавный fade-in с ценой");
print("  ✅ Anti-ESP: через стены пусто");
print("  ✅ Фикс очистки slotBoardsGui по префиксу");
print("  ✅ Fade-in / fade-out анимации");
print("========================================");