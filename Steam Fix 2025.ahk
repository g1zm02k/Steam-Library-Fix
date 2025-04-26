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
GOO.AddText(CP(2,H-14,W-4,12,"1A9FFF","171D25",2),"GitHub")
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

;Set Steam's CSS Directory
DIR:=SteamDir()
SetWorkingDir(!DIR?SteamDir():DIR)
If DIR
  SS0.Text:=SubStr(DIR,1,InStr(DIR,"Steam")+5),SS0.SetFont("cGreen")
;Get Last 'chunk*.css' Filename
Loop Files "chunk*.css","F"
  CSS:=FileRead(FIL:=A_LoopFileName)
If !IsSet(CSS)
  MsgBox("No matching file(s) found!`n`nQuitting...","STEAM CSS Error",0x1010)
  ,ExitApp()
;Actual Searches
RM1:=".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"
RR1:="`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
RT1:=".*?17uEB[^\{]*\{di.*?\}\.Lib.*"
RM2:=".*?3SkuN[^\{]*\{bo.*?\}.*"
RR2:="`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
RT2:=".*?3SkuN[^\{]*\{di.*?;\}.*"
REP:="$1display:none !important;$2"
CNT:=0
Loop 2{
  I:=A_Index
  If POS:=RegExMatch(CSS,RM%I%)
    SS%I%.Text:="Match found at " POS "; fix?",CB%I%.Visible:=1,CNT++
  Else If POS:=RegExMatch(CSS,RT%I%)
    SS%I%.Text:="Already fixed at " POS ".",SS%I%.SetFont("cGreen")
  Else
    SS%I%.Text:="Error; new fix required!",SS%I%.SetFont("cRed")
}
GOO["BtnMain"].Text:=(!CNT?"Already done; exit?":"Fix selected?")

DT(CT,*){
  If CT.Text{
    Switch{
      Case CT.Text="X":ExitApp()
      Case InStr(CT.Text,"exit"):ExitApp()
      Case InStr(CT.Text,"W.A."):
        Run("https://github.com/g1zm02k/Steam-Library-Fix")
      Case CT.Text="Fix selected?":FX(CT)
      Default:
        While GetKeyState("LButton","P")
          PostMessage(0xA1,0x2,,,"A")
    }
  }Else{
    CNT:=0
    Loop 2
      If CB%A_Index%.Value
        CNT++
    GOO["BtnMain"].Text:=(!CNT?"Fix nothing; exit?":"Fix selected?")
  }
}

FX(CT){
  Global CSS,DIR
  EXE:=""
  If WinExist("Steam ahk_exe steamwebhelper.exe"){
    RES:=MsgBox("Steam will be closed; okay to continue?","Warning!",0x1021)
    If (RES="Cancel")
      Return
    EXE:=RegExReplace(WinGetProcessPath("Steam ahk_exe steamwebhelper.exe")
      ,"(.*)bin.*","$1steam.exe")
    ProcessClose("steamwebhelper.exe")
  }
  CNT:=0,SIZ:=StrLen(CSS)
  Loop 2{
    I:=A_Index
    If CB%I%.Visible && CB%I%.Value{
      CSS:=RegExReplace(CSS,RR%I%,REP)
      CB%I%.Visible:=0
      SS%I%.Text:="Successfully replaced!"
      SS%I%.SetFont("cGreen")
      CNT++
    }
  }
  If CNT{
    FileMove(FIL,SubStr(FIL,1,-3) "bup",1)
    FileAppend(CSS Format("{: " SIZ-StrLen(CSS) "}"," "),FIL)
  }
  RunWait(RegExReplace(DIR,"steamui\\css\\","steam.exe"))
  If EXE
    Run(EXE)
  CT.Text:="Fixed and saved! Exit?"
}

CP(X,Y,W:=0,H:=0,F:=0,B:=0,O:=0)=>"x" X " y" Y (W?" w" W:"") (H?" h" H:"")
. (F?" C" F:"") (B?" +Background" (B=1?F:B):"")
. (O=1?" Disabled":O=2?" Center":O=3?" Checked":"")

SteamDir(){  ;Locate Steam's install folder...
  DIR:=""
  If !DIR  ;Check if running
    Try DIR:=RegExReplace(WinGetProcessPath("Steam ahk_exe steamwebhelper.exe")
      ,"(.*)bin.*","$1steamui\css\")
  If !DIR  ;Try default install location
    If FileExist("C:\Program Files (x86)\Steam\steam.exe")
      DIR:="C:\Program Files (x86)\Steam\steamui\css\"
  If !DIR  ;Try registry uninstall path
    Try DIR:=RegExReplace(RegRead("HKLM\SOFTWARE\Microsoft\Windows\Current"
      . "Version\Uninstall\Steam","UninstallString"),"(.*)\\.*"
      ,"$1\steamui\css\")
  If !DIR  ;Try registy use exe path
    Try DIR:=RegExReplace(RegRead("HKCR\steam\Shell\Open\Command")
      ,'^"(.*)\\.*',"$1\steamui\css\")
  If !DIR  ;If still not found, ask
    Loop{
      DIR:=RegExReplace(FileSelect("1","C:\Program Files (x86)\Steam"
        ,"Select your 'steam.exe'...","Steam (steam.exe)"),"(.*)\\.*"
        ,"$1\steamui\css\")
    }Until !DIR || (DIR~="steamui")
  If !DIR  ;Quit if not found
    MsgBox("Steam not found, quitting...","Aborted",0x1030),ExitApp()
  Return DIR
}
