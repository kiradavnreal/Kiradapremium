local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

-- Đợi game tải
repeat task.wait() until game:IsLoaded() and LocalPlayer

-- Key hợp lệ
local validKeys = {
    ["noob"] = true,
    ["namgamer"] = true,
    ["kiradavnhub"] = true,
    ["tunghub"] = true,
    ["hangay"] = true,
    ["nguyendo"] = true,
    ["chunggay"] = true,
    ["huyencute"] = true,
    ["test"] = true,
    ["lucy"] = true,
    ["soma"] = true,
    ["redzhub"] = true
    ["joke"] = true
}

-- Giao diện nhập key với chủ đề nửa ác quỷ nửa thiên thần
local function createKeyGui()
    local screenGui = Instance.new("ScreenGui", PlayerGui)
    screenGui.Name = "KeySystemGui"
    screenGui.IgnoreGuiInset = true

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 10)

    -- Gradient cho chủ đề nửa ác quỷ (đỏ/đen) nửa thiên thần (trắng/xanh)
    local uiGradient = Instance.new("UIGradient", mainFrame)
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),  -- Ác quỷ: Đỏ
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)), -- Chuyển tiếp đen
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) -- Thiên thần: Trắng
    }
    uiGradient.Rotation = 0  -- Gradient ngang

    -- Khung con bên ác quỷ (trái)
    local devilFrame = Instance.new("Frame", mainFrame)
    devilFrame.Size = UDim2.new(0.5, 0, 1, 0)
    devilFrame.Position = UDim2.new(0, 0, 0, 0)
    devilFrame.BackgroundTransparency = 1

    local devilLabel = Instance.new("TextLabel", devilFrame)
    devilLabel.Size = UDim2.new(1, 0, 0.2, 0)
    devilLabel.Position = UDim2.new(0, 0, 0.1, 0)
    devilLabel.BackgroundTransparency = 1
    devilLabel.Text = "Ác Quỷ"
    devilLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    devilLabel.TextScaled = true
    devilLabel.Font = Enum.Font.GothamBlack

    -- Khung con bên thiên thần (phải)
    local angelFrame = Instance.new("Frame", mainFrame)
    angelFrame.Size = UDim2.new(0.5, 0, 1, 0)
    angelFrame.Position = UDim2.new(0.5, 0, 0, 0)
    angelFrame.BackgroundTransparency = 1

    local angelLabel = Instance.new("TextLabel", angelFrame)
    angelLabel.Size = UDim2.new(1, 0, 0.2, 0)
    angelLabel.Position = UDim2.new(0, 0, 0.
