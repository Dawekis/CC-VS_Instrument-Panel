require("math")

---------------------基础变量-------------------------
--全局变量
local monitor = peripheral.find("monitor")
monitor.setTextScale(0.5)
local mx,my = monitor.getSize()
local pi = math.pi
if mx/15 >= my/10 then
    mline_num = mx/15
    num = 0.1/mline_num
else
    mline_num = my/10
    num = 0.1/mline_num
end
if (mx/15)/(my/10) >= 3 then
    cx = 48
    cy = 17*(my/10)/(mx/15)
else
    cy = 16
    cx = 25.5*(mx/15)/(my/10)
end
local Program_run = 1
mouse_event = 0
mouse_click = 0
mouse_dir = 0
mouse_x = 0
mouse_y= 0
key = 0
key_held = false
var_max = 9
high_max = 500
vy_max = 10
speed = 0
roll = 0
Pitch = 0
yaw = 0
DNum = 0
--ship坐标位置
sx = 0
sy = 0
sz = 0
--ship方位速度
vx = 0
vy = 0
vz = 0
--测速表变量
speedometerData = {}
speedometerData[0] = 1
speedometerData[1]= mx/2
speedometerData[2]= my/2
speedometerData[3]= 6
speedometerData[4]= 4
speedometerData[5]= var_max
speedometerData[6] = {}
speedometerData[6][1] = var_max
speedometerData[6][2] = "MaxSpeed:"
--姿态仪变量
AttitudemeterData = {}
AttitudemeterData[0] = 0
AttitudemeterData[1] = mx/2
AttitudemeterData[2] = my/2
AttitudemeterData[3] = 6
AttitudemeterData[4] = 4
AttitudemeterData[5] = 0
--转弯侧滑仪变量
TurnCoordinatorData = {}
TurnCoordinatorData[0] = 0
TurnCoordinatorData[1] = mx/2
TurnCoordinatorData[2] = my/2
TurnCoordinatorData[3] = 6
TurnCoordinatorData[4] = 4
TurnCoordinatorData[5] = 0
--航向仪变量
HeadingIndicatorData = {}
HeadingIndicatorData[0] = 0
HeadingIndicatorData[1] = mx/2
HeadingIndicatorData[2] = my/2
HeadingIndicatorData[3] = 6
HeadingIndicatorData[4] = 4
HeadingIndicatorData[5] = 0
azimuth = {}
azimuth[1] = "N"
azimuth[2] = "EN"
azimuth[3] = "E"
azimuth[4] = "ES"
azimuth[5] = "S"
azimuth[6] = "WS"
azimuth[7] = "W"
azimuth[8] = "WN"
--高度表变量
AltitudeIndicatorData = {}
AltitudeIndicatorData[0] = 0
AltitudeIndicatorData[1] = mx/2
AltitudeIndicatorData[2] = my/2
AltitudeIndicatorData[3] = 6
AltitudeIndicatorData[4] = 4
AltitudeIndicatorData[5] = high_max
AltitudeIndicatorData[6] = {}
AltitudeIndicatorData[6][1] = high_max
AltitudeIndicatorData[6][2] = "MaxHigh:"
--升降表变量
VerticalIndicatorData = {}
VerticalIndicatorData[0] = 0
VerticalIndicatorData[1] = mx/2
VerticalIndicatorData[2] = my/2
VerticalIndicatorData[3] = 6
VerticalIndicatorData[4] = 4
VerticalIndicatorData[5] = vy_max
VerticalIndicatorData[6] = {}
VerticalIndicatorData[6][1] = vy_max
VerticalIndicatorData[6][2] = "MaxSpeed:"
--仪表盘变量
InstrumentPanelData = {}
InstrumentPanelData[1] = speedometerData
InstrumentPanelData[2] = AttitudemeterData
InstrumentPanelData[3] = TurnCoordinatorData
InstrumentPanelData[4] = HeadingIndicatorData
InstrumentPanelData[5] = AltitudeIndicatorData
InstrumentPanelData[6] = VerticalIndicatorData
--配置文件路径
local configDir = "InstrumentPanelConfig/InstrumentPanelConfig.txt"
local SpeedometeConfigDir = "InstrumentPanelConfig/SpeedometerConfig.txt"
local AttitudemeterConfigDir = "InstrumentPanelConfig/AttitudemeterConfig.txt"
local TurnCoordinatorConfigDir = "InstrumentPanelConfig/TurnCoordinatorConfig.txt"
local HeadingIndicatorConfigDir = "InstrumentPanelConfig/HeadingIndicatorConfig.txt"
local AltitudeIndicatorConfigDir = "InstrumentPanelConfig/AltitudeIndicatorConfig.txt"
local VerticalIndicatorConfigDir = "InstrumentPanelConfig/VerticalIndicatorConfig.txt"


----------------------------刷新参数---------------------------
local DisplayNum = function ()
    local j = 0
    for k,v in ipairs(InstrumentPanelData) do
        if v[0] > 0 then
            j = j + 1
        end
    end
    return
    j
end
local M_DisplayNum = function ()
    local j  = 0
    for k,v in ipairs(InstrumentPanelData) do
        if v[0] > 0 and math.max(v[3],v[4]) > j  then
            j = math.max(v[3],v[4])/10
        end
    end
    return
    j
end
----------------------------坐标转换---------------------------
--屏幕-电脑
local M_C_coordinate = function (table)
    local x = 26-cx/2+table[1]*cx/mx
    local y = 10-cy/2+table[2]*cy/my
    local a = table[3]*cx/mx
    local b = table[4]*cy/my
    return
    x,y,a,b
end
--数据导出画外圆
local DataExport_Max = function (table)
    local x = table[1]
    local y = table[2]
    local a = table[3]
    local b = table[4]
    return
    x,y,a,b
end
--数据导出画内圆
local DataExport_Min = function (table,num)
    local x = table[1]
    local y = table[2]
    local a = table[3]-num
    local b = table[4]-num
    return
    x,y,a,b
end
---------------------监听函数-----------------------------------
--mouse_drag
local Position = function (table,click_x,click_y,click)
    if table[0] == 2 and click_x >= 26-cx/2+(table[1]/mx)*cx-table[3]*cx/mx  and click_y >= 10-cy/2+(table[2]/my)*cy-table[4]*cy/my and click_x <=26-cx/2+(table[1]/mx)*cx+table[3]*cx/mx and click_y <= 10-cy/2+(table[2]/my)*cy+table[4]*cy/my and click == 1 then
        table[1] = (click_x+cx/2-26)*mx/cx
        table[2] = (click_y+cy/2-10)*my/cy
    end
end
--mouse_click
--保存配置
local SaveConfig = function (ConfigDir,table)
    local Dir = io.open(ConfigDir,"w")
    io.output(Dir)
    for i = 0,5 do
        io.write(table[i].."\n")
    end
    io.close(Dir)
end
--按钮启动
local Launch = function (table,x,y,long,click_x,click_y,click)
    if click_x >= x and click_x <= x+long-1 and click_y == y and click == 1 and table[0] == 0 then
        table[0] = 1
    elseif click_x >= x and click_x <= x+long-1 and click_y == y and click == 1 and table[0] >= 1 then
        table[0] = 0
    elseif table[0] == 1 and click_x >= 26-cx/2+(table[1]/mx)*cx-table[3]*cx/mx  and click_y >= 10-cy/2+(table[2]/my)*cy-table[4]*cy/my and click_x <=26-cx/2+(table[1]/mx)*cx+table[3]*cx/mx and click_y <= 10-cy/2+(table[2]/my)*cy+table[4]*cy/my and click == 1 then
        table[0] = 2
    elseif click_x >= x and click_x <= x+long-1 and click_y == y and click == 2 and table[0] >= 1 then
        table[0] = 3
    elseif table[0] >= 2 and (click_x < 26-cx/2+(table[1]/mx)*cx-table[3]*cx/mx  or click_y < 10-cy/2+(table[2]/my)*cy-table[4]*cy/my or click_x > 26-cx/2+(table[1]/mx)*cx+table[3]*cx/mx or click_y > 10-cy/2+(table[2]/my)*cy+table[4]*cy/my) then
        table[0] = 1
    end
end
--mouse_scroll
--仪表半径调节
local scroll = function (table,dir)
    if key == 0 and table[0] >= 1 and mouse_x >= 26-cx/2+(table[1]/mx)*cx-table[3]*cx/mx  and mouse_y >= 10-cy/2+(table[2]/my)*cy-table[4]*cy/my and mouse_x <=26-cx/2+(table[1]/mx)*cx+table[3]*cx/mx and mouse_y <= 10-cy/2+(table[2]/my)*cy+table[4]*cy/my and mouse_click == 1 then
        table[4] = table[4]-dir
    elseif key == 340 and table[0] >= 1 and mouse_x >= 26-cx/2+(table[1]/mx)*cx-table[3]*cx/mx  and mouse_y >= 10-cy/2+(table[2]/my)*cy-table[4]*cy/my and mouse_x <=26-cx/2+(table[1]/mx)*cx+table[3]*cx/mx and mouse_y <= 10-cy/2+(table[2]/my)*cy+table[4]*cy/my and mouse_click == 1 then
       table[3] = table[3]-dir
    end
end
--参数调整
local VarChange = function (table,dir)
    if  key == 0 and table[0] == 3 and mouse_click == 2 then
    table[6][1] = table[6][1]-dir
    table[5] = table[6][1]
elseif key == 340 and table[0] == 3 and mouse_click == 2 then
    table[6][1] = table[6][1]-10*dir
    table[5] = table[6][1]
    end
end


----------------------UI设计----------------------------------
local UI = {
    --按钮UI
    Button = function (x,y,table,button_str,BackgroundColor)
        if table[0] == 1 then
            term.setCursorPos(x,y);term.setBackgroundColor(BackgroundColor);term.setTextColor(colors.lime)
            term.write(button_str)
        elseif table[0] ==  2 then
                term.setCursorPos(x,y);term.setBackgroundColor(BackgroundColor);term.setTextColor(colors.orange)
                term.write(button_str)
        elseif table[0] == 3 then
                term.setCursorPos(x,y);term.setBackgroundColor(BackgroundColor);term.setTextColor(colors.yellow)
                term.write(button_str)
        else
            term.setCursorPos(x,y);term.setBackgroundColor(BackgroundColor);term.setTextColor(colors.red)
            term.write(button_str)
        end
    end;
    --菜单UI
    Menu = function (x,y,table)
        if table[0] == 3 then
            term.setBackgroundColor(colors.lightGray);term.setTextColor(colors.black)
            paintutils.drawFilledBox(x,y-1,x+10,y-#table[6],colors.lightGray)
            for k,v in ipairs(table[6]) do
                term.setCursorPos(x+1,y-k);term.write(v)
            end
        end
    end
}


---------------------生成配置文件------------------------------
--读取测速表配置文件
if fs.exists(SpeedometeConfigDir) == true then
    local j = 0
    for i in io.lines(SpeedometeConfigDir) do
        speedometerData[j] = tonumber(i)
        j = j+1
    end
end
--读取姿态仪配置文件
if fs.exists(AttitudemeterConfigDir) == true then
    local j = 0
    for i in io.lines(AttitudemeterConfigDir) do
        AttitudemeterData[j] = tonumber(i)
        j = j+1
    end
end
--读取转弯侧滑仪配置文件
if fs.exists(TurnCoordinatorConfigDir) == true then
    local j = 0
    for i in io.lines(TurnCoordinatorConfigDir) do
        TurnCoordinatorData[j] = tonumber(i)
        j = j+1
    end
end
--读取航向仪配置文件
if fs.exists(HeadingIndicatorConfigDir) == true then
    local j = 0
    for i in io.lines(HeadingIndicatorConfigDir) do
        HeadingIndicatorData[j] = tonumber(i)
        j = j+1
    end
end
--读取高度表配置文件
if fs.exists(AltitudeIndicatorConfigDir) == true then
    local j = 0
    for i in io.lines(AltitudeIndicatorConfigDir) do
        AltitudeIndicatorData[j] = tonumber(i)
        j = j+1
    end
end
--读取升降表配置文件
if fs.exists(VerticalIndicatorConfigDir) == true then
    local j = 0
    for i in io.lines(VerticalIndicatorConfigDir) do
        VerticalIndicatorData[j] = tonumber(i)
        j = j+1
    end
end
--生成仪表盘配置文件
if fs.exists(configDir) == false then
    fs.makeDir("InstrumentPanelConfig")
    local config = io.open(configDir,"w")
    io.output(config)
    io.write("SpeedometerDisplayMode:0".."\n")
    io.write("AttitudemeterDisplayMode:0".."\n")
    io.write("TurnCoordinatorDisplayMode:0".."\n")
    io.write("HeadingIndicatorDisplayMode:0".."\n")
    io.write("AltitudeIndicatorDisplayMode:0".."\n")
    io.write("VerticalIndicatorDisplayMode:0".."\n")
    io.close(config)
end


---------------------------电脑绘图程序---------------------------
--电脑画圆--
local C_DrawCircle = function (x,y,a,b,rs,re,color)
    for i = rs,re,num do
        local rx = math.floor(x + a*math.cos(i) + 1)
        local ry = math.floor(y + b*math.sin(i) + 1)
        paintutils.drawPixel(rx,ry,color)
    end
end
--电脑画线(圆形)--
local C_DrawLine = function (re,x,y,a,b,color)
    for i = 0,a-1,num do
        local b = (b/a)*i
        local rx = math.floor(x - i*math.cos(re) + 1)
        local ry = math.floor(y - b*math.sin(re) + 1)
        paintutils.drawPixel(rx,ry,color)
    end
end


---------------------------屏幕绘图程序---------------------------
--屏幕画圆--
local M_DrawCircle = function (rs,re,x,y,a,b)
    for i = rs,re,num do
        local rx = math.floor(x + a*math.cos(i) + 1)
        local ry = math.floor(y + b*math.sin(i) + 1)
        monitor.setCursorPos(rx,ry)
        monitor.write("#")
    end
end
--屏幕画线(圆形)--
local M_DrawLine = function (re,x,y,a,b)
    for i = 0,a-1,num do
        local b = (b/a)*i
        local rx = math.floor(x - i*math.cos(re) + 1)
        local ry = math.floor(y - b*math.sin(re) + 1)
        monitor.setCursorPos(rx,ry)
        monitor.write("#")
    end
end
--屏幕刻度(圆形)--
local M_VarCircle = function (re,str,x,y,a,b)
    local rx = math.floor(x + a*math.cos(re) + 1)
    local ry = math.floor(y + b*math.sin(re) + 1)
    monitor.setCursorPos(math.floor(rx),math.floor(ry))
    monitor.write(str)
end
--屏幕画线(两点)--
local M_DrawLine_L = function (x1,y1,x2,y2)
    local num = math.max((y2-y1),(x2-x1))
    for i = 0,num do
        monitor.setCursorPos(math.floor(x1+(x2-x1)*i/num),math.floor(y1+(y2-y1)*i/num))
        monitor.write("#")
    end
end


-----------------------配置程序-------------------------
--全局配置--
local config = {}
local j = 1
for i in io.lines(configDir) do
    config[j] = i
    j = j+1
end
--全局变量设置--
local variable = function ()
    while true do
        os.sleep(0)
        DNum = DisplayNum()
        mline_num = M_DisplayNum()
        posit = ship.getWorldspacePosition()
        sx = posit.x
        sy = posit.y
        sz = posit.z
        vel = ship.getVelocity()
        vx = vel.x
        vy = vel.y
        vz = vel.z
        --欧拉角变量
        Q = ship.getQuaternion()
        w = Q.w;
        x = Q.z;
        y = Q.x;
        z = Q.y;
        r = math.atan2(2*(w*x+y*z),(1-2*(x^2+y^2)))
        p = -math.asin(2*(w*y-x*z))/180*pi
        y = math.atan2(2*(w*z+x*y),(1-2*(y^2+z^2)))
        p = p*180/pi;
        yaw = string.format("%.2f",y)
        Pitch = string.format("%.2f",p)
        roll = string.format("%.2f",r)
        speed = string.format("%.2f",math.sqrt(vel.x*vel.x+vel.y*vel.y+vel.z*vel.z))
        --测速表最大速度变量
        speedometerData[6][1] = speedometerData[5]
        var_max = speedometerData[5]
        --高度表最大高度变量
        AltitudeIndicatorData[6][1] = AltitudeIndicatorData[5]
        high_max = AltitudeIndicatorData[5]
        --升降表表最大速度变量
        VerticalIndicatorData[6][1] = VerticalIndicatorData[5]
        vy_max = VerticalIndicatorData[5]
        if key_held == false then
            key = 0
        end
        if tonumber(speed) > var_max then
            var_max = tonumber(speed)
        end
        mouse_dir = 0
    end
end


--------------------------监听程序-----------------------------
--电脑鼠标点击--
local click = function ()
    local event,click,click_x,click_y = os.pullEvent("mouse_click")
    mouse_event = event
    mouse_click = click
    mouse_x = click_x
    mouse_y = click_y
    --关闭程序
    if click_x == 51 and click_y == 1 and click == 1 then
        Program_run = 0
    --保存
    elseif click_x >= 47 and click_x <= 50 and click_y == 1 and click == 1 then
        --保存测速表配置
        SaveConfig(SpeedometeConfigDir,speedometerData)
        --保存姿态仪配置
        SaveConfig(AttitudemeterConfigDir,AttitudemeterData)
        --保存转弯侧滑仪配置
        SaveConfig(TurnCoordinatorConfigDir,TurnCoordinatorData)
        --保存航向仪配置
        SaveConfig(HeadingIndicatorConfigDir,HeadingIndicatorData)
        --保存高度表配置
        SaveConfig(AltitudeIndicatorConfigDir,AltitudeIndicatorData)
        --保存升降表配置
        SaveConfig(VerticalIndicatorConfigDir,VerticalIndicatorData)
    end
    --刷新屏幕
    if click_x >= 2 and click_x <= 50 and click_y == 19 and click == 1 then
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
    end
    --测速表启用和禁用和选中
    Launch(speedometerData,2,19,2,click_x,click_y,click)
    --姿态仪启用和禁用和选中
    Launch(AttitudemeterData,5,19,2,click_x,click_y,click)
    --转弯侧滑仪启用和禁用和选中
    Launch(TurnCoordinatorData,8,19,2,click_x,click_y,click)
    --航向仪启用和禁用和选中
    Launch(HeadingIndicatorData,11,19,2,click_x,click_y,click)
    --高度表启用和禁用和选中
    Launch(AltitudeIndicatorData,14,19,2,click_x,click_y,click)
    --升降表启用和禁用和选中
    Launch(VerticalIndicatorData,17,19,2,click_x,click_y,click)
end
--电脑鼠标拖动--
local drag = function ()
    local event,click,click_x,click_y = os.pullEvent("mouse_drag")
    mouse_event = event
    --测速表位置
    Position(speedometerData,click_x,click_y,click)
    --姿态仪位置
    Position(AttitudemeterData,click_x,click_y,click)
    --转弯侧滑仪位置
    Position(TurnCoordinatorData,click_x,click_y,click)
    --航向仪位置
    Position(HeadingIndicatorData,click_x,click_y,click)
    --高度表位置
    Position(AltitudeIndicatorData,click_x,click_y,click)
    --升降表位置
    Position(VerticalIndicatorData,click_x,click_y,click)
end
--电脑鼠标松开--
local up = function ()
    local event,click,click_x,click_y = os.pullEvent("mouse_up")
    mouse_event = event
end
--电脑鼠标滚动--
local scroll = function ()
    local event,dir,x,y = os.pullEvent("mouse_scroll")
    mouse_event = event
    mouse_dir = dir

    --仪表半径设置--
    --测速表半径设置
    scroll(speedometerData,dir)
    --姿态仪半径设置
    scroll(AttitudemeterData,dir)
    --转弯侧滑仪半径设置
    scroll(TurnCoordinatorData,dir)
    --航向仪半径设置
    scroll(HeadingIndicatorData,dir)
    --高度表半径设置
    scroll(AltitudeIndicatorData,dir)
    --升降表半径设置
    scroll(VerticalIndicatorData,dir)

    --仪表最大变量设置--
    --测速表-最大速度设置
    VarChange(speedometerData,dir)
    --高度表-最大高度设置
    VarChange(AltitudeIndicatorData,dir)
    --升降表-最大速度设置
    VarChange(VerticalIndicatorData,dir)
end
--电脑键盘敲击--
local keyboard = function ()
    local event,click_key,is_held = os.pullEvent("key")
    key = click_key
    key_held = true
end
--电脑键盘松开--
local keyboard_up = function ()
    local event,click_key = os.pullEvent("key_up")
    key = click_key
    key_held = false
end
--监听集合--
local mouse_monitor = function ()
    while Program_run == 1 do
        parallel.waitForAny(click,keyboard,keyboard_up,drag,scroll,up)
    end
end


-------------------------电脑仪表图像程序------------------------
--电脑测速表--
local C_Spendometer = function (x,y,a,b)
    C_DrawCircle(x,y,a-1,b-1,-1*pi/3,3*pi/5,colors.lime)
    C_DrawCircle(x,y,a-1,b-1,3*pi/5,7*pi/6,colors.yellow)
    C_DrawCircle(x,y,a-1,b-1,7*pi/6,5/4*pi,colors.red)
    C_DrawCircle(x,y,a,b,0,2*pi,colors.lightGray)
    C_DrawLine((speed/var_max)*7/4*pi + pi/2,x,y,a-1,b-1,colors.white)
end
--电脑姿态仪--
local C_Attitudemeter =function (x,y,a,b)
    if tonumber(Pitch) >= 0 then
        C_DrawLine(pi/5-Pitch,x,y,a,b,colors.lime)
        C_DrawLine(-Pitch,x,y,a,b,colors.green)
        C_DrawLine(pi-Pitch,x,y,a,b,colors.green)
    else
        C_DrawLine(pi/5-Pitch,x,y,a,b,colors.pink)
        C_DrawLine(-Pitch,x,y,a,b,colors.red)
        C_DrawLine(pi-Pitch,x,y,a,b,colors.red)
    end
    C_DrawCircle(x,y,a,b,0,2*pi,colors.lightBlue)
end
--电脑转弯侧滑仪--
local C_TurnCoordinator = function (x,y,a,b)
    local rx = math.floor(x - a/3*math.cos(pi/2-roll) + 1)
    local ry = math.floor(y - b/3*math.sin(pi/2-roll) + 1)
    C_DrawCircle(x,y,a/4,b/4,0,2*pi,colors.white)
    C_DrawLine(-roll,x,y,a,b,colors.white)
    C_DrawLine(pi-roll,x,y,a,b,colors.white)
    C_DrawLine(-roll,rx,ry,a/2,b/2,colors.white)
    C_DrawLine(pi-roll,rx,ry,a/2,b/2,colors.white)
    C_DrawCircle(x,y,a,b,0,2*pi,colors.red)
end
--电脑航向仪--
local C_HeadingIndicator =function (x,y,a,b)
    local rx1 = math.floor(x - a*math.cos(pi/2)+2/a)
    local ry1 = math.floor(y - b*math.sin(pi/2)+2)
    local rx2 = math.floor(x - a*math.cos(pi/2+3*pi/4)+1)
    local ry2 = math.floor(y - b*math.sin(pi/2+3*pi/4)+1)
    local rx3 = math.floor(x - a*math.cos(pi/2-3*pi/4)+1)
    local ry3 = math.floor(y - b*math.sin(pi/2-3*pi/4)+1)
    paintutils.drawLine(rx1,ry1,rx2,ry2,colors.lime)
    paintutils.drawLine(rx1,ry1,rx3,ry3,colors.lime)
    paintutils.drawLine(x,y,rx2,ry2,colors.lime)
    paintutils.drawLine(x,y,rx3,ry3,colors.lime)
    C_DrawCircle(x,y,a,b,0,2*pi,colors.gray)
end
--电脑高度表--
local C_AltitudeIndicator =function (x,y,a,b)
    if sy >= 0 then
        C_DrawLine((sy/high_max)*7/4*pi + pi/2,x,y,a-1,b-1,colors.lightGray)
        C_DrawLine((sy/(high_max/100))*7/4*pi + pi/2,x,y,a-1,b-1,colors.white)
    else
        C_DrawLine((-sy/high_max)*7/4*pi + pi/2,x,y,a-1,b-1,colors.red)
        C_DrawLine((-sy/(high_max/100))*7/4*pi + pi/2,x,y,a-1,b-1,colors.pink)
    end
    C_DrawCircle(x,y,a,b,0,2*pi,colors.green)
end
--电脑升降表--
local C_VerticalIndicator =function (x,y,a,b)
    if vy >= 0 then
        C_DrawLine((vy/vy_max)*7/4*pi + pi/2,x,y,a-1,b-1,colors.lime)
    else
        C_DrawLine((-vy/vy_max)*7/4*pi + pi/2,x,y,a-1,b-1,colors.green)
    end
    C_DrawCircle(x,y,a,b,0,2*pi,colors.pink)
end


-------------------------屏幕仪表图像程序------------------------
--屏幕测速表--
local M_Speedometer = function ()
    monitor.setBackgroundColor(colors.lime)
    monitor.setTextColor(colors.lime)
    M_DrawCircle(-1*pi/3,3*pi/5,DataExport_Min(speedometerData,1))
    monitor.setBackgroundColor(colors.yellow)
    monitor.setTextColor(colors.yellow)
    M_DrawCircle(3*pi/5,7*pi/6,DataExport_Min(speedometerData,1))
    monitor.setBackgroundColor(colors.red)
    monitor.setTextColor(colors.red)
    M_DrawCircle(7*pi/6,5/4*pi,DataExport_Min(speedometerData,1))
    monitor.setBackgroundColor(colors.lightGray)
    monitor.setTextColor(colors.lightGray)
    M_DrawCircle(0,2*pi,DataExport_Max(speedometerData))
    monitor.setCursorPos(speedometerData[1],speedometerData[2]+speedometerData[4]-2)
    monitor.setBackgroundColor(colors.black)
    monitor.write(speed)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.white)
    M_DrawLine((speed/var_max)*7/4*pi + pi/2,DataExport_Min(speedometerData,1))
    monitor.setBackgroundColor(colors.lightGray)
    monitor.setTextColor(colors.black)
    M_VarCircle(3/2*pi,0,DataExport_Max(speedometerData))
    for i = 1,7 do
        M_VarCircle(3/2*pi+i/4*pi,math.ceil(i/8*var_max),DataExport_Max(speedometerData))
    end
end
--屏幕姿态仪--
local M_Attitudemeter = function ()
    if tonumber(Pitch) >= 0 then
        monitor.setBackgroundColor(colors.lime)
        monitor.setTextColor(colors.lime)
        M_DrawLine(pi/5-Pitch,DataExport_Min(AttitudemeterData,1))
        monitor.setBackgroundColor(colors.green)
        monitor.setTextColor(colors.green)
        M_DrawLine(-Pitch,DataExport_Min(AttitudemeterData,1))
        M_DrawLine(pi-Pitch,DataExport_Min(AttitudemeterData,1))
    else
        monitor.setBackgroundColor(colors.pink)
        monitor.setTextColor(colors.pink)
        M_DrawLine(pi/5-Pitch,DataExport_Min(AttitudemeterData,1))
        monitor.setBackgroundColor(colors.red)
        monitor.setTextColor(colors.red)
        M_DrawLine(-Pitch,DataExport_Min(AttitudemeterData,1))
        M_DrawLine(pi-Pitch,DataExport_Min(AttitudemeterData,1))
    end

    monitor.setBackgroundColor(colors.lightBlue)
    monitor.setTextColor(colors.lightBlue)
    M_DrawCircle(0,2*pi,DataExport_Max(AttitudemeterData))
end
--屏幕转弯侧滑仪--
local M_TurnCoordinator = function ()
    local rx = math.floor(TurnCoordinatorData[1] - TurnCoordinatorData[3]/3*math.cos(pi/2-roll) + 1)
    local ry = math.floor(TurnCoordinatorData[2] - TurnCoordinatorData[4]/3*math.sin(pi/2-roll) + 1)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.white)
    M_DrawCircle(0,2*pi,TurnCoordinatorData[1],TurnCoordinatorData[2],TurnCoordinatorData[3]/4,TurnCoordinatorData[4]/4)
    M_DrawLine(-roll,rx,ry,TurnCoordinatorData[3]/2,TurnCoordinatorData[4]/2)
    M_DrawLine(pi-roll,rx,ry,TurnCoordinatorData[3]/2,TurnCoordinatorData[4]/2)
    M_DrawLine(-roll,DataExport_Min(TurnCoordinatorData,1))
    M_DrawLine(pi-roll,DataExport_Min(TurnCoordinatorData,1))
    monitor.setBackgroundColor(colors.red)
    monitor.setTextColor(colors.red)
    M_DrawCircle(0,2*pi,DataExport_Max(TurnCoordinatorData))
    monitor.setTextColor(colors.black)
    M_VarCircle(0,"R",DataExport_Max(TurnCoordinatorData))
    M_VarCircle(pi,"L",DataExport_Max(TurnCoordinatorData))
end
--屏幕航向仪--
local M_HeadingIndicator = function ()
    local rx1 = math.floor(HeadingIndicatorData[1] - HeadingIndicatorData[3]*math.cos(pi/2)+2/HeadingIndicatorData[3])
    local ry1 = math.floor(HeadingIndicatorData[2] - HeadingIndicatorData[4]*math.sin(pi/2)+2)
    local rx2 = math.floor(HeadingIndicatorData[1] - HeadingIndicatorData[3]*math.cos(pi/2+3*pi/4)+1)
    local ry2 = math.floor(HeadingIndicatorData[2] - HeadingIndicatorData[4]*math.sin(pi/2+3*pi/4)+1)
    local rx3 = math.floor(HeadingIndicatorData[1] - HeadingIndicatorData[3]*math.cos(pi/2-3*pi/4)+1)
    local ry3 = math.floor(HeadingIndicatorData[2] - HeadingIndicatorData[4]*math.sin(pi/2-3*pi/4)+1)
    monitor.setBackgroundColor(colors.lime)
    monitor.setTextColor(colors.lime)
    M_DrawLine_L(rx1,ry1,rx2,ry2)
    M_DrawLine_L(rx1,ry1,rx3,ry3)
    M_DrawLine_L(HeadingIndicatorData[1],HeadingIndicatorData[2],rx2,ry2)
    M_DrawLine_L(HeadingIndicatorData[1],HeadingIndicatorData[2],rx3,ry3)
    monitor.setBackgroundColor(colors.gray)
    monitor.setTextColor(colors.gray)
    M_DrawCircle(0,2*pi,DataExport_Max(HeadingIndicatorData))
    monitor.setTextColor(colors.lime)
    for i = 1,8 do
        M_VarCircle(pi/2+yaw+pi*(i-1)/4,azimuth[i],DataExport_Max(HeadingIndicatorData))
    end
end
--屏幕高度表--
local M_AltitudeIndicator = function ()
    if sy >= 0 then
        monitor.setBackgroundColor(colors.lightGray)
        monitor.setTextColor(colors.lightGray)
        M_DrawLine((sy/high_max)*7/4*pi+pi/2,DataExport_Min(AltitudeIndicatorData,1))
        monitor.setBackgroundColor(colors.white)
        monitor.setTextColor(colors.white)
        M_DrawLine((sy/(high_max/100))*7/4*pi+pi/2,DataExport_Min(AltitudeIndicatorData,0))
    else
        monitor.setBackgroundColor(colors.red)
        monitor.setTextColor(colors.red)
        M_DrawLine((-sy/high_max)*7/4*pi+pi/2,DataExport_Min(AltitudeIndicatorData,1))
        monitor.setBackgroundColor(colors.pink)
        monitor.setTextColor(colors.pink)
        M_DrawLine((-sy/(high_max/100))*7/4*pi+pi/2,DataExport_Min(AltitudeIndicatorData,0))
    end
    monitor.setBackgroundColor(colors.green)
    monitor.setTextColor(colors.green)
    M_DrawCircle(0,2*pi,DataExport_Max(AltitudeIndicatorData))
    monitor.setTextColor(colors.black)
    for i = 0,9 do
        M_VarCircle(3/2*pi+i/5*pi,math.ceil(i/100*high_max),DataExport_Max(AltitudeIndicatorData))
    end
end
--屏幕升降表--
local M_VerticalIndicator = function ()
    if vy >= 0 then
        monitor.setBackgroundColor(colors.lime)
        monitor.setTextColor(colors.lime)
        M_DrawLine((vy/vy_max)*7/4*pi+pi/2,DataExport_Min(VerticalIndicatorData,0))
    else
        monitor.setBackgroundColor(colors.green)
        monitor.setTextColor(colors.green)
        M_DrawLine((-vy/vy_max)*7/4*pi+pi/2,DataExport_Min(VerticalIndicatorData,0))
    end
    monitor.setBackgroundColor(colors.pink)
    monitor.setTextColor(colors.pink)
    M_DrawCircle(0,2*pi,DataExport_Max(VerticalIndicatorData))
    monitor.setTextColor(colors.black)
    for i = 0,7 do
        M_VarCircle(3/2*pi+i/4*pi,math.ceil(i/8*vy_max),DataExport_Max(VerticalIndicatorData))
    end
end


---------------------------图像统合------------------------------
--电脑图像统合--
local Computer_program = function ()
    --开机动画--
    for i = 1,10 do
        paintutils.drawLine(i,i,51-i,i,colors.lightBlue)
        sleep(0.01)
        paintutils.drawLine(52-i,i,52-i,20-i,colors.lightBlue)
        sleep(0.01)
        paintutils.drawLine(51-i,20-i,i,20-i,colors.lightBlue)
        sleep(0.01)
        paintutils.drawLine(i,20-i,i,i,colors.lightBlue)
        sleep(0.01)
    end
    paintutils.drawLine(1,1,50,1,colors.black)
    sleep(0.01)
    paintutils.drawLine(51,1,51,19,colors.black)
    sleep(0.01)
    paintutils.drawLine(50,19,1,19,colors.black)
    sleep(0.01)
    paintutils.drawLine(1,19,1,1,colors.black)
    sleep(0.01)
    while true do
        os.sleep(0.006*mline_num*DNum)
        paintutils.drawFilledBox(1,1,51,19,colors.black)
        paintutils.drawFilledBox(2,2,50,18,colors.lightBlue)
        paintutils.drawFilledBox(26-cx/2,10-cy/2,26+cx/2,10+cy/2,colors.black)
        --关闭按钮UI
        term.setCursorPos(51,1);term.setBackgroundColor(colors.black);term.setTextColor(colors.red)
        term.write("X")
        --保存按钮UI
        if mouse_event == "mouse_click" and mouse_click == 1 and mouse_x >= 47 and mouse_x <= 50 and mouse_y == 1 then
            term.setCursorPos(46,1);term.setBackgroundColor(colors.lightGray);term.setTextColor(colors.yellow)
            term.write("Save")
        else
            term.setCursorPos(46,1);term.setBackgroundColor(colors.black);term.setTextColor(colors.green)
            term.write("Save")
        end
        --测速表按钮UI
        UI.Button(2,19,speedometerData,"SM",colors.gray)
        --姿态仪按钮UI
        UI.Button(5,19,AttitudemeterData,"AM",colors.black)
        --转弯侧滑仪按钮UI
        UI.Button(8,19,TurnCoordinatorData,"TC",colors.gray)
        --航向仪按钮UI
        UI.Button(11,19,HeadingIndicatorData,"HI",colors.black)
        --高度表按钮UI
        UI.Button(14,19,AltitudeIndicatorData,"AI",colors.gray)
        --升降表按钮UI
        UI.Button(17,19,VerticalIndicatorData,"VI",colors.black)
        --附加菜单按钮UI
        term.setCursorPos(1,19);term.setBackgroundColor(colors.black);term.setTextColor(colors.orange)
        term.write("+")
        term.setCursorPos(2,1);term.setBackgroundColor(colors.black);term.setTextColor(colors.orange)
        term.write("Welcome to use Dawekis'Instrument Panel")
        --判断电脑测速表是否显示
        if speedometerData[0] >= 1 then
            C_Spendometer(M_C_coordinate(speedometerData))
        end
        --判断电脑姿态仪是否显示
        if AttitudemeterData[0] >= 1 then
            C_Attitudemeter(M_C_coordinate(AttitudemeterData))
        end
        --判断电脑转弯侧滑仪是否显示
        if TurnCoordinatorData[0] >= 1 then
            C_TurnCoordinator(M_C_coordinate(TurnCoordinatorData))
        end
        --判断电脑航向仪是否显示
        if HeadingIndicatorData[0] >= 1 then
            C_HeadingIndicator(M_C_coordinate(HeadingIndicatorData))
        end
        --判断电脑高度表是否显示
        if AltitudeIndicatorData[0] >= 1 then
            C_AltitudeIndicator(M_C_coordinate(AltitudeIndicatorData))
        end
        --判断电脑升降表是否显示
        if VerticalIndicatorData[0] >= 1 then
            C_VerticalIndicator(M_C_coordinate(VerticalIndicatorData))
        end
        --测速表菜单UI
        UI.Menu(2,19,speedometerData)
        --高度表菜单UI
        UI.Menu(14,19,AltitudeIndicatorData)
        --升降表菜单UI
        UI.Menu(17,19,VerticalIndicatorData)
    end
end
--屏幕图像统合--
local Monitor_program = function ()
    while true do
        os.sleep(0.04*mline_num*DNum)
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        --判断屏幕测速表是否显示
        if speedometerData[0] >= 1 then
            M_Speedometer()
        end
        --判断屏幕姿态仪是否显示
        if AttitudemeterData[0] >= 1 then
            M_Attitudemeter()
        end
        --判断屏幕转弯侧滑仪是否显示
        if TurnCoordinatorData[0] >= 1 then
            M_TurnCoordinator()
        end
        --判断屏幕航向仪是否显示
        if HeadingIndicatorData[0] >= 1 then
            M_HeadingIndicator()
        end
        --判断屏幕高度表是否显示
        if AltitudeIndicatorData[0] >= 1 then
            M_AltitudeIndicator()
        end
        --判断升降表是否显示
        if VerticalIndicatorData[0] >= 1 then
            M_VerticalIndicator()
        end
    end
end

---------------------------程序运行--------------------------
local run = function ()
    while Program_run == 1 do
        parallel.waitForAny(variable,mouse_monitor,Computer_program,Monitor_program)
    end
end
run()
term.setBackgroundColor(colors.black)
monitor.setBackgroundColor(colors.black)
monitor.clear()
shell.run("clear")