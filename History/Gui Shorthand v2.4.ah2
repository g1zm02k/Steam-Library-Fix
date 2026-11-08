#Requires AutoHotkey 2.0+
#SingleInstance Force
X:=6,Y:=25,W:=400,H:=130
;                                                                             80
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
GOO.AddText(CP(2,H-14,W-4,12,"1A9FFF","171D25",2),"W.A.Robinson")
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
  }
  GOO.AddProgress(CP(1,Y+(I+1)*20-1,W-2,1,"313842",1,1))
}
;...
GOO.AddProgress(CP(60,Y+64,W-120,22,"1A9FFF",1,1))
GOO.AddText(CP(61,Y+65,W-122,20,"1A9FFF","171D25",2),"...")
.OnEvent("Click",DT)
;...
GOO.Show("w" W " h" H)


;#####  Set Steam's CSS directory  #####
DIR:=""
RM1:=".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"
RR1:="`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
RT1:=".*?17uEB[^\{]*\{di.*?\}\.Lib.*"
RM2:=".*?3SkuN[^\{]*\{bo.*?\}.*"
RR2:="`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
RT2:=".*?3SkuN[^\{]*\{di.*?;\}.*"
REP:="$1display:none !important;$2"

DIR:=SteamDir()
SetWorkingDir((!DIR?SteamDir():DIR))
If DIR
  SS0.Text:=SubStr(DIR,1,InStr(DIR,"Steam")+5)
Loop Files "chunk*.bup","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If POS:=RegExMatch(CSS,RM1)
    SS1.Text:="Found at position " POS ".",CB1.Visible:=1
  Else
    SS1.Text:="Error/Fixed?"
}
Loop Files "chunk*.bup","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If POS:=RegExMatch(CSS,RM2)
    SS2.Text:="Found at position " POS ".",CB2.Visible:=1
  Else
    SS2.Text:="Error/Fixed?"
}

SteamDir(){  ;Locate Steam's install folder...
  DIR:=""
  If !DIR{  ;Try default install location
    SetWorkingDir("C:\Program Files (x86)\Steam\")
    If FileExist("steam.exe")
      DIR:="C:\Program Files (x86)\Steam\steamui\css\"
  }
  If !DIR{  ;Try registry uninstall path
    SetRegView(32)
    Try DIR:=RegRead("HKLM\SOFTWARE\Microsoft\Windows\"
      . "CurrentVersion\Uninstall\Steam","UninstallString")
    DIR:=RegExReplace(DIR,'(.*)\\.*',"$1\steamui\css\")
  }
  If !DIR{  ;Try registy use exe path
    Try DIR:=RegRead("HKCR\steam\Shell\Open\Command")
    DIR:=RegExReplace(DIR,'^"(.*)\\.*',"$1\steamui\css\")
  }
  If !DIR{  ;If still not found, ask
    Loop{
      DIR:=FileSelect("1","C:\Program Files (x86)\Steam"
        ,"Select your 'steam.exe'...","Steam (steam.exe)")
      DIR:=RegExReplace(DIR,'(.*)\\.*',"$1\steamui\css\")
    }Until !DIR || (DIR~="steamui")
    If !DIR
      MsgBox("Steam not found, quitting...","Aborted"),ExitApp()
  }
  Return DIR
}


CP(X,Y,W:=0,H:=0,F:=0,B:=0,O:=0)=>"x" X " y" Y (W?" w" W:"") (H?" h" H:"")
. (F?" C" F:"") (B?" +Background" (B=1?F:B):"")
. (O=1?" Disabled":O=2?" Center":O=3?" Checked":"")

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