local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Valid keys
local validKeys = {
    ["noob"] = true,
    ["hangay"] = true,
    ["kiradavnhub"] = true,
    ["mimi"] = true,
    ["tunghub"] = true,
    ["phucdam"] = true,
    ["chuoihub"] = true,
    ["ezakgaminh"] = true
}

-- Simulate local storage for key expiration (since DataStore is server-side)
local keyStorage = {}
local STORAGE_KEY = "KiradaPremiumKey"

-- Load key storage (simulated)
local function loadKeyStorage()
    local success, result = pcall(function()
        return HttpService:JSONDecode(LocalPlayer:GetAttribute(STORAGE_KEY) or "{}")
    end)
    if success then
        keyStorage = result
    else
        keyStorage = {}
    end
end

-- Save key storage
local function saveKeyStorage()
    pcall(function()
        LocalPlayer:SetAttribute(STORAGE_KEY, HttpService:JSONEncode(keyStorage))
    end)
end

-- Check if key is valid and not expired
local function isKeyValid(inputKey)
    if not validKeys[inputKey] then
        return false, "Key không hợp lệ!"
    end
    loadKeyStorage()
    local currentTime = os.time()
    local keyData = keyStorage[inputKey]
    if keyData and keyData.expirationTime then
        if currentTime < keyData.expirationTime then
            return true, "Key hợp lệ!"
        else
            return false, "Key đã hết hạn!"
        end
    else
        -- New key, set 24-hour expiration
        keyStorage[inputKey] = {expirationTime = currentTime + 24 * 60 * 60}
        saveKeyStorage()
        return true, "Key hợp lệ!"
    end
end

-- Create key system UI
local function createKeySystemUI()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    -- Main frame
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    local uiCorner = Instance.new("UICorner", frame)
    uiCorner.CornerRadius = UDim.new(0, 10)

    -- Title
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Hệ Thống Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold

    -- Key input box
    local keyInput = Instance.new("TextBox", frame)
    keyInput.Size = UDim2.new(0.8, 0, 0, 40)
    keyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
    keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderText = "Nhập key tại đây..."
    keyInput.TextScaled = true
    keyInput.Font = Enum.Font.Gotham
    local inputCorner = Instance.new("UICorner", keyInput)
    inputCorner.CornerRadius = UDim.new(0, 8)

    -- Submit button
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 40)
    submitButton.Position = UDim2.new(0.3, 0, 0.5, 10)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold
    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    -- Feedback label
    local feedbackLabel = Instance.new("TextLabel", frame)
    feedbackLabel.Size = UDim2.new(0.8, 0, 0, 30)
    feedbackLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
    feedbackLabel.BackgroundTransparency = 1
    feedbackLabel.Text = ""
    feedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    feedbackLabel.TextScaled = true
    feedbackLabel.Font = Enum.Font.Gotham

    -- Animations
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    frame.BackgroundTransparency = 1
    title.TextTransparency = 1
    keyInput.BackgroundTransparency = 1
    submitButton.BackgroundTransparency = 1
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(keyInput, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 0}):Play()

    -- Button hover effect
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
    end)

    -- Submit button logic
    submitButton.Activated:Connect(function()
        local key = keyInput.Text
        local isValid, message = isKeyValid(key)
        feedbackLabel.Text = message
        feedbackLabel.TextColor3 = isValid and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if isValid then
            -- Fade out and destroy UI
            TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(keyInput, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(feedbackLabel, tweenInfo, {TextTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
            -- Proceed to load the main menu
            detectGameAndAddTabs()
        end
    end)

    return screenGui
end

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Tải UI Redz V2
pcall(function()
    local success, result = pcall(loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể tải UI: " .. tostring(result),
            Duration = 10
        })
        return
    end
end)

-- Preload tài nguyên
pcall(function()
    ContentProvider:PreloadAsync({
        "rbxassetid://75676578090181",
        "rbxassetid://89326205091486",
        "rbxassetid://8987546731"
    })
end)

-- Âm thanh startup
local function playStartupSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://8987546731"
    sound.Volume = 1
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
pcall(playStartupSound)

-- Intro animation
local function introAnimation()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.IgnoreGuiInset = true
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Kirada Premium\nTác giả: Kirada VN & Habato\nNgười test: Nấm Gamer"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    local imageLabel = Instance.new("ImageLabel", frame)
    imageLabel.Size = UDim2.new(0, 100, 0, 100)
    imageLabel.Position = UDim2.new(0.5, -50, 0.6, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://75676578090181"
    imageLabel.ImageTransparency = 1
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine)
    TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 0}):Play()
    task.wait(1)
    TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 1}):Play()
    task.wait(1)
    screenGui:Destroy()
end
pcall(introAnimation)

-- Show key system UI
createKeySystemUI()

-- Original functions (unchanged)
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
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi",
                    Text = "Không thể lấy danh sách server!",
                    Duration = 5
                })
                break
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
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi",
                    Text = "Không tìm thấy server dưới 5 người!",
                    Duration = 5
                })
            end
        end)
        teleportAttempts = teleportAttempts + 1
        task.wait(2)
    end
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể hop server sau " .. maxTeleportAttempts .. " lần thử!",
            Duration = 5
        })
    end
end

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

function detectGameAndAddTabs()
    local tab1 = MakeTab({Name = "Blox Fruits"})
    addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
    addScriptButton(tab1, "H4X Script", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
    addScriptButton(tab1, "Nat Hub", "https://get.nathub.xyz/loader")
    addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
    addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab1, "Tạo Server VIP Bạn Của Bạn Có Thể Vô Chỉ Cần Gửi Link", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")
    addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
    addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")

    local tab3 = MakeTab({Name = "99 Đêm"})
    addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
    addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
    addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
    addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
    addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
    addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

    local tabHop = MakeTab({Name = "Hop Server"})
    addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
    addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
    AddButton(tabHop, {
        Name = "Hop Server Ít Người",
        Callback = hopToLowPlayerServer
    })

    local tabSocial = MakeTab({Name = "Mạng Xã Hội"})
    addButton(tabSocial, "Discord", "https://discord.gg/kJ9ydA2PP4")
    addButton(tabSocial, "YouTube", "https://www.youtube.com/@kiradavn")
    addButton(tabSocial, "TikTok", "https://www.tiktok.com/@offbyebyesad")

    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Đã tải menu Kirada Premium thành công!",
        Duration = 5
    })
end
