#Requires AutoHotkey 2.0+
#SingleInstance Force
X:=6,Y:=25,W:=280,H:=130
;                                                                             80
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress("x1 y1 w" W-2 " h" H-2 " Disabled C192B3E +Background192B3E")
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress("x1 y1 w" W-2 " h24 Disabled C313842 +Background313842")
GOO.AddText("x2 y2 w" W-28 " h22 C1A9FFF +Background171D25 Center","STEAM Library Fix 2024")
.OnEvent("Click",DT)
;Close Button 25px
GOO.AddProgress("x" W-26 " y1 w24 h24 Disabled C313842 +Background313842")
GOO.AddText("x" W-24 " y2 w22 h22 CFF0000 +Background171D25 Center","X")
.OnEvent("Click",DT)
;Bot Section 15px
GOO.SetFont("s08")
GOO.AddProgress("x1 y" H-15 " w" W-2 " h14 Disabled C313842 +Background313842")
GOO.AddText("x2 y" H-14 " w" W-4 " h12 C1A9FFF +Background171D25 Center","W.A.Robinson")
;Sub Section H-40px
GOO.SetFont("s12")
GOO.AddText("x6 y" Y+00 " CDCDEDF +Background192B3E","Steam Dir :")
SS0:=GOO.AddText("x112 y" Y+00 " C506A82 +Background192B3E","Searching...")
GOO.AddProgress("x1 y" y+19 " w" W-2 " h1 Disabled C313842 +Background313842")

GOO.AddText("x6 y" Y+20 " CDCDEDF +Background192B3E","What's New:")
SS1:=GOO.AddText("x112 y" Y+20 " C506A82 +Background192B3E","Searching...")
CB1:=GOO.AddCheckBox("x" W-17 " y" Y+21 " w14 h18 Checked +Background192B3E")
CB1.Visible:=0
GOO.AddProgress("x1 y" y+39 " w" W-2 " h1 Disabled C313842 +Background313842")

GOO.AddText("x6 y" Y+40 " CDCDEDF +Background192B3E","Add Shelf :")
SS2:=GOO.AddText("x112 y" Y+40 " C506A82 +Background192B3E","Searching...")
CB2:=GOO.AddCheckBox("x" W-17 " y" Y+41 " w14 h18 Checked +Background192B3E")
CB2.Visible:=0
GOO.AddProgress("x1 y" y+59 " w" W-2 " h1 Disabled C313842 +Background313842")
;...
GOO.AddProgress("x60 y" y+64 " w" W-120 " h22 Disabled C1A9FFF +Background1A9FFF")
GOO.AddText("x61 y" y+65 " w" W-122 " h20 C1A9FFF +Background171D25 Center","...")
.OnEvent("Click",DT)
;...
GOO.Show("w" W " h" H)

DT(CT,*){
  Switch CT.Text{
    Case "X":ExitApp
    Case "...":FX(CT)
    Default:
      While GetKeyState("LButton","P")
        PostMessage(0xA1,0x2,,,"A")
  }
}

FX(CT){
  CT.Text:="Fixed!"
  Loop 3{
    I:=A_Index-1
    SS%I%.Text:="Trying!"
    If I
      CB%I%.Visible:=1
  }
}