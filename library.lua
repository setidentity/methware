local lib = {}
lib.__index = lib

local tween = game:service("TweenService")
local uis = game:service("UserInputService")
local run = game:service("RunService")
local hui = game:service("CoreGui")

function lib.new(cfg)
    local s = setmetatable({}, lib)
    
    s.title = cfg.title or "UI"
    s.size = cfg.size or UDim2.new(0, 280, 0, 420)
    s.pos = cfg.pos or UDim2.new(0, 30, 0, 30)
    s.tabs = {}
    s.curtab = nil
    s.cd = {}
    
    s:makeui()
    
    return s
end

function lib:makeui()
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "UI_" .. math.random(1000, 9999)
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.DisplayOrder = 999999
    self.gui.Parent = hui
    
    self.shadow = Instance.new("Frame")
    self.shadow.Size = self.size
    self.shadow.Position = self.pos
    self.shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.shadow.BackgroundTransparency = 0.5
    self.shadow.BorderSizePixel = 0
    self.shadow.ZIndex = 999
    self.shadow.Parent = self.gui
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 12)
    sc.Parent = self.shadow
    
    self.menu = Instance.new("Frame")
    self.menu.Size = UDim2.new(1, -4, 1, -4)
    self.menu.Position = UDim2.new(0, 2, 0, 2)
    self.menu.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    self.menu.BorderSizePixel = 0
    self.menu.ZIndex = 1000
    self.menu.Parent = self.shadow
    
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 10)
    mc.Parent = self.menu
    
    local grad = Instance.new("Frame")
    grad.Size = UDim2.new(1, 0, 1, 0)
    grad.BackgroundTransparency = 1
    grad.ZIndex = 1001
    grad.Parent = self.menu
    
    local grd = Instance.new("UIGradient")
    grd.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    }
    grd.Rotation = 45
    grd.Parent = grad
    
    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 50)
    hdr.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    hdr.BorderSizePixel = 0
    hdr.ZIndex = 1002
    hdr.Parent = self.menu
    
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 10)
    hc.Parent = hdr
    
    local hfix = Instance.new("Frame")
    hfix.Size = UDim2.new(1, 0, 0, 25)
    hfix.Position = UDim2.new(0, 0, 1, -25)
    hfix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    hfix.BorderSizePixel = 0
    hfix.ZIndex = 1002
    hfix.Parent = hdr
    
    local htitle = Instance.new("TextLabel")
    htitle.Size = UDim2.new(1, -20, 1, 0)
    htitle.Position = UDim2.new(0, 20, 0, 0)
    htitle.BackgroundTransparency = 1
    htitle.Text = self.title
    htitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    htitle.Font = Enum.Font.GothamBold
    htitle.TextSize = 18
    htitle.TextXAlignment = Enum.TextXAlignment.Left
    htitle.ZIndex = 1003
    htitle.Parent = hdr
    
    local hacc = Instance.new("Frame")
    hacc.Size = UDim2.new(0, 4, 0, 30)
    hacc.Position = UDim2.new(0, 0, 0, 10)
    hacc.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    hacc.BorderSizePixel = 0
    hacc.ZIndex = 1004
    hacc.Parent = hdr
    
    local acc = Instance.new("UICorner")
    acc.CornerRadius = UDim.new(0, 2)
    acc.Parent = hacc
    
    self:makedrag(hdr)
    
    self.tabframe = Instance.new("Frame")
    self.tabframe.Size = UDim2.new(1, -20, 0, 40)
    self.tabframe.Position = UDim2.new(0, 10, 0, 60)
    self.tabframe.BackgroundTransparency = 1
    self.tabframe.ZIndex = 1002
    self.tabframe.Parent = self.menu
    
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.SortOrder = Enum.SortOrder.LayoutOrder
    tl.Padding = UDim.new(0, 8)
    tl.Parent = self.tabframe
end

function lib:makedrag(hdr)
    local drag = false
    local dstart = nil
    local spos = nil
    
    hdr.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dstart = Vector2.new(i.Position.X, i.Position.Y)
            spos = self.shadow.Position
        end
    end)
    
    hdr.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    uis.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = Vector2.new(i.Position.X, i.Position.Y) - dstart
            local nx = spos.X.Offset + d.X
            local ny = spos.Y.Offset + d.Y
            local vp = workspace.CurrentCamera.ViewportSize
            local w = self.shadow.Size.X.Offset
            local h = self.shadow.Size.Y.Offset
            nx = math.clamp(nx, 0, vp.X - w)
            ny = math.clamp(ny, 0, vp.Y - h)
            self.shadow.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
end

function lib:maketab(n, o)
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0.5, -4, 1, 0)
    tb.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tb.BorderSizePixel = 0
    tb.Text = n
    tb.TextColor3 = Color3.fromRGB(180, 180, 180)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 13
    tb.ZIndex = 1003
    tb.LayoutOrder = o
    tb.Parent = self.tabframe
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tb
    
    local ta = Instance.new("Frame")
    ta.Size = UDim2.new(0, 0, 0, 3)
    ta.Position = UDim2.new(0.5, 0, 1, -3)
    ta.AnchorPoint = Vector2.new(0.5, 0)
    ta.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    ta.BorderSizePixel = 0
    ta.ZIndex = 1004
    ta.Parent = tb
    
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(1, 0)
    ac.Parent = ta
    
    local cf = Instance.new("Frame")
    cf.Size = UDim2.new(1, -30, 1, -120)
    cf.Position = UDim2.new(0, 15, 0, 110)
    cf.BackgroundTransparency = 1
    cf.ZIndex = 1002
    cf.ClipsDescendants = false
    cf.Visible = false
    cf.Parent = self.menu
    
    local cl = Instance.new("UIListLayout")
    cl.SortOrder = Enum.SortOrder.LayoutOrder
    cl.Padding = UDim.new(0, 12)
    cl.Parent = cf
    
    local tab = {
        name = n,
        btn = tb,
        acc = ta,
        cont = cf,
        elems = {}
    }
    
    self.tabs[n] = tab
    
    if not self.curtab then
        self:swtab(n)
    end
    
    tb.MouseButton1Click:Connect(function()
        self:swtab(n)
    end)
    
    tb.MouseEnter:Connect(function()
        if self.curtab ~= n then
            tween:Create(tb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end
    end)
    
    tb.MouseLeave:Connect(function()
        if self.curtab ~= n then
            tween:Create(tb, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end
    end)
    
    return tab
end

function lib:swtab(n)
    for tn, t in pairs(self.tabs) do
        t.cont.Visible = false
        tween:Create(t.acc, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 3)}):Play()
        tween:Create(t.btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
    end
    
    local tab = self.tabs[n]
    tab.cont.Visible = true
    self.curtab = n
    
    tween:Create(tab.acc, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0.7, 0, 0, 3)}):Play()
    tween:Create(tab.btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

function lib:toggle(tab, n, iv, cb, cd)
    cd = cd or 1
    
    local cf = Instance.new("Frame")
    cf.Size = UDim2.new(1, 0, 0, 45)
    cf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    cf.BorderSizePixel = 0
    cf.ZIndex = 1003
    cf.Parent = tab.cont
    
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = cf
    
    local cl = Instance.new("TextLabel")
    cl.Size = UDim2.new(1, -60, 1, 0)
    cl.Position = UDim2.new(0, 15, 0, 0)
    cl.BackgroundTransparency = 1
    cl.Text = n
    cl.TextColor3 = Color3.fromRGB(220, 220, 220)
    cl.Font = Enum.Font.Gotham
    cl.TextSize = 14
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.ZIndex = 1004
    cl.Parent = cf
    
    local cbg = Instance.new("Frame")
    cbg.Size = UDim2.new(0, 40, 0, 22)
    cbg.Position = UDim2.new(1, -50, 0.5, -11)
    cbg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    cbg.BorderSizePixel = 0
    cbg.ZIndex = 1004
    cbg.Parent = cf
    
    local cbc = Instance.new("UICorner")
    cbc.CornerRadius = UDim.new(1, 0)
    cbc.Parent = cbg
    
    local cbl = Instance.new("Frame")
    cbl.Size = UDim2.new(0, 18, 0, 18)
    cbl.Position = UDim2.new(0, 2, 0.5, -9)
    cbl.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    cbl.BorderSizePixel = 0
    cbl.ZIndex = 1005
    cbl.Parent = cbg
    
    local cblc = Instance.new("UICorner")
    cblc.CornerRadius = UDim.new(1, 0)
    cblc.Parent = cbl
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 1006
    btn.Parent = cf
    
    local function up(v)
        local tp = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local tc = v and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 60)
        local bc = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        
        tween:Create(cbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = tp, BackgroundColor3 = bc}):Play()
        tween:Create(cbg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = tc}):Play()
    end
    
    up(iv)
    
    btn.MouseButton1Click:Connect(function()
        if self.cd[n] then return end
        
        self.cd[n] = true
        iv = not iv
        up(iv)
        cb(iv)
        
        task.delay(cd, function()
            self.cd[n] = nil
        end)
    end)
    
    btn.MouseEnter:Connect(function()
        tween:Create(cf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        tween:Create(cf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)
    
    return cf
end

function lib:slider(tab, n, mn, mx, iv, cb)
    local sf = Instance.new("Frame")
    sf.Size = UDim2.new(1, 0, 0, 60)
    sf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sf.BorderSizePixel = 0
    sf.ZIndex = 1003
    sf.Parent = tab.cont
    sf.ClipsDescendants = false
    sf.BackgroundTransparency = 0
    
    local sfc = Instance.new("UICorner")
    sfc.CornerRadius = UDim.new(0, 8)
    sfc.Parent = sf
    
    local sl = Instance.new("TextLabel")
    sl.Size = UDim2.new(1, -20, 0, 20)
    sl.Position = UDim2.new(0, 10, 0, 5)
    sl.BackgroundTransparency = 1
    sl.Text = n
    sl.TextColor3 = Color3.fromRGB(220, 220, 220)
    sl.Font = Enum.Font.Gotham
    sl.TextSize = 13
    sl.TextXAlignment = Enum.TextXAlignment.Left
    sl.ZIndex = 1004
    sl.Parent = sf
    
    local sv = Instance.new("TextLabel")
    sv.Size = UDim2.new(0, 50, 0, 20)
    sv.Position = UDim2.new(1, -60, 0, 5)
    sv.BackgroundTransparency = 1
    sv.Text = tostring(iv)
    sv.TextColor3 = Color3.fromRGB(100, 150, 255)
    sv.Font = Enum.Font.GothamBold
    sv.TextSize = 13
    sv.TextXAlignment = Enum.TextXAlignment.Right
    sv.ZIndex = 1004
    sv.Parent = sf
    
    local st = Instance.new("Frame")
    st.Size = UDim2.new(1, -20, 0, 6)
    st.Position = UDim2.new(0, 10, 0, 35)
    st.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    st.BorderSizePixel = 0
    st.ZIndex = 1004
    st.Parent = sf
    
    local stc = Instance.new("UICorner")
    stc.CornerRadius = UDim.new(1, 0)
    stc.Parent = st
    
    local sfl = Instance.new("Frame")
    sfl.Size = UDim2.new((iv - mn) / (mx - mn), 0, 1, 0)
    sfl.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sfl.BorderSizePixel = 0
    sfl.ZIndex = 1005
    sfl.Parent = st
    
    local sflc = Instance.new("UICorner")
    sflc.CornerRadius = UDim.new(1, 0)
    sflc.Parent = sfl
    
    local sk = Instance.new("Frame")
    sk.Size = UDim2.new(0, 16, 0, 16)
    sk.Position = UDim2.new((iv - mn) / (mx - mn), -8, 0.5, -8)
    sk.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sk.BorderSizePixel = 0
    sk.ZIndex = 1006
    sk.Parent = st
    
    local skc = Instance.new("UICorner")
    skc.CornerRadius = UDim.new(1, 0)
    skc.Parent = sk
    
    local ds = false
    
    local function ups(v)
        v = math.clamp(v, mn, mx)
        local pct = (v - mn) / (mx - mn)
        
        sfl.Size = UDim2.new(pct, 0, 1, 0)
        sk.Position = UDim2.new(pct, -8, 0.5, -8)
        sv.Text = tostring(math.floor(v))
        
        cb(v)
    end
    
    st.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            ds = true
            local pct = math.clamp((i.Position.X - st.AbsolutePosition.X) / st.AbsoluteSize.X, 0, 1)
            local v = mn + (mx - mn) * pct
            ups(v)
        end
    end)
    
    st.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            ds = false
        end
    end)
    
    uis.InputChanged:Connect(function(i)
        if ds and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((i.Position.X - st.AbsolutePosition.X) / st.AbsoluteSize.X, 0, 1)
            local v = mn + (mx - mn) * pct
            ups(v)
        end
    end)
    
    sk.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            ds = true
        end
    end)
    
    sk.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            ds = false
        end
    end)
    
    return sf
end

function lib:dropdown(tab, n, opts, iv, cb)
    local df = Instance.new("Frame")
    df.Size = UDim2.new(1, 0, 0, 45)
    df.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    df.BorderSizePixel = 0
    df.ZIndex = 1003
    df.ClipsDescendants = false
    df.Parent = tab.cont
    
    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(0, 8)
    dc.Parent = df
    
    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, -140, 1, 0)
    dl.Position = UDim2.new(0, 15, 0, 0)
    dl.BackgroundTransparency = 1
    dl.Text = n
    dl.TextColor3 = Color3.fromRGB(220, 220, 220)
    dl.Font = Enum.Font.Gotham
    dl.TextSize = 14
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.ZIndex = 1004
    dl.Parent = df
    
    local db = Instance.new("TextButton")
    db.Size = UDim2.new(0, 110, 0, 30)
    db.Position = UDim2.new(1, -120, 0.5, -15)
    db.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    db.BorderSizePixel = 0
    db.Text = ""
    db.TextColor3 = Color3.fromRGB(255, 255, 255)
    db.Font = Enum.Font.Gotham
    db.TextSize = 12
    db.ZIndex = 1004
    db.Parent = df
    
    local dbc = Instance.new("UICorner")
    dbc.CornerRadius = UDim.new(0, 6)
    dbc.Parent = db
    
    local dbg = Instance.new("UIGradient")
    dbg.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 60))
    }
    dbg.Rotation = 90
    dbg.Parent = db
    
    local dbs = Instance.new("UIStroke")
    dbs.Color = Color3.fromRGB(70, 70, 80)
    dbs.Thickness = 1
    dbs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    dbs.Parent = db
    
    local bt = Instance.new("TextLabel")
    bt.Size = UDim2.new(1, -30, 1, 0)
    bt.Position = UDim2.new(0, 10, 0, 0)
    bt.BackgroundTransparency = 1
    bt.Text = iv == "HumanoidRootPart" and "RootPart" or iv
    bt.TextColor3 = Color3.fromRGB(255, 255, 255)
    bt.Font = Enum.Font.GothamMedium
    bt.TextSize = 12
    bt.TextXAlignment = Enum.TextXAlignment.Left
    bt.ZIndex = 1005
    bt.Parent = db
    
    local ar = Instance.new("TextLabel")
    ar.Size = UDim2.new(0, 20, 1, 0)
    ar.Position = UDim2.new(1, -20, 0, 0)
    ar.BackgroundTransparency = 1
    ar.Text = "▼"
    ar.TextColor3 = Color3.fromRGB(100, 150, 255)
    ar.Font = Enum.Font.GothamBold
    ar.TextSize = 10
    ar.ZIndex = 1005
    ar.Parent = db
    
    local dlist = Instance.new("Frame")
    dlist.Size = UDim2.new(0, 110, 0, #opts * 33 + 16)
    dlist.Position = UDim2.new(1, -120, 1, 5)
    dlist.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    dlist.BorderSizePixel = 0
    dlist.ZIndex = 3000
    dlist.Visible = false
    dlist.BackgroundTransparency = 0
    dlist.ClipsDescendants = false
    dlist.Parent = self.gui
    
    local dlc = Instance.new("UICorner")
    dlc.CornerRadius = UDim.new(0, 8)
    dlc.Parent = dlist
    
    local dlsh = Instance.new("ImageLabel")
    dlsh.Size = UDim2.new(1, 30, 1, 30)
    dlsh.Position = UDim2.new(0, -15, 0, -15)
    dlsh.BackgroundTransparency = 1
    dlsh.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    dlsh.ImageColor3 = Color3.fromRGB(0, 0, 0)
    dlsh.ImageTransparency = 0.7
    dlsh.ScaleType = Enum.ScaleType.Slice
    dlsh.SliceCenter = Rect.new(10, 10, 118, 118)
    dlsh.ZIndex = 2999
    dlsh.Parent = dlist
    
    local dls = Instance.new("UIStroke")
    dls.Color = Color3.fromRGB(100, 150, 255)
    dls.Thickness = 1.5
    dls.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    dls.Transparency = 0.5
    dls.Parent = dlist
    
    local oc = Instance.new("Frame")
    oc.Size = UDim2.new(1, 0, 1, 0)
    oc.BackgroundTransparency = 1
    oc.ZIndex = 3001
    oc.Parent = dlist
    
    local dll = Instance.new("UIListLayout")
    dll.SortOrder = Enum.SortOrder.LayoutOrder
    dll.Padding = UDim.new(0, 3)
    dll.Parent = oc
    
    local dlp = Instance.new("UIPadding")
    dlp.PaddingTop = UDim.new(0, 8)
    dlp.PaddingBottom = UDim.new(0, 8)
    dlp.PaddingLeft = UDim.new(0, 5)
    dlp.PaddingRight = UDim.new(0, 5)
    dlp.Parent = oc
    
    db.MouseButton1Click:Connect(function()
        dlist.Visible = not dlist.Visible
        if dlist.Visible then
            local ap = db.AbsolutePosition
            local as = db.AbsoluteSize
            dlist.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 5)
            dlist.Size = UDim2.new(0, 110, 0, 0)
            tween:Create(dlist, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 110, 0, #opts * 33 + 16)
            }):Play()
        end
        local tr = dlist.Visible and 180 or 0
        tween:Create(ar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = tr}):Play()
    end)
    
    run.RenderStepped:Connect(function()
        if dlist.Visible then
            local ap = db.AbsolutePosition
            local as = db.AbsoluteSize
            dlist.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 5)
        end
    end)
    
    db.MouseEnter:Connect(function()
        tween:Create(db, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        tween:Create(dbs, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 150, 255)}):Play()
        tween:Create(ar, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(120, 170, 255)}):Play()
    end)
    
    db.MouseLeave:Connect(function()
        tween:Create(db, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        tween:Create(dbs, TweenInfo.new(0.2), {Color = Color3.fromRGB(70, 70, 80)}):Play()
        tween:Create(ar, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 150, 255)}):Play()
    end)
    
    for i, opt in ipairs(opts) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, -10, 0, 30)
        ob.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ob.BorderSizePixel = 0
        ob.Text = ""
        ob.ZIndex = 3002
        ob.AutoButtonColor = false
        ob.Parent = oc
        
        local obc = Instance.new("UICorner")
        obc.CornerRadius = UDim.new(0, 6)
        obc.Parent = ob
        
        local obg = Instance.new("UIGradient")
        obg.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50))
        }
        obg.Rotation = 90
        obg.Parent = ob
        
        local ot = Instance.new("TextLabel")
        ot.Size = UDim2.new(1, -20, 1, 0)
        ot.Position = UDim2.new(0, 10, 0, 0)
        ot.BackgroundTransparency = 1
        ot.Text = opt == "HumanoidRootPart" and "RootPart" or opt
        ot.TextColor3 = Color3.fromRGB(220, 220, 220)
        ot.Font = Enum.Font.Gotham
        ot.TextSize = 12
        ot.TextXAlignment = Enum.TextXAlignment.Left
        ot.ZIndex = 3003
        ot.Parent = ob
        
        if opt == iv then
            local chk = Instance.new("TextLabel")
            chk.Size = UDim2.new(0, 20, 1, 0)
            chk.Position = UDim2.new(1, -20, 0, 0)
            chk.BackgroundTransparency = 1
            chk.Text = "✓"
            chk.TextColor3 = Color3.fromRGB(100, 150, 255)
            chk.Font = Enum.Font.GothamBold
            chk.TextSize = 14
            chk.ZIndex = 3003
            chk.Parent = ob
        end
        
        ob.MouseButton1Click:Connect(function()
            bt.Text = opt == "HumanoidRootPart" and "RootPart" or opt
            tween:Create(dlist, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 110, 0, 0)
            }):Play()
            task.wait(0.2)
            dlist.Visible = false
            dlist.Size = UDim2.new(0, 110, 0, #opts * 33 + 16)
            tween:Create(ar, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
            cb(opt)
        end)
        
        ob.MouseEnter:Connect(function()
            tween:Create(ob, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
            tween:Create(ot, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        ob.MouseLeave:Connect(function()
            tween:Create(ob, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            tween:Create(ot, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
        end)
    end
    
    return df
end

function lib:panel(tab, txt)
    local inf = Instance.new("Frame")
    inf.Size = UDim2.new(1, 0, 0, 50)
    inf.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
    inf.BorderSizePixel = 0
    inf.ZIndex = 1003
    inf.Parent = tab.cont
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 8)
    ic.Parent = inf
    
    local ig = Instance.new("UIGradient")
    ig.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 100, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 120))
    }
    ig.Rotation = 45
    ig.Parent = inf
    
    local il = Instance.new("TextLabel")
    il.Size = UDim2.new(1, -20, 1, -10)
    il.Position = UDim2.new(0, 10, 0, 5)
    il.BackgroundTransparency = 1
    il.Text = txt
    il.TextColor3 = Color3.fromRGB(255, 255, 255)
    il.Font = Enum.Font.Gotham
    il.TextSize = 12
    il.TextWrapped = true
    il.TextYAlignment = Enum.TextYAlignment.Center
    il.ZIndex = 1004
    il.Parent = inf
    
    return inf
end

function lib:destroy()
    if self.gui then
        self.gui:Destroy()
    end
end

return lib
