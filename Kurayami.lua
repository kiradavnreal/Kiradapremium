-- KURAYAMI HUB UI LIBRARY - DEMO FORSAKEN (ICON MENU TỪ TỪ)
loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/LibraryV2/main/redzLib"))()

-- TẠO CỬA SỔ CHÍNH
MakeWindow({
    Hub = {
        Title = "KURAYAMI HUB",
        Animation = "by forsaken"
    },
    Key = {
        KeySystem = false
    }
})

-- NÚT THU NHỎ (ICON MENU TỪ TỪ - FORSAKEN STYLE)
MinimizeButton({
    Image = "rbxassetid://7733960981",  -- Icon Forsaken (mắt đen huyền bí)
    Size = {40, 40},
    Color = Color3.fromRGB(15, 15, 15),
    Corner = true,
    Stroke = true,
    StrokeColor = Color3.fromRGB(138, 43, 226),  -- Tím huyền bí
    Animation = "FadeInOut"  -- Hiệu ứng từ từ
})

-- TAB CHÍNH
local Home = MakeTab({Name = "Home"})
local Farm = MakeTab({Name = "Farm"})
local Combat = MakeTab({Name = "Combat"})
local Visual = MakeTab({Name = "Visual"})

-- HIỆU ỨNG MỞ UI TỪ TỪ
MakeNotifi({
    Title = "KURAYAMI HUB",
    Text = "Giao diện Forsaken - Icon menu từ từ hiện",
    Time = 5,
    Fade = true
})

-- ===== HOME TAB =====
Home:AddLabel({Text = "🌑 KURAYAMI HUB - Forsaken Edition"})
Home:AddLabel({Text = "Demo giao diện icon menu từ từ"})

Home:AddDiscordInvite({
    Name = "Join Forsaken",
    Logo = "rbxassetid://7733960981",
    Invite = "https://discord.gg/forsaken"
})

Home:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/forsaken")
        MakeNotifi({Title = "Copied!", Text = "Link đã được copy!", Time = 3})
    end
})

-- ===== FARM TAB =====
Farm:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(v)
        _G.AutoFarm = v
        MakeNotifi({Title = "Farm", Text = v and "Bật từ từ..." or "Tắt", Time = 3, Fade = true})
    end
})

Farm:AddSlider({
    Name = "Speed",
    Min = 1,
    Max = 50,
    Default = 16,
    Callback = function(v) _G.Speed = v end
})

-- ===== COMBAT TAB =====
Combat:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(v) _G.Aimbot = v end
})

Combat:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(v) _G.Silent = v end
})

-- ===== VISUAL TAB (FORSAKEN STYLE) =====
Visual:AddToggle({
    Name = "ESP Box",
    Default = false,
    Callback = function(v) _G.ESP = v end
})

Visual:AddToggle({
    Name = "Tracers",
    Default = false,
    Callback = function(v) _G.Tracers = v end
})

-- HIỆU ỨNG KẾT THÚC
MakeNotifi({
    Title = "KURAYAMI HUB Loaded",
    Text = "Icon menu hiện từ từ như Forsaken\nUpdate: 07/11/2025",
    Time = 7,
    Fade = true
})
