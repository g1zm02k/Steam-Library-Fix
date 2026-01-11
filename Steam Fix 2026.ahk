#Requires AutoHotkey 2.0+
#SingleInstance Force
SetRegView(32)

X:=6,Y:=25,W:=400,H:=150
GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.AddProgress(CP(1,1,W-2,H-2,"192B3E",1,1))
;Top Section 25px
GOO.SetFont("s14","Consolas")
GOO.AddProgress(CP(1,1,W-2,24,"313842",1,1))
GOO.AddText(CP(2,2,W-28,22,"1A9FFF","171D25",2),"STEAM Library Fix 2026")
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
;Assign 'Found' Sections
ARR:=[{T:"Steam Dir :",I:1,C:0},{T:"CSS File  :",I:2,C:0}
     ,{T:"What's New:",I:3,C:1},{T:"Add Shelf :",I:4,C:1}]
Loop ARR.Length{
  I:=A_Index,P:=I-1
  GOO.AddText(CP(6,Y+P*20,,,"CDCDEDF","192B3E"),ARR[I].T)
  ARR[I].I:=GOO.AddText(CP(112,Y+P*20,W-120,,"506A82","192B3E"),"Searching...")
  If ARR[I].C{
    ARR[I].C:=GOO.AddCheckBox(CP(W-17,Y+P*20+1,14,18,1,"192B3E",3))
    ARR[I].C.Visible:=0
    ARR[I].C.OnEvent("Click",DT)
  }
}
;Main Button
GOO.AddProgress(CP(60,Y+84,W-120,22,"1A9FFF",1,1))
GOO.AddText(CP(61,Y+85,W-122,20,"1A9FFF","171D25",2) " vBtnMain","...")
.OnEvent("Click",DT)
;Show GUI
GOO.Show("w" W " h" H)

;Actual Search Values
RM1:=".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"
RR1:="`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
RT1:=".*?17uEB[^\{]*\{di.*?\}\.Lib.*"
RM2:=".*?3SkuN[^\{]*\{bo.*?\}.*"
RR2:="`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
RT2:=".*?3SkuN[^\{]*\{di.*?;\}.*"
REP:="$1display:none !important;$2"

;Set Steam's CSS Directory
SetWorkingDir(DIR:=SteamDir())
If DIR
  ARR[1].I.Text:=SubStr(DIR,1,InStr(DIR,"Steam")+5),ARR[1].I.SetFont("c00FF00")

;Get Matching 'chunk*.css' Filename
Loop Files "chunk*.css","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If !IsSet(CSS)
    MsgBox("No matching file(s) found!`n`nQuitting...","STEAM CSS Error",0x1010)
     ,ExitApp()
  If RegExMatch(CSS,RM1) || RegExMatch(CSS,RM2)
   || RegExMatch(CSS,RT1) || RegExMatch(CSS,RT2){
    CNT:=1
    Break
  }
}
If !CNT
  MsgBox("No matching code(s) found!`n`nQuitting...","STEAM CSS Error",0x1010)
   ,ExitApp()
Else
  ARR[2].I.Text:=FIL,ARR[2].I.SetFont("c00FF00")

;Find Matching CSS Code
CNT:=0
Loop 2{
  I:=A_Index
  If POS:=RegExMatch(CSS,RM%I%)
    ARR[I+2].I.Text:="Match at " POS " bytes; fix?",ARR[I+2].C.Visible:=1,CNT++
  Else If POS:=RegExMatch(CSS,RT%I%)
    ARR[I+2].I.Text:="Already fixed at " POS ".",ARR[I+2].I.SetFont("c00FF00")
  Else
    ARR[I+2].I.Text:="Error; new fix required!",ARR[I+2].I.SetFont("cFF0000")
}
GOO["BtnMain"].Text:=(!CNT?"Already done; exit":"Fix selected")

;Control Interaction Handler
DT(CT,*){
  If CT.Text{
    Switch{
      Case CT.Text="X":ExitApp()
      Case InStr(CT.Text,"exit"):ExitApp()
      Case InStr(CT.Text,"GitHub"):
        Run("https://github.com/g1zm02k/Steam-Library-Fix")
      Case InStr(CT.Text,"Fix selected"):FX(CT)
      Default:
        While GetKeyState("LButton","P")
          PostMessage(0xA1,0x2,,,"A")
    }
  }Else{
    CNT:=0
    Loop 2
      If ARR[A_Index+2].C.Value
        CNT++
    GOO["BtnMain"].Text:=(!CNT?"Exit without fixing":"Fix selected")
  }
}

;Main Fix Code
FX(CT){
  Global CSS,DIR
  EXE:=""
  UND:=WinExist("Steam ahk_exe steamwebhelper.exe")
  DetectHiddenWindows(1)
  DET:=WinExist("Steam ahk_exe steamwebhelper.exe")
  If (DET||UND){
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
    If ARR[I+2].C.Visible && ARR[I+2].C.Value{
      CSS:=RegExReplace(CSS,RR%I%,REP)
      ARR[I+2].C.Visible:=0
      ARR[I+2].I.Text:="Successfully replaced!"
      ARR[I+2].I.SetFont("c00FF00")
      CNT++
    }
  }
  If CNT{
    FileMove(FIL,SubStr(FIL,1,-3) "bup",1)
    FileAppend(CSS Format("{: " SIZ-StrLen(CSS) "}"," "),FIL)
  }
  RunWait(RegExReplace(DIR,"steamui\\css\\","steam.exe"))
  If EXE{
    Run(EXE)
    If UND{
      DetectHiddenWindows(1)
      WinWait("Steam ahk_exe steamwebhelper.exe")
      WinShow("Steam ahk_exe steamwebhelper.exe")
    }
  }
  CT.Text:="Fixed and saved! Exit?"
}

;GUI Parameter Shortener
CP(X,Y,W:=0,H:=0,F:=0,B:=0,O:=0)=>"x" X " y" Y (W?" w" W:"") (H?" h" H:"")
. (F?" C" F:"") (B?" +Background" (B=1?F:B):"")
. (O=1?" Disabled":O=2?" Center":O=3?" Checked":"")

;Steam Install Directory Finder
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
