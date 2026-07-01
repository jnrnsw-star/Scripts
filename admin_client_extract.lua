-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__TweenService__4 = game:GetService("TweenService");
local l__LocalPlayer__5 = l__Players__1.LocalPlayer;
local l__PlayerGui__6 = l__LocalPlayer__5:WaitForChild("PlayerGui");
local v1 = l__ReplicatedStorage__2:FindFirstChild("AdminRemotes");
if not v1 then
    local v2 = tick();
    while not v1 and tick() - v2 < 5 do
        v1 = l__ReplicatedStorage__2:FindFirstChild("AdminRemotes");
        task.wait(0.1);
    end;
end;
if v1 then
    local l__AdminCommand__7 = v1:WaitForChild("AdminCommand", 5);
    local l__AdminRefresh__8 = v1:WaitForChild("AdminRefresh", 5);
    local l__AdminLog__9 = v1:WaitForChild("AdminLog", 5);
    local u3 = v1:FindFirstChild("EventCommand");
    local u4 = v1:FindFirstChild("GeneratePromoCodes");
    if l__AdminCommand__7 then
        local u5 = nil;
        local v6, _ = pcall(function() --[[ Line: 40 ]]
            -- upvalues: u5 (ref), l__AdminCommand__7 (copy)
            u5 = l__AdminCommand__7:InvokeServer("getAdminInfo", {});
        end);
        if v6 and (u5 and u5.isAdmin) then
            local v7 = u5.role or "Unknown";
            local _ = u5.permissions;
            local _ = l__UserInputService__3.TouchEnabled;
            local v8 = tick();
            local u9 = nil;
            while not u9 and tick() - v8 < 10 do
                u9 = l__PlayerGui__6:FindFirstChild("AdminPanel");
                task.wait(0.1);
            end;
            if u9 then
                local l__MainFrame__10 = u9:WaitForChild("MainFrame", 5);
                if l__MainFrame__10 then
                    local l__Header__11 = l__MainFrame__10:WaitForChild("Header", 5);
                    local l__TabBar__12 = l__MainFrame__10:WaitForChild("TabBar", 5);
                    local l__ContentFrame__13 = l__MainFrame__10:WaitForChild("ContentFrame", 5);
                    if l__ContentFrame__13 then
                        local l__PlayersTab__14 = l__ContentFrame__13:WaitForChild("PlayersTab", 5);
                        local l__ShopsTab__15 = l__ContentFrame__13:WaitForChild("ShopsTab", 5);
                        local l__LogsTab__16 = l__ContentFrame__13:WaitForChild("LogsTab", 5);
                        local u10 = l__ContentFrame__13:FindFirstChild("ServerTab");
                        local u11 = l__ContentFrame__13:FindFirstChild("EventTab");
                        local v12 = l__ContentFrame__13:FindFirstChild("ClansTab");
                        if not v12 then
                            v12 = Instance.new("Frame");
                            v12.Name = "ClansTab";
                            v12.Size = UDim2.fromScale(1, 1);
                            v12.BackgroundColor3 = Color3.fromRGB(18, 18, 24);
                            v12.BorderSizePixel = 0;
                            v12.Visible = false;
                            v12.Parent = l__ContentFrame__13;
                        end;
                        local v13 = l__ContentFrame__13:FindFirstChild("BannedTab");
                        if not v13 then
                            v13 = Instance.new("Frame");
                            v13.Name = "BannedTab";
                            v13.Size = UDim2.fromScale(1, 1);
                            v13.BackgroundColor3 = Color3.fromRGB(18, 18, 24);
                            v13.BorderSizePixel = 0;
                            v13.Visible = false;
                            v13.Parent = l__ContentFrame__13;
                        end;
                        local v14 = l__ContentFrame__13:FindFirstChild("PromoTab");
                        if not v14 then
                            v14 = Instance.new("Frame");
                            v14.Name = "PromoTab";
                            v14.Size = UDim2.fromScale(1, 1);
                            v14.BackgroundColor3 = Color3.fromRGB(18, 18, 24);
                            v14.BorderSizePixel = 0;
                            v14.Visible = false;
                            v14.Parent = l__ContentFrame__13;
                        end;
                        local l__PlayerListScroll__17 = l__PlayersTab__14:WaitForChild("PlayerListScroll", 5);
                        l__PlayerListScroll__17:WaitForChild("PlayerEntryTemplate", 5);
                        local l__PlayerCard__18 = l__PlayersTab__14:WaitForChild("PlayerCard", 5);
                        local l__CardInfoLabel__19 = l__PlayerCard__18:WaitForChild("CardInfoLabel", 5);
                        local l__ActionsFrame__20 = l__PlayerCard__18:WaitForChild("ActionsFrame", 5);
                        local l__InventoryToggle__21 = l__PlayerCard__18:WaitForChild("InventoryToggle", 5);
                        local l__InventoryContainer__22 = l__PlayerCard__18:WaitForChild("InventoryContainer", 5);
                        local l__ShopListScroll__23 = l__ShopsTab__15:WaitForChild("ShopListScroll", 5);
                        local l__ShopEntryTemplate__24 = l__ShopListScroll__23:WaitForChild("ShopEntryTemplate", 5);
                        local l__GlobalControls__25 = l__ShopsTab__15:WaitForChild("GlobalControls", 5);
                        local l__LogScroll__26 = l__LogsTab__16:WaitForChild("LogScroll", 5);
                        local l__LogEntryTemplate__27 = l__LogScroll__26:WaitForChild("LogEntryTemplate", 5);
                        local l__LogsTopFrame__28 = l__LogsTab__16:WaitForChild("LogsTopFrame", 5);
                        local l__AdminToggleGui__29 = l__PlayerGui__6:WaitForChild("AdminToggleGui", 5);
                        if l__AdminToggleGui__29 then
                            l__AdminToggleGui__29 = l__AdminToggleGui__29:FindFirstChild("AdminToggleBtn");
                        end;
                        local u15 = {
                            bg = Color3.fromRGB(18, 18, 24),
                            panel = Color3.fromRGB(28, 28, 38),
                            card = Color3.fromRGB(38, 38, 52),
                            cardHover = Color3.fromRGB(48, 48, 65),
                            accent = Color3.fromRGB(88, 101, 242),
                            green = Color3.fromRGB(67, 181, 129),
                            red = Color3.fromRGB(237, 66, 69),
                            orange = Color3.fromRGB(250, 166, 26),
                            yellow = Color3.fromRGB(254, 231, 92),
                            text = Color3.fromRGB(220, 221, 222),
                            textDim = Color3.fromRGB(148, 155, 164),
                            textBright = Color3.fromRGB(255, 255, 255),
                            border = Color3.fromRGB(58, 58, 78),
                            purple = Color3.fromRGB(140, 70, 220),
                            gold = Color3.fromRGB(255, 200, 0),
                            inactive = Color3.fromRGB(60, 60, 68),
                            clanBlue = Color3.fromRGB(60, 140, 200),
                            clanPurple = Color3.fromRGB(130, 70, 200),
                            fake = Color3.fromRGB(100, 100, 110),
                            banRed = Color3.fromRGB(50, 15, 15),
                            promoGreen = Color3.fromRGB(40, 180, 100),
                            promoDark = Color3.fromRGB(20, 35, 25)
                        };
                        local u16 = {
                            Common = Color3.fromRGB(180, 180, 180),
                            Uncommon = Color3.fromRGB(80, 200, 80),
                            Rare = Color3.fromRGB(80, 150, 255),
                            Epic = Color3.fromRGB(180, 80, 255),
                            Legendary = Color3.fromRGB(255, 180, 0)
                        };
                        local u17 = nil;
                        local u18 = nil;
                        local u19 = nil;
                        local u20 = nil;
                        local u21 = nil;
                        local u22 = nil;
                        local u23 = nil;
                        local u24 = "Players";
                        local u25 = nil;
                        local u26 = nil;
                        local u27 = false;
                        local u28 = nil;
                        local u29 = {};
                        local u30 = false;
                        local u31 = nil;
                        local u32 = false;
                        local u33 = 1;
                        local u34 = 1;
                        local u35 = "";
                        local u36 = false;
                        local u37 = false;
                        local u38 = 1;
                        local u39 = 1;
                        local u40 = "";
                        local u41 = false;
                        local u42 = {};
                        local u43 = false;
                        local u44 = {};
                        local u45 = "";
                        local function u50(u46, u47) --[[ Line: 214 ]]
                            -- upvalues: l__AdminCommand__7 (copy)
                            local v48, v49 = pcall(function() --[[ Line: 215 ]]
                                -- upvalues: l__AdminCommand__7 (ref), u46 (copy), u47 (copy)
                                return l__AdminCommand__7:InvokeServer(u46, u47 or {});
                            end);
                            if v48 then
                                return v49 or {};
                            end;
                            warn("[AdminPanel] cmd failed:", u46, (tostring(v49)));
                            return {
                                error = tostring(v49)
                            };
                        end;
                        local function u56(p51) --[[ Line: 244 ]]
                            if p51 and p51 > 0 then
                                local v52 = math.floor(p51);
                                local v53 = math.floor(v52 / 86400);
                                local v54 = math.floor(v52 % 86400 / 3600);
                                local v55 = math.floor(v52 % 3600 / 60);
                                if v53 > 0 then
                                    return v53 .. "д " .. v54 .. "ч";
                                elseif v54 > 0 then
                                    return v54 .. "ч " .. v55 .. "м";
                                else
                                    return v55 .. " мин";
                                end;
                            else
                                return "истёк";
                            end;
                        end;
                        local function v60(p57, p58) --[[ Line: 255 ]]
                            local v59 = Instance.new("UICorner");
                            v59.CornerRadius = UDim.new(0, p58 or 6);
                            v59.Parent = p57;
                            return v59;
                        end;
                        local function u65(p61, p62, p63) --[[ Line: 270 ]]
                            local v64 = Instance.new("UIPadding");
                            v64.PaddingTop = UDim.new(0, p62 or 6);
                            v64.PaddingBottom = UDim.new(0, p62 or 6);
                            v64.PaddingLeft = UDim.new(0, p63 or 8);
                            v64.PaddingRight = UDim.new(0, p63 or 8);
                            v64.Parent = p61;
                        end;
                        local function u72(p66, p67, p68, p69, p70) --[[ Line: 279 ]]
                            local v71 = Instance.new("UIListLayout");
                            v71.FillDirection = p67 or Enum.FillDirection.Vertical;
                            v71.Padding = UDim.new(0, p68 or 4);
                            v71.HorizontalAlignment = p69 or Enum.HorizontalAlignment.Left;
                            v71.VerticalAlignment = p70 or Enum.VerticalAlignment.Top;
                            v71.SortOrder = Enum.SortOrder.LayoutOrder;
                            v71.Parent = p66;
                            return v71;
                        end;
                        local function u80(p73, p74, u75, p76, p77) --[[ Line: 290 ]]
                            -- upvalues: u15 (copy), l__TweenService__4 (copy)
                            local u78 = Instance.new("TextButton");
                            u78.Text = p74;
                            u78.Font = Enum.Font.GothamBold;
                            u78.TextSize = 11;
                            u78.TextColor3 = u15.textBright;
                            u78.BackgroundColor3 = u75;
                            u78.Size = UDim2.new(0, p76 or 80, 0, p77 or 26);
                            u78.AutoButtonColor = false;
                            u78.BorderSizePixel = 0;
                            u78.Parent = p73;
                            local v79 = Instance.new("UICorner");
                            v79.CornerRadius = UDim.new(0, 4);
                            v79.Parent = u78;
                            u78.MouseEnter:Connect(function() --[[ Line: 302 ]]
                                -- upvalues: l__TweenService__4 (ref), u78 (copy), u75 (copy)
                                l__TweenService__4:Create(u78, TweenInfo.new(0.1), {
                                    BackgroundColor3 = Color3.new(math.min(u75.R + 0.1, 1), math.min(u75.G + 0.1, 1), (math.min(u75.B + 0.1, 1)))
                                }):Play();
                            end);
                            u78.MouseLeave:Connect(function() --[[ Line: 311 ]]
                                -- upvalues: l__TweenService__4 (ref), u78 (copy), u75 (copy)
                                l__TweenService__4:Create(u78, TweenInfo.new(0.1), {
                                    BackgroundColor3 = u75
                                }):Play();
                            end);
                            return u78;
                        end;
                        local function v83(p81) --[[ Line: 317 ]]
                            -- upvalues: u72 (copy), u65 (copy)
                            local v82 = Instance.new("ScrollingFrame");
                            v82.Size = UDim2.fromScale(1, 1);
                            v82.BackgroundTransparency = 1;
                            v82.CanvasSize = UDim2.new(0, 0, 0, 0);
                            v82.AutomaticCanvasSize = Enum.AutomaticSize.Y;
                            v82.ScrollBarThickness = 3;
                            v82.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100);
                            v82.BorderSizePixel = 0;
                            v82.Parent = p81;
                            u72(v82, nil, 4);
                            u65(v82, 6, 6);
                            return v82;
                        end;
                        local u84 = nil;
                        local function u99() --[[ Line: 338 ]]
                            -- upvalues: u84 (ref), u9 (ref), u15 (copy)
                            if u84 then
                                return u84;
                            end;
                            local u85 = Instance.new("Frame");
                            u85.Name = "CopyPopupBG";
                            u85.Size = UDim2.fromScale(1, 1);
                            u85.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                            u85.BackgroundTransparency = 0.45;
                            u85.BorderSizePixel = 0;
                            u85.ZIndex = 60;
                            u85.Parent = u9;
                            local u86 = Instance.new("Frame");
                            u86.Name = "CopyPopupCard";
                            u86.Size = UDim2.new(0.75, 0, 0, 320);
                            u86.Position = UDim2.new(0.125, 0, 0.5, -160);
                            u86.BackgroundColor3 = Color3.fromRGB(22, 22, 32);
                            u86.BorderSizePixel = 0;
                            u86.ZIndex = 61;
                            u86.Parent = u9;
                            local v87 = Instance.new("UICorner");
                            v87.CornerRadius = UDim.new(0, 10);
                            v87.Parent = u86;
                            local l__promoGreen__30 = u15.promoGreen;
                            local v88 = Instance.new("UIStroke");
                            v88.Color = l__promoGreen__30 or Color3.fromRGB(58, 58, 78);
                            v88.Thickness = 1.5;
                            v88.Parent = u86;
                            local v89 = Instance.new("UIPadding");
                            v89.PaddingTop = UDim.new(0, 14);
                            v89.PaddingBottom = UDim.new(0, 14);
                            v89.PaddingLeft = UDim.new(0, 16);
                            v89.PaddingRight = UDim.new(0, 16);
                            v89.Parent = u86;
                            local v90 = Instance.new("UIListLayout");
                            v90.FillDirection = Enum.FillDirection.Vertical;
                            v90.SortOrder = Enum.SortOrder.LayoutOrder;
                            v90.Padding = UDim.new(0, 10);
                            v90.Parent = u86;
                            local v91 = Instance.new("TextLabel");
                            v91.BackgroundTransparency = 1;
                            v91.Size = UDim2.new(1, 0, 0, 22);
                            v91.Text = "Нажми Ctrl+A, затем Ctrl+C чтобы скопировать";
                            v91.TextColor3 = u15.promoGreen;
                            v91.TextSize = 12;
                            v91.Font = Enum.Font.GothamBold;
                            v91.TextXAlignment = Enum.TextXAlignment.Left;
                            v91.LayoutOrder = 1;
                            v91.ZIndex = 62;
                            v91.Parent = u86;
                            local v92 = Instance.new("TextBox");
                            v92.Name = "CopyBox";
                            v92.Size = UDim2.new(1, 0, 0, 240);
                            v92.BackgroundColor3 = Color3.fromRGB(12, 18, 14);
                            v92.TextColor3 = Color3.fromRGB(180, 240, 200);
                            v92.PlaceholderColor3 = u15.textDim;
                            v92.TextSize = 12;
                            v92.Font = Enum.Font.Code;
                            v92.TextXAlignment = Enum.TextXAlignment.Left;
                            v92.TextYAlignment = Enum.TextYAlignment.Top;
                            v92.MultiLine = true;
                            v92.TextWrapped = true;
                            v92.ClearTextOnFocus = false;
                            v92.TextEditable = false;
                            v92.BorderSizePixel = 0;
                            v92.LayoutOrder = 2;
                            v92.ZIndex = 62;
                            v92.Parent = u86;
                            local v93 = Instance.new("UICorner");
                            v93.CornerRadius = UDim.new(0, 6);
                            v93.Parent = v92;
                            local v94 = Instance.new("UIPadding");
                            v94.PaddingTop = UDim.new(0, 8);
                            v94.PaddingBottom = UDim.new(0, 8);
                            v94.PaddingLeft = UDim.new(0, 8);
                            v94.PaddingRight = UDim.new(0, 8);
                            v94.Parent = v92;
                            local v95 = Instance.new("TextButton");
                            v95.Size = UDim2.new(1, 0, 0, 30);
                            v95.BackgroundColor3 = Color3.fromRGB(38, 28, 28);
                            v95.Text = "ЗАКРЫТЬ";
                            v95.TextColor3 = u15.red;
                            v95.TextSize = 12;
                            v95.Font = Enum.Font.GothamBold;
                            v95.AutoButtonColor = false;
                            v95.BorderSizePixel = 0;
                            v95.LayoutOrder = 3;
                            v95.ZIndex = 62;
                            v95.Parent = u86;
                            local v96 = Instance.new("UICorner");
                            v96.CornerRadius = UDim.new(0, 6);
                            v96.Parent = v95;
                            local function v97() --[[ Line: 431 ]]
                                -- upvalues: u85 (copy), u86 (copy)
                                u85.Visible = false;
                                u86.Visible = false;
                            end;
                            v95.MouseButton1Click:Connect(v97);
                            u85.InputBegan:Connect(function(p98) --[[ Line: 438 ]]
                                -- upvalues: u85 (copy), u86 (copy)
                                if p98.UserInputType == Enum.UserInputType.MouseButton1 or p98.UserInputType == Enum.UserInputType.Touch then
                                    u85.Visible = false;
                                    u86.Visible = false;
                                end;
                            end);
                            u85.Visible = false;
                            u86.Visible = false;
                            u84 = {
                                bg = u85,
                                card = u86,
                                box = v92,
                                close = v97
                            };
                            return u84;
                        end;
                        local l__InputPopup__31 = u9:WaitForChild("InputPopup", 5);
                        local l__ConfirmPopup__32 = u9:WaitForChild("ConfirmPopup", 5);
                        local l__GiveItemPopup__33 = u9:WaitForChild("GiveItemPopup", 5);
                        local l__PopupOverlay__34 = u9:WaitForChild("PopupOverlay", 5);
                        local function u105(p100, p101, p102) --[[ Line: 484 ]]
                            -- upvalues: l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                            if l__InputPopup__31 then
                                if l__InputPopup__31 then
                                    l__InputPopup__31.Visible = false;
                                end;
                                if l__ConfirmPopup__32 then
                                    l__ConfirmPopup__32.Visible = false;
                                end;
                                if l__GiveItemPopup__33 then
                                    l__GiveItemPopup__33.Visible = false;
                                end;
                                if l__PopupOverlay__34 then
                                    l__PopupOverlay__34.Visible = false;
                                end;
                                u31 = nil;
                                local v103 = l__InputPopup__31:FindFirstChild("PopupTitle");
                                local v104 = l__InputPopup__31:FindFirstChild("PopupInput");
                                if v103 then
                                    v103.Text = p100;
                                end;
                                if v104 then
                                    v104.PlaceholderText = p101 or "Enter value...";
                                    v104.Text = "";
                                end;
                                u31 = p102;
                                if l__PopupOverlay__34 then
                                    l__PopupOverlay__34.Visible = true;
                                end;
                                l__InputPopup__31.Visible = true;
                                if v104 then
                                    task.wait(0.05);
                                    v104:CaptureFocus();
                                end;
                            end;
                        end;
                        if l__InputPopup__31 then
                            local v106 = l__InputPopup__31:FindFirstChild("PopupConfirm");
                            local v107 = l__InputPopup__31:FindFirstChild("PopupCancel");
                            local u108 = l__InputPopup__31:FindFirstChild("PopupInput");
                            if v106 then
                                v106.MouseButton1Click:Connect(function() --[[ Line: 515 ]]
                                    -- upvalues: u108 (copy), u31 (ref), l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy)
                                    local v109 = u108 and u108.Text or "";
                                    local v110 = u31;
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                    if v110 then
                                        v110(v109);
                                    end;
                                end);
                            end;
                            if v107 then
                                v107.MouseButton1Click:Connect(function() --[[ Line: 521 ]]
                                    -- upvalues: l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                end);
                            end;
                        end;
                        if l__ConfirmPopup__32 then
                            local v111 = l__ConfirmPopup__32:FindFirstChild("ConfirmYes");
                            local v112 = l__ConfirmPopup__32:FindFirstChild("ConfirmNo");
                            if v111 then
                                v111.MouseButton1Click:Connect(function() --[[ Line: 528 ]]
                                    -- upvalues: u31 (ref), l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy)
                                    local v113 = u31;
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                    if v113 then
                                        v113();
                                    end;
                                end);
                            end;
                            if v112 then
                                v112.MouseButton1Click:Connect(function() --[[ Line: 533 ]]
                                    -- upvalues: l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                end);
                            end;
                        end;
                        if l__PopupOverlay__34 then
                            l__PopupOverlay__34.MouseButton1Click:Connect(function() --[[ Line: 537 ]]
                                -- upvalues: l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                                if l__InputPopup__31 then
                                    l__InputPopup__31.Visible = false;
                                end;
                                if l__ConfirmPopup__32 then
                                    l__ConfirmPopup__32.Visible = false;
                                end;
                                if l__GiveItemPopup__33 then
                                    l__GiveItemPopup__33.Visible = false;
                                end;
                                if l__PopupOverlay__34 then
                                    l__PopupOverlay__34.Visible = false;
                                end;
                                u31 = nil;
                            end);
                        end;
                        local v114 = l__GiveItemPopup__33 and l__GiveItemPopup__33:FindFirstChild("GiveItemClose");
                        if v114 then
                            v114.MouseButton1Click:Connect(function() --[[ Line: 542 ]]
                                -- upvalues: l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                                if l__InputPopup__31 then
                                    l__InputPopup__31.Visible = false;
                                end;
                                if l__ConfirmPopup__32 then
                                    l__ConfirmPopup__32.Visible = false;
                                end;
                                if l__GiveItemPopup__33 then
                                    l__GiveItemPopup__33.Visible = false;
                                end;
                                if l__PopupOverlay__34 then
                                    l__PopupOverlay__34.Visible = false;
                                end;
                                u31 = nil;
                            end);
                        end;
                        local function u143(p115) --[[ Line: 545 ]]
                            -- upvalues: l__GiveItemPopup__33 (copy), u28 (ref), u50 (copy), l__InputPopup__31 (copy), l__ConfirmPopup__32 (copy), l__PopupOverlay__34 (copy), u31 (ref), u15 (copy)
                            if l__GiveItemPopup__33 then
                                local u116 = tostring(p115 or "");
                                if u116 == "" then
                                else
                                    if not u28 then
                                        u28 = u50("getConfigItems").items or {};
                                    end;
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                    local v117 = l__GiveItemPopup__33:FindFirstChild("GiveItemTitle");
                                    local u118 = l__GiveItemPopup__33:FindFirstChild("GiveItemSearch");
                                    if v117 then
                                        v117.Text = "Give Item → " .. u116;
                                    end;
                                    if u118 then
                                        u118.Text = "";
                                    end;
                                    local u119 = l__GiveItemPopup__33:FindFirstChild("GiveItemScroll");
                                    local u120;
                                    if u119 then
                                        u120 = u119:FindFirstChild("GiveItemEntryTemplate");
                                    else
                                        u120 = u119;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = true;
                                    end;
                                    l__GiveItemPopup__33.Visible = true;
                                    local function u142(p121) --[[ Line: 562 ]]
                                        -- upvalues: u119 (copy), u28 (ref), u120 (copy), u15 (ref), u116 (copy), u50 (ref), l__InputPopup__31 (ref), l__ConfirmPopup__32 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                        if not u119 then
                                            return;
                                        end;
                                        for _, v122 in ipairs(u119:GetChildren()) do
                                            if v122:IsA("TextButton") and v122.Name ~= "GiveItemEntryTemplate" then
                                                v122:Destroy();
                                            end;
                                        end;
                                        local v123 = (p121 or ""):lower();
                                        local v124 = 0;
                                        for v125, u126 in ipairs(u28) do
                                            local l__name__35 = u126.name;
                                            if l__name__35 then
                                                l__name__35 = u126.name:lower():find(v123, 1, true);
                                            end;
                                            local l__brand__36 = u126.brand;
                                            if l__brand__36 then
                                                l__brand__36 = u126.brand:lower():find(v123, 1, true);
                                            end;
                                            if v123 == "" or (l__name__35 or l__brand__36) then
                                                local v127;
                                                if u120 then
                                                    v127 = u120:Clone();
                                                else
                                                    v127 = Instance.new("TextButton");
                                                    v127.Font = Enum.Font.GothamMedium;
                                                    v127.TextSize = 12;
                                                    v127.TextColor3 = u15.text;
                                                    v127.BackgroundColor3 = u15.card;
                                                    v127.Size = UDim2.new(1, 0, 0, 28);
                                                    v127.TextXAlignment = Enum.TextXAlignment.Left;
                                                    v127.AutoButtonColor = false;
                                                    v127.BorderSizePixel = 0;
                                                    local v128 = Instance.new("UICorner");
                                                    v128.CornerRadius = UDim.new(0, 4);
                                                    v128.Parent = v127;
                                                    local v129 = Instance.new("UIPadding");
                                                    v129.PaddingLeft = UDim.new(0, 8);
                                                    v129.Parent = v127;
                                                end;
                                                v127.Name = "GiveItem_" .. v125;
                                                local v130 = "  [";
                                                local v131 = u126.category or "?";
                                                local v132 = "] ";
                                                local v133 = u126.brand or "";
                                                local v134 = " - ";
                                                local v135 = u126.name or "?";
                                                local v136 = " | ";
                                                local v137 = tonumber(u126.fairPrice) or 0;
                                                local v138;
                                                if v137 >= 1000000 then
                                                    v138 = "$" .. string.format("%.1fM", v137 / 1000000);
                                                elseif v137 >= 1000 then
                                                    v138 = "$" .. string.format("%.1fK", v137 / 1000);
                                                else
                                                    v138 = "$" .. tostring(v137);
                                                end;
                                                v127.Text = v130 .. v131 .. v132 .. v133 .. v134 .. v135 .. v136 .. v138;
                                                v127.Visible = true;
                                                v127.LayoutOrder = v125;
                                                v127.Parent = u119;
                                                local u139 = u116;
                                                v127.MouseButton1Click:Connect(function() --[[ Line: 600 ]]
                                                    -- upvalues: u126 (copy), u50 (ref), u139 (copy), l__InputPopup__31 (ref), l__ConfirmPopup__32 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                    local v140 = {
                                                        id = u126.id,
                                                        name = u126.name,
                                                        brand = u126.brand,
                                                        rarity = u126.rarity,
                                                        fairPrice = u126.fairPrice,
                                                        category = u126.category
                                                    };
                                                    if u126.sourceType then
                                                        v140.sourceType = u126.sourceType;
                                                    end;
                                                    if u126.customModelName then
                                                        v140.customModelName = u126.customModelName;
                                                    end;
                                                    if u126.isMultiPart then
                                                        v140.isMultiPart = u126.isMultiPart;
                                                    end;
                                                    if u126.accessoryType then
                                                        v140.accessoryType = u126.accessoryType;
                                                    end;
                                                    local v141 = u50("giveItem", {
                                                        playerName = u139,
                                                        itemData = v140
                                                    });
                                                    if v141.success then
                                                        print("[AdminPanel] Given", v141.itemName, "→", v141.givenTo);
                                                    elseif v141.error then
                                                        warn("[AdminPanel] Give failed:", v141.error);
                                                    end;
                                                    if l__InputPopup__31 then
                                                        l__InputPopup__31.Visible = false;
                                                    end;
                                                    if l__ConfirmPopup__32 then
                                                        l__ConfirmPopup__32.Visible = false;
                                                    end;
                                                    if l__GiveItemPopup__33 then
                                                        l__GiveItemPopup__33.Visible = false;
                                                    end;
                                                    if l__PopupOverlay__34 then
                                                        l__PopupOverlay__34.Visible = false;
                                                    end;
                                                    u31 = nil;
                                                end);
                                                v124 = v124 + 1;
                                                if v124 >= 100 then
                                                    break;
                                                end;
                                            end;
                                        end;
                                    end;
                                    u142("");
                                    if u118 then
                                        u118:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 628 ]]
                                            -- upvalues: l__GiveItemPopup__33 (ref), u142 (copy), u118 (copy)
                                            if l__GiveItemPopup__33.Visible then
                                                u142(u118.Text);
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        local u144 = {
                            Players = l__PlayersTab__14,
                            Shops = l__ShopsTab__15,
                            Logs = l__LogsTab__16,
                            Clans = v12,
                            Banned = v13,
                            Promos = v14
                        };
                        if u10 then
                            u144.Server = u10;
                        end;
                        if u11 then
                            u144.Event = u11;
                        end;
                        local function u150(p145) --[[ Line: 649 ]]
                            -- upvalues: u24 (ref), u144 (copy), l__TabBar__12 (copy), u15 (copy)
                            u24 = p145;
                            for v146, v147 in pairs(u144) do
                                if v147 then
                                    v147.Visible = v146 == p145;
                                end;
                            end;
                            if l__TabBar__12 then
                                for _, v148 in ipairs(l__TabBar__12:GetChildren()) do
                                    if v148:IsA("TextButton") then
                                        local v149 = v148.Name:gsub("Tab_", "");
                                        if v149 == p145 then
                                            v148.BackgroundColor3 = v149 == "Promos" and u15.promoGreen or u15.accent;
                                            v148.TextColor3 = u15.textBright;
                                        else
                                            v148.BackgroundColor3 = u15.panel;
                                            v148.TextColor3 = u15.textDim;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        local u151;
                        if l__TabBar__12 then
                            if not l__TabBar__12:FindFirstChild("Tab_Banned") then
                                local v152 = Instance.new("TextButton");
                                v152.Name = "Tab_Banned";
                                v152.Text = "Bans";
                                v152.Font = Enum.Font.GothamBold;
                                v152.TextSize = 11;
                                v152.TextColor3 = u15.textDim;
                                v152.BackgroundColor3 = u15.panel;
                                v152.BorderSizePixel = 0;
                                v152.Size = UDim2.new(0, 65, 1, 0);
                                v152.Parent = l__TabBar__12;
                                local v153 = Instance.new("UICorner");
                                v153.CornerRadius = UDim.new(0, 4);
                                v153.Parent = v152;
                            end;
                            if not l__TabBar__12:FindFirstChild("Tab_Clans") then
                                local v154 = Instance.new("TextButton");
                                v154.Name = "Tab_Clans";
                                v154.Text = "Clans";
                                v154.Font = Enum.Font.GothamBold;
                                v154.TextSize = 11;
                                v154.TextColor3 = u15.textDim;
                                v154.BackgroundColor3 = u15.panel;
                                v154.BorderSizePixel = 0;
                                v154.Size = UDim2.new(0, 60, 1, 0);
                                v154.Parent = l__TabBar__12;
                                local v155 = Instance.new("UICorner");
                                v155.CornerRadius = UDim.new(0, 4);
                                v155.Parent = v154;
                            end;
                            if not l__TabBar__12:FindFirstChild("Tab_Promos") then
                                local v156 = Instance.new("TextButton");
                                v156.Name = "Tab_Promos";
                                v156.Text = "Promos";
                                v156.Font = Enum.Font.GothamBold;
                                v156.TextSize = 11;
                                v156.TextColor3 = u15.textDim;
                                v156.BackgroundColor3 = u15.panel;
                                v156.BorderSizePixel = 0;
                                v156.Size = UDim2.new(0, 68, 1, 0);
                                v156.Parent = l__TabBar__12;
                                local v157 = Instance.new("UICorner");
                                v157.CornerRadius = UDim.new(0, 4);
                                v157.Parent = v156;
                                local v158 = Color3.fromRGB(40, 120, 70);
                                local v159 = Instance.new("UIStroke");
                                v159.Color = v158 or Color3.fromRGB(58, 58, 78);
                                v159.Thickness = 1;
                                v159.Parent = v156;
                            end;
                            u151 = u84;
                            for _, v160 in ipairs(l__TabBar__12:GetChildren()) do
                                if v160:IsA("TextButton") then
                                    local u161 = v160.Name:gsub("Tab_", "");
                                    v160.MouseButton1Click:Connect(function() --[[ Line: 717 ]]
                                        -- upvalues: u150 (copy), u161 (copy), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref)
                                        u150(u161);
                                        if u161 == "Players" and u17 then
                                            u17();
                                        elseif u161 == "Shops" and u18 then
                                            u18();
                                        elseif u161 == "Logs" and u19 then
                                            u19();
                                        elseif u161 == "Server" and u20 then
                                            u20();
                                        elseif u161 == "Event" and u21 then
                                            u21();
                                        elseif u161 == "Banned" and u22 then
                                            u22();
                                        elseif u161 == "Promos" and u23 then
                                            u23();
                                        else
                                            local _ = u161 == "Clans";
                                        end;
                                    end);
                                end;
                            end;
                        else
                            u151 = u84;
                        end;
                        local function u191(u162) --[[ Line: 781 ]]
                            -- upvalues: l__InventoryContainer__22 (copy), u50 (copy), u15 (copy), u65 (copy), u72 (copy), u80 (copy), u191 (copy), l__ConfirmPopup__32 (copy), l__InputPopup__31 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref)
                            if l__InventoryContainer__22 then
                                for _, v163 in ipairs(l__InventoryContainer__22:GetChildren()) do
                                    if not (v163:IsA("UIListLayout") or v163:IsA("UIPadding")) then
                                        v163:Destroy();
                                    end;
                                end;
                                local v164 = u162.online ~= false;
                                local v165 = {};
                                local v166;
                                if v164 and u162.name then
                                    v166 = u50("getPlayerInventory", {
                                        playerName = u162.name
                                    }).inventory or {};
                                else
                                    v166 = u162.userId and u162.userId ~= 0 and (u50("getOfflinePlayerInventory", {
                                        userId = u162.userId
                                    }).inventory or {}) or v165;
                                end;
                                if not v164 then
                                    local v167 = Instance.new("TextLabel");
                                    v167.BackgroundTransparency = 1;
                                    v167.Size = UDim2.new(1, 0, 0, 20);
                                    v167.Text = "Офлайн инвентарь (только чтение)";
                                    v167.TextColor3 = u15.orange;
                                    v167.TextSize = 10;
                                    v167.Font = Enum.Font.GothamMedium;
                                    v167.TextXAlignment = Enum.TextXAlignment.Center;
                                    v167.LayoutOrder = 0;
                                    v167.Parent = l__InventoryContainer__22;
                                end;
                                if #v166 == 0 then
                                    local v168 = Instance.new("TextLabel");
                                    v168.BackgroundTransparency = 1;
                                    v168.Size = UDim2.new(1, 0, 0, 28);
                                    v168.Text = "Инвентарь пуст";
                                    v168.TextColor3 = u15.textDim;
                                    v168.TextSize = 13;
                                    v168.Font = Enum.Font.GothamMedium;
                                    v168.TextXAlignment = Enum.TextXAlignment.Center;
                                    v168.LayoutOrder = 1;
                                    v168.Parent = l__InventoryContainer__22;
                                else
                                    for v169, u170 in ipairs(v166) do
                                        local v171 = Instance.new("Frame");
                                        v171.Name = "InvItem_" .. v169;
                                        v171.Size = UDim2.new(1, 0, 0, 0);
                                        v171.AutomaticSize = Enum.AutomaticSize.Y;
                                        v171.BackgroundColor3 = u15.bg;
                                        v171.BorderSizePixel = 0;
                                        v171.LayoutOrder = v169;
                                        v171.Parent = l__InventoryContainer__22;
                                        local v172 = Instance.new("UICorner");
                                        v172.CornerRadius = UDim.new(0, 6);
                                        v172.Parent = v171;
                                        u65(v171, 5, 8);
                                        u72(v171, nil, 2);
                                        local v173 = "#" .. v169 .. " " .. (u170.name or "Unknown");
                                        if u170.equipped then
                                            v173 = v173 .. " [EQUIPPED]";
                                        end;
                                        local v174 = Instance.new("TextLabel");
                                        v174.Text = v173;
                                        v174.Font = Enum.Font.GothamBold;
                                        v174.TextSize = 12;
                                        v174.TextColor3 = u170.equipped and u15.green or u15.textBright;
                                        v174.BackgroundTransparency = 1;
                                        v174.Size = UDim2.new(1, 0, 0, 16);
                                        v174.TextXAlignment = Enum.TextXAlignment.Left;
                                        v174.LayoutOrder = 1;
                                        v174.Parent = v171;
                                        local v175 = {};
                                        if u170.category then
                                            local l__category__37 = u170.category;
                                            if u170.accessoryType then
                                                l__category__37 = l__category__37 .. " (" .. u170.accessoryType .. ")";
                                            end;
                                            table.insert(v175, l__category__37);
                                        end;
                                        if u170.brand then
                                            table.insert(v175, u170.brand);
                                        end;
                                        if u170.rarity then
                                            table.insert(v175, u170.rarity);
                                        end;
                                        if u170.fairPrice then
                                            local v176 = tonumber(u170.fairPrice) or 0;
                                            local v177;
                                            if v176 >= 1000000 then
                                                v177 = "$" .. string.format("%.1fM", v176 / 1000000);
                                            elseif v176 >= 1000 then
                                                v177 = "$" .. string.format("%.1fK", v176 / 1000);
                                            else
                                                v177 = "$" .. tostring(v176);
                                            end;
                                            table.insert(v175, v177);
                                        end;
                                        local v178 = Instance.new("TextLabel");
                                        v178.Text = "  " .. table.concat(v175, " | ");
                                        v178.Font = Enum.Font.RobotoMono;
                                        v178.TextSize = 10;
                                        v178.TextColor3 = u15.textDim;
                                        v178.BackgroundTransparency = 1;
                                        v178.Size = UDim2.new(1, 0, 0, 0);
                                        v178.AutomaticSize = Enum.AutomaticSize.Y;
                                        v178.TextXAlignment = Enum.TextXAlignment.Left;
                                        v178.TextWrapped = true;
                                        v178.LayoutOrder = 2;
                                        v178.Parent = v171;
                                        if v164 then
                                            local v179 = Instance.new("Frame");
                                            v179.Size = UDim2.new(1, 0, 0, 26);
                                            v179.BackgroundTransparency = 1;
                                            v179.LayoutOrder = 3;
                                            v179.Parent = v171;
                                            u72(v179, Enum.FillDirection.Horizontal, 4);
                                            u80(v179, "Copy", u15.accent, 60, 24).MouseButton1Click:Connect(function() --[[ Line: 873 ]]
                                                -- upvalues: u50 (ref), u170 (copy)
                                                u50("giveCopyToAdmin", {
                                                    itemData = u170
                                                });
                                            end);
                                            u80(v179, "Remove", u15.red, 65, 24).MouseButton1Click:Connect(function() --[[ Line: 877 ]]
                                                -- upvalues: u170 (copy), u50 (ref), u162 (copy), u191 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                local v180 = "Remove " .. (u170.name or "item") .. "?";
                                                local function v181() --[[ Line: 878 ]]
                                                    -- upvalues: u50 (ref), u162 (ref), u170 (ref), u191 (ref)
                                                    u50("removeItem", {
                                                        playerName = u162.name,
                                                        itemUid = u170.uid
                                                    });
                                                    task.wait(0.3);
                                                    u191(u162);
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    if l__InputPopup__31 then
                                                        l__InputPopup__31.Visible = false;
                                                    end;
                                                    if l__ConfirmPopup__32 then
                                                        l__ConfirmPopup__32.Visible = false;
                                                    end;
                                                    if l__GiveItemPopup__33 then
                                                        l__GiveItemPopup__33.Visible = false;
                                                    end;
                                                    if l__PopupOverlay__34 then
                                                        l__PopupOverlay__34.Visible = false;
                                                    end;
                                                    u31 = nil;
                                                    local v182 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                    if v182 then
                                                        v182.Text = v180;
                                                    end;
                                                    u31 = v181;
                                                    if l__PopupOverlay__34 then
                                                        l__PopupOverlay__34.Visible = true;
                                                    end;
                                                    l__ConfirmPopup__32.Visible = true;
                                                end;
                                            end);
                                            if u170.equipped then
                                                u80(v179, "Unequip", u15.orange, 65, 24).MouseButton1Click:Connect(function() --[[ Line: 885 ]]
                                                    -- upvalues: u50 (ref), u162 (copy), u170 (copy), u191 (ref)
                                                    u50("unequipItem", {
                                                        playerName = u162.name,
                                                        itemUid = u170.uid
                                                    });
                                                    task.wait(0.3);
                                                    u191(u162);
                                                end);
                                            elseif u170.category ~= "Phone" then
                                                u80(v179, "Equip", u15.green, 55, 24).MouseButton1Click:Connect(function() --[[ Line: 892 ]]
                                                    -- upvalues: u50 (ref), u162 (copy), u170 (copy), u191 (ref)
                                                    u50("equipItem", {
                                                        playerName = u162.name,
                                                        itemUid = u170.uid
                                                    });
                                                    task.wait(0.3);
                                                    u191(u162);
                                                end);
                                            end;
                                            u80(v179, "Drop", u15.orange, 55, 24).MouseButton1Click:Connect(function() --[[ Line: 899 ]]
                                                -- upvalues: u50 (ref), u162 (copy), u170 (copy), u191 (ref)
                                                u50("dropItem", {
                                                    playerName = u162.name,
                                                    itemUid = u170.uid
                                                });
                                                task.wait(0.3);
                                                u191(u162);
                                            end);
                                        end;
                                    end;
                                    if v164 then
                                        local v183 = Instance.new("Frame");
                                        v183.Size = UDim2.new(1, 0, 0, 32);
                                        v183.BackgroundTransparency = 1;
                                        v183.LayoutOrder = 9999;
                                        v183.Parent = l__InventoryContainer__22;
                                        u72(v183, Enum.FillDirection.Horizontal, 6);
                                        local v184 = u80(v183, "Clone All To Me", u15.accent, 140, 28);
                                        v184.TextSize = 12;
                                        v184.MouseButton1Click:Connect(function() --[[ Line: 915 ]]
                                            -- upvalues: u50 (ref), u162 (copy), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                            local function v185() --[[ Line: 916 ]]
                                                -- upvalues: u50 (ref), u162 (ref)
                                                u50("cloneAllToAdmin", {
                                                    playerName = u162.name
                                                });
                                            end;
                                            if l__ConfirmPopup__32 then
                                                if l__InputPopup__31 then
                                                    l__InputPopup__31.Visible = false;
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    l__ConfirmPopup__32.Visible = false;
                                                end;
                                                if l__GiveItemPopup__33 then
                                                    l__GiveItemPopup__33.Visible = false;
                                                end;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = false;
                                                end;
                                                u31 = nil;
                                                local v186 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                if v186 then
                                                    v186.Text = "Clone ALL items to yourself?";
                                                end;
                                                u31 = v185;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = true;
                                                end;
                                                l__ConfirmPopup__32.Visible = true;
                                            end;
                                        end);
                                        local v187 = u80(v183, "Clear All", u15.red, 90, 28);
                                        v187.TextSize = 12;
                                        v187.MouseButton1Click:Connect(function() --[[ Line: 922 ]]
                                            -- upvalues: u162 (copy), u50 (ref), u191 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                            local v188 = "DELETE ALL from " .. u162.name .. "?";
                                            local function v189() --[[ Line: 923 ]]
                                                -- upvalues: u50 (ref), u162 (ref), u191 (ref)
                                                u50("clearInventory", {
                                                    playerName = u162.name
                                                });
                                                task.wait(0.3);
                                                u191(u162);
                                            end;
                                            if l__ConfirmPopup__32 then
                                                if l__InputPopup__31 then
                                                    l__InputPopup__31.Visible = false;
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    l__ConfirmPopup__32.Visible = false;
                                                end;
                                                if l__GiveItemPopup__33 then
                                                    l__GiveItemPopup__33.Visible = false;
                                                end;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = false;
                                                end;
                                                u31 = nil;
                                                local v190 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                if v190 then
                                                    v190.Text = v188;
                                                end;
                                                u31 = v189;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = true;
                                                end;
                                                l__ConfirmPopup__32.Visible = true;
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        local function u228(u192) --[[ Line: 931 ]]
                            -- upvalues: l__PlayerCard__18 (copy), l__InventoryContainer__22 (copy), u27 (ref), l__InventoryToggle__21 (copy), u26 (ref), u25 (ref), l__CardInfoLabel__19 (copy), u56 (copy), l__ActionsFrame__20 (copy), u72 (copy), u80 (copy), u15 (copy), u50 (copy), u228 (copy), u17 (ref), l__ConfirmPopup__32 (copy), l__InputPopup__31 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref), u105 (copy), l__LocalPlayer__5 (copy)
                            if l__PlayerCard__18 then
                                l__PlayerCard__18.Visible = true;
                                if l__InventoryContainer__22 then
                                    l__InventoryContainer__22.Visible = false;
                                end;
                                u27 = false;
                                if l__InventoryToggle__21 then
                                    l__InventoryToggle__21.Text = "View Inventory";
                                end;
                                u26 = u192;
                                u25 = u192.name or tostring(u192.userId);
                                local v193 = u192.online ~= false;
                                local v194 = u192.isBanned == true;
                                if l__CardInfoLabel__19 then
                                    local v195;
                                    if v194 and u192.banData then
                                        local l__banData__38 = u192.banData;
                                        local v196;
                                        if l__banData__38.expiresAt == -1 then
                                            v196 = "PERM";
                                        else
                                            local v197 = u56;
                                            local v198 = l__banData__38.expiresAt - os.time();
                                            v196 = v197((math.max(0, v198)));
                                        end;
                                        v195 = "\nBANNED: " .. (l__banData__38.reason or "?") .. "\nАдмин: " .. (l__banData__38.bannedBy or "?") .. " | Осталось: " .. v196;
                                    else
                                        v195 = "";
                                    end;
                                    local v199 = l__CardInfoLabel__19;
                                    local v200 = "Name: ";
                                    local v201 = u192.displayName or (u192.name or "?");
                                    local v202 = "\nUserId: ";
                                    local v203 = tostring(u192.userId);
                                    local v204;
                                    if v193 then
                                        local v205 = "\nMoney: ";
                                        local v206 = tonumber(u192.money) or 0;
                                        local v207;
                                        if v206 >= 1000000 then
                                            v207 = "$" .. string.format("%.1fM", v206 / 1000000);
                                        elseif v206 >= 1000 then
                                            v207 = "$" .. string.format("%.1fK", v206 / 1000);
                                        else
                                            v207 = "$" .. tostring(v206);
                                        end;
                                        v204 = v205 .. v207 or "";
                                    else
                                        v204 = "";
                                    end;
                                    v199.Text = v200 .. v201 .. v202 .. v203 .. v204 .. (v193 and ("\nItems: " .. tostring(u192.itemCount or 0) or "") or "") .. "\nStatus: " .. (v193 and "Online" or "Offline") .. v195;
                                end;
                                if l__ActionsFrame__20 then
                                    for _, v208 in ipairs(l__ActionsFrame__20:GetChildren()) do
                                        if v208:IsA("TextButton") then
                                            v208:SetAttribute("TargetPlayer", u192.name or "");
                                            v208:SetAttribute("TargetUserId", u192.userId);
                                        end;
                                    end;
                                    local v209 = l__ActionsFrame__20:FindFirstChild("BanUnbanRow");
                                    if v209 then
                                        v209:Destroy();
                                    end;
                                    local v210 = Instance.new("Frame");
                                    v210.Name = "BanUnbanRow";
                                    v210.Size = UDim2.new(1, 0, 0, 28);
                                    v210.BackgroundTransparency = 1;
                                    v210.LayoutOrder = 99;
                                    v210.Parent = l__ActionsFrame__20;
                                    u72(v210, Enum.FillDirection.Horizontal, 4);
                                    if v194 then
                                        local v211 = u80(v210, "Разбанить", u15.green, 100, 26);
                                        v211.TextSize = 10;
                                        v211.MouseButton1Click:Connect(function() --[[ Line: 978 ]]
                                            -- upvalues: u192 (copy), u50 (ref), u228 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                            local v212 = "Разбанить " .. (u192.name or tostring(u192.userId)) .. "?";
                                            local function v213() --[[ Line: 979 ]]
                                                -- upvalues: u50 (ref), u192 (ref), u228 (ref), u17 (ref)
                                                if u50("unbanPlayer", {
                                                    userId = u192.userId
                                                }).success then
                                                    u192.isBanned = false;
                                                    u192.banData = nil;
                                                    u228(u192);
                                                    if u17 then
                                                        u17();
                                                    end;
                                                end;
                                            end;
                                            if l__ConfirmPopup__32 then
                                                if l__InputPopup__31 then
                                                    l__InputPopup__31.Visible = false;
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    l__ConfirmPopup__32.Visible = false;
                                                end;
                                                if l__GiveItemPopup__33 then
                                                    l__GiveItemPopup__33.Visible = false;
                                                end;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = false;
                                                end;
                                                u31 = nil;
                                                local v214 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                if v214 then
                                                    v214.Text = v212;
                                                end;
                                                u31 = v213;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = true;
                                                end;
                                                l__ConfirmPopup__32.Visible = true;
                                            end;
                                        end);
                                    else
                                        local v215 = u80(v210, "Забанить", u15.red, 90, 26);
                                        v215.TextSize = 10;
                                        v215.MouseButton1Click:Connect(function() --[[ Line: 993 ]]
                                            -- upvalues: u192 (copy), u105 (ref), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                            local u216 = u192;
                                            u105("Бан: " .. (u216.name or tostring(u216.userId)), "Причина бана...", function(p217) --[[ Line: 742 ]]
                                                -- upvalues: u105 (ref), u216 (copy), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                local u218 = p217 == "" and "Нарушение правил" or p217;
                                                u105("Срок (мин или \'perm\'):", "60 | 1440 | perm", function(p219) --[[ Line: 744 ]]
                                                    -- upvalues: u216 (ref), u218 (ref), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                    local u220;
                                                    if p219:lower() == "perm" or p219 == "-1" then
                                                        u220 = -1;
                                                    else
                                                        local v221 = tonumber(p219);
                                                        if not v221 or v221 < 1 then
                                                            return;
                                                        end;
                                                        u220 = v221 * 60;
                                                    end;
                                                    local v222 = "Забанить " .. (u216.name or tostring(u216.userId)) .. "?\nПричина: " .. u218 .. "\nСрок: " .. (u220 == -1 and "ПЕРМ" or math.floor(u220 / 60) .. " мин");
                                                    local function v224() --[[ Line: 756 ]]
                                                        -- upvalues: u50 (ref), u216 (ref), u218 (ref), u220 (ref), l__LocalPlayer__5 (ref), u17 (ref)
                                                        local v223 = u50("banPlayer", {
                                                            userId = u216.userId,
                                                            playerName = u216.name,
                                                            reason = u218,
                                                            duration = u220
                                                        });
                                                        if v223.success then
                                                            u216.isBanned = true;
                                                            u216.banData = {
                                                                reason = u218,
                                                                bannedBy = l__LocalPlayer__5.Name,
                                                                expiresAt = u220 == -1 and -1 or os.time() + u220
                                                            };
                                                            if u17 then
                                                                u17();
                                                            end;
                                                        else
                                                            warn("[AdminPanel] Ban failed:", v223.error);
                                                        end;
                                                    end;
                                                    if l__ConfirmPopup__32 then
                                                        if l__InputPopup__31 then
                                                            l__InputPopup__31.Visible = false;
                                                        end;
                                                        if l__ConfirmPopup__32 then
                                                            l__ConfirmPopup__32.Visible = false;
                                                        end;
                                                        if l__GiveItemPopup__33 then
                                                            l__GiveItemPopup__33.Visible = false;
                                                        end;
                                                        if l__PopupOverlay__34 then
                                                            l__PopupOverlay__34.Visible = false;
                                                        end;
                                                        u31 = nil;
                                                        local v225 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                        if v225 then
                                                            v225.Text = v222;
                                                        end;
                                                        u31 = v224;
                                                        if l__PopupOverlay__34 then
                                                            l__PopupOverlay__34.Visible = true;
                                                        end;
                                                        l__ConfirmPopup__32.Visible = true;
                                                    end;
                                                end);
                                            end);
                                        end);
                                    end;
                                    if v193 then
                                        local v226 = u80(v210, "Fly ON", u15.clanBlue, 65, 26);
                                        v226.TextSize = 10;
                                        v226.MouseButton1Click:Connect(function() --[[ Line: 999 ]]
                                            -- upvalues: u50 (ref), u192 (copy)
                                            u50("flyPlayer", {
                                                enable = true,
                                                speed = 50,
                                                playerName = u192.name
                                            });
                                        end);
                                        local v227 = u80(v210, "Fly OFF", u15.inactive, 55, 26);
                                        v227.TextSize = 10;
                                        v227.MouseButton1Click:Connect(function() --[[ Line: 1004 ]]
                                            -- upvalues: u50 (ref), u192 (copy)
                                            u50("flyPlayer", {
                                                enable = false,
                                                playerName = u192.name
                                            });
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        if l__InventoryToggle__21 then
                            l__InventoryToggle__21.MouseButton1Click:Connect(function() --[[ Line: 1012 ]]
                                -- upvalues: u26 (ref), u27 (ref), l__InventoryToggle__21 (copy), l__InventoryContainer__22 (copy), u191 (copy)
                                if u26 then
                                    u27 = not u27;
                                    if u27 then
                                        l__InventoryToggle__21.Text = "Hide Inventory";
                                        if l__InventoryContainer__22 then
                                            l__InventoryContainer__22.Visible = true;
                                        end;
                                        u191(u26);
                                    else
                                        l__InventoryToggle__21.Text = "View Inventory";
                                        if l__InventoryContainer__22 then
                                            l__InventoryContainer__22.Visible = false;
                                        end;
                                    end;
                                end;
                            end);
                        end;
                        local function u239() --[[ Line: 1026 ]]
                            -- upvalues: l__PlayerListScroll__17 (copy), u65 (copy), u72 (copy), u15 (copy), u35 (ref), u33 (ref), u17 (ref), u80 (copy), u32 (ref), u37 (ref), u34 (ref)
                            local v229 = l__PlayerListScroll__17:FindFirstChild("PlayersTopBar");
                            if v229 then
                                v229:Destroy();
                            end;
                            local v230 = Instance.new("Frame");
                            v230.Name = "PlayersTopBar";
                            v230.Size = UDim2.new(1, 0, 0, 80);
                            v230.BackgroundColor3 = Color3.fromRGB(22, 22, 32);
                            v230.BorderSizePixel = 0;
                            v230.LayoutOrder = 1;
                            v230.Parent = l__PlayerListScroll__17;
                            local v231 = Instance.new("UICorner");
                            v231.CornerRadius = UDim.new(0, 6);
                            v231.Parent = v230;
                            u65(v230, 4, 6);
                            u72(v230, nil, 4);
                            local u232 = Instance.new("TextBox");
                            u232.Name = "PlayerSearch";
                            u232.Size = UDim2.new(1, 0, 0, 22);
                            u232.BackgroundColor3 = u15.card;
                            u232.Text = u35;
                            u232.PlaceholderText = "Поиск (имя / userId)...";
                            u232.PlaceholderColor3 = u15.textDim;
                            u232.TextColor3 = u15.textBright;
                            u232.TextSize = 11;
                            u232.Font = Enum.Font.GothamMedium;
                            u232.ClearTextOnFocus = false;
                            u232.BorderSizePixel = 0;
                            u232.Parent = v230;
                            local v233 = Instance.new("UICorner");
                            v233.CornerRadius = UDim.new(0, 4);
                            v233.Parent = u232;
                            u65(u232, 0, 6);
                            u232:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 1051 ]]
                                -- upvalues: u35 (ref), u232 (copy), u33 (ref), u17 (ref)
                                u35 = u232.Text;
                                u33 = 1;
                                task.delay(0.4, function() --[[ Line: 1054 ]]
                                    -- upvalues: u35 (ref), u232 (ref), u17 (ref)
                                    if u35 == u232.Text and u17 then
                                        u17();
                                    end;
                                end);
                            end);
                            local v234 = Instance.new("Frame");
                            v234.Size = UDim2.new(1, 0, 0, 22);
                            v234.BackgroundTransparency = 1;
                            v234.Parent = v230;
                            u72(v234, Enum.FillDirection.Horizontal, 4);
                            local v235 = u80(v234, "Онлайн", u32 and u15.card or u15.green, 72, 22);
                            v235.TextSize = 10;
                            v235.MouseButton1Click:Connect(function() --[[ Line: 1068 ]]
                                -- upvalues: u32 (ref), u33 (ref), u35 (ref), u37 (ref), u17 (ref)
                                u32 = false;
                                u33 = 1;
                                u35 = "";
                                u37 = false;
                                if u17 then
                                    u17();
                                end;
                            end);
                            local v236 = u80(v234, "Все", u32 and not u37 and u15.accent or u15.card, 50, 22);
                            v236.TextSize = 10;
                            v236.MouseButton1Click:Connect(function() --[[ Line: 1075 ]]
                                -- upvalues: u32 (ref), u37 (ref), u33 (ref), u17 (ref)
                                u32 = true;
                                u37 = false;
                                u33 = 1;
                                if u17 then
                                    u17();
                                end;
                            end);
                            local v237 = u80(v234, "Баны", u37 and u15.red or u15.card, 55, 22);
                            v237.TextSize = 10;
                            v237.MouseButton1Click:Connect(function() --[[ Line: 1082 ]]
                                -- upvalues: u32 (ref), u37 (ref), u33 (ref), u17 (ref)
                                u32 = true;
                                u37 = not u37;
                                u33 = 1;
                                if u17 then
                                    u17();
                                end;
                            end);
                            if u32 then
                                local v238 = Instance.new("TextLabel");
                                v238.BackgroundTransparency = 1;
                                v238.Size = UDim2.new(1, -200, 1, 0);
                                v238.Text = "Стр. " .. u33 .. "/" .. u34;
                                v238.TextColor3 = u15.textDim;
                                v238.TextSize = 10;
                                v238.Font = Enum.Font.GothamMedium;
                                v238.TextXAlignment = Enum.TextXAlignment.Right;
                                v238.Parent = v234;
                            end;
                        end;
                        local function u277(u240, p241) --[[ Line: 1099 ]]
                            -- upvalues: u15 (copy), l__PlayerListScroll__17 (copy), u72 (copy), u80 (copy), u50 (copy), u17 (ref), l__ConfirmPopup__32 (copy), l__InputPopup__31 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref), u105 (copy), l__LocalPlayer__5 (copy), l__TweenService__4 (copy), u228 (copy)
                            local u242 = u240.online ~= false;
                            local u243 = u240.isBanned == true;
                            local u244 = Instance.new("TextButton");
                            u244.Name = "PlayerEntry_" .. (u240.userId or p241);
                            u244.Size = UDim2.new(1, 0, 0, 44);
                            u244.AutoButtonColor = false;
                            u244.Text = "";
                            u244.BorderSizePixel = 0;
                            u244.LayoutOrder = 10 + p241;
                            u244.BackgroundColor3 = u243 and u15.banRed or (u242 and u15.card or Color3.fromRGB(28, 28, 38));
                            u244.Parent = l__PlayerListScroll__17;
                            local v245 = Instance.new("UICorner");
                            v245.CornerRadius = UDim.new(0, 6);
                            v245.Parent = u244;
                            if u243 then
                                local v246 = Color3.fromRGB(180, 40, 40);
                                local v247 = Instance.new("UIStroke");
                                v247.Color = v246 or Color3.fromRGB(58, 58, 78);
                                v247.Thickness = 1;
                                v247.Parent = u244;
                            end;
                            local v248 = Instance.new("Frame");
                            v248.Size = UDim2.new(0, 8, 0, 8);
                            v248.Position = UDim2.new(0, 8, 0.5, -4);
                            v248.BackgroundColor3 = u242 and u15.green or (u243 and u15.red or u15.textDim);
                            v248.BorderSizePixel = 0;
                            v248.Parent = u244;
                            local v249 = Instance.new("UICorner");
                            v249.CornerRadius = UDim.new(0, 4);
                            v249.Parent = v248;
                            local v250 = Instance.new("TextLabel");
                            v250.BackgroundTransparency = 1;
                            v250.Size = UDim2.new(1, -120, 0, 18);
                            v250.Position = UDim2.fromOffset(22, 4);
                            v250.Text = (u240.name or "Unknown") .. (u243 and "  BAN" or "") .. (u242 and "" or "  OFF");
                            v250.TextColor3 = u243 and u15.red or (u242 and u15.textBright or u15.textDim);
                            v250.TextSize = 12;
                            v250.Font = Enum.Font.GothamBold;
                            v250.TextXAlignment = Enum.TextXAlignment.Left;
                            v250.Parent = u244;
                            local v251;
                            if u242 then
                                local v252 = tonumber(u240.money) or 0;
                                local v253;
                                if v252 >= 1000000 then
                                    v253 = "$" .. string.format("%.1fM", v252 / 1000000);
                                elseif v252 >= 1000 then
                                    v253 = "$" .. string.format("%.1fK", v252 / 1000);
                                else
                                    v253 = "$" .. tostring(v252);
                                end;
                                v251 = v253 .. "  |  " .. tostring(u240.itemCount or 0) .. " items";
                            else
                                local v254;
                                if u240.lastSeen then
                                    local v255 = os.time() - u240.lastSeen;
                                    if v255 < 3600 then
                                        v254 = math.floor(v255 / 60) .. " мин назад";
                                    elseif v255 < 86400 then
                                        v254 = math.floor(v255 / 3600) .. " ч назад";
                                    else
                                        v254 = math.floor(v255 / 86400) .. " дн назад";
                                    end;
                                else
                                    v254 = "давно";
                                end;
                                v251 = "ID: " .. tostring(u240.userId) .. "  |  Был: " .. v254;
                            end;
                            local v256 = Instance.new("TextLabel");
                            v256.BackgroundTransparency = 1;
                            v256.Size = UDim2.new(1, -120, 0, 14);
                            v256.Position = UDim2.fromOffset(22, 22);
                            v256.Text = v251;
                            v256.TextColor3 = u15.textDim;
                            v256.TextSize = 10;
                            v256.Font = Enum.Font.GothamMedium;
                            v256.TextXAlignment = Enum.TextXAlignment.Left;
                            v256.Parent = u244;
                            local v257 = Instance.new("Frame");
                            v257.Size = UDim2.new(0, 110, 0, 40);
                            v257.Position = UDim2.new(1, -114, 0.5, -20);
                            v257.BackgroundTransparency = 1;
                            v257.Parent = u244;
                            u72(v257, Enum.FillDirection.Vertical, 2);
                            if u243 then
                                local v258 = u80(v257, "Разбан", u15.green, 108, 18);
                                v258.TextSize = 9;
                                v258.MouseButton1Click:Connect(function() --[[ Line: 1169 ]]
                                    -- upvalues: u240 (copy), u50 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                    local v259 = "Разбанить " .. (u240.name or tostring(u240.userId)) .. "?";
                                    local function v260() --[[ Line: 1170 ]]
                                        -- upvalues: u50 (ref), u240 (ref), u17 (ref)
                                        if u50("unbanPlayer", {
                                            userId = u240.userId
                                        }).success and u17 then
                                            u17();
                                        end;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        if l__InputPopup__31 then
                                            l__InputPopup__31.Visible = false;
                                        end;
                                        if l__ConfirmPopup__32 then
                                            l__ConfirmPopup__32.Visible = false;
                                        end;
                                        if l__GiveItemPopup__33 then
                                            l__GiveItemPopup__33.Visible = false;
                                        end;
                                        if l__PopupOverlay__34 then
                                            l__PopupOverlay__34.Visible = false;
                                        end;
                                        u31 = nil;
                                        local v261 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                        if v261 then
                                            v261.Text = v259;
                                        end;
                                        u31 = v260;
                                        if l__PopupOverlay__34 then
                                            l__PopupOverlay__34.Visible = true;
                                        end;
                                        l__ConfirmPopup__32.Visible = true;
                                    end;
                                end);
                            else
                                local v262 = u80(v257, "Забанить", u15.red, 108, 18);
                                v262.TextSize = 9;
                                v262.MouseButton1Click:Connect(function() --[[ Line: 1178 ]]
                                    -- upvalues: u240 (copy), u105 (ref), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                    local u263 = u240;
                                    u105("Бан: " .. (u263.name or tostring(u263.userId)), "Причина бана...", function(p264) --[[ Line: 742 ]]
                                        -- upvalues: u105 (ref), u263 (copy), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                        local u265 = p264 == "" and "Нарушение правил" or p264;
                                        u105("Срок (мин или \'perm\'):", "60 | 1440 | perm", function(p266) --[[ Line: 744 ]]
                                            -- upvalues: u263 (ref), u265 (ref), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                            local u267;
                                            if p266:lower() == "perm" or p266 == "-1" then
                                                u267 = -1;
                                            else
                                                local v268 = tonumber(p266);
                                                if not v268 or v268 < 1 then
                                                    return;
                                                end;
                                                u267 = v268 * 60;
                                            end;
                                            local v269 = "Забанить " .. (u263.name or tostring(u263.userId)) .. "?\nПричина: " .. u265 .. "\nСрок: " .. (u267 == -1 and "ПЕРМ" or math.floor(u267 / 60) .. " мин");
                                            local function v271() --[[ Line: 756 ]]
                                                -- upvalues: u50 (ref), u263 (ref), u265 (ref), u267 (ref), l__LocalPlayer__5 (ref), u17 (ref)
                                                local v270 = u50("banPlayer", {
                                                    userId = u263.userId,
                                                    playerName = u263.name,
                                                    reason = u265,
                                                    duration = u267
                                                });
                                                if v270.success then
                                                    u263.isBanned = true;
                                                    u263.banData = {
                                                        reason = u265,
                                                        bannedBy = l__LocalPlayer__5.Name,
                                                        expiresAt = u267 == -1 and -1 or os.time() + u267
                                                    };
                                                    if u17 then
                                                        u17();
                                                    end;
                                                else
                                                    warn("[AdminPanel] Ban failed:", v270.error);
                                                end;
                                            end;
                                            if l__ConfirmPopup__32 then
                                                if l__InputPopup__31 then
                                                    l__InputPopup__31.Visible = false;
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    l__ConfirmPopup__32.Visible = false;
                                                end;
                                                if l__GiveItemPopup__33 then
                                                    l__GiveItemPopup__33.Visible = false;
                                                end;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = false;
                                                end;
                                                u31 = nil;
                                                local v272 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                if v272 then
                                                    v272.Text = v269;
                                                end;
                                                u31 = v271;
                                                if l__PopupOverlay__34 then
                                                    l__PopupOverlay__34.Visible = true;
                                                end;
                                                l__ConfirmPopup__32.Visible = true;
                                            end;
                                        end);
                                    end);
                                end);
                            end;
                            if u242 and u240.name then
                                local v273 = u80(v257, "+Money", u15.orange, 108, 18);
                                v273.TextSize = 9;
                                local l__name__39 = u240.name;
                                v273.MouseButton1Click:Connect(function() --[[ Line: 1184 ]]
                                    -- upvalues: u105 (ref), l__name__39 (copy), u50 (ref)
                                    u105("Дать деньги → " .. l__name__39, "Сумма", function(p274) --[[ Line: 1185 ]]
                                        -- upvalues: u50 (ref), l__name__39 (ref)
                                        local v275 = tonumber(p274);
                                        if v275 and v275 > 0 then
                                            u50("giveMoney", {
                                                playerName = l__name__39,
                                                amount = v275
                                            });
                                        end;
                                    end);
                                end);
                            end;
                            u244.MouseEnter:Connect(function() --[[ Line: 1192 ]]
                                -- upvalues: u243 (copy), l__TweenService__4 (ref), u244 (copy), u15 (ref)
                                if not u243 then
                                    l__TweenService__4:Create(u244, TweenInfo.new(0.1), {
                                        BackgroundColor3 = u15.cardHover
                                    }):Play();
                                end;
                            end);
                            u244.MouseLeave:Connect(function() --[[ Line: 1197 ]]
                                -- upvalues: u243 (copy), u15 (ref), u242 (copy), l__TweenService__4 (ref), u244 (copy)
                                local v276 = u243 and u15.banRed or (u242 and u15.card or Color3.fromRGB(28, 28, 38));
                                l__TweenService__4:Create(u244, TweenInfo.new(0.1), {
                                    BackgroundColor3 = v276
                                }):Play();
                            end);
                            u244.MouseButton1Click:Connect(function() --[[ Line: 1201 ]]
                                -- upvalues: u228 (ref), u240 (copy)
                                u228(u240);
                            end);
                        end;
                        local function u287(p278, p279, p280, p281, p282) --[[ Line: 1204 ]]
                            -- upvalues: u72 (copy), u80 (copy), u15 (copy)
                            local v283 = Instance.new("Frame");
                            v283.Name = "PaginationBar";
                            v283.Size = UDim2.new(1, 0, 0, 28);
                            v283.BackgroundTransparency = 1;
                            v283.LayoutOrder = 9998;
                            v283.Parent = p278;
                            u72(v283, Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Center);
                            local v284 = u80(v283, "<", u15.card, 32, 24);
                            v284.TextSize = 12;
                            v284.MouseButton1Click:Connect(p281);
                            local v285 = Instance.new("TextLabel");
                            v285.BackgroundTransparency = 1;
                            v285.Size = UDim2.new(0, 80, 1, 0);
                            v285.Text = p279 .. " / " .. p280;
                            v285.TextColor3 = u15.textDim;
                            v285.TextSize = 11;
                            v285.Font = Enum.Font.GothamBold;
                            v285.TextXAlignment = Enum.TextXAlignment.Center;
                            v285.Parent = v283;
                            local v286 = u80(v283, ">", u15.card, 32, 24);
                            v286.TextSize = 12;
                            v286.MouseButton1Click:Connect(p282);
                        end;
                        u17 = function() --[[ Line: 1227 ]]
                            -- upvalues: l__PlayerListScroll__17 (copy), l__PlayerCard__18 (copy), l__InventoryContainer__22 (copy), u27 (ref), u25 (ref), u26 (ref), u239 (copy), u32 (ref), u50 (copy), u277 (copy), u15 (copy), u36 (ref), u33 (ref), u35 (ref), u37 (ref), u34 (ref), u287 (copy), u17 (ref)
                            if l__PlayerListScroll__17 then
                                for _, v288 in ipairs(l__PlayerListScroll__17:GetChildren()) do
                                    if (v288:IsA("Frame") or (v288:IsA("TextButton") or v288:IsA("TextLabel"))) and v288.Name ~= "PlayerEntryTemplate" then
                                        v288:Destroy();
                                    end;
                                end;
                                if l__PlayerCard__18 then
                                    l__PlayerCard__18.Visible = false;
                                end;
                                if l__InventoryContainer__22 then
                                    l__InventoryContainer__22.Visible = false;
                                end;
                                u27 = false;
                                u25 = nil;
                                u26 = nil;
                                u239();
                                if u32 then
                                    if u36 then
                                    else
                                        u36 = true;
                                        local u289 = Instance.new("TextLabel");
                                        u289.Name = "LoadingLabel";
                                        u289.BackgroundTransparency = 1;
                                        u289.Size = UDim2.new(1, 0, 0, 30);
                                        u289.Text = "Загрузка из памяти...";
                                        u289.TextColor3 = u15.textDim;
                                        u289.TextSize = 12;
                                        u289.Font = Enum.Font.GothamMedium;
                                        u289.TextXAlignment = Enum.TextXAlignment.Center;
                                        u289.LayoutOrder = 100;
                                        u289.Parent = l__PlayerListScroll__17;
                                        task.spawn(function() --[[ Line: 1269 ]]
                                            -- upvalues: u50 (ref), u33 (ref), u35 (ref), u37 (ref), u36 (ref), u34 (ref), u289 (copy), u277 (ref), u287 (ref), l__PlayerListScroll__17 (ref), u17 (ref), u15 (ref)
                                            local v290 = u50("getGlobalPlayers", {
                                                page = u33,
                                                filter = u35,
                                                bannedOnly = u37
                                            });
                                            u36 = false;
                                            u34 = v290.totalPages or 1;
                                            u33 = math.min(u33, u34);
                                            if u289 and u289.Parent then
                                                u289:Destroy();
                                            end;
                                            local v291 = v290.players or {};
                                            for v292, v293 in ipairs(v291) do
                                                u277(v293, v292);
                                            end;
                                            if u34 > 1 then
                                                u287(l__PlayerListScroll__17, u33, u34, function() --[[ Line: 1283 ]]
                                                    -- upvalues: u33 (ref), u17 (ref)
                                                    if u33 > 1 then
                                                        u33 = u33 - 1;
                                                        u17();
                                                    end;
                                                end, function() --[[ Line: 1286 ]]
                                                    -- upvalues: u33 (ref), u34 (ref), u17 (ref)
                                                    if u33 < u34 then
                                                        u33 = u33 + 1;
                                                        u17();
                                                    end;
                                                end);
                                            end;
                                            if #v291 == 0 then
                                                local v294 = Instance.new("TextLabel");
                                                v294.BackgroundTransparency = 1;
                                                v294.Size = UDim2.new(1, 0, 0, 30);
                                                v294.Text = u37 and "Нет забаненных" or "Ничего не найдено";
                                                v294.TextColor3 = u15.textDim;
                                                v294.TextSize = 12;
                                                v294.Font = Enum.Font.GothamMedium;
                                                v294.TextXAlignment = Enum.TextXAlignment.Center;
                                                v294.LayoutOrder = 999;
                                                v294.Parent = l__PlayerListScroll__17;
                                            end;
                                            local v295 = Instance.new("TextLabel");
                                            v295.BackgroundTransparency = 1;
                                            v295.Size = UDim2.new(1, 0, 0, 16);
                                            v295.Text = "Всего в базе: " .. tostring(v290.totalCount or 0) .. " | Стр. " .. tostring(u33) .. "/" .. tostring(u34);
                                            v295.TextColor3 = u15.textDim;
                                            v295.TextSize = 9;
                                            v295.Font = Enum.Font.GothamMedium;
                                            v295.TextXAlignment = Enum.TextXAlignment.Center;
                                            v295.LayoutOrder = 9999;
                                            v295.Parent = l__PlayerListScroll__17;
                                        end);
                                    end;
                                else
                                    local v296 = u50("getPlayers").players or {};
                                    for v297, v298 in ipairs(v296) do
                                        u277(v298, v297);
                                    end;
                                    if #v296 == 0 then
                                        local v299 = Instance.new("TextLabel");
                                        v299.BackgroundTransparency = 1;
                                        v299.Size = UDim2.new(1, 0, 0, 30);
                                        v299.Text = "Нет игроков онлайн";
                                        v299.TextColor3 = u15.textDim;
                                        v299.TextSize = 12;
                                        v299.Font = Enum.Font.GothamMedium;
                                        v299.TextXAlignment = Enum.TextXAlignment.Center;
                                        v299.LayoutOrder = 999;
                                        v299.Parent = l__PlayerListScroll__17;
                                    end;
                                end;
                            end;
                        end;
                        local function v327() --[[ Line: 1317 ]]
                            -- upvalues: l__ActionsFrame__20 (copy), u105 (copy), u50 (copy), u17 (ref), u143 (copy), u27 (ref), u26 (ref), u191 (copy), l__ConfirmPopup__32 (copy), l__InputPopup__31 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref), u30 (ref), l__LocalPlayer__5 (copy), l__Players__1 (copy)
                            if l__ActionsFrame__20 then
                                for _, u300 in ipairs(l__ActionsFrame__20:GetChildren()) do
                                    if u300:IsA("TextButton") then
                                        local u301 = u300.Name:gsub("Action_", "");
                                        u300.MouseButton1Click:Connect(function() --[[ Line: 1322 ]]
                                            -- upvalues: u300 (copy), u301 (copy), u105 (ref), u50 (ref), u17 (ref), u143 (ref), u27 (ref), u26 (ref), u191 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref), u30 (ref), l__LocalPlayer__5 (ref), l__Players__1 (ref)
                                            local u302 = u300:GetAttribute("TargetPlayer") or "";
                                            if u302 == "" then
                                            elseif u301 == "GiveMoney" then
                                                u105("Give Money to " .. u302, "Enter amount", function(p303) --[[ Line: 1326 ]]
                                                    -- upvalues: u50 (ref), u302 (copy), u17 (ref)
                                                    local v304 = tonumber(p303);
                                                    if v304 then
                                                        u50("giveMoney", {
                                                            playerName = u302,
                                                            amount = v304
                                                        });
                                                        task.wait(0.3);
                                                        u17();
                                                    end;
                                                end);
                                            elseif u301 == "TakeMoney" then
                                                u105("Take Money from " .. u302, "Enter amount", function(p305) --[[ Line: 1333 ]]
                                                    -- upvalues: u50 (ref), u302 (copy), u17 (ref)
                                                    local v306 = tonumber(p305);
                                                    if v306 then
                                                        u50("takeMoney", {
                                                            playerName = u302,
                                                            amount = v306
                                                        });
                                                        task.wait(0.3);
                                                        u17();
                                                    end;
                                                end);
                                            elseif u301 == "GiveItem" then
                                                u143(u302);
                                            elseif u301 == "ClearInv" then
                                                local v307 = "Clear ALL inventory of " .. u302 .. "?";
                                                local function v308() --[[ Line: 1341 ]]
                                                    -- upvalues: u50 (ref), u302 (copy), u27 (ref), u26 (ref), u191 (ref)
                                                    u50("clearInventory", {
                                                        playerName = u302
                                                    });
                                                    task.wait(0.3);
                                                    if u27 and u26 then
                                                        u191(u26);
                                                    end;
                                                end;
                                                if l__ConfirmPopup__32 then
                                                    if l__InputPopup__31 then
                                                        l__InputPopup__31.Visible = false;
                                                    end;
                                                    if l__ConfirmPopup__32 then
                                                        l__ConfirmPopup__32.Visible = false;
                                                    end;
                                                    if l__GiveItemPopup__33 then
                                                        l__GiveItemPopup__33.Visible = false;
                                                    end;
                                                    if l__PopupOverlay__34 then
                                                        l__PopupOverlay__34.Visible = false;
                                                    end;
                                                    u31 = nil;
                                                    local v309 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                    if v309 then
                                                        v309.Text = v307;
                                                    end;
                                                    u31 = v308;
                                                    if l__PopupOverlay__34 then
                                                        l__PopupOverlay__34.Visible = true;
                                                    end;
                                                    l__ConfirmPopup__32.Visible = true;
                                                end;
                                            elseif u301 == "Goto" then
                                                u50("gotoPlayer", {
                                                    playerName = u302
                                                });
                                            elseif u301 == "Bring" then
                                                u50("bringPlayer", {
                                                    playerName = u302
                                                });
                                            else
                                                if u301 == "Spectate" then
                                                    if u30 then
                                                        u30 = false;
                                                        u300.Text = "Spectate";
                                                        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
                                                        local l__Character__40 = l__LocalPlayer__5.Character;
                                                        local v310 = l__Character__40 and l__Character__40:FindFirstChildOfClass("Humanoid");
                                                        if v310 then
                                                            workspace.CurrentCamera.CameraSubject = v310;
                                                        end;
                                                    else
                                                        local v311 = l__Players__1:FindFirstChild(u302);
                                                        local v312 = v311 and (v311.Character and v311.Character:FindFirstChildOfClass("Humanoid"));
                                                        if v312 then
                                                            u30 = true;
                                                            u300.Text = "Stop Spec";
                                                            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
                                                            workspace.CurrentCamera.CameraSubject = v312;
                                                        end;
                                                    end;
                                                else
                                                    if u301 == "Freeze" then
                                                        u50("freezePlayer", {
                                                            playerName = u302
                                                        });
                                                        return;
                                                    end;
                                                    if u301 == "Unfreeze" then
                                                        u50("unfreezePlayer", {
                                                            playerName = u302
                                                        });
                                                        return;
                                                    end;
                                                    if u301 == "Respawn" then
                                                        local v313 = "Respawn " .. u302 .. "?";
                                                        local function v314() --[[ Line: 1371 ]]
                                                            -- upvalues: u50 (ref), u302 (copy)
                                                            u50("respawnPlayer", {
                                                                playerName = u302
                                                            });
                                                        end;
                                                        if l__ConfirmPopup__32 then
                                                            if l__InputPopup__31 then
                                                                l__InputPopup__31.Visible = false;
                                                            end;
                                                            if l__ConfirmPopup__32 then
                                                                l__ConfirmPopup__32.Visible = false;
                                                            end;
                                                            if l__GiveItemPopup__33 then
                                                                l__GiveItemPopup__33.Visible = false;
                                                            end;
                                                            if l__PopupOverlay__34 then
                                                                l__PopupOverlay__34.Visible = false;
                                                            end;
                                                            u31 = nil;
                                                            local v315 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                            if v315 then
                                                                v315.Text = v313;
                                                            end;
                                                            u31 = v314;
                                                            if l__PopupOverlay__34 then
                                                                l__PopupOverlay__34.Visible = true;
                                                            end;
                                                            l__ConfirmPopup__32.Visible = true;
                                                            return;
                                                        else
                                                            return;
                                                        end;
                                                    end;
                                                    if u301 == "Kick" then
                                                        u105("Kick " .. u302, "Enter reason", function(p316) --[[ Line: 1375 ]]
                                                            -- upvalues: u50 (ref), u302 (copy), u17 (ref)
                                                            if p316 and p316 ~= "" then
                                                                u50("kickPlayer", {
                                                                    playerName = u302,
                                                                    reason = p316
                                                                });
                                                                task.wait(0.5);
                                                                u17();
                                                            end;
                                                        end);
                                                        return;
                                                    end;
                                                    if u301 == "Ban" then
                                                        if u26 then
                                                            local u317 = u26;
                                                            u105("Бан: " .. (u317.name or tostring(u317.userId)), "Причина бана...", function(p318) --[[ Line: 742 ]]
                                                                -- upvalues: u105 (ref), u317 (copy), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                                local u319 = p318 == "" and "Нарушение правил" or p318;
                                                                u105("Срок (мин или \'perm\'):", "60 | 1440 | perm", function(p320) --[[ Line: 744 ]]
                                                                    -- upvalues: u317 (ref), u319 (ref), u50 (ref), l__LocalPlayer__5 (ref), u17 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                                                    local u321;
                                                                    if p320:lower() == "perm" or p320 == "-1" then
                                                                        u321 = -1;
                                                                    else
                                                                        local v322 = tonumber(p320);
                                                                        if not v322 or v322 < 1 then
                                                                            return;
                                                                        end;
                                                                        u321 = v322 * 60;
                                                                    end;
                                                                    local v323 = "Забанить " .. (u317.name or tostring(u317.userId)) .. "?\nПричина: " .. u319 .. "\nСрок: " .. (u321 == -1 and "ПЕРМ" or math.floor(u321 / 60) .. " мин");
                                                                    local function v325() --[[ Line: 756 ]]
                                                                        -- upvalues: u50 (ref), u317 (ref), u319 (ref), u321 (ref), l__LocalPlayer__5 (ref), u17 (ref)
                                                                        local v324 = u50("banPlayer", {
                                                                            userId = u317.userId,
                                                                            playerName = u317.name,
                                                                            reason = u319,
                                                                            duration = u321
                                                                        });
                                                                        if v324.success then
                                                                            u317.isBanned = true;
                                                                            u317.banData = {
                                                                                reason = u319,
                                                                                bannedBy = l__LocalPlayer__5.Name,
                                                                                expiresAt = u321 == -1 and -1 or os.time() + u321
                                                                            };
                                                                            if u17 then
                                                                                u17();
                                                                            end;
                                                                        else
                                                                            warn("[AdminPanel] Ban failed:", v324.error);
                                                                        end;
                                                                    end;
                                                                    if l__ConfirmPopup__32 then
                                                                        if l__InputPopup__31 then
                                                                            l__InputPopup__31.Visible = false;
                                                                        end;
                                                                        if l__ConfirmPopup__32 then
                                                                            l__ConfirmPopup__32.Visible = false;
                                                                        end;
                                                                        if l__GiveItemPopup__33 then
                                                                            l__GiveItemPopup__33.Visible = false;
                                                                        end;
                                                                        if l__PopupOverlay__34 then
                                                                            l__PopupOverlay__34.Visible = false;
                                                                        end;
                                                                        u31 = nil;
                                                                        local v326 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                                                        if v326 then
                                                                            v326.Text = v323;
                                                                        end;
                                                                        u31 = v325;
                                                                        if l__PopupOverlay__34 then
                                                                            l__PopupOverlay__34.Visible = true;
                                                                        end;
                                                                        l__ConfirmPopup__32.Visible = true;
                                                                    end;
                                                                end);
                                                            end);
                                                        end;
                                                    else
                                                        if u301 == "Resync" then
                                                            u50("resyncAccessories", {
                                                                playerName = u302
                                                            });
                                                            return;
                                                        end;
                                                        if u301 == "ClearStuck" then
                                                            u50("clearStuckAccessories", {
                                                                playerName = u302
                                                            });
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        local u328 = Instance.new("Frame");
                        u328.Size = UDim2.new(1, 0, 0, 56);
                        u328.BackgroundColor3 = Color3.fromRGB(22, 22, 32);
                        u328.BorderSizePixel = 0;
                        u328.Parent = v13;
                        u65(u328, 4, 6);
                        u72(u328, nil, 4);
                        local u329 = Instance.new("TextBox");
                        u329.Size = UDim2.new(1, 0, 0, 22);
                        u329.BackgroundColor3 = Color3.fromRGB(40, 20, 20);
                        u329.Text = "";
                        u329.PlaceholderText = "Поиск забаненных...";
                        u329.PlaceholderColor3 = u15.textDim;
                        u329.TextColor3 = u15.textBright;
                        u329.TextSize = 11;
                        u329.Font = Enum.Font.GothamMedium;
                        u329.ClearTextOnFocus = false;
                        u329.BorderSizePixel = 0;
                        u329.Parent = u328;
                        local v330 = Instance.new("UICorner");
                        v330.CornerRadius = UDim.new(0, 4);
                        v330.Parent = u329;
                        u65(u329, 0, 6);
                        local v331 = Color3.fromRGB(180, 40, 40);
                        local v332 = Instance.new("UIStroke");
                        v332.Color = v331 or Color3.fromRGB(58, 58, 78);
                        v332.Thickness = 1;
                        v332.Parent = u329;
                        local v333 = Instance.new("Frame");
                        v333.Size = UDim2.new(1, 0, 0, 22);
                        v333.BackgroundTransparency = 1;
                        v333.Parent = u328;
                        u72(v333, Enum.FillDirection.Horizontal, 4);
                        local v334 = u80(v333, "Обновить", u15.red, 80, 22);
                        v334.TextSize = 10;
                        v334.MouseButton1Click:Connect(function() --[[ Line: 1426 ]]
                            -- upvalues: u38 (ref), u22 (ref)
                            u38 = 1;
                            if u22 then
                                u22();
                            end;
                        end);
                        local v335 = Instance.new("TextLabel");
                        v335.Name = "BannedCountLbl";
                        v335.BackgroundTransparency = 1;
                        v335.Size = UDim2.new(1, -90, 1, 0);
                        v335.Text = "Загрузка...";
                        v335.TextColor3 = u15.red;
                        v335.TextSize = 11;
                        v335.Font = Enum.Font.GothamBold;
                        v335.TextXAlignment = Enum.TextXAlignment.Right;
                        v335.Parent = v333;
                        local v336 = Instance.new("Frame");
                        v336.Size = UDim2.new(1, 0, 1, -60);
                        v336.Position = UDim2.new(0, 0, 0, 60);
                        v336.BackgroundTransparency = 1;
                        v336.BorderSizePixel = 0;
                        v336.Parent = v13;
                        local u337 = v83(v336);
                        u329:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 1450 ]]
                            -- upvalues: u40 (ref), u329 (copy), u38 (ref), u22 (ref)
                            u40 = u329.Text;
                            u38 = 1;
                            task.delay(0.4, function() --[[ Line: 1453 ]]
                                -- upvalues: u40 (ref), u329 (ref), u22 (ref)
                                if u40 == u329.Text and u22 then
                                    u22();
                                end;
                            end);
                        end);
                        local function u366(u338, p339) --[[ Line: 1460 ]]
                            -- upvalues: u15 (copy), u337 (copy), u65 (copy), u72 (copy), u56 (copy), u80 (copy), u50 (copy), u22 (ref), l__ConfirmPopup__32 (copy), l__InputPopup__31 (copy), l__GiveItemPopup__33 (copy), l__PopupOverlay__34 (copy), u31 (ref), u105 (copy)
                            local v340 = u338.online == true;
                            local u341 = u338.banData or {};
                            local v342 = u338.banType or "PERM";
                            local v343 = u338.timeLeft or 0;
                            local v344 = Instance.new("Frame");
                            v344.Name = "BannedEntry_" .. (u338.userId or p339);
                            v344.Size = UDim2.new(1, 0, 0, 0);
                            v344.AutomaticSize = Enum.AutomaticSize.Y;
                            v344.BackgroundColor3 = u15.banRed;
                            v344.BorderSizePixel = 0;
                            v344.LayoutOrder = p339;
                            v344.Parent = u337;
                            local v345 = Instance.new("UICorner");
                            v345.CornerRadius = UDim.new(0, 6);
                            v345.Parent = v344;
                            local v346 = Color3.fromRGB(180, 40, 40);
                            local v347 = Instance.new("UIStroke");
                            v347.Color = v346 or Color3.fromRGB(58, 58, 78);
                            v347.Thickness = 1;
                            v347.Parent = v344;
                            u65(v344, 6, 10);
                            u72(v344, nil, 3);
                            local v348 = Instance.new("Frame");
                            v348.Size = UDim2.new(1, 0, 0, 20);
                            v348.BackgroundTransparency = 1;
                            v348.LayoutOrder = 1;
                            v348.Parent = v344;
                            u72(v348, Enum.FillDirection.Horizontal, 6);
                            local v349 = Instance.new("TextLabel");
                            v349.BackgroundTransparency = 1;
                            v349.Size = UDim2.new(0.5, 0, 1, 0);
                            v349.Text = (u338.name or "Unknown") .. (v340 and " ONLINE" or "");
                            v349.TextColor3 = v340 and u15.orange or u15.red;
                            v349.TextSize = 13;
                            v349.Font = Enum.Font.GothamBold;
                            v349.TextXAlignment = Enum.TextXAlignment.Left;
                            v349.Parent = v348;
                            local v350 = Instance.new("TextLabel");
                            v350.BackgroundTransparency = 1;
                            v350.Size = UDim2.new(0.5, 0, 1, 0);
                            v350.Text = v342 == "PERM" and "PERM" or "Осталось: " .. u56(v343);
                            v350.TextColor3 = v342 == "PERM" and u15.red or u15.orange;
                            v350.TextSize = 11;
                            v350.Font = Enum.Font.GothamBold;
                            v350.TextXAlignment = Enum.TextXAlignment.Right;
                            v350.Parent = v348;
                            local v351 = Instance.new("TextLabel");
                            v351.BackgroundTransparency = 1;
                            v351.Size = UDim2.new(1, 0, 0, 0);
                            v351.AutomaticSize = Enum.AutomaticSize.Y;
                            v351.Text = "Причина: " .. (u341.reason or "?") .. "\nАдмин: " .. (u341.bannedBy or "?") .. "  |  ID: " .. tostring(u338.userId);
                            v351.TextColor3 = u15.textDim;
                            v351.TextSize = 10;
                            v351.Font = Enum.Font.GothamMedium;
                            v351.TextXAlignment = Enum.TextXAlignment.Left;
                            v351.TextWrapped = true;
                            v351.LayoutOrder = 2;
                            v351.Parent = v344;
                            local v352 = Instance.new("Frame");
                            v352.Size = UDim2.new(1, 0, 0, 26);
                            v352.BackgroundTransparency = 1;
                            v352.LayoutOrder = 3;
                            v352.Parent = v344;
                            u72(v352, Enum.FillDirection.Horizontal, 4);
                            local v353 = u80(v352, "Разбанить", u15.green, 90, 24);
                            v353.TextSize = 10;
                            v353.MouseButton1Click:Connect(function() --[[ Line: 1523 ]]
                                -- upvalues: u338 (copy), u50 (ref), u22 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                local v354 = "Разбанить " .. (u338.name or tostring(u338.userId)) .. "?";
                                local function v355() --[[ Line: 1524 ]]
                                    -- upvalues: u50 (ref), u338 (ref), u22 (ref)
                                    if u50("unbanPlayer", {
                                        userId = u338.userId
                                    }).success and u22 then
                                        u22();
                                    end;
                                end;
                                if l__ConfirmPopup__32 then
                                    if l__InputPopup__31 then
                                        l__InputPopup__31.Visible = false;
                                    end;
                                    if l__ConfirmPopup__32 then
                                        l__ConfirmPopup__32.Visible = false;
                                    end;
                                    if l__GiveItemPopup__33 then
                                        l__GiveItemPopup__33.Visible = false;
                                    end;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = false;
                                    end;
                                    u31 = nil;
                                    local v356 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                    if v356 then
                                        v356.Text = v354;
                                    end;
                                    u31 = v355;
                                    if l__PopupOverlay__34 then
                                        l__PopupOverlay__34.Visible = true;
                                    end;
                                    l__ConfirmPopup__32.Visible = true;
                                end;
                            end);
                            local v357 = u80(v352, "Изменить", u15.orange, 80, 24);
                            v357.TextSize = 10;
                            v357.MouseButton1Click:Connect(function() --[[ Line: 1531 ]]
                                -- upvalues: u105 (ref), u50 (ref), u338 (copy), u341 (copy), u22 (ref)
                                u105("Новый срок (мин или \'perm\'):", "60 | perm", function(p358) --[[ Line: 1532 ]]
                                    -- upvalues: u50 (ref), u338 (ref), u341 (ref), u22 (ref)
                                    local v359;
                                    if p358:lower() == "perm" then
                                        v359 = -1;
                                    else
                                        local v360 = tonumber(p358);
                                        if not v360 or v360 < 1 then
                                            return;
                                        end;
                                        v359 = v360 * 60;
                                    end;
                                    if u50("banPlayer", {
                                        userId = u338.userId,
                                        reason = u341.reason or "Нарушение правил",
                                        duration = v359
                                    }).success and u22 then
                                        u22();
                                    end;
                                end);
                            end);
                            if v340 and u338.name then
                                local v361 = u80(v352, "Обнулить", u15.red, 80, 24);
                                v361.TextSize = 10;
                                local l__name__41 = u338.name;
                                v361.MouseButton1Click:Connect(function() --[[ Line: 1552 ]]
                                    -- upvalues: l__name__41 (copy), u50 (ref), l__ConfirmPopup__32 (ref), l__InputPopup__31 (ref), l__GiveItemPopup__33 (ref), l__PopupOverlay__34 (ref), u31 (ref)
                                    local v362 = "Обнулить деньги " .. l__name__41 .. "?";
                                    local function v363() --[[ Line: 1553 ]]
                                        -- upvalues: u50 (ref), l__name__41 (ref)
                                        u50("takeMoney", {
                                            amount = 999999999,
                                            playerName = l__name__41
                                        });
                                    end;
                                    if l__ConfirmPopup__32 then
                                        if l__InputPopup__31 then
                                            l__InputPopup__31.Visible = false;
                                        end;
                                        if l__ConfirmPopup__32 then
                                            l__ConfirmPopup__32.Visible = false;
                                        end;
                                        if l__GiveItemPopup__33 then
                                            l__GiveItemPopup__33.Visible = false;
                                        end;
                                        if l__PopupOverlay__34 then
                                            l__PopupOverlay__34.Visible = false;
                                        end;
                                        u31 = nil;
                                        local v364 = l__ConfirmPopup__32:FindFirstChild("ConfirmTitle");
                                        if v364 then
                                            v364.Text = v362;
                                        end;
                                        u31 = v363;
                                        if l__PopupOverlay__34 then
                                            l__PopupOverlay__34.Visible = true;
                                        end;
                                        l__ConfirmPopup__32.Visible = true;
                                    end;
                                end);
                                local v365 = u80(v352, "Кик", Color3.fromRGB(100, 50, 50), 45, 24);
                                v365.TextSize = 9;
                                v365.MouseButton1Click:Connect(function() --[[ Line: 1559 ]]
                                    -- upvalues: u50 (ref), l__name__41 (copy)
                                    u50("kickPlayer", {
                                        reason = "Banned player",
                                        playerName = l__name__41
                                    });
                                end);
                            end;
                        end;
                        local function u376() --[[ Line: 1565 ]]
                            -- upvalues: u337 (copy), u41 (ref), u15 (copy), u50 (copy), u38 (ref), u40 (ref), u39 (ref), u328 (copy), u366 (copy), u287 (copy), u376 (ref)
                            for _, v367 in ipairs(u337:GetChildren()) do
                                if not (v367:IsA("UIListLayout") or v367:IsA("UIPadding")) then
                                    v367:Destroy();
                                end;
                            end;
                            if u41 then
                            else
                                u41 = true;
                                local u368 = Instance.new("TextLabel");
                                u368.BackgroundTransparency = 1;
                                u368.Size = UDim2.new(1, 0, 0, 30);
                                u368.Text = "Загрузка бан-листа...";
                                u368.TextColor3 = u15.textDim;
                                u368.TextSize = 12;
                                u368.Font = Enum.Font.GothamMedium;
                                u368.TextXAlignment = Enum.TextXAlignment.Center;
                                u368.LayoutOrder = 1;
                                u368.Parent = u337;
                                task.spawn(function() --[[ Line: 1581 ]]
                                    -- upvalues: u50 (ref), u38 (ref), u40 (ref), u41 (ref), u39 (ref), u368 (copy), u328 (ref), u15 (ref), u337 (ref), u366 (ref), u287 (ref), u376 (ref)
                                    local v369 = u50("getBannedPlayers", {
                                        page = u38,
                                        filter = u40
                                    });
                                    u41 = false;
                                    u39 = v369.totalPages or 1;
                                    u38 = math.min(u38, u39);
                                    if u368 and u368.Parent then
                                        u368:Destroy();
                                    end;
                                    local v370 = u328:FindFirstChild("BannedCountLbl");
                                    if v370 then
                                        v370.Text = "Забаненных: " .. tostring(v369.totalCount or 0);
                                    end;
                                    if v369.loading then
                                        local v371 = Instance.new("TextLabel");
                                        v371.BackgroundTransparency = 1;
                                        v371.Size = UDim2.new(1, 0, 0, 30);
                                        v371.Text = "Ban index загружается, подождите...";
                                        v371.TextColor3 = u15.orange;
                                        v371.TextSize = 12;
                                        v371.Font = Enum.Font.GothamMedium;
                                        v371.TextXAlignment = Enum.TextXAlignment.Center;
                                        v371.LayoutOrder = 1;
                                        v371.Parent = u337;
                                    else
                                        local v372 = v369.players or {};
                                        for v373, v374 in ipairs(v372) do
                                            u366(v374, v373);
                                        end;
                                        if u39 > 1 then
                                            u287(u337, u38, u39, function() --[[ Line: 1606 ]]
                                                -- upvalues: u38 (ref), u376 (ref)
                                                if u38 > 1 then
                                                    u38 = u38 - 1;
                                                    u376();
                                                end;
                                            end, function() --[[ Line: 1609 ]]
                                                -- upvalues: u38 (ref), u39 (ref), u376 (ref)
                                                if u38 < u39 then
                                                    u38 = u38 + 1;
                                                    u376();
                                                end;
                                            end);
                                        end;
                                        if #v372 == 0 then
                                            local v375 = Instance.new("TextLabel");
                                            v375.BackgroundTransparency = 1;
                                            v375.Size = UDim2.new(1, 0, 0, 40);
                                            v375.Text = u40 == "" and "Забаненных нет!" or "Ничего не найдено";
                                            v375.TextColor3 = u40 == "" and u15.green or u15.textDim;
                                            v375.TextSize = 14;
                                            v375.Font = Enum.Font.GothamBold;
                                            v375.TextXAlignment = Enum.TextXAlignment.Center;
                                            v375.LayoutOrder = 1;
                                            v375.Parent = u337;
                                        end;
                                    end;
                                end);
                            end;
                        end;
                        local v377 = Instance.new("Frame");
                        v377.Name = "PromoTopBar";
                        v377.Size = UDim2.new(1, 0, 0, 106);
                        v377.BackgroundColor3 = Color3.fromRGB(20, 34, 26);
                        v377.BorderSizePixel = 0;
                        v377.Parent = v14;
                        u65(v377, 10, 14);
                        u72(v377, nil, 8);
                        local v378 = Instance.new("Frame");
                        v378.Size = UDim2.new(1, 0, 0, 20);
                        v378.BackgroundTransparency = 1;
                        v378.LayoutOrder = 1;
                        v378.Parent = v377;
                        u72(v378, Enum.FillDirection.Horizontal, 8);
                        local v379 = Instance.new("TextLabel");
                        v379.BackgroundTransparency = 1;
                        v379.Size = UDim2.new(0, 18, 1, 0);
                        v379.Text = "*";
                        v379.TextColor3 = u15.promoGreen;
                        v379.TextSize = 16;
                        v379.Font = Enum.Font.GothamBold;
                        v379.TextXAlignment = Enum.TextXAlignment.Center;
                        v379.Parent = v378;
                        local v380 = Instance.new("TextLabel");
                        v380.BackgroundTransparency = 1;
                        v380.Size = UDim2.new(1, -26, 1, 0);
                        v380.Text = "ГЕНЕРАЦИЯ ПРОМОКОДОВ";
                        v380.TextColor3 = u15.promoGreen;
                        v380.TextSize = 13;
                        v380.Font = Enum.Font.GothamBold;
                        v380.TextXAlignment = Enum.TextXAlignment.Left;
                        v380.Parent = v378;
                        local v381 = Instance.new("Frame");
                        v381.Size = UDim2.new(1, 0, 0, 34);
                        v381.BackgroundTransparency = 1;
                        v381.LayoutOrder = 2;
                        v381.Parent = v377;
                        u72(v381, Enum.FillDirection.Horizontal, 8);
                        local u382 = Instance.new("TextBox");
                        u382.Name = "PromoCountBox";
                        u382.Size = UDim2.new(0, 90, 1, 0);
                        u382.BackgroundColor3 = Color3.fromRGB(28, 44, 34);
                        u382.Text = "10";
                        u382.PlaceholderText = "1-500";
                        u382.PlaceholderColor3 = u15.textDim;
                        u382.TextColor3 = u15.textBright;
                        u382.TextSize = 15;
                        u382.Font = Enum.Font.GothamBold;
                        u382.ClearTextOnFocus = false;
                        u382.BorderSizePixel = 0;
                        u382.Parent = v381;
                        local v383 = Instance.new("UICorner");
                        v383.CornerRadius = UDim.new(0, 6);
                        v383.Parent = u382;
                        local v384 = Color3.fromRGB(40, 100, 60);
                        local v385 = Instance.new("UIStroke");
                        v385.Color = v384 or Color3.fromRGB(58, 58, 78);
                        v385.Thickness = 1;
                        v385.Parent = u382;
                        u65(u382, 0, 10);
                        local function v392(p386, p387, u388) --[[ Line: 1693 ]]
                            -- upvalues: u80 (copy), u15 (copy), u382 (copy)
                            local v389 = u80(p386, p387, Color3.fromRGB(30, 50, 38), 36, 34);
                            v389.TextSize = 11;
                            v389.TextColor3 = u15.promoGreen;
                            local v390 = Color3.fromRGB(40, 100, 60);
                            local v391 = Instance.new("UIStroke");
                            v391.Color = v390 or Color3.fromRGB(58, 58, 78);
                            v391.Thickness = 1;
                            v391.Parent = v389;
                            v389.MouseButton1Click:Connect(function() --[[ Line: 1698 ]]
                                -- upvalues: u382 (ref), u388 (copy)
                                u382.Text = tostring(u388);
                            end);
                            return v389;
                        end;
                        v392(v381, "5", 5);
                        v392(v381, "25", 25);
                        v392(v381, "50", 50);
                        v392(v381, "100", 100);
                        local v393 = Instance.new("Frame");
                        v393.BackgroundTransparency = 1;
                        v393.Size = UDim2.new(1, -312, 1, 0);
                        v393.Parent = v381;
                        local u394 = Instance.new("TextButton");
                        u394.Name = "PromoGenBtn";
                        u394.Size = UDim2.new(0, 110, 1, 0);
                        u394.BackgroundColor3 = u15.promoGreen;
                        u394.Text = "СОЗДАТЬ";
                        u394.TextColor3 = Color3.fromRGB(10, 20, 14);
                        u394.TextSize = 13;
                        u394.Font = Enum.Font.GothamBold;
                        u394.AutoButtonColor = false;
                        u394.BorderSizePixel = 0;
                        u394.Parent = v381;
                        local v395 = Instance.new("UICorner");
                        v395.CornerRadius = UDim.new(0, 6);
                        v395.Parent = u394;
                        u394.MouseEnter:Connect(function() --[[ Line: 1726 ]]
                            -- upvalues: u43 (ref), l__TweenService__4 (copy), u394 (copy)
                            if not u43 then
                                l__TweenService__4:Create(u394, TweenInfo.new(0.12), {
                                    BackgroundColor3 = Color3.fromRGB(60, 210, 120)
                                }):Play();
                            end;
                        end);
                        u394.MouseLeave:Connect(function() --[[ Line: 1732 ]]
                            -- upvalues: u43 (ref), l__TweenService__4 (copy), u394 (copy), u15 (copy)
                            if not u43 then
                                l__TweenService__4:Create(u394, TweenInfo.new(0.12), {
                                    BackgroundColor3 = u15.promoGreen
                                }):Play();
                            end;
                        end);
                        local v396 = Instance.new("Frame");
                        v396.Size = UDim2.new(1, 0, 0, 18);
                        v396.BackgroundTransparency = 1;
                        v396.LayoutOrder = 3;
                        v396.Parent = v377;
                        u72(v396, Enum.FillDirection.Horizontal, 8);
                        local u397 = Instance.new("TextLabel");
                        u397.Name = "PromoStatus";
                        u397.BackgroundTransparency = 1;
                        u397.Size = UDim2.new(0.65, 0, 1, 0);
                        u397.Text = "Введи количество и нажми СОЗДАТЬ";
                        u397.TextColor3 = u15.textDim;
                        u397.TextSize = 11;
                        u397.Font = Enum.Font.Gotham;
                        u397.TextXAlignment = Enum.TextXAlignment.Left;
                        u397.Parent = v396;
                        local u398 = Instance.new("TextButton");
                        u398.Name = "PromoCopyAll";
                        u398.Size = UDim2.new(0, 120, 1, 0);
                        u398.BackgroundColor3 = Color3.fromRGB(38, 38, 52);
                        u398.Text = "Скопировать все";
                        u398.TextColor3 = u15.textDim;
                        u398.TextSize = 10;
                        u398.Font = Enum.Font.Gotham;
                        u398.AutoButtonColor = false;
                        u398.BorderSizePixel = 0;
                        u398.Visible = false;
                        u398.Parent = v396;
                        v60(u398, 4);
                        u398.MouseEnter:Connect(function() --[[ Line: 1770 ]]
                            -- upvalues: l__TweenService__4 (copy), u398 (copy), u15 (copy)
                            l__TweenService__4:Create(u398, TweenInfo.new(0.1), {
                                BackgroundColor3 = u15.card
                            }):Play();
                        end);
                        u398.MouseLeave:Connect(function() --[[ Line: 1774 ]]
                            -- upvalues: l__TweenService__4 (copy), u398 (copy)
                            l__TweenService__4:Create(u398, TweenInfo.new(0.1), {
                                BackgroundColor3 = Color3.fromRGB(38, 38, 52)
                            }):Play();
                        end);
                        local v399 = Instance.new("Frame");
                        v399.Size = UDim2.new(1, 0, 0, 1);
                        v399.Position = UDim2.new(0, 0, 0, 106);
                        v399.BackgroundColor3 = Color3.fromRGB(40, 70, 50);
                        v399.BorderSizePixel = 0;
                        v399.Parent = v14;
                        local v400 = Instance.new("Frame");
                        v400.Name = "PromoResultArea";
                        v400.Size = UDim2.new(1, 0, 1, -108);
                        v400.Position = UDim2.new(0, 0, 0, 108);
                        v400.BackgroundTransparency = 1;
                        v400.BorderSizePixel = 0;
                        v400.Parent = v14;
                        local u401 = Instance.new("TextLabel");
                        u401.Name = "PromoEmptyLabel";
                        u401.BackgroundTransparency = 1;
                        u401.Size = UDim2.new(1, 0, 0, 60);
                        u401.Position = UDim2.new(0, 0, 0.3, 0);
                        u401.Text = "Коды появятся здесь после генерации";
                        u401.TextColor3 = Color3.fromRGB(60, 90, 70);
                        u401.TextSize = 13;
                        u401.Font = Enum.Font.Gotham;
                        u401.TextXAlignment = Enum.TextXAlignment.Center;
                        u401.Parent = v400;
                        local u402 = Instance.new("ScrollingFrame");
                        u402.Name = "PromoCodeScroll";
                        u402.Size = UDim2.fromScale(1, 1);
                        u402.BackgroundTransparency = 1;
                        u402.CanvasSize = UDim2.new(0, 0, 0, 0);
                        u402.AutomaticCanvasSize = Enum.AutomaticSize.Y;
                        u402.ScrollBarThickness = 3;
                        u402.ScrollBarImageColor3 = Color3.fromRGB(50, 120, 70);
                        u402.BorderSizePixel = 0;
                        u402.Visible = false;
                        u402.Parent = v400;
                        u72(u402, nil, 3);
                        u65(u402, 6, 8);
                        local u403 = Instance.new("Frame");
                        u403.Name = "PromoColHeader";
                        u403.Size = UDim2.new(1, -16, 0, 22);
                        u403.Position = UDim2.new(0, 8, 0, 108);
                        u403.BackgroundColor3 = Color3.fromRGB(20, 34, 26);
                        u403.BorderSizePixel = 0;
                        u403.Visible = false;
                        u403.ZIndex = 5;
                        u403.Parent = v14;
                        u72(u403, Enum.FillDirection.Horizontal, 0);
                        local function v408(p404, p405, p406) --[[ Line: 1831 ]]
                            local v407 = Instance.new("TextLabel");
                            v407.BackgroundTransparency = 1;
                            v407.Size = UDim2.new(p406, 0, 1, 0);
                            v407.Text = p405;
                            v407.TextColor3 = Color3.fromRGB(80, 150, 100);
                            v407.TextSize = 10;
                            v407.Font = Enum.Font.GothamBold;
                            v407.TextXAlignment = Enum.TextXAlignment.Left;
                            v407.Parent = p404;
                            return v407;
                        end;
                        v408(u403, "  #", 0.04);
                        v408(u403, "КОД", 0.3);
                        v408(u403, "ПРЕДМЕТ", 0.36);
                        v408(u403, "РЕДКОСТЬ", 0.16);
                        v408(u403, "ДЕЙСТВИЕ", 0.14);
                        local function u430(p409, u410) --[[ Line: 1854 ]]
                            -- upvalues: u16 (copy), u402 (copy), u15 (copy), l__TweenService__4 (copy), u99 (copy)
                            local v411 = u16[p409.rarity] or u16.Common;
                            local u412 = Instance.new("Frame");
                            u412.Name = "PromoRow_" .. u410;
                            u412.Size = UDim2.new(1, 0, 0, 36);
                            u412.BackgroundColor3 = u410 % 2 == 0 and Color3.fromRGB(22, 36, 28) or Color3.fromRGB(26, 42, 32);
                            u412.BorderSizePixel = 0;
                            u412.LayoutOrder = u410;
                            u412.Parent = u402;
                            local v413 = Instance.new("UIListLayout");
                            v413.FillDirection = Enum.FillDirection.Horizontal;
                            v413.SortOrder = Enum.SortOrder.LayoutOrder;
                            v413.VerticalAlignment = Enum.VerticalAlignment.Center;
                            v413.Parent = u412;
                            local v414 = Instance.new("Frame");
                            v414.Size = UDim2.new(0, 3, 1, 0);
                            v414.BackgroundColor3 = v411;
                            v414.BorderSizePixel = 0;
                            v414.LayoutOrder = 0;
                            v414.Parent = u412;
                            local v415 = Instance.new("TextLabel");
                            v415.BackgroundTransparency = 1;
                            v415.Size = UDim2.new(0.04, -3, 1, 0);
                            v415.Text = tostring(u410);
                            v415.TextColor3 = u15.textDim;
                            v415.TextSize = 10;
                            v415.Font = Enum.Font.Gotham;
                            v415.TextXAlignment = Enum.TextXAlignment.Center;
                            v415.LayoutOrder = 1;
                            v415.Parent = u412;
                            local v416 = Instance.new("TextLabel");
                            v416.BackgroundTransparency = 1;
                            v416.Size = UDim2.new(0.3, 0, 1, 0);
                            v416.Text = p409.code or "";
                            v416.TextColor3 = Color3.fromRGB(180, 230, 200);
                            v416.TextSize = 13;
                            v416.Font = Enum.Font.Code;
                            v416.TextXAlignment = Enum.TextXAlignment.Left;
                            v416.LayoutOrder = 2;
                            v416.Parent = u412;
                            local v417 = Instance.new("UIPadding");
                            v417.PaddingLeft = UDim.new(0, 6);
                            v417.Parent = v416;
                            local v418 = Instance.new("TextLabel");
                            v418.BackgroundTransparency = 1;
                            v418.Size = UDim2.new(0.36, 0, 1, 0);
                            v418.Text = p409.name or "Unknown";
                            v418.TextColor3 = u15.text;
                            v418.TextSize = 11;
                            v418.Font = Enum.Font.Gotham;
                            v418.TextXAlignment = Enum.TextXAlignment.Left;
                            v418.TextTruncate = Enum.TextTruncate.AtEnd;
                            v418.LayoutOrder = 3;
                            v418.Parent = u412;
                            local v419 = Instance.new("TextLabel");
                            v419.BackgroundTransparency = 1;
                            v419.Size = UDim2.new(0.16, 0, 1, 0);
                            v419.Text = p409.rarity or "";
                            v419.TextColor3 = v411;
                            v419.TextSize = 10;
                            v419.Font = Enum.Font.GothamBold;
                            v419.TextXAlignment = Enum.TextXAlignment.Left;
                            v419.LayoutOrder = 4;
                            v419.Parent = u412;
                            local v420 = Instance.new("Frame");
                            v420.BackgroundTransparency = 1;
                            v420.Size = UDim2.new(0.14, 0, 1, 0);
                            v420.LayoutOrder = 5;
                            v420.Parent = u412;
                            local u421 = Instance.new("TextButton");
                            u421.Size = UDim2.new(1, -8, 0, 26);
                            u421.Position = UDim2.new(0, 4, 0.5, -13);
                            u421.BackgroundColor3 = Color3.fromRGB(30, 55, 40);
                            u421.Text = "Копировать";
                            u421.TextColor3 = u15.promoGreen;
                            u421.TextSize = 10;
                            u421.Font = Enum.Font.Gotham;
                            u421.AutoButtonColor = false;
                            u421.BorderSizePixel = 0;
                            u421.Parent = v420;
                            local v422 = Instance.new("UICorner");
                            v422.CornerRadius = UDim.new(0, 4);
                            v422.Parent = u421;
                            local v423 = Color3.fromRGB(40, 100, 60);
                            local v424 = Instance.new("UIStroke");
                            v424.Color = v423 or Color3.fromRGB(58, 58, 78);
                            v424.Thickness = 1;
                            v424.Parent = u421;
                            local u425 = p409.code or "";
                            u421.MouseEnter:Connect(function() --[[ Line: 1950 ]]
                                -- upvalues: l__TweenService__4 (ref), u421 (copy)
                                l__TweenService__4:Create(u421, TweenInfo.new(0.1), {
                                    BackgroundColor3 = Color3.fromRGB(40, 80, 55)
                                }):Play();
                            end);
                            u421.MouseLeave:Connect(function() --[[ Line: 1954 ]]
                                -- upvalues: l__TweenService__4 (ref), u421 (copy)
                                l__TweenService__4:Create(u421, TweenInfo.new(0.1), {
                                    BackgroundColor3 = Color3.fromRGB(30, 55, 40)
                                }):Play();
                            end);
                            u421.MouseButton1Click:Connect(function() --[[ Line: 1960 ]]
                                -- upvalues: u425 (copy), u99 (ref)
                                local v426 = u425;
                                local v427 = u99();
                                v427.box.Text = v426 or "";
                                v427.bg.Visible = true;
                                v427.card.Visible = true;
                                task.wait(0.05);
                                v427.box:CaptureFocus();
                            end);
                            local v428 = Instance.new("TextButton");
                            v428.Size = UDim2.fromScale(1, 1);
                            v428.BackgroundTransparency = 1;
                            v428.Text = "";
                            v428.ZIndex = 0;
                            v428.Parent = u412;
                            v428.MouseEnter:Connect(function() --[[ Line: 1971 ]]
                                -- upvalues: l__TweenService__4 (ref), u412 (copy)
                                l__TweenService__4:Create(u412, TweenInfo.new(0.1), {
                                    BackgroundColor3 = Color3.fromRGB(34, 55, 42)
                                }):Play();
                            end);
                            v428.MouseLeave:Connect(function() --[[ Line: 1975 ]]
                                -- upvalues: u410 (copy), l__TweenService__4 (ref), u412 (copy)
                                local v429 = u410 % 2 == 0 and Color3.fromRGB(22, 36, 28) or Color3.fromRGB(26, 42, 32);
                                l__TweenService__4:Create(u412, TweenInfo.new(0.1), {
                                    BackgroundColor3 = v429
                                }):Play();
                            end);
                        end;
                        u398.MouseButton1Click:Connect(function() --[[ Line: 1993 ]]
                            -- upvalues: u45 (ref), u99 (copy)
                            if u45 == "" then
                            else
                                local v431 = u45;
                                local v432 = u99();
                                v432.box.Text = v431 or "";
                                v432.bg.Visible = true;
                                v432.card.Visible = true;
                                task.wait(0.05);
                                v432.box:CaptureFocus();
                            end;
                        end);
                        local function u434() --[[ Line: 1998 ]]
                            -- upvalues: u402 (copy), u401 (copy), u403 (copy), u398 (copy), u45 (ref), u44 (ref)
                            for _, v433 in ipairs(u402:GetChildren()) do
                                if not (v433:IsA("UIListLayout") or v433:IsA("UIPadding")) then
                                    v433:Destroy();
                                end;
                            end;
                            u402.Visible = false;
                            u401.Visible = true;
                            u403.Visible = false;
                            u398.Visible = false;
                            u45 = "";
                            u44 = {};
                        end;
                        local function u439(p435) --[[ Line: 2010 ]]
                            -- upvalues: u401 (copy), u403 (copy), u402 (copy), u398 (copy), u45 (ref), u430 (copy)
                            u401.Visible = false;
                            u403.Visible = true;
                            u402.Visible = true;
                            u398.Visible = true;
                            for _, v436 in ipairs(u402:GetChildren()) do
                                if not (v436:IsA("UIListLayout") or v436:IsA("UIPadding")) then
                                    v436:Destroy();
                                end;
                            end;
                            u45 = "";
                            for v437, v438 in ipairs(p435) do
                                u430(v438, v437);
                                u45 = u45 .. (v438.code or "") .. " | " .. (v438.name or "") .. " [" .. (v438.rarity or "") .. "]\n";
                            end;
                        end;
                        u394.MouseButton1Click:Connect(function() --[[ Line: 2028 ]]
                            -- upvalues: u43 (ref), u4 (copy), u15 (copy), u397 (copy), u382 (copy), l__TweenService__4 (copy), u394 (copy), u44 (ref), u439 (copy)
                            if u43 then
                            elseif u4 then
                                local v440 = tonumber(u382.Text);
                                if v440 and v440 >= 1 then
                                    local v441 = math.floor(v440);
                                    local u442 = math.clamp(v441, 1, 500);
                                    u43 = true;
                                    u394.BackgroundColor3 = Color3.fromRGB(40, 80, 55);
                                    u394.Text = "Генерация...";
                                    local u443 = 0;
                                    local u444 = nil;
                                    u444 = game:GetService("RunService").Heartbeat:Connect(function() --[[ Line: 2062 ]]
                                        -- upvalues: u43 (ref), u444 (ref), u443 (ref), u394 (ref)
                                        if u43 then
                                            u443 = (u443 + 1) % 4;
                                            u394.Text = "Генерация" .. string.rep(".", u443);
                                        else
                                            if u444 then
                                                u444:Disconnect();
                                            end;
                                        end;
                                    end);
                                    local v445 = "Создаём " .. u442 .. " кодов...";
                                    local l__promoGreen__42 = u15.promoGreen;
                                    u397.Text = v445;
                                    u397.TextColor3 = l__promoGreen__42 or u15.textDim;
                                    task.spawn(function() --[[ Line: 2073 ]]
                                        -- upvalues: u4 (ref), u442 (ref), u444 (ref), u43 (ref), u394 (ref), u15 (ref), u397 (ref), u44 (ref), u439 (ref)
                                        local v446, v447 = pcall(function() --[[ Line: 2074 ]]
                                            -- upvalues: u4 (ref), u442 (ref)
                                            return u4:InvokeServer(u442);
                                        end);
                                        if u444 then
                                            u444:Disconnect();
                                        end;
                                        u43 = false;
                                        u394.Text = "СОЗДАТЬ";
                                        u394.BackgroundColor3 = u15.promoGreen;
                                        if v446 then
                                            if v447 and v447.success then
                                                local v448 = v447.codes or {};
                                                if #v448 == 0 then
                                                    local l__orange__43 = u15.orange;
                                                    u397.Text = "Коды не созданы";
                                                    u397.TextColor3 = l__orange__43 or u15.textDim;
                                                else
                                                    u44 = v448;
                                                    u439(v448);
                                                    local v449 = {};
                                                    for _, v450 in ipairs(v448) do
                                                        local v451 = v450.rarity or "Unknown";
                                                        v449[v451] = (v449[v451] or 0) + 1;
                                                    end;
                                                    local v452 = {};
                                                    for v453, v454 in pairs(v449) do
                                                        table.insert(v452, v454 .. "x " .. v453);
                                                    end;
                                                    table.sort(v452);
                                                    local v455 = string.format("Создано %d кодов: %s", #v448, table.concat(v452, ", "));
                                                    local l__promoGreen__44 = u15.promoGreen;
                                                    u397.Text = v455;
                                                    u397.TextColor3 = l__promoGreen__44 or u15.textDim;
                                                end;
                                            else
                                                local v456 = "Ошибка: " .. (v447 and v447.error or "?");
                                                local l__red__45 = u15.red;
                                                u397.Text = v456;
                                                u397.TextColor3 = l__red__45 or u15.textDim;
                                            end;
                                        else
                                            local v457 = "Ошибка соединения: " .. tostring(v447);
                                            local l__red__46 = u15.red;
                                            u397.Text = v457;
                                            u397.TextColor3 = l__red__46 or u15.textDim;
                                        end;
                                    end);
                                else
                                    local l__orange__47 = u15.orange;
                                    u397.Text = "Введи число от 1 до 500";
                                    u397.TextColor3 = l__orange__47 or u15.textDim;
                                    local l__Position__48 = u382.Position;
                                    task.spawn(function() --[[ Line: 2040 ]]
                                        -- upvalues: l__TweenService__4 (ref), u382 (ref), l__Position__48 (copy)
                                        for _ = 1, 3 do
                                            l__TweenService__4:Create(u382, TweenInfo.new(0.05), {
                                                Position = l__Position__48 + UDim2.new(0, 4, 0, 0)
                                            }):Play();
                                            task.wait(0.05);
                                            l__TweenService__4:Create(u382, TweenInfo.new(0.05), {
                                                Position = l__Position__48 + UDim2.new(0, -4, 0, 0)
                                            }):Play();
                                            task.wait(0.05);
                                        end;
                                        l__TweenService__4:Create(u382, TweenInfo.new(0.05), {
                                            Position = l__Position__48
                                        }):Play();
                                    end);
                                end;
                            else
                                local l__red__49 = u15.red;
                                u397.Text = "Remote GeneratePromoCodes не найден";
                                u397.TextColor3 = l__red__49 or u15.textDim;
                            end;
                        end);
                        local function u465() --[[ Line: 2120 ]]
                            -- upvalues: u44 (ref), u439 (copy), u15 (copy), u397 (copy), u434 (copy)
                            if #u44 > 0 then
                                u439(u44);
                                local v458 = {};
                                for _, v459 in ipairs(u44) do
                                    local v460 = v459.rarity or "Unknown";
                                    v458[v460] = (v458[v460] or 0) + 1;
                                end;
                                local v461 = {};
                                for v462, v463 in pairs(v458) do
                                    table.insert(v461, v463 .. "x " .. v462);
                                end;
                                table.sort(v461);
                                local v464 = string.format("%d кодов в кэше: %s", #u44, table.concat(v461, ", "));
                                local l__textDim__50 = u15.textDim;
                                u397.Text = v464;
                                u397.TextColor3 = l__textDim__50 or u15.textDim;
                            else
                                u434();
                                local l__textDim__51 = u15.textDim;
                                u397.Text = "Введи количество и нажми СОЗДАТЬ";
                                u397.TextColor3 = l__textDim__51 or u15.textDim;
                            end;
                        end;
                        local function u476(p466, p467) --[[ Line: 2147 ]]
                            -- upvalues: u50 (copy), u15 (copy), u65 (copy), u72 (copy)
                            if p466 then
                                p466 = p466:FindFirstChild("StockContainer");
                            end;
                            if p466 then
                                for _, v468 in ipairs(p466:GetChildren()) do
                                    if not (v468:IsA("UIListLayout") or v468:IsA("UIPadding")) then
                                        v468:Destroy();
                                    end;
                                end;
                                local v469 = u50("getShopStock", {
                                    shopName = p467
                                }).stock or {};
                                if #v469 == 0 then
                                    local v470 = Instance.new("TextLabel");
                                    v470.Text = "  No stock data available";
                                    v470.Font = Enum.Font.GothamMedium;
                                    v470.TextSize = 11;
                                    v470.TextColor3 = u15.textDim;
                                    v470.BackgroundTransparency = 1;
                                    v470.Size = UDim2.new(1, 0, 0, 22);
                                    v470.LayoutOrder = 1;
                                    v470.Parent = p466;
                                else
                                    for v471, v472 in ipairs(v469) do
                                        local v473 = Instance.new("Frame");
                                        v473.Size = UDim2.new(1, 0, 0, 0);
                                        v473.AutomaticSize = Enum.AutomaticSize.Y;
                                        v473.BackgroundColor3 = u15.bg;
                                        v473.BorderSizePixel = 0;
                                        v473.LayoutOrder = v471;
                                        v473.Parent = p466;
                                        local v474 = Instance.new("UICorner");
                                        v474.CornerRadius = UDim.new(0, 4);
                                        v474.Parent = v473;
                                        u65(v473, 4, 6);
                                        u72(v473, nil, 2);
                                        local v475 = Instance.new("TextLabel");
                                        v475.Text = "Slot " .. v471 .. ": " .. (v472.name or "[EMPTY]");
                                        v475.Font = Enum.Font.GothamBold;
                                        v475.TextSize = 11;
                                        v475.TextColor3 = v472.available and u15.text or u15.textDim;
                                        v475.BackgroundTransparency = 1;
                                        v475.Size = UDim2.new(1, 0, 0, 16);
                                        v475.TextXAlignment = Enum.TextXAlignment.Left;
                                        v475.LayoutOrder = 1;
                                        v475.Parent = v473;
                                    end;
                                end;
                            end;
                        end;
                        local function u491() --[[ Line: 2189 ]]
                            -- upvalues: l__ShopListScroll__23 (copy), u50 (copy), l__ShopEntryTemplate__24 (copy), u15 (copy), u491 (ref), u476 (copy)
                            if not l__ShopListScroll__23 then
                                return;
                            end;
                            for _, v477 in ipairs(l__ShopListScroll__23:GetChildren()) do
                                if v477:IsA("Frame") and v477.Name ~= "ShopEntryTemplate" then
                                    v477:Destroy();
                                end;
                            end;
                            local v478 = u50("getShops").shops or {};
                            for v479, u480 in ipairs(v478) do
                                if not l__ShopEntryTemplate__24 then
                                    break;
                                end;
                                local u481 = l__ShopEntryTemplate__24:Clone();
                                u481.Name = "ShopEntry_" .. (u480.name or v479);
                                u481.Visible = true;
                                u481.LayoutOrder = 10 + v479;
                                u481.Parent = l__ShopListScroll__23;
                                local v482 = u481:FindFirstChild("ShopTitle");
                                if v482 then
                                    v482.Text = (u480.name or "?") .. " — " .. (u480.isOpen and "OPEN" or "CLOSED");
                                    v482.TextColor3 = u480.isOpen and u15.green or u15.red;
                                end;
                                local v483 = u481:FindFirstChild("ShopInfo");
                                if v483 then
                                    local v484 = tonumber(u480.timer or 0) or 0;
                                    v483.Text = "Timer: " .. string.format("%d:%02d", math.floor(v484 / 60), (math.floor(v484 % 60)));
                                end;
                                local v485 = u481:FindFirstChild("ButtonRow");
                                if v485 then
                                    local v486 = v485:FindFirstChild("ToggleBtn");
                                    local v487 = v485:FindFirstChild("RestockBtn");
                                    local u488 = v485:FindFirstChild("ViewStockBtn");
                                    local u489 = u481:FindFirstChild("StockContainer");
                                    if v486 then
                                        v486.Text = u480.isOpen and "Close" or "Open";
                                        v486.BackgroundColor3 = u480.isOpen and u15.red or u15.green;
                                        v486.MouseButton1Click:Connect(function() --[[ Line: 2220 ]]
                                            -- upvalues: u480 (copy), u50 (ref), u491 (ref)
                                            if u480.isOpen then
                                                u50("closeShop", {
                                                    shopName = u480.name
                                                });
                                            else
                                                u50("openShop", {
                                                    shopName = u480.name
                                                });
                                            end;
                                            task.wait(0.5);
                                            u491();
                                        end);
                                    end;
                                    if v487 then
                                        local l__name__52 = u480.name;
                                        v487.MouseButton1Click:Connect(function() --[[ Line: 2228 ]]
                                            -- upvalues: u50 (ref), l__name__52 (copy), u491 (ref)
                                            u50("restockShop", {
                                                shopName = l__name__52
                                            });
                                            task.wait(0.5);
                                            u491();
                                        end);
                                    end;
                                    if u488 and u489 then
                                        local u490 = false;
                                        local l__name__53 = u480.name;
                                        u488.MouseButton1Click:Connect(function() --[[ Line: 2234 ]]
                                            -- upvalues: u490 (ref), u488 (copy), u489 (copy), u476 (ref), u481 (copy), l__name__53 (copy)
                                            u490 = not u490;
                                            if u490 then
                                                u488.Text = "Hide Stock";
                                                u489.Visible = true;
                                                u476(u481, l__name__53);
                                            else
                                                u488.Text = "View Stock";
                                                u489.Visible = false;
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        local function v494() --[[ Line: 2248 ]]
                            -- upvalues: l__GlobalControls__25 (copy), u50 (copy), u491 (ref)
                            if l__GlobalControls__25 then
                                for _, u492 in ipairs({
                                    {
                                        name = "OpenAll",
                                        cmd2 = "openAllShops",
                                        refresh = true
                                    },
                                    {
                                        name = "CloseAll",
                                        cmd2 = "closeAllShops",
                                        refresh = true
                                    },
                                    {
                                        name = "RestockAll",
                                        cmd2 = "restockAllShops",
                                        refresh = true
                                    },
                                    {
                                        name = "ForceRotation",
                                        cmd2 = "forceRotationAll",
                                        refresh = true
                                    },
                                    {
                                        name = "CleanupDrops",
                                        cmd2 = "cleanupDrops",
                                        refresh = false
                                    }
                                }) do
                                    local v493 = l__GlobalControls__25:FindFirstChild("Global_" .. u492.name);
                                    if v493 then
                                        v493.MouseButton1Click:Connect(function() --[[ Line: 2261 ]]
                                            -- upvalues: u50 (ref), u492 (copy), u491 (ref)
                                            u50(u492.cmd2, {});
                                            if u492.refresh then
                                                task.wait(0.5);
                                                u491();
                                            end;
                                        end);
                                    end;
                                end;
                            end;
                        end;
                        local function u503() --[[ Line: 2273 ]]
                            -- upvalues: l__LogScroll__26 (copy), u50 (copy), u29 (ref), u15 (copy), l__LogEntryTemplate__27 (copy)
                            if l__LogScroll__26 then
                                for _, v495 in ipairs(l__LogScroll__26:GetChildren()) do
                                    if v495:IsA("TextLabel") and v495.Name ~= "LogEntryTemplate" then
                                        v495:Destroy();
                                    end;
                                end;
                                u29 = u50("getLogs").logs or {};
                                if #u29 == 0 then
                                    local v496 = Instance.new("TextLabel");
                                    v496.Text = "  No logs yet.";
                                    v496.Font = Enum.Font.GothamMedium;
                                    v496.TextSize = 13;
                                    v496.TextColor3 = u15.textDim;
                                    v496.BackgroundTransparency = 1;
                                    v496.Size = UDim2.new(1, 0, 0, 28);
                                    v496.LayoutOrder = 1;
                                    v496.Parent = l__LogScroll__26;
                                else
                                    for v497, v498 in ipairs(u29) do
                                        local v499;
                                        if l__LogEntryTemplate__27 then
                                            v499 = l__LogEntryTemplate__27:Clone();
                                        else
                                            v499 = Instance.new("TextLabel");
                                            v499.Font = Enum.Font.RobotoMono;
                                            v499.TextSize = 11;
                                            v499.TextColor3 = u15.textDim;
                                            v499.BackgroundColor3 = u15.card;
                                            v499.Size = UDim2.new(1, 0, 0, 22);
                                            v499.TextXAlignment = Enum.TextXAlignment.Left;
                                            v499.BorderSizePixel = 0;
                                            local v500 = Instance.new("UICorner");
                                            v500.CornerRadius = UDim.new(0, 4);
                                            v500.Parent = v499;
                                            local v501 = Instance.new("UIPadding");
                                            v501.PaddingLeft = UDim.new(0, 8);
                                            v501.Parent = v499;
                                        end;
                                        local v502 = os.date("%H:%M", v498.time);
                                        v499.Name = "LogEntry_" .. v497;
                                        v499.Text = "  [" .. v502 .. "] " .. (v498.admin or "?") .. " — " .. (v498.action or "?") .. (v498.details and v498.details ~= "" and (" | " .. v498.details or "") or "");
                                        v499.Visible = true;
                                        v499.LayoutOrder = v497;
                                        v499.Parent = l__LogScroll__26;
                                    end;
                                end;
                            end;
                        end;
                        if l__LogsTopFrame__28 then
                            local v504 = l__LogsTopFrame__28:FindFirstChild("LogRefreshBtn");
                            local v505 = l__LogsTopFrame__28:FindFirstChild("LogClearBtn");
                            if v504 then
                                v504.MouseButton1Click:Connect(function() --[[ Line: 2322 ]]
                                    -- upvalues: u503 (ref)
                                    u503();
                                end);
                            end;
                            if v505 then
                                v505.MouseButton1Click:Connect(function() --[[ Line: 2324 ]]
                                    -- upvalues: u50 (copy), u503 (ref)
                                    u50("clearLogs", {});
                                    u503();
                                end);
                            end;
                        end;
                        if l__AdminLog__9 then
                            l__AdminLog__9.OnClientEvent:Connect(function(p506) --[[ Line: 2331 ]]
                                -- upvalues: u29 (ref), u24 (ref), u9 (ref), u503 (ref)
                                if p506 then
                                    table.insert(u29, 1, p506);
                                    if u24 == "Logs" and u9.Enabled then
                                        u503();
                                    end;
                                end;
                            end);
                        end;
                        local function u512() --[[ Line: 2343 ]]
                            -- upvalues: u3 (copy), u11 (copy), u15 (copy)
                            if u3 then
                                local u507 = {};
                                pcall(function() --[[ Line: 2346 ]]
                                    -- upvalues: u507 (ref), u3 (ref)
                                    u507 = u3:InvokeServer("getEventStatus", {}) or {};
                                end);
                                local v508 = u11 and (u11:FindFirstChild("EventScroll") and u11.EventScroll:FindFirstChild("EventStatusSection"));
                                if v508 then
                                    v508 = u11.EventScroll.EventStatusSection:FindFirstChild("EventStatusLabel");
                                end;
                                local v509 = u11 and (u11:FindFirstChild("EventScroll") and u11.EventScroll:FindFirstChild("EventStatusSection"));
                                if v509 then
                                    v509 = u11.EventScroll.EventStatusSection:FindFirstChild("EventTimerLabel");
                                end;
                                if v508 then
                                    v508.Text = u507.active and "Status: ACTIVE" or "Status: Inactive";
                                    v508.TextColor3 = u507.active and u15.green or u15.textDim;
                                end;
                                if v509 then
                                    if u507.active and u507.timeLeft then
                                        local v510 = math.floor(u507.timeLeft);
                                        local v511 = math.max(0, v510);
                                        v509.Text = "Time left: " .. string.format("%d:%02d:%02d", math.floor(v511 / 3600), math.floor(v511 % 3600 / 60), v511 % 60);
                                    else
                                        v509.Text = "Time left: --:--:--";
                                    end;
                                end;
                            end;
                        end;
                        local function u519() --[[ Line: 2370 ]]
                            -- upvalues: u10 (copy), u50 (copy)
                            if u10 then
                                local v513 = u10:FindFirstChild("ServerScroll");
                                if v513 then
                                    local u514 = {};
                                    pcall(function() --[[ Line: 2375 ]]
                                        -- upvalues: u514 (ref), u50 (ref)
                                        u514 = u50("getServerInfo", {}) or {};
                                    end);
                                    local v515 = v513:FindFirstChild("QuickSection");
                                    if v515 then
                                        local v516 = v515:FindFirstChild("ServerInfoLabel");
                                        if v516 and u514.playerCount then
                                            local v517 = u514.uptime or 0;
                                            local v518 = string.format("%d:%02d:%02d", math.floor(v517 / 3600), math.floor(v517 % 3600 / 60), v517 % 60);
                                            v516.Text = string.format("Players: %d/%d | Uptime: %s | Cache: %d | Bans: %d", u514.playerCount, u514.maxPlayers or 0, v518, u514.cachedPlayers or 0, u514.banIndexSize or 0);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        local function u520() --[[ Line: 2394 ]]
                            -- upvalues: u9 (ref), u24 (ref), u17 (ref), u491 (ref), u503 (ref), u519 (ref), u512 (ref), u376 (ref), u465 (ref), u42 (ref), u151 (ref)
                            u9.Enabled = not u9.Enabled;
                            if u9.Enabled then
                                if u24 == "Players" then
                                    u17();
                                    return;
                                end;
                                if u24 == "Shops" then
                                    u491();
                                    return;
                                end;
                                if u24 == "Logs" then
                                    u503();
                                    return;
                                end;
                                if u24 == "Server" then
                                    u519();
                                    return;
                                end;
                                if u24 == "Event" then
                                    u512();
                                    return;
                                end;
                                if u24 == "Banned" then
                                    u376();
                                    return;
                                end;
                                if u24 == "Promos" then
                                    u465();
                                    return;
                                end;
                                if u24 == "Clans" then
                                    u42 = {};
                                    (nil)("");
                                end;
                            elseif u151 then
                                u151.close();
                            end;
                        end;
                        local v521 = l__Header__11 and l__Header__11:FindFirstChild("CloseButton");
                        if v521 then
                            v521.MouseButton1Click:Connect(function() --[[ Line: 2418 ]]
                                -- upvalues: u151 (ref), u9 (ref)
                                if u151 then
                                    u151.close();
                                end;
                                u9.Enabled = false;
                            end);
                        end;
                        l__UserInputService__3.InputBegan:Connect(function(p522, p523) --[[ Line: 2425 ]]
                            -- upvalues: u520 (copy), u9 (ref), u150 (copy), u17 (ref), u491 (ref), u503 (ref), u519 (ref), u512 (ref), u42 (ref), u376 (ref), u465 (ref)
                            if p523 then
                            else
                                if p522.KeyCode == Enum.KeyCode.BackSlash or p522.KeyCode == Enum.KeyCode.F9 then
                                    u520();
                                end;
                                if u9.Enabled then
                                    if p522.KeyCode == Enum.KeyCode.One then
                                        u150("Players");
                                        u17();
                                    elseif p522.KeyCode == Enum.KeyCode.Two then
                                        u150("Shops");
                                        u491();
                                    elseif p522.KeyCode == Enum.KeyCode.Three then
                                        u150("Logs");
                                        u503();
                                    elseif p522.KeyCode == Enum.KeyCode.Four then
                                        u150("Server");
                                        u519();
                                    elseif p522.KeyCode == Enum.KeyCode.Five then
                                        u150("Event");
                                        u512();
                                    elseif p522.KeyCode == Enum.KeyCode.Six then
                                        u150("Clans");
                                        u42 = {};
                                        (nil)("");
                                    elseif p522.KeyCode == Enum.KeyCode.Seven then
                                        u150("Banned");
                                        u376();
                                    else
                                        if p522.KeyCode == Enum.KeyCode.Eight then
                                            u150("Promos");
                                            u465();
                                        end;
                                    end;
                                end;
                            end;
                        end);
                        if l__AdminToggleGui__29 then
                            l__AdminToggleGui__29.Visible = true;
                            l__AdminToggleGui__29.Size = UDim2.new(0, 54, 0, 54);
                            l__AdminToggleGui__29.Position = UDim2.new(1, -70, 0, 120);
                            l__AdminToggleGui__29.MouseButton1Click:Connect(function() --[[ Line: 2446 ]]
                                -- upvalues: u520 (copy)
                                u520();
                            end);
                        end;
                        if l__AdminRefresh__8 then
                            l__AdminRefresh__8.OnClientEvent:Connect(function(p524, p525) --[[ Line: 2450 ]]
                                if p524 == "adminConnected" then
                                    print("[AdminPanel] Connected as " .. (p525 and p525.role or "?"));
                                end;
                            end);
                        end;
                        local v526 = l__Header__11 and l__Header__11:FindFirstChild("TitleLabel");
                        if v526 then
                            v526.Text = "Admin Panel — " .. v7;
                        end;
                        v327();
                        v494();
                        u150("Players");
                        u17();
                        print("[AdminPanelClient] V1.7 Loaded | Role: " .. v7);
                        print("  \\ or F9 = toggle | 1-8 = tabs");
                        print("  V1.7: Copy popup via TextBox (Ctrl+A -> Ctrl+C)");
                    else
                        warn("[AdminPanelClient] ContentFrame not found");
                    end;
                else
                    warn("[AdminPanelClient] MainFrame not found");
                end;
            else
                warn("[AdminPanelClient] AdminPanel not found");
            end;
        end;
    else
        warn("[AdminPanelClient] AdminCommand not found");
    end;
else
    warn("[AdminPanelClient] AdminRemotes not found");
end;