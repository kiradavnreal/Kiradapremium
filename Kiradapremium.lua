local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer and LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Kiểm tra LocalPlayer
if not LocalPlayer then
    warn("Không tìm thấy LocalPlayer. Script sẽ không chạy.")
    return
end

-- Đợi game tải hoàn tất
repeat
    task.wait()
until game:IsLoaded() and LocalPlayer

-- Danh sách key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true,
    ["phucdam"] = true,
    ["ezakgaminh"] = true,
    ["test"] = true,
    ["kiradapremiumv2"] = true,
    ["noobv5"] = true
}

-- Tạo giao diện nhập key
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "GiaoDienHeThongKey"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    -- Khung chính
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    -- Hiệu ứng gradient
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    })
    gradient.Rotation = 45

    -- Bo góc
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Hiệu ứng bóng
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = -1

    -- Tiêu đề
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Hệ Thống Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextTransparency = 1

    -- Ô nhập văn bản
    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    textBox.PlaceholderText = "Nhập key của bạn tại đây..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.TextTransparency = 1
    textBox.BackgroundTransparency = 1

    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)

    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(80, 80, 80)
    textBoxStroke.Thickness = 1

    -- Nút xác nhận
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.5, 0, 0, 50)
    submitButton.Position = UDim2.new(0.25, 0, 0.6, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextTransparency = 1
    submitButton.BackgroundTransparency = 1

    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)

    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(0, 80, 150)
    buttonStroke.Thickness = 1

    -- Hiệu ứng di chuột cho nút
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
    end)

    -- Hiệu ứng mở giao diện
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -175, 0.5, -125)}):Play()
    TweenService:Create(title, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(textBox, tweenInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    TweenService:Create(submitButton, tweenInfo, {TextTransparency = 0, BackgroundTransparency = 0}):Play()

    -- Logic kiểm tra key
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        if validKeys[textBox.Text:lower()] then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công",
                Text = "Cảm ơn bạn đã sử dụng Kirada Premium! 😍",
                Duration = 5
            })
            -- Hiệu ứng đóng giao diện
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(textBox, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key không hợp lệ! Vui lòng thử lại.",
                Duration = 5
            })
            textBox.Text = ""
            -- Hiệu ứng rung khi key sai
            local originalPos = textBox.Position
            for i = 1, 3 do
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, 5, 0, 0)}):Play()
                task.wait(0.05)
                TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos + UDim2.new(0, -5, 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(textBox, TweenInfo.new(0.05), {Position = originalPos}):Play()
        end
    end)

    while not keyEntered do
        task.wait(0.1)
    end
end

-- Thử chạy giao diện key
local success, err = pcall(createKeyGui)
if not success then
    warn("Lỗi khi tạo giao diện key: " .. tostring(err))
    StarterGui:SetCore("SendNotification", {
        Title = "Lỗi",
        Text = "Không thể tạo giao diện key: " .. tostring(err),
        Duration = 10
    })
    return
end

-- Tải thư viện UI Redz V2
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)
if not success then
    warn("Lỗi khi tải UI Redz V2: " .. tostring(result))
    StarterGui:SetCore("SendNotification", {
        Title = "Lỗi",
        Text = "Không thể tải giao diện: " .. tostring(result),
        Duration = 10
    })
    return
end

-- Tải trước tài nguyên
local success, err = pcall(function()
    ContentProvider:PreloadAsync({
        "rbxassetid://75676578090181",
        "rbxassetid://89326205091486",
        "rbxassetid://8987546731"
    })
end)
if not success then
    warn("Lỗi khi tải trước tài nguyên: " .. tostring(err))
end

-- Phát âm thanh khởi động
local function playStartupSound()
    local success, err = pcall(function()
        local sound = Instance.new("Sound", SoundService)
        sound.SoundId = "rbxassetid://8987546731"
        sound.Volume = 1
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
    if not success then
        warn("Lỗi khi phát âm thanh khởi động: " .. tostring(err))
    end
end
playStartupSound()

-- Hiệu ứng giới thiệu
local function introAnimation()
    local success, err = pcall(function()
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
        textLabel.Text = "Kirada Premium\nTác giả: Kirada VN & Habato\nNgười kiểm tra: Nấm Gamer"
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
    end)
    if not success then
        warn("Lỗi khi chạy hiệu ứng giới thiệu: " .. tostring(err))
    end
end
introAnimation()

-- Kiểm tra các hàm giao diện
if not (MakeWindow and AddButton and MinimizeButton) then
    warn("Một hoặc nhiều hàm MakeWindow, AddButton, MinimizeButton không tồn tại. Kiểm tra thư viện UI Redz V2.")
    StarterGui:SetCore("SendNotification", {
        Title = "Lỗi",
        Text = "Thư viện UI Redz V2 không tải đúng. Vui lòng kiểm tra URL hoặc script.",
        Duration = 10
    })
    return
end

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
    Key = {KeySystem = false, Title = "Hệ Thống Key", Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không hợp lệ", CopyKeyLink = "Đã sao chép vào clipboard"}}
})
MinimizeButton({
    Image = "rbxassetid://89326205091486",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

-- Hàm thêm nút sao chép
local function addButton(tab, name, url)
    local success, err = pcall(function()
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
    end)
    if not success then
        warn("Lỗi khi thêm nút sao chép: " .. tostring(err))
    end
end

-- Hàm thêm nút chạy script
local function addScriptButton(tab, name, url)
    local success, err = pcall(function()
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
    end)
    if not success then
        warn("Lỗi khi thêm nút script: " .. tostring(err))
    end
end

-- Hàm chuyển server ít người
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
            task.wait(0.5)
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        return servers
    end

    local maxTeleportAttempts = 10
    local teleportAttempts = 0
    local success = false
    while not success and teleportAttempts < maxTeleportAttempts do
        local teleportSuccess, err = pcall(function()
            local servers = getServerList()
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(gameId, servers[1].id, LocalPlayer)
                StarterGui:SetCore("SendNotification", {
                    Title = "Thông Báo",
                    Text = "Đang chuyển đến server có " .. tostring(servers[1].playing) .. " người!",
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
        if not teleportSuccess then
            warn("Lỗi khi chuyển server: " .. tostring(err))
        end
        teleportAttempts = teleportAttempts + 1
        task.wait(2)
    end
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể chuyển server sau " .. maxTeleportAttempts .. " lần thử!",
            Duration = 5
        })
    end
end

-- Hàm phát hiện admin
local function checkAdmin()
    local success, err = pcall(function()
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
    end)
    if not success then
        warn("Lỗi khi kiểm tra admin: " .. tostring(err))
    end
end
checkAdmin()

-- Thêm các tab
local function detectGameAndAddTabs()
    local success, err = pcall(function()
        -- Tab Blox Fruits
        local tab1 = MakeTab({Name = "Blox Fruits"})
        addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
        addScriptButton(tab1, "H4X Script", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
        addScriptButton(tab1, "Nat Hub", "https://get.nathub.xyz/loader")
        addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
        addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
        addScriptButton(tab1, "OMG HUB Server VIP Free", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua")
        addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
        addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")

        -- Tab 99 Đêm
        local tab3 = MakeTab({Name = "99 Đêm"})
        addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
        addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
        addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
        addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
        addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
        addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

        -- Tab Chuyển Server
        local tabHop = MakeTab({Name = "Chuyển Server"})
        addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
        addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
        AddButton(tabHop, {
            Name = "Chuyển Server Ít Người",
            Callback = hopToLowPlayerServer
        })

        -- Tab Hệ Thống Key
        local tabKey = MakeTab({Name = "Hệ Thống Key"})
        addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")

        StarterGui:SetCore("SendNotification", {
            Title = "Thông Báo",
            Text = "Đã tải tất cả tab!",
            Duration = 5
        })
    end)
    if not success then
        warn("Lỗi khi thêm tab: " .. tostring(err))
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể thêm tab: " .. tostring(err),
            Duration = 10
        })
    end
end

-- Chạy các tab
task.wait(0.1)
detectGameAndAddTabs()
