#Requires AutoHotkey 2.0+
#SingleInstance Force
X:=6,Y:=25,W:=250,H:=130
;                                                                             80
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress(CP(1,1,W-2,H-2) PM())
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress(CP(1,1,W-2,24) PH())
GOO.AddText(CP(2,2,W-4,22) TT(),"STEAM Library Fix 2024")
.OnEvent("Click",DT)
;Bot Section 15px
GOO.SetFont("s08")
GOO.AddProgress(CP(1,H-15,W-2,14) PH())
GOO.AddText(CP(2,H-14,W-4,12) TT(),"W.A.Robinson")
;Sub Section H-40px
GOO.SetFont("s12")
ARR:=["Steam Dir :","What's New:","Add Shelf :"],SS0:=SS1:=SS2:=CB1:=CB2:=""
Loop 3{
  I:=A_Index
  GOO.AddText(CP(6,Y+(I-1)*20) TQ(),ARR[I])
  SS%(I-1)%:=GOO.AddText(CP(112,Y+(I-1)*20) TA(),"Searching...")
  If (I>1)
    CB%(I-1)%:=GOO.AddCheckBox(CP(W-17,Y+(I-1)*20+1,14,18) CB()).Visible:=0
  GOO.AddProgress(CP(1,Y+I*20-1,W-2,1) PH())
}
;...
GOO.AddProgress(CP(60,Y+64,W-120,22) BH())
GOO.AddText(CP(61,Y+65,W-122,20) TT(),"Fix it!")
;...
GOO.Show("w" W " h" H)

CP(X,Y,W?,H?)=>"x" X " y" Y (IsSet(W)?" w" W:"") (IsSet(H)?" h" H:"")
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