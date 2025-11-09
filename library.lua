local lib = {}
lib.__index = lib

local plrs = game:service("Players")
local runs = game:service("RunService")
local uis = game:service("UserInputService")
local tws = game:service("TweenService")
local cg = game:service("CoreGui")

local lp = plrs.LocalPlayer
local m = lp:GetMouse()

function lib:new(cfg)
    local self = setmetatable({}, lib)
    
    self.title = cfg.Title or "UI LIBRARY"
    self.size = cfg.Size or UDim2.new(0, 500, 0, 420)
    self.pos = cfg.Position or UDim2.new(0, 30, 0, 30)
    self.tkey = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.dkey = cfg.DestroyKey or Enum.KeyCode.F3
    
    self.tabs = {}
    self.ctab = nil
    self.cd = {}
    
    self:createui()
    self:setupdrag()
    self:setupkeys()
    
    return self
end

function lib:createui()
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "ModernLibrary_" .. math.random(1000, 9999)
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = cg
    
    self.shd = Instance.new("Frame")
    self.shd.Size = self.size
    self.shd.Position = self.pos
    self.shd.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.shd.BackgroundTransparency = 0.5
    self.shd.BorderSizePixel = 0
    self.shd.ZIndex = 999
    self.shd.Parent = self.gui
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 12)
    sc.Parent = self.shd
    
    self.menu = Instance.new("Frame")
    self.menu.Size = UDim2.new(1, -4, 1, -4)
    self.menu.Position = UDim2.new(0, 2, 0, 2)
    self.menu.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    self.menu.BorderSizePixel = 0
    self.menu.ZIndex = 1000
    self.menu.Parent = self.shd
    
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
    
    self.hdr = Instance.new("Frame")
    self.hdr.Size = UDim2.new(1, 0, 0, 50)
    self.hdr.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    self.hdr.BorderSizePixel = 0
    self.hdr.ZIndex = 1002
    self.hdr.Parent = self.menu
    
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 10)
    hc.Parent = self.hdr
    
    local hfix = Instance.new("Frame")
    hfix.Size = UDim2.new(1, 0, 0, 25)
    hfix.Position = UDim2.new(0, 0, 1, -25)
    hfix.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    hfix.BorderSizePixel = 0
    hfix.ZIndex = 1002
    hfix.Parent = self.hdr
    
    self.tlbl = Instance.new("TextLabel")
    self.tlbl.Size = UDim2.new(1, -20, 1, 0)
    self.tlbl.Position = UDim2.new(0, 20, 0, 0)
    self.tlbl.BackgroundTransparency = 1
    self.tlbl.Text = self.title
    self.tlbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.tlbl.Font = Enum.Font.GothamBold
    self.tlbl.TextSize = 18
    self.tlbl.TextXAlignment = Enum.TextXAlignment.Left
    self.tlbl.ZIndex = 1003
    self.tlbl.Parent = self.hdr
    
    local hacc = Instance.new("Frame")
    hacc.Size = UDim2.new(0, 4, 0, 30)
    hacc.Position = UDim2.new(0, 0, 0, 10)
    hacc.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    hacc.BorderSizePixel = 0
    hacc.ZIndex = 1004
    hacc.Parent = self.hdr
    
    local acc = Instance.new("UICorner")
    acc.CornerRadius = UDim.new(0, 2)
    acc.Parent = hacc
    
    self.tcont = Instance.new("Frame")
    self.tcont.Size = UDim2.new(1, -20, 0, 40)
    self.tcont.Position = UDim2.new(0, 10, 0, 60)
    self.tcont.BackgroundTransparency = 1
    self.tcont.ZIndex = 1002
    self.tcont.Parent = self.menu
    
    local tl = Instance.new("UIListLayout")
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.SortOrder = Enum.SortOrder.LayoutOrder
    tl.Padding = UDim.new(0, 8)
    tl.Parent = self.tcont
end

function lib:setupdrag()
    local drag = false
    local ds = nil
    local sp = nil
    
    self.hdr.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            ds = Vector2.new(input.Position.X, input.Position.Y)
            sp = self.shd.Position
        end
    end)
    
    self.hdr.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    uis.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - ds
            local nx = sp.X.Offset + delta.X
            local ny = sp.Y.Offset + delta.Y
            local vp = workspace.CurrentCamera.ViewportSize
            local w = self.shd.Size.X.Offset
            local h = self.shd.Size.Y.Offset
            nx = math.clamp(nx, 0, vp.X - w)
            ny = math.clamp(ny, 0, vp.Y - h)
            self.shd.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
end

function lib:setupkeys()
    uis.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == self.tkey then
            self:toggle()
        elseif input.KeyCode == self.dkey then
            self:destroy()
        end
    end)
end

function lib:toggle()
    self.shd.Visible = not self.shd.Visible
end

function lib:destroy()
    self.gui:Destroy()
end

function lib:newtab(name)
    local libref = self
    local tab = {}
    tab.name = name
    tab.elems = {}
    tab.ord = libref.tabs and #libref.tabs + 1 or 1
    
    tab.btn = Instance.new("TextButton")
    local tw = 1 / math.max(#libref.tabs + 1, 2) - 0.02
    tab.btn.Size = UDim2.new(tw, 0, 1, 0)
    tab.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tab.btn.BorderSizePixel = 0
    tab.btn.Text = name
    tab.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tab.btn.Font = Enum.Font.GothamBold
    tab.btn.TextSize = 13
    tab.btn.ZIndex = 1003
    tab.btn.LayoutOrder = tab.ord
    tab.btn.Parent = libref.tcont
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tab.btn
    
    tab.acc = Instance.new("Frame")
    tab.acc.Size = UDim2.new(0, 0, 0, 3)
    tab.acc.Position = UDim2.new(0.5, 0, 1, -3)
    tab.acc.AnchorPoint = Vector2.new(0.5, 0)
    tab.acc.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    tab.acc.BorderSizePixel = 0
    tab.acc.ZIndex = 1004
    tab.acc.Parent = tab.btn
    
    local ac = Instance.new("UICorner")
    ac.CornerRadius = UDim.new(1, 0)
    ac.Parent = tab.acc
    
    tab.cont = Instance.new("ScrollingFrame")
    tab.cont.Size = UDim2.new(1, -30, 1, -120)
    tab.cont.Position = UDim2.new(0, 15, 0, 110)
    tab.cont.BackgroundTransparency = 1
    tab.cont.BorderSizePixel = 0
    tab.cont.ZIndex = 1002
    tab.cont.Visible = false
    tab.cont.ScrollBarThickness = 4
    tab.cont.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    tab.cont.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.cont.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.cont.Parent = libref.menu
    
    local cl = Instance.new("UIListLayout")
    cl.SortOrder = Enum.SortOrder.LayoutOrder
    cl.Padding = UDim.new(0, 12)
    cl.Parent = tab.cont
    
    tab.btn.MouseButton1Click:Connect(function()
        libref:switchtab(tab)
    end)
    
    tab.btn.MouseEnter:Connect(function()
        if libref.ctab ~= tab then
            tws:Create(tab.btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end
    end)
    
    tab.btn.MouseLeave:Connect(function()
        if libref.ctab ~= tab then
            tws:Create(tab.btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end
    end)
    
    table.insert(libref.tabs, tab)
    
    if #libref.tabs == 1 then
        libref:switchtab(tab)
    end
    
    libref:updatetabsizes()
    
    tab.newtoggle = function(self, cfg) return libref:gettabmethods().newtoggle(self, cfg) end
    tab.toggle = tab.newtoggle
    tab.newslider = function(self, cfg) return libref:gettabmethods().newslider(self, cfg) end
    tab.slider = tab.newslider
    tab.newdropdown = function(self, cfg) return libref:gettabmethods().newdropdown(self, cfg) end
    tab.dropdown = tab.newdropdown
    tab.newbutton = function(self, cfg) return libref:gettabmethods().newbutton(self, cfg) end
    tab.button = tab.newbutton
    tab.btn = tab.newbutton
    tab.newbtn = tab.newbutton
    tab.newlabel = function(self, cfg) return libref:gettabmethods().newlabel(self, cfg) end
    tab.label = tab.newlabel
    tab.newkeybind = function(self, cfg) return libref:gettabmethods().newkeybind(self, cfg) end
    tab.keybind = tab.newkeybind
    tab.newtextbox = function(self, cfg) return libref:gettabmethods().newtextbox(self, cfg) end
    tab.textbox = tab.newtextbox
    tab.tb = tab.newtextbox
    tab.newtb = tab.newtextbox
    tab.newsection = function(self, name) return libref:gettabmethods().newsection(self, name) end
    tab.section = tab.newsection
    
    return tab
end

lib.tab = lib.newtab

function lib:updatetabsizes()
    local tc = #self.tabs
    local tw = 1 / math.max(tc, 2) - (0.02 * (tc - 1) / tc)
    
    for _, tab in ipairs(self.tabs) do
        tab.btn.Size = UDim2.new(tw, 0, 1, 0)
    end
end

function lib:switchtab(tab)
    for _, t in ipairs(self.tabs) do
        t.cont.Visible = false
        tws:Create(t.acc, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 3)}):Play()
        tws:Create(t.btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
    end
    
    tab.cont.Visible = true
    self.ctab = tab
    tws:Create(tab.acc, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0.7, 0, 0, 3)}):Play()
    tws:Create(tab.btn, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

function lib:gettabmethods()
    local tm = {}
    
    function tm:newtoggle(cfg)
        local tg = {
            name = cfg.Name or "Toggle",
            def = cfg.Default or false,
            cb = cfg.Callback or function() end,
            cd = cfg.Cooldown or 0.5
        }
        
        local cf = Instance.new("Frame")
        cf.Size = UDim2.new(1, 0, 0, 45)
        cf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        cf.BorderSizePixel = 0
        cf.ZIndex = 1003
        cf.Parent = self.cont
        
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(0, 8)
        cc.Parent = cf
        
        local cl = Instance.new("TextLabel")
        cl.Size = UDim2.new(1, -60, 1, 0)
        cl.Position = UDim2.new(0, 15, 0, 0)
        cl.BackgroundTransparency = 1
        cl.Text = tg.name
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
        
        local function upd(val)
            local tp = val and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local tc = val and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 60)
            local bc = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            
            tws:Create(cbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = tp, BackgroundColor3 = bc}):Play()
            tws:Create(cbg, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = tc}):Play()
        end
        
        tg.val = tg.def
        upd(tg.val)
        
        btn.MouseButton1Click:Connect(function()
            if lib.cd[tg.name] then return end
            
            lib.cd[tg.name] = true
            tg.val = not tg.val
            upd(tg.val)
            tg.cb(tg.val)
            
            task.delay(tg.cd, function()
                lib.cd[tg.name] = nil
            end)
        end)
        
        btn.MouseEnter:Connect(function()
            tws:Create(cf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            tws:Create(cf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end)
        
        tg.setval = function(val)
            tg.val = val
            upd(val)
        end
        
        table.insert(self.elems, tg)
        return tg
    end
    
    tm.toggle = tm.newtoggle
    
    function tm:newslider(cfg)
        local sl = {
            name = cfg.Name or "Slider",
            min = cfg.Min or 0,
            max = cfg.Max or 100,
            def = cfg.Default or 50,
            cb = cfg.Callback or function() end
        }
        
        local sf = Instance.new("Frame")
        sf.Size = UDim2.new(1, 0, 0, 60)
        sf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        sf.BorderSizePixel = 0
        sf.ZIndex = 1003
        sf.Parent = self.cont
        
        local sfc = Instance.new("UICorner")
        sfc.CornerRadius = UDim.new(0, 8)
        sfc.Parent = sf
        
        local slbl = Instance.new("TextLabel")
        slbl.Size = UDim2.new(1, -20, 0, 20)
        slbl.Position = UDim2.new(0, 10, 0, 5)
        slbl.BackgroundTransparency = 1
        slbl.Text = sl.name
        slbl.TextColor3 = Color3.fromRGB(220, 220, 220)
        slbl.Font = Enum.Font.Gotham
        slbl.TextSize = 13
        slbl.TextXAlignment = Enum.TextXAlignment.Left
        slbl.ZIndex = 1004
        slbl.Parent = sf
        
        local sv = Instance.new("TextLabel")
        sv.Size = UDim2.new(0, 50, 0, 20)
        sv.Position = UDim2.new(1, -60, 0, 5)
        sv.BackgroundTransparency = 1
        sv.Text = tostring(sl.def)
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
        sfl.Size = UDim2.new((sl.def - sl.min) / (sl.max - sl.min), 0, 1, 0)
        sfl.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        sfl.BorderSizePixel = 0
        sfl.ZIndex = 1005
        sfl.Parent = st
        
        local sflc = Instance.new("UICorner")
        sflc.CornerRadius = UDim.new(1, 0)
        sflc.Parent = sfl
        
        local sk = Instance.new("Frame")
        sk.Size = UDim2.new(0, 16, 0, 16)
        sk.Position = UDim2.new((sl.def - sl.min) / (sl.max - sl.min), -8, 0.5, -8)
        sk.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sk.BorderSizePixel = 0
        sk.ZIndex = 1006
        sk.Parent = st
        
        local skc = Instance.new("UICorner")
        skc.CornerRadius = UDim.new(1, 0)
        skc.Parent = sk
        
        local drag = false
        
        local function upd(val)
            val = math.clamp(val, sl.min, sl.max)
            local pct = (val - sl.min) / (sl.max - sl.min)
            
            sfl.Size = UDim2.new(pct, 0, 1, 0)
            sk.Position = UDim2.new(pct, -8, 0.5, -8)
            sv.Text = tostring(math.floor(val))
            
            sl.val = val
            sl.cb(val)
        end
        
        st.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                local pct = math.clamp((input.Position.X - st.AbsolutePosition.X) / st.AbsoluteSize.X, 0, 1)
                local val = sl.min + (sl.max - sl.min) * pct
                upd(val)
            end
        end)
        
        st.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = false
            end
        end)
        
        uis.InputChanged:Connect(function(input)
            if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pct = math.clamp((input.Position.X - st.AbsolutePosition.X) / st.AbsoluteSize.X, 0, 1)
                local val = sl.min + (sl.max - sl.min) * pct
                upd(val)
            end
        end)
        
        sl.setval = function(val)
            upd(val)
        end
        
        table.insert(self.elems, sl)
        return sl
    end
    
    tm.slider = tm.newslider
    
    function tm:newdropdown(cfg)
        local dd = {
            name = cfg.Name or "Dropdown",
            opts = cfg.Options or {},
            def = cfg.Default or cfg.Options[1],
            cb = cfg.Callback or function() end
        }
        
        local df = Instance.new("Frame")
        df.Size = UDim2.new(1, 0, 0, 45)
        df.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        df.BorderSizePixel = 0
        df.ZIndex = 1003
        df.Parent = self.cont
        
        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(0, 8)
        dc.Parent = df
        
        local dl = Instance.new("TextLabel")
        dl.Size = UDim2.new(1, -140, 1, 0)
        dl.Position = UDim2.new(0, 15, 0, 0)
        dl.BackgroundTransparency = 1
        dl.Text = dd.name
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
        db.ZIndex = 1004
        db.Parent = df
        
        local dbc = Instance.new("UICorner")
        dbc.CornerRadius = UDim.new(0, 6)
        dbc.Parent = db
        
        local bt = Instance.new("TextLabel")
        bt.Size = UDim2.new(1, -30, 1, 0)
        bt.Position = UDim2.new(0, 10, 0, 0)
        bt.BackgroundTransparency = 1
        bt.Text = dd.def == "HumanoidRootPart" and "RootPart" or dd.def
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
        dlist.Size = UDim2.new(0, 110, 0, #dd.opts * 33 + 16)
        dlist.Position = UDim2.new(1, -120, 1, 5)
        dlist.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        dlist.BorderSizePixel = 0
        dlist.ZIndex = 3000
        dlist.Visible = false
        dlist.Parent = lib.gui
        
        local dlc = Instance.new("UICorner")
        dlc.CornerRadius = UDim.new(0, 8)
        dlc.Parent = dlist
        
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
            end
            local tr = dlist.Visible and 180 or 0
            tws:Create(ar, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = tr}):Play()
        end)
        
        runs.RenderStepped:Connect(function()
            if dlist.Visible then
                local ap = db.AbsolutePosition
                local as = db.AbsoluteSize
                dlist.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 5)
            end
        end)
        
        for i, opt in ipairs(dd.opts) do
            local ob = Instance.new("TextButton")
            ob.Size = UDim2.new(1, -10, 0, 30)
            ob.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ob.BorderSizePixel = 0
            ob.Text = ""
            ob.ZIndex = 3002
            ob.Parent = oc
            
            local obc = Instance.new("UICorner")
            obc.CornerRadius = UDim.new(0, 6)
            obc.Parent = ob
            
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
            
            ob.MouseButton1Click:Connect(function()
                bt.Text = opt == "HumanoidRootPart" and "RootPart" or opt
                dlist.Visible = false
                tws:Create(ar, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Rotation = 0}):Play()
                dd.val = opt
                dd.cb(opt)
            end)
            
            ob.MouseEnter:Connect(function()
                tws:Create(ob, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
                tws:Create(ot, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)
            
            ob.MouseLeave:Connect(function()
                tws:Create(ob, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                tws:Create(ot, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
            end)
        end
        
        dd.val = dd.def
        
        table.insert(self.elems, dd)
        return dd
    end
    
    tm.dropdown = tm.newdropdown
    
    function tm:newbutton(cfg)
        local btn = {
            name = cfg.Name or "Button",
            cb = cfg.Callback or function() end
        }
        
        local bf = Instance.new("Frame")
        bf.Size = UDim2.new(1, 0, 0, 45)
        bf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        bf.BorderSizePixel = 0
        bf.ZIndex = 1003
        bf.Parent = self.cont
        
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = bf
        
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 1, 0)
        b.BackgroundTransparency = 1
        b.Text = btn.name
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.ZIndex = 1004
        b.Parent = bf
        
        b.MouseButton1Click:Connect(function()
            btn.cb()
        end)
        
        b.MouseEnter:Connect(function()
            tws:Create(bf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
            tws:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        b.MouseLeave:Connect(function()
            tws:Create(bf, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            tws:Create(b, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
        end)
        
        table.insert(self.elems, btn)
        return btn
    end
    
    tm.button = tm.newbutton
    tm.btn = tm.newbutton
    tm.newbtn = tm.newbutton
    
    function tm:newlabel(cfg)
        local lbl = {
            txt = cfg.Text or "Label"
        }
        
        local lf = Instance.new("Frame")
        lf.Size = UDim2.new(1, 0, 0, 50)
        lf.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
        lf.BorderSizePixel = 0
        lf.ZIndex = 1003
        lf.Parent = self.cont
        
        local lc = Instance.new("UICorner")
        lc.CornerRadius = UDim.new(0, 8)
        lc.Parent = lf
        
        local lg = Instance.new("UIGradient")
        lg.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 100, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 120))
        }
        lg.Rotation = 45
        lg.Parent = lf
        
        local lt = Instance.new("TextLabel")
        lt.Size = UDim2.new(1, -20, 1, -10)
        lt.Position = UDim2.new(0, 10, 0, 5)
        lt.BackgroundTransparency = 1
        lt.Text = lbl.txt
        lt.TextColor3 = Color3.fromRGB(255, 255, 255)
        lt.Font = Enum.Font.Gotham
        lt.TextSize = 12
        lt.TextWrapped = true
        lt.TextYAlignment = Enum.TextYAlignment.Center
        lt.ZIndex = 1004
        lt.Parent = lf
        
        lbl.setval = function(txt)
            lbl.txt = txt
            lt.Text = txt
        end
        
        table.insert(self.elems, lbl)
        return lbl
    end
    
    tm.label = tm.newlabel
    
    function tm:newkeybind(cfg)
        local kb = {
            name = cfg.Name or "Keybind",
            def = cfg.Default or Enum.KeyCode.E,
            cb = cfg.Callback or function() end
        }
        
        local kf = Instance.new("Frame")
        kf.Size = UDim2.new(1, 0, 0, 45)
        kf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        kf.BorderSizePixel = 0
        kf.ZIndex = 1003
        kf.Parent = self.cont
        
        local kc = Instance.new("UICorner")
        kc.CornerRadius = UDim.new(0, 8)
        kc.Parent = kf
        
        local kl = Instance.new("TextLabel")
        kl.Size = UDim2.new(1, -140, 1, 0)
        kl.Position = UDim2.new(0, 15, 0, 0)
        kl.BackgroundTransparency = 1
        kl.Text = kb.name
        kl.TextColor3 = Color3.fromRGB(220, 220, 220)
        kl.Font = Enum.Font.Gotham
        kl.TextSize = 14
        kl.TextXAlignment = Enum.TextXAlignment.Left
        kl.ZIndex = 1004
        kl.Parent = kf
        
        local kbb = Instance.new("TextButton")
        kbb.Size = UDim2.new(0, 110, 0, 30)
        kbb.Position = UDim2.new(1, -120, 0.5, -15)
        kbb.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        kbb.BorderSizePixel = 0
        kbb.Text = kb.def.Name
        kbb.TextColor3 = Color3.fromRGB(255, 255, 255)
        kbb.Font = Enum.Font.GothamMedium
        kbb.TextSize = 12
        kbb.ZIndex = 1004
        kbb.Parent = kf
        
        local kbc = Instance.new("UICorner")
        kbc.CornerRadius = UDim.new(0, 6)
        kbc.Parent = kbb
        
        local bind = false
        
        kbb.MouseButton1Click:Connect(function()
            if bind then return end
            bind = true
            kbb.Text = "..."
            
            local con
            con = uis.InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    kb.val = input.KeyCode
                    kbb.Text = input.KeyCode.Name
                    bind = false
                    con:Disconnect()
                end
            end)
        end)
        
        uis.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == kb.val then
                kb.cb()
            end
        end)
        
        kb.val = kb.def
        
        table.insert(self.elems, kb)
        return kb
    end
    
    tm.keybind = tm.newkeybind
    
    function tm:newtextbox(cfg)
        local tb = {
            name = cfg.Name or "Textbox",
            def = cfg.Default or "",
            ph = cfg.Placeholder or "Enter text...",
            cb = cfg.Callback or function() end
        }
        
        local tf = Instance.new("Frame")
        tf.Size = UDim2.new(1, 0, 0, 45)
        tf.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        tf.BorderSizePixel = 0
        tf.ZIndex = 1003
        tf.Parent = self.cont
        
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(0, 8)
        tc.Parent = tf
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, -140, 1, 0)
        tl.Position = UDim2.new(0, 15, 0, 0)
        tl.BackgroundTransparency = 1
        tl.Text = tb.name
        tl.TextColor3 = Color3.fromRGB(220, 220, 220)
        tl.Font = Enum.Font.Gotham
        tl.TextSize = 14
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.ZIndex = 1004
        tl.Parent = tf
        
        local tbb = Instance.new("TextBox")
        tbb.Size = UDim2.new(0, 110, 0, 30)
        tbb.Position = UDim2.new(1, -120, 0.5, -15)
        tbb.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        tbb.BorderSizePixel = 0
        tbb.Text = tb.def
        tbb.PlaceholderText = tb.ph
        tbb.TextColor3 = Color3.fromRGB(255, 255, 255)
        tbb.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        tbb.Font = Enum.Font.Gotham
        tbb.TextSize = 12
        tbb.ZIndex = 1004
        tbb.Parent = tf
        
        local tbc = Instance.new("UICorner")
        tbc.CornerRadius = UDim.new(0, 6)
        tbc.Parent = tbb
        
        tbb.FocusLost:Connect(function(ep)
            if ep then
                tb.val = tbb.Text
                tb.cb(tbb.Text)
            end
        end)
        
        tb.val = tb.def
        
        table.insert(self.elems, tb)
        return tb
    end
    
    tm.textbox = tm.newtextbox
    tm.tb = tm.newtextbox
    tm.newtb = tm.newtextbox
    
    function tm:newsection(name)
        local sf = Instance.new("Frame")
        sf.Size = UDim2.new(1, 0, 0, 30)
        sf.BackgroundTransparency = 1
        sf.ZIndex = 1003
        sf.Parent = self.cont
        
        local sl = Instance.new("TextLabel")
        sl.Size = UDim2.new(1, 0, 1, 0)
        sl.BackgroundTransparency = 1
        sl.Text = name
        sl.TextColor3 = Color3.fromRGB(100, 150, 255)
        sl.Font = Enum.Font.GothamBold
        sl.TextSize = 15
        sl.TextXAlignment = Enum.TextXAlignment.Left
        sl.ZIndex = 1004
        sl.Parent = sf
        
        local ln = Instance.new("Frame")
        ln.Size = UDim2.new(1, 0, 0, 2)
        ln.Position = UDim2.new(0, 0, 1, -5)
        ln.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        ln.BorderSizePixel = 0
        ln.ZIndex = 1004
        ln.BackgroundTransparency = 0.5
        ln.Parent = sf
        
        return sf
    end
    
    tm.section = tm.newsection
    
    return tm
end

return lib
