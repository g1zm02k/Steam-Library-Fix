#Requires AutoHotkey 2.0+
#SingleInstance Force
X:=6,Y:=25,W:=250,H:=130
;                                                                             80
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress("x1 y1 w" W-2 " h" H-2 PM())
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress("x1 y1 w" W-2 " h24 " PH())
GOO.AddText("x2 y2 w" W-4 " h22 " TT(),"STEAM Library Fix 2024")
.OnEvent("Click",DT)
;Bot Section 15px
GOO.SetFont("s08")
GOO.AddProgress("x1 y" H-15 " w" W-2 " h14 " PH())
GOO.AddText("x2 y" H-14 " w" W-4 " h12 " TT(),"W.A.Robinson")
;Sub Section H-40px
GOO.SetFont("s12")
GOO.AddText("x6 y" Y+00 TQ(),"Steam Dir :")
SS0:=GOO.AddText("x112 y" Y+00 TA(),"Searching...")
GOO.AddProgress("x1 y" y+19 " w" W-2 " h1 " PH())

GOO.AddText("x6 y" Y+20 TQ(),"What's New:")
SS1:=GOO.AddText("x112 y" Y+20 TA(),"Searching...")
CB1:=GOO.AddCheckBox("x" W-17 " y" Y+21 " w14 h18" CB()).Visible:=0
GOO.AddProgress("x1 y" y+39 " w" W-2 " h1 " PH())

GOO.AddText("x6 y" Y+40 TQ(),"Add Shelf :")
SS2:=GOO.AddText("x112 y" Y+40 TA(),"Searching...")
CB2:=GOO.AddCheckBox("x" W-17 " y" Y+41 " w14 h18" CB()).Visible:=0
GOO.AddProgress("x1 y" y+59 " w" W-2 " h1 " PH())
;...
GOO.AddProgress("x60 y" y+64 " w" W-120 " h22 " BH())
GOO.AddText("x61 y" y+65 " w" W-122 " h20" TT(),"Fix it!")
;...
GOO.Show("w" W " h" H)

PM()=>" Disabled C192B3E +Background192B3E"
PH()=>" Disabled C313842 +Background313842"
BH()=>" Disabled C1A9FFF +Background1A9FFF"
TT()=>" C1A9FFF +Background171D25 Center"
TQ()=>" CDCDEDF +Background192B3E"
TA()=>" C506A82 +Background192B3E"
CB()=>" Checked +Background192B3E"

DT(*){
  While GetKeyState("LButton","P")
    PostMessage(0xA1,0x2,,,"A")
}