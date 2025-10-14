local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- DataStore để lưu thời gian hết hạn key
local KeyDataStore = DataStoreService:GetDataStore("KiradaKeyData")

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true,
    ["phucdam"] = true,
    ["ezakgaminh"] = true
}

-- Biến lưu thời gian hết hạn key hicak
local hicakExpiration = nil

-- Kiểm tra key hicak từ DataStore
local function checkStoredKey()
    local success, storedData = pcall(function()
        return KeyDataStore:GetAsync("Hicak_" .. LocalPlayer.UserId)
    end)
    if success and storedData and typeof(storedData) == "number" and os.time() <= storedData then
        hicakExpiration = storedData
        return true
    end
    return false
end

-- Lưu key hicak vào DataStore
local function saveKeyExpiration(expirationTime)
    pcall(function()
        KeyDataStore:SetAsync("Hicak_" .. LocalPlayer.UserId, expirationTime)
    end)
end

-- Giao diện nhập key cute
local function createKeyGui()
    if checkStoredKey() then
        StarterGui:SetCore("SendNotification", {
            Title = "Thành Công 💖",
            Text = "Key hicak còn hợp lệ! 😊",
            Duration = 5
        })
        return
    end

    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Hồng phấn
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium 💕"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.Cartoon

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.8, 0, 0, 40)
    textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 230, 235) -- Hồng nhạt
    textBox.TextColor3 = Color3.fromRGB(50, 50, 50)
    textBox.PlaceholderText = "Nhập key... ✨"
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Cartoon
    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.5, 0, 0, 40)
    submitButton.Position = UDim2.new(0.25, 0, 0.65, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(173, 216, 230) -- Xanh nhạt
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận 🌟"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.Cartoon
    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    submitButton.MouseButton1Down:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.48, 0, 0, 38)}):Play()
    end)
    submitButton.MouseButton1Up:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {Size = UDim2.new(0.5, 0, 0, 40)}):Play()
    end)

    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        local input = textBox.Text:lower()
        local validity = validKeys[input]
        if input == "hicak" then
            local expirationTime = os.time() + 86400
            hicakExpiration = expirationTime
            saveKeyExpiration(expirationTime)
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công 💖",
                Text = "Key hicak hợp lệ 24h! 😊",
                Duration = 5
            })
            screenGui:Destroy()
        elseif validity then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công 💖",
                Text = "Key Premium hợp lệ! 😍",
                Duration = 5
            })
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi 😓",
                Text = "Key không đúng! Thử lại nhé! 💕",
                Duration = 5
            })
            textBox.Text = ""
        end
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then submitButton:Activate() end
    end)

    while not keyEntered do task.wait(0.1) end
end
pcall(createKeyGui)

-- Đồng hồ đếm ngược cho key hicak
local function createCountdownGui()
    if not hicakExpiration then return end

    local countdownGui = Instance.new("ScreenGui", PlayerGui)
    countdownGui.Name = "HicakCountdown"
    countdownGui.IgnoreGuiInset = true

    local textLabel = Instance.new("TextLabel", countdownGui)
    textLabel.Size = UDim2.new(0, 150, 0, 40)
    textLabel.Position = UDim2.new(1, -160, 0, 10)
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 182, 193)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.Cartoon
    textLabel.BackgroundTransparency = 0.3
    local corner = Instance.new("UICorner", textLabel)
    corner.CornerRadius = UDim.new(0, 8)

    RunService.Heartbeat:Connect(function()
        local remaining = hicakExpiration - os.time()
        if remaining > 0 then
            local hours = math.floor(remaining / 3600)
            local minutes = math.floor((remaining % 3600) / 60)
            local seconds = remaining % 60
            textLabel.Text = string.format("Hicak: %02d:%02d:%02d 💕", hours, minutes, seconds)
        else
            textLabel.Text = "Hicak: Hết hạn! 😓"
            textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(5)
            countdownGui:Destroy()
            pcall(createKeyGui)
        end
    end)
end
pcall(createCountdownGui)

-- Tải UI Redz V2 hoặc UI dự phòng
local function createFallbackUI()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "FallbackUI"
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193)

    local tabs = {"Blox Fruits", "99 Đêm", "Hop Server", "Hệ Thống Key"}
    for i, tabName in ipairs(tabs) do
        local button = Instance.new("TextButton", frame)
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Position = UDim2.new(0, 0, 0, (i-1)*40)
        button.BackgroundColor3 = Color3.fromRGB(173, 216, 230)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Text = tabName
        button.TextScaled = true
        button.Font = Enum.Font.Cartoon
        button.MouseButton1Click:Connect(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Tab",
                Text = "Đã chọn: " .. tabName,
                Duration = 3
            })
        end)
    end
end

local success = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not success then createFallbackUI() end

-- Hàm thêm nút sao chép
local function addButton(tab, name, url)
    if not _G.AddButton then return end
    _G.AddButton(tab, {
        Name = name,
        Callback = function()
            setclipboard(url)
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Đã sao chép: " .. name .. " 💖",
                Duration = 5
            })
        end
    })
end

-- Hàm thêm nút chạy script
local function addScriptButton(tab, name, url)
    if not _G.AddButton then return end
    _G.AddButton(tab, {
        Name = name,
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet(url))()
                StarterGui:SetCore("SendNotification", {
                    Title = "Thành Công",
                    Text = "Đã chạy: " .. name .. " 😊",
                    Duration = 5
                })
            end)
        end
    })
end

-- Hàm hop server ít người
local function hopToLowPlayerServer()
    local function getServerList()
        local cursor = ""
        local servers = {}
        for i = 1, 5 do
            local result = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor))
            if result and result.data then
                for _, server in pairs(result.data) do
                    if server.playing <= 4 and server.id ~= game.JobId then
                        table.insert(servers, server)
                    end
                end
                cursor = result.nextPageCursor or ""
                if not cursor then break end
            end
            task.wait(0.5)
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        return servers
    end

    for i = 1, 10 do
        pcall(function()
            local servers = getServerList()
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(gameId, servers[1].id, LocalPlayer)
            end
        end)
        task.wait(2)
    end
end

-- Hàm phát hiện admin
local function checkAdmin()
    local adminIds = {[912348] = true, [120173604] = true}
    for _, player in pairs(Players:GetPlayers()) do
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            hopToLowPlayerServer()
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            hopToLowPlayerServer()
        end
    end)
end
pcall(checkAdmin)

-- Thêm tất cả tab
local function detectGameAndAddTabs()
    if not _G.MakeTab or not _G.AddButton then
        createFallbackUI()
        return
    end

    -- Tab Blox Fruits
    local tab1 = _G.MakeTab({Name = "Blox Fruits"})
    addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
    addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
    addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab1, "Server VIP Free", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")
    addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
    addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")
    addScriptButton(tab1, "Gravity Hub", "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua")

    -- Tab 99 Đêm
    local tab3 = _G.MakeTab({Name = "99 Đêm"})
    addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
    addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
    addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
    addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
    addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

    -- Tab Hop Server
    local tabHop = _G.MakeTab({Name = "Hop Server"})
    addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
    addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
    _G.AddButton(tabHop, {
        Name = "Hop Server Ít Người",
        Callback = hopToLowPlayerServer
    })

    -- Tab Hệ Thống Key
    local tabKey = _G.MakeTab({Name = "Hệ Thống Key"})
    addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")
end
pcall(detectGameAndAddTabs)
