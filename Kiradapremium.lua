-- Khai báo các service cần thiết
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local gameId = game.PlaceId

-- Đợi game tải hoàn toàn
repeat task.wait() until game:IsLoaded() and PlayerGui

-- Kiểm tra game có được hỗ trợ hay không
local supportedGames = {
    [2753915549] = "Blox Fruits",
    [1234567890] = "99 Đêm" -- Thay bằng PlaceId thực tế của 99 Đêm
}
if not supportedGames[gameId] then
    StarterGui:SetCore("SendNotification", {
        Title = "Thông Báo",
        Text = "Cảm ơn bạn đã sử dụng script của mình nhé 😘",
        Duration = 10
    })
    return -- Dừng script nếu game không được hỗ trợ
end

-- Hàm phát hiện admin và hop server ngay lập tức
local function checkAdmin()
    local adminIds = {[912348] = true, [120173604] = true}
    Players.PlayerAdded:Connect(function(player)
        if adminIds[player.UserId] or player.Name:lower():find("admin") or player:GetRoleInGroup(game.CreatorId) ~= "Guest" then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(gameId, game.JobId, LocalPlayer)
            end)
        end
    end)
end
pcall(checkAdmin)

-- Tải thư viện UI Redz V2
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()
end)

-- Preload ảnh logo và âm thanh
pcall(function()
    ContentProvider:PreloadAsync({
        "rbxassetid://75676578090181",
        "rbxassetid://89326205091486",
        "rbxassetid://8987546731"
    })
end)

-- Phát âm thanh khởi động
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
    textLabel.Text = "Kirada Premium\nTác giả: Kirada & Habato\nNgười kiểm script: Nấm Gamer & Hiếu Hầu Nam\nNgười viết code: Hiếu Gamer & Hiếu TV 124"
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
    wait(5)
    fadeOutText:Play()
    fadeOutFrame:Play()
    fadeOutImage:Play()
    fadeOutText.Completed:Wait()
    screenGui:Destroy()
end
pcall(introAnimation)

-- Hệ thống key
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

local function createKeySystem()
    local keyGui = Instance.new("ScreenGui", PlayerGui)
    keyGui.Name = "KeySystemGui"
    keyGui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.1
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Kirada Premium - Key System"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0.8, 0, 0, 40)
    input.Position = UDim2.new(0.1, 0, 0.3, 0)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Nhập key tại đây..."
    input.Text = ""
    input.TextScaled = true
    local inputCorner = Instance.new("UICorner", input)
    inputCorner.CornerRadius = UDim.new(0, 5)

    local submitButton = Instance.new("TextButton", frame)
    submitButton.Size = UDim2.new(0.4, 0, 0, 40)
    submitButton.Position = UDim2.new(0.3, 0, 0.55, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.Text = "Xác Nhận"
    submitButton.TextScaled = true
    local buttonCorner = Instance.new("UICorner", submitButton)
    buttonCorner.CornerRadius = UDim.new(0, 5)

    local notification = Instance.new("TextLabel", frame)
    notification.Size = UDim2.new(1, 0, 0, 30)
    notification.Position = UDim2.new(0, 0, 0.75, 0)
    notification.BackgroundTransparency = 1
    notification.Text = ""
    notification.TextColor3 = Color3.fromRGB(255, 50, 50)
    notification.TextScaled = true

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine)
    local fadeInFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0})
    fadeInFrame:Play()

    local keyValid = false
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = input.Text:lower()
        if validKeys[enteredKey] then
            notification.Text = "Key hợp lệ! Đang chạy script..."
            notification.TextColor3 = Color3.fromRGB(50, 255, 50)
            keyValid = true
            local fadeOutFrame = TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 1})
            fadeOutFrame:Play()
            wait(1)
            keyGui:Destroy()
        else
            notification.Text = "Key không hợp lệ! Vui lòng thử lại."
            notification.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)

    -- Đợi key hợp lệ
    repeat task.wait() until keyValid
end
pcall(createKeySystem)

-- Tạo menu chính
local window = MakeWindow({
    Hub = {Title = "Kirada Premium", Animation = "YouTube: Kirada Premium"},
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

-- Hàm thêm nút sao chép key
local function addButton(tab, name, key)
    AddButton(tab, {
        Name = name,
        Callback = function()
            local success, err = pcall(function()
                setclipboard(key)
            end)
            StarterGui:SetCore("SendNotification", success and {
                Title = "Thông Báo",
                Text = "Đã sao chép key " .. name .. "!",
                Duration = 10
            } or {
                Title = "Lỗi",
                Text = "Không thể sao chép key " .. name .. ": " .. tostring(err),
                Duration = 5
            })
        end
    })
end

-- Tab: Blox Fruit
local tab1 = MakeTab({Name = "Blox Fruit"})
addScriptButton(tab1, "W-AZURE", "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua")
addScriptButton(tab1, "H4X Script", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
addScriptButton(tab1, "Nat Hub", "https://get.nathub.xyz/loader")
addScriptButton(tab1, "Quantum Hub", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua")
addScriptButton(tab1, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
addScriptButton(tab1, "Tạo Server VIP Free", "https://raw.githubusercontent.com/JoshzzAlteregooo/FreePrivateServer/refs/heads/main/UniversalFreePrivateServerByJoshzz")
addScriptButton(tab1, "Giảm Lag", "https://raw.githubusercontent.com/TurboLite/Script/main/FixLag.lua")
addScriptButton(tab1, "Maru Premium Fake", "https://raw.githubusercontent.com/hnc-roblox/Free/refs/heads/main/MaruHubPremiumFake.HNC%20Roblox.lua")

-- Tab: Hop Server
local tab2 = MakeTab({Name = "Hop Server"})
addScriptButton(tab2, "Teddy Hub", "https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM")
addScriptButton(tab2, "VisionX", "https://raw.githubusercontent.com/xSync-gg/VisionX/refs/heads/main/Server_Finder.lua")

-- Tab: 99 Đêm
local tab3 = MakeTab({Name = "99 Đêm"})
addScriptButton(tab3, "NATHUB", "https://get.nathub.xyz/loader")
addScriptButton(tab3, "H4X", "https://raw.githubusercontent.com/H4xScripts/Loader/refs/heads/main/loader.lua")
addScriptButton(tab3, "Speed Hub", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua")
addScriptButton(tab3, "Hack Farm Kim Cương", "https://raw.githubusercontent.com/sleepyvill/script/refs/heads/main/99nights.lua")
addScriptButton(tab3, "Skibidi", "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua")
addScriptButton(tab3, "Ringta", "https://raw.githubusercontent.com/wefwef127382/99daysloader.github.io/refs/heads/main/ringta.lua")

-- Tab: Hệ Thống Key
local tab5 = MakeTab({Name = "Hệ Thống Key"})
addButton(tab5, "Sao Chép Key Speed Hub", "KfHLmNFnuaRmvbkQRwZGXDROXkxhdYAE")
