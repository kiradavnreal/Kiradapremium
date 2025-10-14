local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- DataStore để lưu thời gian kích hoạt key
local KeyDataStore = DataStoreService:GetDataStore("KeyActivationTimes")

-- Key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true,
    ["phucdam"] = true,
    ["ezakgaminh"] = true,
    ["hicak"] = true
}

-- Thời gian hết hạn cho key "hicak" (10 tiếng = 36000 giây)
local HICAK_DURATION = 36000

-- Hàm hiển thị thời gian còn lại cho key "hicak"
local function displayKeyTimer()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeyTimerGui"
    screenGui.IgnoreGuiInset = true

    local timerFrame = Instance.new("Frame", screenGui)
    timerFrame.Size = UDim2.new(0, 150, 0, 40)
    timerFrame.Position = UDim2.new(1, -160, 0, 10)
    timerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    timerFrame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", timerFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local timerLabel = Instance.new("TextLabel", timerFrame)
    timerLabel.Size = UDim2.new(1, 0, 1, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timerLabel.TextScaled = true
    timerLabel.Font = Enum.Font.Gotham
    timerLabel.Text = "Thời gian key: Đang tính..."

    local function updateTimer(remainingTime)
        if remainingTime <= 0 then
            timerLabel.Text = "Key hicak đã hết hạn!"
            task.wait(2)
            screenGui:Destroy()
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key hicak đã hết hạn! Vui lòng nhập key mới.",
                Duration = 5
            })
            pcall(createKeyGui)
            return
        end
        local hours = math.floor(remainingTime / 3600)
        local minutes = math.floor((remainingTime % 3600) / 60)
        local seconds = remainingTime % 60
        timerLabel.Text = string.format("Thời gian key: %02d:%02d:%02d", hours, minutes, seconds)
    end

    local key = "hicak"
    local success, activationTime = pcall(function()
        return KeyDataStore:GetAsync(LocalPlayer.UserId .. "_" .. key)
    end)

    if success and activationTime then
        local currentTime = os.time()
        local elapsedTime = currentTime - activationTime
        local remainingTime = HICAK_DURATION - elapsedTime

        if remainingTime > 0 then
            spawn(function()
                while remainingTime > 0 and timerFrame.Parent do
                    updateTimer(remainingTime)
                    task.wait(1)
                    remainingTime = remainingTime - 1
                end
                updateTimer(0)
            end)
        else
            updateTimer(0)
        end
    else
        screenGui:Destroy()
    end
end

-- Giao diện nhập key cải tiến
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0

    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    gradient.Rotation = 45

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 15)

    local shadow = Instance.new("ImageLabel", frame)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.8
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ZIndex = -1

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Nhập Key"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.35, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key tại đây..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false

    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 10)

    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(100, 100, 100)
    textBoxStroke.Thickness = 1

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 50)
    submitButton.Position = UDim2.new(0.3, 0, 0.65, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold

    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 10)

    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1

    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)

    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = textBox.Text:lower()
        if validKeys[enteredKey] then
            if enteredKey == "hicak" then
                local success, activationTime = pcall(function()
                    return KeyDataStore:GetAsync(LocalPlayer.UserId .. "_" .. enteredKey)
                end)
                local currentTime = os.time()
                if success and activationTime then
                    local elapsedTime = currentTime - activationTime
                    if elapsedTime > HICAK_DURATION then
                        StarterGui:SetCore("SendNotification", {
                            Title = "Lỗi",
                            Text = "Key hicak đã hết hạn! Vui lòng nhập key mới.",
                            Duration = 5
                        })
                        textBox.Text = ""
                        return
                    end
                else
                    pcall(function()
                        KeyDataStore:SetAsync(LocalPlayer.UserId .. "_" .. enteredKey, currentTime)
                    end)
                end
                displayKeyTimer()
            end
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Cảm ơn bạn đã mua bản Premium của tớ 😍",
                Duration = 5
            })
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine)
            TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(textBox, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
            proceedWithScript()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key không đúng! Vui lòng thử lại.",
                Duration = 5
            })
            textBox.Text = ""
            local originalPos = textBox.Position
            for i = 1, 3 do
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = UDim2.new(0.075 + 0.01, 0, 0.35, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = UDim2.new(0.075 - 0.01, 0, 0.35, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos}):Play()
        end
    end)
end

-- Hàm tiếp tục script sau khi nhập key
local function proceedWithScript()
    pcall(introAnimation)
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
    pcall(detectGameAndAddTabs)
end

-- Preload tài nguyên
pcall(function()
    local assets = {"rbxassetid://75676578090181", "rbxassetid://89326205091486"}
    for _, asset in pairs(assets) do
        if game:GetService("MarketplaceService"):GetProductInfo(tonumber(asset:match("%d+"))).AssetTypeId == Enum.AssetType.Image then
            ContentProvider:PreloadAsync({asset})
        end
    end
end)

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

-- Tạo menu chính
local function createMainUI()
    local success, window = pcall(MakeWindow, {
        Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
        Key = {KeySystem = false, Title = "Hệ Thống Key", Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không đúng", CopyKeyLink = "Đã sao chép vào clipboard"}}
    })
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể tạo UI: " .. tostring(window),
            Duration = 10
        })
        return
    end
    return window
end

-- Hàm thêm nút sao chép
local function addButton(tab, name, url)
    pcall(AddButton, tab, {
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
    pcall(AddButton, tab, {
        Name = name,
        Callback = function()
            pcall(function()
                local success, result = pcall(loadstring(game:HttpGet(url)))
                if success then
                    result()
                    StarterGui:SetCore("SendNotification", {
                        Title = "Thông Báo",
                        Text = "Đã chạy script " .. name .. "!",
                        Duration = 5
                    })
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "Lỗi",
                        Text = "Không thể tải script " .. name .. ": " .. tostring(result),
                        Duration = 10
                    })
                end
            end)
        end
    })
end

-- Hàm hop server ít người
local function hopToLowPlayerServer()
    local function getServerList()
        local cursor = ""
        local servers = {}
        local maxAttempts = 3
        local attempts = 0
        while attempts < maxAttempts do
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor))
            end)
            if success and result and result.data then
                for _, server in pairs(result.data) do
                    if server.playing <= 4 and server.id ~= game.JobId then
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
            task.wait(1)
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        return servers
    end

    local maxTeleportAttempts = 5
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
        task.wait(3)
    end
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể hop server sau " .. maxTeleportAttempts .. " lần thử!",
            Duration = 5
        })
    end
end

-- Hàm phát hiện admin
local function checkAdmin()
    local adminIds = {[912348] = true, [120173604] = true}
    for _, player in pairs(Players:GetPlayers()) do
        local isAdmin = adminIds[player.UserId] or
                        player:GetRoleInGroup(game.CreatorId):lower():find("admin") or
                        player:IsInGroup(game.CreatorId)
        if isAdmin then
            hopToLowPlayerServer()
        end
    end
    Players.PlayerAdded:Connect(function(player)
        local isAdmin = adminIds[player.UserId] or
                        player:GetRoleInGroup(game.CreatorId):lower():find("admin") or
                        player:IsInGroup(game.CreatorId)
        if isAdmin then
            hopToLowPlayerServer()
        end
    end)
end
pcall(checkAdmin)

-- Thêm tất cả tab
local function detectGameAndAddTabs()
    local window = createMainUI()
    if not window then return end

    local tab1 = pcall(MakeTab, {Name = "Blox Fruits"})
    if tab1 then
        addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
        addScriptButton(tab1, "H4X Script", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
        addScriptButton(tab1, "Nat Hub", "https://get.nathub.xyz/loader")
        addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
        addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
        addScriptButton(tab1, "OMG HUB Server VIP Free", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua")
        addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
        addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")
    end

    local tab3 = pcall(MakeTab, {Name = "99 Đêm"})
    if tab3 then
        addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
        addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
        addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
        addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
        addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
        addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")
    end

    local tabHop = pcall(MakeTab, {Name = "Hop Server"})
    if tabHop then
        addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
        addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
        pcall(AddButton, tabHop, {
            Name = "Hop Server Ít Người",
            Callback = hopToLowPlayerServer
        })
    end

    local tabKey = pcall(MakeTab, {Name = "Hệ Thống Key"})
    if tabKey then
        addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")
    end

    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Đã load tất cả tab!",
        Duration = 5
    })
end

-- Bắt đầu script
pcall(createKeyGui)
