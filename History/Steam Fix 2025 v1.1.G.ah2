#Requires AutoHotkey 2.0+
#SingleInstance Force
SetRegView(32)

X:=6,Y:=25,W:=400,H:=130
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress(CP(1,1,W-2,H-2,"192B3E",1,1))
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress(CP(1,1,W-2,24,"313842",1,1))
GOO.AddText(CP(2,2,W-28,22,"1A9FFF","171D25",2),"STEAM Library Fix 2025")
.OnEvent("Click",DT)
;Close Button 25px
GOO.AddProgress(CP(W-26,1,24,24,"313842",1,1))
GOO.AddText(CP(W-24,2,22,22,"FF0000","171D25",2),"X")
.OnEvent("Click",DT)
;Bot Section 15px
GOO.SetFont("s08")
GOO.AddProgress(CP(1,H-15,W-2,14,"313842",1,1))
GOO.AddText(CP(2,H-14,W-4,12,"1A9FFF","171D25",2),"W.A.Robinson|G1ZM02K GitHub")
.OnEvent("Click",DT)
;Sub Section H-40px
GOO.SetFont("s12")
ARR:=["Steam Dir :","What's New:","Add Shelf :"],SS0:=SS1:=SS2:=CB1:=CB2:=""
Loop 3{
  I:=A_Index-1
  GOO.AddText(CP(6,Y+I*20,,,"CDCDEDF","192B3E"),ARR[I+1])
  SS%I%:=GOO.AddText(CP(112,Y+I*20,W-120,,"506A82","192B3E"),"Searching...")
  If I{
    CB%I%:=GOO.AddCheckBox(CP(W-17,Y+I*20+1,14,18,1,"192B3E",3))
    CB%I%.Visible:=0
    CB%I%.OnEvent("Click",DT)
  }
  GOO.AddProgress(CP(1,Y+(I+1)*20-1,W-2,1,"313842",1,1))
}
;...
GOO.AddProgress(CP(60,Y+64,W-120,22,"1A9FFF",1,1))
GOO.AddText(CP(61,Y+65,W-122,20,"1A9FFF","171D25",2) " vBtnMain","...")
.OnEvent("Click",DT)
;...
GOO.Show("w" W " h" H)

DT(CT,*){
}

FX(CT){
}

CP(X,Y,W:=0,H:=0,F:=0,B:=0,O:=0)=>"x" X " y" Y (W?" w" W:"") (H?" h" H:"")
. (F?" C" F:"") (B?" +Background" (B=1?F:B):"")
. (O=1?" Disabled":O=2?" Center":O=3?" Checked":"")
