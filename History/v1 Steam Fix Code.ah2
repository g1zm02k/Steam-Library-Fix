#Requires AutoHotkey 2.0+
#SingleInstance Force
;                                                                             80
DIR:=""
RM1:=".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"
RR1:="`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
RM2:=".*?3SkuN[^\{]*\{bo.*?\}.*"
RR2:="`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
REP:="$1display:none !important;$2"
;TXT:="Searching..."

GOO:=Gui("+AlwaysOnTop +Owner +ToolWindow -Caption","Steam Library Fix")
GOO.SetFont("s16","Consolas")
EDT:=GOO.AddText("x0 y0 w800 h188 Center","Searching...")
GOO.Show("w800 h188")

;#####  Set Steam's CSS directory  #####
SetWorkingDir((!DIR?SteamDir():DIR))

Loop Files "chunk*.bup","F"{
  CSS:=FileRead(FIL:=A_LoopFileName)
  If RegExMatch(CSS,RM1)
    MsgBox(FIL "`n`n" CSS)
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