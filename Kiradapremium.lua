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

-- Biến lưu thời gian hết hạn của key hicak
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

-- Giao diện nhập key (đơn giản hóa)
local function createKeyGui()
    if checkStoredKey() then
        StarterGui:SetCore("SendNotification", {
            Title = "Thành Công",
            Text = "Key hicak còn hợp lệ! Chào mừng 😍",
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
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium"
    title.TextColor3 = Color3.fromRGB(0, 170, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.8, 0, 0, 40)
    textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham

    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.8, 0, 0, 40)
    submitButton.Position = UDim2.new(0.1, 0, 0.65, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold

    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

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
                Title = "Thành Công",
                Text = "Key tạm thời hợp lệ! Chào mừng 😍",
                Duration = 5
            })
            screenGui:Destroy()
        elseif validity then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công",
                Text = "Cảm ơn bạn đã mua bản Premium 😍",
                Duration = 5
            })
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key không đúng! Vui lòng thử lại.",
                Duration = 5
            })
            textBox.Text = ""
        end
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            submitButton:Activate()
        end
    end)

    while not keyEntered do
        task.wait(0.1)
    end
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
    textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.BackgroundTransparency = 0.5
    local corner = Instance.new("UICorner", textLabel)
    corner.CornerRadius = UDim.new(0, 8)

    RunService.Heartbeat:Connect(function()
        local remaining = hicakExpiration - os.time()
        if remaining > 0 then
            local hours = math.floor(remaining / 3600)
            local minutes = math.floor((remaining % 3600) / 60)
            local seconds = remaining % 60
            textLabel.Text = string.format("Key Hicak: %02d:%02d:%02d", hours, minutes, seconds)
        else
            textLabel.Text = "Key Hicak: Hết hạn!"
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(5)
            countdownGui:Destroy()
            pcall(createKeyGui)
        end
    end)
end
spawn(createCountdownGui)

-- Tải UI Redz V2
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
    Key = {KeySystem = false, Title = "Hệ Thống Key", Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không đúng", CopyKeyLink = "Đã sao chép vào clipboard"}}
})

-- Hàm thêm nút sao chép
local function addButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            pcall(function()
                setclipboard(url)
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đã sao chép link " .. name .. "!",
                    Duration = 5
                })
            end)
        end
    })
end

-- Hàm thêm nút chạy script
local function addScriptButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet(url))()
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đã chạy script " .. name .. "!",
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
        local maxAttempts = 5
        local attempts = 0
        while attempts < maxAttempts do
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor))
            end)
            if success and result and result.data then
                for _, server in pairs(result.data) do
                    if server.playing <= 4 and server.id != game.JobId then
                        table.insert(servers, server)
                    end
                end
                cursor = result.nextPageCursor or ""
                if not cursor then break end
            end
            attempts = attempts + 1
            task.wait(0.5)
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        return servers
    end

    local maxTeleportAttempts = 10
    local teleportAttempts = 0
    local success = false
    while not success and teleportAttempts < maxTeleportAttempts do
        pcall(function()
            local servers = getServerList()
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(gameId, servers[1].id, LocalPlayer)
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đang hop vào server có " .. tostring(servers[1].playing) .. " người!",
                    Duration = 5
                })
                success = true
            end
        end)
        teleportAttempts = teleportAttempts + 1
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
    -- Tab Blox Fruits
    local tab1 = MakeTab({Name = "Blox Fruits"})
    addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
    addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
    addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab1, "Server VIP Free", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")
    addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
    addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")
    addScriptButton(tab1, "Gravity Hub", "https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua")

    -- Tab 99 Đêm
    local tab3 = MakeTab({Name = "99 Đêm"})
    addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
    addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
    addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
    addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
    addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

    -- Tab Hop Server
    local tabHop = MakeTab({Name = "Hop Server"})
    addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
    addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
    AddButton(tabHop, {
        Name = "Hop Server Ít Người",
        Callback = hopToLowPlayerServer
    })

    -- Tab Hệ Thống Key
    local tabKey = MakeTab({Name = "Hệ Thống Key"})
    addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")

    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Đã load tất cả tab!",
        Duration = 5
    })
end

-- Chạy tab ngay lập tức
task.wait(0.1)
detectGameAndAddTabs()
