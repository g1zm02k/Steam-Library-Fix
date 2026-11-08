#Requires AutoHotkey 2.0+
#SingleInstance Force

X:=6,Y:=28,W:=250,H:=170
GOO:=Gui("+Owner +ToolWindow -Caption","Steam Library Fix")
GOO.BackColor:="000000"
GOO.SetFont("s14 c1A9FFF","Consolas")
GOO.AddProgress("x1 y1 w" W-2 " h" H-2 " Disabled c262B32 +Background262B32")
;Top Section
GOO.AddProgress("x1 y1 w" W-2 " h" 25 " c313842 Disabled +Background313842")
GOO.AddText("x2 y2 w" W-4 " h23 Center +Background171D25","STEAM Library Fix 2024")
.OnEvent("Click",Drag)
;Bottom Section
GOO.SetFont("s8 c1A9FFF","Consolas")
GOO.AddProgress("x1 y" H-16 " w" W-2 " h15 c313842 +Background313842")
GOO.AddText("x2 y" H-15 " w" W-4 " h13 Center +Background171D25","by W.A.Robinson")
;Centre Section
GOO.SetFont("s13 cDCDEDF","Consolas")
GOO.AddText("x6 y" Y " +Background262B32","Steam Dir :")
GOO.AddProgress("x1 y+4 w" W-2 " h1 c313842 +Background313842")
GOO.AddText("x6 y+3 +Background262B32","What's New:")
GOO.AddProgress("x1 y+4 w" W-2 " h1 c313842 +Background313842")
GOO.AddText("x6 y+3 +Background262B32","Add Shelf :")
GOO.AddProgress("x1 y+4 w" W-2 " h1 c313842 +Background313842")

CB1:=GOO.AddCheckBox("x" W-21 " y+-54 w18 h24 Checked +Background262B32","CB1")
CB1.OnEvent("Click",Test)
CB1.Visible:=0
CB2:=GOO.AddCheckBox("x" W-21 " y+4   w18 h24 Checked +Background262B32","CB2")
CB2.OnEvent("Click",Test)
CB2.Visible:=0

GOO.SetFont("s13 c506A82","Consolas")
SS0:=GOO.AddText("x114 y28 +Background262B32","Searching...")
SS1:=GOO.AddText("x114 y56 +Background262B32","Searching...")
SS2:=GOO.AddText("x114 y84 +Background262B32","Searching...")

GOO.SetFont("s13 cB8BCBF","Consolas")
GOO.AddProgress("x80 y+14 w" W-160 " h30 Disabled cB8BCBF +BackgroundB8BCBF")
GOO.AddProgress("x81 y+-29 w" W-162 " h28 Disabled c3D4450 +Background3D4450")
GOO.AddText("x96 y+-25 +Background3D4450","Fix it!")
.OnEvent("Click",DoIt)

GOO.Show("w" W " h" H)

;#####  Set Steam's CSS directory  #####
DIR:=""
RM1:=".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"
RR1:="`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
RM2:=".*?3SkuN[^\{]*\{bo.*?\}.*"
RR2:="`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
REP:="$1display:none !important;$2"

DIR:=SteamDir()
SetWorkingDir((!DIR?SteamDir():DIR))
If DIR
  SS0.Text:=DIR
Loop Files "chunk*.bup","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If RegExMatch(CSS,RM1)
    SS1.Text:="Found!",CB1.Visible:=1
  Else
    SS1.Text:="Error/Fixed?"
}
Loop Files "chunk*.css","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If RegExMatch(CSS,RM2)
    SS2.Text:="Found!",CB2.Visible:=1
  Else
    SS2.Text:="Error/Fixed?"
}

Drag(Btn,*){
  While GetKeyState("LButton","P")
    PostMessage(0xA1,0x2,,,"A")
}

DoIt(Btn,*){
  MsgBox("What's New:`t" CB1.Value "`nAdd Shelf:`t" CB2.Value)
}

Test(Chk,*){
  MsgBox("Checked: " Chk.Text)
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