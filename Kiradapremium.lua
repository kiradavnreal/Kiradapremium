local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Đợi game tải
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["kiradahub"] = true,
    ["mimi"] = true,
    ["hangay"] = true,
    ["bananahub"] = true,
    ["phucdam"] = true,
    ["ezakgaminh"] = true,
    ["kiradagamer"] = true
}

-- User ID được phép sử dụng key đặc biệt kiradahub và kiradagamer
local specialKeyUserId = 4368306689

-- Giao diện nhập key cải tiến
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    -- Frame chính với gradient
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 350, 0, 250)
    frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
    }
    gradient.Rotation = 45
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    -- Title
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Hệ Thống Key"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 120, 215)

    -- TextBox
    local textBox = Instance.new("TextBox", frame)
    textBox.Size = UDim2.new(0.85, 0, 0, 50)
    textBox.Position = UDim2.new(0.075, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "Nhập key tại đây..."
    textBox.Text = ""
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    
    local textBoxCorner = Instance.new("UICorner", textBox)
    textBoxCorner.CornerRadius = UDim.new(0, 8)
    
    local textBoxStroke = Instance.new("UIStroke", textBox)
    textBoxStroke.Color = Color3.fromRGB(0, 120, 215)
    textBoxStroke.Thickness = 1

    -- Submit Button
    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 50)
    submitButton.Position = UDim2.new(0.3, 0, 0.65, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.GothamBold
    
    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 8)
    
    local buttonStroke = Instance.new("UIStroke", submitButton)
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Thickness = 1

    -- Hiệu ứng hover cho button
    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
    end)

    -- Xử lý nhập key
    local keyEntered = false
    submitButton.MouseButton1Click:Connect(function()
        local inputKey = textBox.Text:lower()
        local playerUserId = LocalPlayer.UserId

        -- Kiểm tra key đặc biệt chỉ cho User ID 4368306689
        if (inputKey == "kiradahub" or inputKey == "kiradagamer") and playerUserId ~= specialKeyUserId then
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key " .. inputKey .. " chỉ dành cho người dùng đặc biệt!",
                Duration = 5
            })
            textBox.Text = ""
            -- Hiệu ứng rung khi sai key
            local originalPos = frame.Position
            for i = 1, 3 do
                frame.Position = originalPos + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
                task.wait(0.05)
            end
            frame.Position = originalPos
            return
        end

        -- Cấm User ID 4368306689 sử dụng key khác ngoài kiradahub và kiradagamer
        if playerUserId == specialKeyUserId and inputKey ~= "kiradahub" and inputKey ~= "kiradagamer" then
            LocalPlayer:Kick("Bạn chỉ được phép sử dụng key kiradahub hoặc kiradagamer!")
            return
        end

        -- Kiểm tra key hợp lệ
        if validKeys[inputKey] then
            keyEntered = true
            StarterGui:SetCore("SendNotification", {
                Title = "Thành Công",
                Text = "Cảm ơn bạn đã sử dụng premium của mình 😍😘",
                Duration = 5
            })
            -- Hiệu ứng mờ dần khi xác nhận
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, tweenInfo, {TextTransparency = 1}):Play()
            TweenService:Create(textBox, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Lỗi",
                Text = "Key không hợp lệ! Vui lòng thử lại.",
                Duration = 5
            })
            textBox.Text = ""
            -- Hiệu ứng rung khi sai key
            local originalPos = frame.Position
            for i = 1, 3 do
                frame.Position = originalPos + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
                task.wait(0.05)
            end
            frame.Position = originalPos
        end
    end)

    -- Hỗ trợ nhấn Enter để xác nhận
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

-- Hàm phát hiện admin
local function checkAdmin()
    local adminIds = {[912348] = true, [120173604] = true}
    for _, player in pairs(Players:GetPlayers()) do
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            StarterGui:SetCore("SendNotification", {
                Title = "Cảnh Báo",
                Text = "Phát hiện admin trong server!",
                Duration = 5
            })
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if adminIds[player.UserId] or player:GetRoleInGroup(game.CreatorId) == "Admin" then
            StarterGui:SetCore("SendNotification", {
                Title = "Cảnh Báo",
                Text = "Phát hiện admin trong server!",
                Duration = 5
            })
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
    addScriptButton(tab1, "Tạo Server Mọi Game", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")
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
