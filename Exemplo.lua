--// CyberCodersModule.lua

local CyberCodersModule = {}

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

--// PLATOBOOST
local Platoboost = {}
do
    local service = 16113
    local useNonce = true

    local request = request or http_request or syn_request
    local setClipboard = setclipboard or toclipboard
    local getHwid = gethwid or function() return lp.UserId end
    local host = "https://api.platoboost.app"

    local function genNonce()
        local s = ""
        for i = 1, 16 do
            s ..= string.char(math.random(97,122))
        end
        return s
    end

    function Platoboost.CopyLink()
        local r = request({
            Url = host .. "/public/start",
            Method = "POST",
            Body = '{"service":'..service..',"identifier":"'..getHwid()..'"}',
            Headers = {["Content-Type"]="application/json"}
        })

        local url = r and r.Body and r.Body:match('"url"%s*:%s*"(.-)"')
        if url then
            setClipboard(url)
        end
    end

    function Platoboost.VerifyKey(key)
        local url = host.."/public/whitelist/"..service
            .."?identifier="..getHwid()
            .."&key="..key

        if useNonce then
            url ..= "&nonce=" .. genNonce()
        end

        local r = request({ Url = url, Method = "GET" })
        if r and r.StatusCode == 200 and r.Body:find('"valid"%s*:%s*true') then
            return true
        end

        if key:sub(1,4) == "KEY_" then
            local redeem = request({
                Url = host .. "/public/redeem/" .. service,
                Method = "POST",
                Body = '{"identifier":"'..getHwid()..'","key":"'..key..'"}',
                Headers = {["Content-Type"]="application/json"}
            })

            if redeem and redeem.StatusCode == 200
            and redeem.Body:find('"valid"%s*:%s*true') then
                return true
            end
        end

        return false
    end
end

--// UI
function CyberCodersModule.Show(callback)
    callback = callback or function() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CyberCodersKeyUI"
    gui.ResetOnSpawn = false
    gui.Parent = lp:WaitForChild("PlayerGui")

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.65, 0.75)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 28)

    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(170, 90, 255)
    stroke.Transparency = 0.15

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.fromScale(1, 0.18)
    title.BackgroundTransparency = 1
    title.Text = "CyberCoders Menu"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 44
    title.TextColor3 = Color3.fromRGB(190, 120, 255)

    local subtitle = Instance.new("TextLabel", main)
    subtitle.Position = UDim2.fromScale(0, 0.16)
    subtitle.Size = UDim2.fromScale(1, 0.1)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "KEY SYSTEM"
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 20
    subtitle.TextColor3 = Color3.fromRGB(215, 180, 255)

    local mascotHolder = Instance.new("Frame", main)
    mascotHolder.Position = UDim2.fromScale(0.5, 0.37)
    mascotHolder.Size = UDim2.fromScale(0.22, 0.22)
    mascotHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    mascotHolder.BackgroundTransparency = 1

    local mascot = Instance.new("ImageLabel", mascotHolder)
    mascot.Size = UDim2.fromScale(1, 1)
    mascot.AnchorPoint = Vector2.new(0.5, 0.5)
    mascot.Position = UDim2.fromScale(0.5, 0.5)
    mascot.BackgroundTransparency = 1
    mascot.Image = "rbxassetid://6646175684"
    mascot.ScaleType = Enum.ScaleType.Fit
    Instance.new("UIAspectRatioConstraint", mascot).AspectRatio = 1

    local mascotText = Instance.new("TextLabel", main)
    mascotText.Position = UDim2.fromScale(0.2, 0.52)
    mascotText.Size = UDim2.fromScale(0.6, 0.06)
    mascotText.BackgroundTransparency = 1
    mascotText.Text = "Waiting for the key to be entered..."
    mascotText.Font = Enum.Font.GothamBold
    mascotText.TextSize = 18
    mascotText.TextColor3 = Color3.fromRGB(200,195,225)

    local idleRotate = TweenService:Create(
        mascotHolder,
        TweenInfo.new(2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    idleRotate:Play()

    local box = Instance.new("TextBox", main)
    box.Position = UDim2.fromScale(0.1, 0.6)
    box.Size = UDim2.fromScale(0.8, 0.12)
    box.PlaceholderText = "Put Key here"
    box.Font = Enum.Font.Gotham
    box.TextSize = 20
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.BackgroundColor3 = Color3.fromRGB(22,18,40)
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,16)

    local verify = Instance.new("TextButton", main)
    verify.Position = UDim2.fromScale(0.1, 0.75)
    verify.Size = UDim2.fromScale(0.8, 0.12)
    verify.Text = "Execute Script"
    verify.Font = Enum.Font.GothamBold
    verify.TextSize = 22
    verify.TextColor3 = Color3.fromRGB(255,255,255)
    verify.BackgroundColor3 = Color3.fromRGB(135,85,255)
    verify.BorderSizePixel = 0
    Instance.new("UICorner", verify).CornerRadius = UDim.new(0,18)

    local getkey = Instance.new("TextButton", main)
    getkey.Position = UDim2.fromScale(0.1, 0.89)
    getkey.Size = UDim2.fromScale(0.8, 0.07)
    getkey.Text = "Copy Key Link"
    getkey.Font = Enum.Font.GothamBold
    getkey.TextSize = 18
    getkey.TextColor3 = Color3.fromRGB(30,20,50)
    getkey.BackgroundColor3 = Color3.fromRGB(200,180,255)
    getkey.BorderSizePixel = 0
    Instance.new("UICorner", getkey).CornerRadius = UDim.new(0,14)

    getkey.MouseButton1Click:Connect(function()
        Platoboost.CopyLink()
        mascotText.Text = "Link copied! Generate your key on Platoboost."
        mascotText.TextColor3 = Color3.fromRGB(180,160,255)
    end)

    verify.MouseButton1Click:Connect(function()
        if Platoboost.VerifyKey(box.Text) then
            idleRotate:Cancel()
            gui:Destroy()
            callback(true)
        else
            mascotText.Text = "Invalid Key"
            mascotText.TextColor3 = Color3.fromRGB(255,90,90)
        end
    end)
end

return CyberCodersModule
