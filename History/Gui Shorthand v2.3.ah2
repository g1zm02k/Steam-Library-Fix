#Requires AutoHotkey 2.0+
#SingleInstance Force
X:=6,Y:=25,W:=280,H:=130
;                                                                             80
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress(CP(1,1,W-2,H-2) BG("192B3E",,1))
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress(CP(1,1,W-2,24) BG("313842",,1))
GOO.AddText(CP(2,2,W-28,22) BG("1A9FFF","171D25",,1),"STEAM Library Fix 2025")
.OnEvent("Click",DT)
;Close Button 25px
GOO.AddProgress(CP(W-26,1,24,24) BG("313842",,1))
GOO.AddText(CP(W-24,2,22,22) BG("FF0000","171D25",,1),"X")
.OnEvent("Click",DT)
;Bot Section 15px
GOO.SetFont("s08")
GOO.AddProgress(CP(1,H-15,W-2,14) BG("313842",,1))
GOO.AddText(CP(2,H-14,W-4,12) BG("1A9FFF","171D25",,1),"W.A.Robinson")
;Sub Section H-40px
GOO.SetFont("s12")
ARR:=["Steam Dir :","What's New:","Add Shelf :"],SS0:=SS1:=SS2:=CB1:=CB2:=""
Loop 3{
  I:=A_Index-1
  GOO.AddText(CP(6,Y+I*20) BG("CDCDEDF","192B3E"),ARR[I+1])
  SS%I%:=GOO.AddText(CP(112,Y+I*20) BG("506A82","192B3E"),"Searching...")
  If I{
    CB%I%:=GOO.AddCheckBox(CP(W-17,Y+I*20+1,14,18) BG(,"192B3E",,,1))
    CB%I%.Visible:=0
  }
  GOO.AddProgress(CP(1,Y+(I+1)*20-1,W-2,1) BG("313842",,1))
}
;...
GOO.AddProgress(CP(60,Y+64,W-120,22) BG("1A9FFF",,1))
GOO.AddText(CP(61,Y+65,W-122,20) BG("1A9FFF","171D25",,1),"...")
.OnEvent("Click",DT)
;...
GOO.Show("w" W " h" H)

CP(X,Y,W?,H?)=>"x" X " y" Y (IsSet(W)?" w" W:"") (IsSet(H)?" h" H:"")
BG(F?,B?,D?,C?,T?)=>(IsSet(F)?" C" F:"") " +Background" (IsSet(B)?B:F)
. (IsSet(D)?" Disabled":"") (IsSet(C)?" Center":"") (IsSet(T)?" Checked":"")

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