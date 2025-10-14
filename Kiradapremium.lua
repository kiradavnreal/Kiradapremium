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

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Key hợp lệ (vô thời hạn, trừ hicak)
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

-- Bảng lưu thời gian sử dụng key (chỉ cho hicak)
local keyUsage = {} -- Format: {key = {startTime = os.time(), duration = 36000}}

-- Kiểm tra key hợp lệ và thời gian sử dụng
local function isKeyValid(key)
    key = key:lower()
    if not validKeys[key] then
        return false, "Key không đúng!"
    end

    -- Chỉ áp dụng giới hạn thời gian cho hicak
    if key == "hicak" and keyUsage[key] then
        local elapsed = os.time() - keyUsage[key].startTime
        if elapsed >= keyUsage[key].duration then
            keyUsage[key] = nil -- Hết thời gian sử dụng
            return false, "Key hicak đã hết thời gian sử dụng (10 tiếng)!"
        end
    end
    return true, nil
end

-- Tính thời gian còn lại
local function getRemainingTime(key)
    key = key:lower()
    if key == "hicak" and keyUsage[key] then
        local elapsed = os.time() - keyUsage[key].startTime
        local remaining = keyUsage[key].duration - elapsed
        if remaining > 0 then
            local hours = math.floor(remaining / 3600)
            local minutes = math.floor((remaining % 3600) / 60)
            local seconds = remaining % 60
            return string.format("%02d:%02d:%02d", hours, minutes, seconds)
        end
        return "Hết hạn"
    end
    return "Vô thời hạn"
end

-- Giao diện nhập key "cute"
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    -- Frame chính với màu pastel
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 300)
    frame.Position = UDim2.new(0.5, -175, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Màu hồng phấn
    frame.BorderSizePixel = 0

    -- Góc bo tròn
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 20)

    -- Gradient nền
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 182, 193)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 230))
    })
    gradient.Rotation = 45

    -- Hiệu ứng ánh sáng nhẹ
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.5

    -- Tiêu đề
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "🌸 Kirada Premium 🌸"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.FredokaOne
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(100, 100, 100)

    -- Hiển thị thời gian còn lại
    local timeLabel = Instance.new("TextLabel", frame)
    timeLabel.Size = UDim2.new(0.85, 0, 0, 30)
    timeLabel.Position = UDim2.new(0.075, 0, 0.65, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Thời gian còn lại: Chưa nhập key"
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.FredokaOne

    -- TextBox nhập key
    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextColor3 = Color3.fromRGB(255, 105, 180)
    textBox.PlaceholderText = "Nhập key của bạn tại đây... 💖"
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.FredokaOne
    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 15)
    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(255, 182, 193)
    textBoxStroke.Thickness = 1

    -- Nút xác nhận
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 50)
    submitButton.Position = UDim2.new(0.3, 0, 0.45, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận ✨"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.FredokaOne
    local cornerButton = Instance.new("UICorner", submitButton)
    cornerButton.CornerRadius = UDim.new(0, 15)
    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1
    buttonStroke.Transparency = 0.5

    -- Hiệu ứng hover cho nút
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 150, 200)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play()
    end)

    -- Hiệu ứng nhấp nút
    submitButton.MouseButton1Down:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.38, 0, 0, 45)}):Play()
    end)
    submitButton.MouseButton1Up:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.1), {Size = UDim2.new(0.4, 0, 0, 50)}):Play()
    end)

    -- Logic xử lý key
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        local isValid, errorMsg = isKeyValid(textBox.Text)
        if isValid then
            keyEntered = true
            if textBox.Text:lower() == "hicak" then
                keyUsage[textBox.Text:lower()] = {startTime = os.time(), duration = 36000}
            end
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công 🌟",
                Text = "Cảm ơn bạn đã sử dụng Kirada Premium! 😍",
                Duration = 5
            })
            -- Cập nhật thời gian còn lại
            timeLabel.Text = "Thời gian còn lại: " .. getRemainingTime(textBox.Text)
            -- Hiệu ứng mờ dần khi thành công
            TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(timeLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(textBox, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(submitButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi 😔",
                Text = errorMsg or "Key không đúng!",
                Duration = 5
            })
            textBox.Text = ""
            -- Hiệu ứng rung khi lỗi
            local originalPos = frame.Position
            for i = 1, 3 do
                frame.Position = originalPos + UDim2.new(0, 5, 0, 0)
                task.wait(0.05)
                frame.Position = originalPos + UDim2.new(0, -5, 0, 0)
                task.wait(0.05)
            end
            frame.Position = originalPos
        end
    end)

    -- Cập nhật thời gian còn lại mỗi giây
    spawn(function()
        while not keyEntered and frame.Parent do
            timeLabel.Text = "Thời gian còn lại: " .. getRemainingTime(textBox.Text)
            task.wait(1)
        end
    end)

    while not keyEntered do
        task.wait(0.1)
    end
end
pcall(createKeyGui)

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

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
    Key = {KeySystem = false, Title = "Hệ Thống Key", Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không đúng", CopyKeyLink = "Đã sao chép vào clipboard"}}
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
        -- Sắp xếp ưu tiên server 0, 1, 3, dưới 5 người
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
    addScriptButton(tab1, "OMG HUB Server VIP Free", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua")
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

-- Theo dõi thời gian sử dụng key hicak và thông báo khi hết hạn
spawn(function()
    while true do
        if keyUsage["hicak"] then
            if os.time() - keyUsage["hicak"].startTime >= keyUsage["hicak"].duration then
                keyUsage["hicak"] = nil
                StarterGui:SetCore("SendNotification", {
                    Title = "Hết Hạn 😔",
                    Text = "Key hicak đã hết thời gian sử dụng (10 tiếng)!",
                    Duration = 5
                })
                -- Yêu cầu nhập lại key
                pcall(createKeyGui)
            end
        end
        task.wait(1)
    end
end)
