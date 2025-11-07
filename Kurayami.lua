-- Kurayami Demo 1.5
-- Hack Script for Roblox (Use with exploits like Synapse X or Krnl)
-- Tác giả: Grok (Demo)
-- Tính năng: Giao diện Giáng sinh, Menu ngang, Kéo được bằng cảm ứng, Bật/Tắt & Nhập số

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Biến trạng thái
local SpeedEnabled = false
local JumpEnabled = false
local PlayerESPEnabled = false
local NPCESPEnabled = false
local NoclipEnabled = false

local SpeedValue = 16
local JumpValue = 50

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KurayamiDemo1.5"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Khung chính (Menu ngang)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
MainFrame.Size = UDim2.new(0, 500, 0, 70)
MainFrame.Active = true
MainFrame.Visible = true

-- Icon Giáng sinh (cây thông xanh)
local ChristmasIcon = Instance.new("ImageLabel")
ChristmasIcon.Name = "ChristmasIcon"
ChristmasIcon.Parent = MainFrame
ChristmasIcon.BackgroundTransparency = 1
ChristmasIcon.Position = UDim2.new(0, 10, 0, 10)
ChristmasIcon.Size = UDim2.new(0, 50, 0, 50)
ChristmasIcon.Image = "rbxassetid://183534042" -- Cây thông Giáng sinh (Roblox Asset)
ChristmasIcon.ImageColor3 = Color3.fromRGB(0, 200, 0)

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 70, 0, 0)
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Kurayami v1.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Bố cục ngang
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Hàm tạo nút Bật/Tắt
local function CreateToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Toggle"
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(0, 70, 0, 50)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.Text = name .. "\nTẮT"
    Button.TextColor3 = Color3.fromRGB(255, 100, 100)
    Button.TextSize = 12
    Button.AutoButtonColor = false

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = name .. "\n" .. (state and "BẬT" or "TẮT")
        Button.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)

    return Button
end

-- Hàm tạo ô nhập số
local function CreateInput(placeholder, size, callback)
    local Box = Instance.new("TextBox")
    Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Box.BorderSizePixel = 0
    Box.Size = size
    Box.Font = Enum.Font.SourceSans
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(200, 200, 200)
    Box.TextSize = 11

    Box.FocusLost:Connect(function(enter)
        if enter and Box.Text ~= "" then
            local num = tonumber(Box.Text)
            if num then
                callback(num)
            end
            Box.Text = ""
        end
    end)

    return Box
end

-- === CHẠY NHANH ===
local SpeedToggle = CreateToggle("CHẠY", function(enabled)
    SpeedEnabled = enabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = enabled and SpeedValue or 16
    end
end)
SpeedToggle.LayoutOrder = 1

local SpeedInput = CreateInput("Số tốc độ...", UDim2.new(0, 50, 0, 30), function(value)
    SpeedValue = math.clamp(value, 16, 500)
    if SpeedEnabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end)
SpeedInput.Parent = SpeedToggle
SpeedInput.Position = UDim2.new(0, 10, 1, 5)

-- === NHẢY CAO ===
local JumpToggle = CreateToggle("NHẢY", function(enabled)
    JumpEnabled = enabled
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = enabled and JumpValue or 50
    end
end)
JumpToggle.LayoutOrder = 2

local JumpInput = CreateInput("Số nhảy...", UDim2.new(0, 50, 0, 30), function(value)
    JumpValue = math.clamp(value, 50, 300)
    if JumpEnabled and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.JumpPower = JumpValue
    end
end)
JumpInput.Parent = JumpToggle
JumpInput.Position = UDim2.new(0, 10, 1, 5)

-- === ĐỊNH VỊ NGƯỜI CHƠI ===
local PlayerESPToggle = CreateToggle("NGƯỜI", function(enabled)
    PlayerESPEnabled = enabled
end)
PlayerESPToggle.LayoutOrder = 3

-- === ĐỊNH VỊ NPC ===
local NPCESPToggle = CreateToggle("NPC", function(enabled)
    NPCESPEnabled = enabled
end)
NPCESPToggle.LayoutOrder = 4

-- === XUYÊN TƯỜNG ===
local NoclipToggle = CreateToggle("XUYÊN", function(enabled)
    NoclipEnabled = enabled
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
NoclipToggle.LayoutOrder = 5

-- === DỊCH CHUYỂN ===
local TeleportFrame = Instance.new("Frame")
TeleportFrame.Size = UDim2.new(0, 80, 0, 50)
TeleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TeleportFrame.LayoutOrder = 6

local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Parent = TeleportFrame
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Size = UDim2.new(1, 0, 0.4, 0)
TeleportLabel.Font = Enum.Font.SourceSansSemibold
TeleportLabel.Text = "DỊCH CHUYỂN"
TeleportLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TeleportLabel.TextSize = 11

local TeleportInput = CreateInput("ID/Tên...", UDim2.new(1, -10, 0.4, 0), function() end)
TeleportInput.Parent = TeleportFrame
TeleportInput.Position = UDim2.new(0, 5, 0.4, 0)

local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = TeleportFrame
TeleportBtn.Size = UDim2.new(1, -10, 0.3, 0)
TeleportBtn.Position = UDim2.new(0, 5, 0.7, 0)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TeleportBtn.Text = "ĐI"
TeleportBtn.TextColor3 = Color3.new(1,1,1)
TeleportBtn.Font = Enum.Font.SourceSansBold
TeleportBtn.TextSize = 12
TeleportBtn.MouseButton1Click:Connect(function()
    local input = TeleportInput.Text
    if input == "" then return end
    local target = Players:FindFirstChild(input) or Players:GetPlayerByUserId(tonumber(input))
    if target and target.Character and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
    TeleportInput.Text = ""
end)

-- === KÉO NGƯỜI ===
local BringFrame = Instance.new("Frame")
BringFrame.Size = UDim2.new(0, 80, 0, 50)
BringFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BringFrame.LayoutOrder = 7

local BringLabel = Instance.new("TextLabel")
BringLabel.Parent = BringFrame
BringLabel.BackgroundTransparency = 1
BringLabel.Size = UDim2.new(1, 0, 0.4, 0)
BringLabel.Font = Enum.Font.SourceSansSemibold
BringLabel.Text = "KÉO VỀ"
BringLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
BringLabel.TextSize = 11

local BringInput = CreateInput("ID/Tên...", UDim2.new(1, -10, 0.4, 0), function() end)
BringInput.Parent = BringFrame
BringInput.Position = UDim2.new(0, 5, 0.4, 0)

local BringBtn = Instance.new("TextButton")
BringBtn.Parent = BringFrame
BringBtn.Size = UDim2.new(1, -10, 0.3, 0)
BringBtn.Position = UDim2.new(0, 5, 0.7, 0)
BringBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
BringBtn.Text = "KÉO"
BringBtn.TextColor3 = Color3.new(1,1,1)
BringBtn.Font = Enum.Font.SourceSansBold
BringBtn.TextSize = 12
BringBtn.MouseButton1Click:Connect(function()
    local input = BringInput.Text
    if input == "" then return end
    local target = Players:FindFirstChild(input) or Players:GetPlayerByUserId(tonumber(input))
    if target and target.Character and LocalPlayer.Character then
        target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
    BringInput.Text = ""
end)

-- Thêm các phần tử vào MainFrame
SpeedToggle.Parent = MainFrame
JumpToggle.Parent = MainFrame
PlayerESPToggle.Parent = MainFrame
NPCESPToggle.Parent = MainFrame
NoclipToggle.Parent = MainFrame
TeleportFrame.Parent = MainFrame
BringFrame.Parent = MainFrame

-- === ESP CHO NGƯỜI & NPC ===
local ESPs = {}
local function AddESP(target, isPlayer)
    if not target or not target:FindFirstChild("Head") then return end
    local bill = Instance.new("BillboardGui")
    bill.Adornee = target.Head
    bill.Size = UDim2.new(0, 120, 0, 60)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = target.Head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = bill
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextColor3 = isPlayer and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    nameLabel.Text = isPlayer and target.Name or "NPC"
    nameLabel.TextSize = 14

    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = bill
    distLabel.BackgroundTransparency = 1
    distLabel.Position = UDim2.new(0,0,0.5,0)
    distLabel.Size = UDim2.new(1,0,0.5,0)
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextColor3 = Color3.fromRGB(255,255,255)
    distLabel.TextSize = 12

    table.insert(ESPs, {bill = bill, dist = distLabel, target = target})

    spawn(function()
        while wait(0.1) do
            if not target.Parent or not LocalPlayer.Character then
                bill:Destroy()
                break
            end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local thrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
            if hrp and thrp then
                local dist = (hrp.Position - thrp.Position).Magnitude
                distLabel.Text = "Khoảng cách: " .. math.floor(dist) .. "m"
            end
            bill.Enabled = (isPlayer and PlayerESPEnabled) or (not isPlayer and NPCESPEnabled)
        end
    end)
end

-- Cập nhật ESP
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        wait(1)
        if PlayerESPEnabled then AddESP(char, true) end
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        if PlayerESPEnabled then AddESP(plr.Character, true) end
    end
end

spawn(function()
    while wait(2) do
        if NPCESPEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
                    AddESP(obj, false)
                end
            end
        end
    end
end)

-- === KÉO MENU BẰNG CẢM ỨNG ===
local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- === NÚT �ters
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

local menuOpen = true
CloseBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
end)

-- === HIỆU ỨNG GIÁNG SINH ===
Lighting.FogEnd = 200
Lighting.FogColor = Color3.fromRGB(200, 230, 255)
Lighting.Brightness = 1.5

print("Kurayami Demo 1.5 đã tải! Chúc Giáng sinh vui vẻ! 🎄")
