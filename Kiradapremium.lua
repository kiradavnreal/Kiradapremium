-- Khai báo các service cần thiết
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

-- Đợi game tải hoàn toàn
repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

-- Danh sách key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true
}

-- Hàm tạo giao diện nhập key
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium Universal - Nhập Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8, 0, 0, 40)
    textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key tại đây..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Parent = frame

    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.4, 0, 0, 40)
    submitButton.Position = UDim2.new(0.3, 0, 0.6, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Parent = frame

    local cornerButton = Instance.new("UICorner")
    cornerButton.CornerRadius = UDim.new(0, 10)
    cornerButton.Parent = submitButton

    -- Hàm xử lý khi nhấn nút xác nhận
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = textBox.Text:lower()
        if validKeys[enteredKey] then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Cảm ơn bạn đã mua bản Premium của tớ 😍",
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

    -- Đợi cho đến khi key được nhập đúng
    while not keyEntered do
        task.wait(0.1)
    end
end

-- Chạy hệ thống key
pcall(function()
    createKeyGui()
end)

-- Tải thư viện UI Redz V2
pcall(function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
    end)
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể tải thư viện UI: " .. tostring(result),
            Duration = 10
        })
        return
    end
end)

-- Preload ảnh logo và âm thanh
pcall(function()
    ContentProvider:PreloadAsync({
        "rbxassetid://75676578090181",
        "rbxassetid://89326205091486",
        "rbxassetid://8987546731"
    })
end)

-- Phát âm thanh startup
local function playStartupSound()
    local sound = Instance.new("Sound", SoundService)
    sound.SoundId = "rbxassetid://8987546731"
    sound.Volume = 1
    sound.PlayOnRemove = false
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end
pcall(playStartupSound)

-- Intro animation
local function introAnimation()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "IntroGui"
    screenGui.IgnoreGuiInset = true
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Kirada Premium Universal\nTác giả: Kirada VN & Habato\nNgười test: Nấm Gamer"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    local imageLabel = Instance.new("ImageLabel", frame)
    imageLabel.Size = UDim2.new(0, 100, 0, 100)
    imageLabel.Position = UDim2.new(0.5, -50, 0.6, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://75676578090181"
    imageLabel.ImageTransparency = 1
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine)
    local fadeInText = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 0})
    local fadeInFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.2})
    local fadeInImage = TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 0})
    local fadeOutText = TweenService:Create(textLabel, tweenInfo, {TextTransparency = 1})
    local fadeOutFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
    local fadeOutImage = TweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 1})
    fadeInText:Play()
    fadeInFrame:Play()
    fadeInImage:Play()
    fadeInText.Completed:Wait()
    task.wait(3)
    fadeOutText:Play()
    fadeOutFrame:Play()
    fadeOutImage:Play()
    fadeOutText.Completed:Wait()
    screenGui:Destroy()
end
pcall(introAnimation)

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada VN"},
    Key = {KeySystem = false, Title = "Hệ Thống Key", Keys = {}, Notifi = {Notifications = true, CorrectKey = "Đang chạy script...", Incorrectkey = "Key không đúng", CopyKeyLink = "Đã sao chép vào clipboard"}}
})
MinimizeButton({
    Image = "rbxassetid://89326205091486",
    Size = {60, 60},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,
    Stroke = false,
    StrokeColor = Color3.fromRGB(255, 0, 0)
})

-- Hàm thêm nút sao chép link/key
local function addButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            local success, err = pcall(function()
                setclipboard(url)
            end)
            StarterGui:SetCore("SendNotification", success and {
                Title = "Thông Báo",
                Text = "Đã sao chép link " .. name .. "!",
                Duration = 10
            } or {
                Title = "Lỗi",
                Text = "Không thể sao chép link " .. name .. ": " .. tostring(err),
                Duration = 5
            })
        end
    })
end

-- Hàm thêm nút chạy script
local function addScriptButton(tab, name, url)
    AddButton(tab, {
        Name = name,
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            StarterGui:SetCore("SendNotification", success and {
                Title = "Thông Báo",
                Text = "Đã chạy script " .. name .. "!",
                Duration = 5
            } or {
                Title = "Lỗi",
                Text = "Không thể chạy script " .. name .. ": " .. tostring(err),
                Duration = 5
            })
        end
    })
end

-- Hàm nhảy vào server có 0 hoặc 1 người
local function hopToLowPlayerServer()
    local function getServerList()
        local cursor = ""
        local servers = {}
        while true do
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor))
            end)
            if success and result and result.data then
                for _, server in pairs(result.data) do
                    if server.playing <= 1 and server.id ~= game.JobId then
                        table.insert(servers, server)
                    end
                end
                cursor = result.nextPageCursor
                if not cursor then break end
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi",
                    Text = "Không thể lấy danh sách server: " .. tostring(result),
                    Duration = 5
                })
                break
            end
            task.wait(1) -- Tăng thời gian để tránh rate limit
        end
        return servers
    end

    local success, err = pcall(function()
        local servers = getServerList()
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(gameId, servers[1].id, LocalPlayer)
            StarterGui:SetCore("SendNotification", {
                Title = "Thông Báo",
                Text = "Đang nhảy vào server có " .. tostring(servers[1].playing) .. " người!",
                Duration = 5
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Không tìm thấy server có 0 hoặc 1 người!",
                Duration = 5
            })
        end
    end)
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Lỗi",
            Text = "Không thể nhảy server: " .. tostring(err),
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

-- Hàm thêm tất cả các tab cho mọi game
local function detectGameAndAddTabs()
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

    -- Tab Hop Server
    local tabHop = MakeTab({Name = "Hop Server"})
    addScriptButton(tabHop, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
    addScriptButton(tabHop, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")
    AddButton(tabHop, {
        Name = "Nhảy Server 0-1 Người",
        Callback = function()
            pcall(hopToLowPlayerServer)
        end
    })

    -- Tab Hệ Thống Key
    local tabKey = MakeTab({Name = "Hệ Thống Key"})
    addButton(tabKey, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")

    -- Tab Idol YTB Hack
    local tabIdol = MakeTab({Name = "Idol YTB Hack"})
    addButton(tabIdol, "Vịt Lỏd", "https://www.youtube.com/channel/UCQinN9_tN8ln_Mk3hqEfLLw")
    addButton(tabIdol, "EZ AK Gaming", "https://www.youtube.com/@akgamingytb999")
    addButton(tabIdol, "TBoy", "https://www.youtube.com/channel/UCTwTw3BeiQm2dNtsVeCxlYw")

    -- Tab Mạng Xã Hội
    local tabSocial = MakeTab({Name = "Mạng Xã Hội"})
    addButton(tabSocial, "Discord", "https://discord.gg/kJ9ydA2PP4")
    addButton(tabSocial, "YouTube", "https://www.youtube.com/@kiradavn")
    addButton(tabSocial, "TikTok", "https://www.tiktok.com/@offbyebyesad")

    -- Thông báo khi load tab
    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Đã load tất cả tab cho game hiện tại!",
        Duration = 5
    })
end

-- Chạy detectGameAndAddTabs sau khi tạo window
task.wait(1) -- Đợi UI load
detectGameAndAddTabs()
