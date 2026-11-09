#Requires AutoHotkey 2.0+
#SingleInstance Force
SetRegView(32)
VER:='2.0.0b',RPO:='g1zm02k/Steam-Library-Fix'

;Actual Search Values
RM1:='.*?17uEB[^\{]*\{bo.*?\}\.Lib.*'
RR1:='`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)'
RT1:='.*?17uEB[^\{]*\{di.*?\}\.Lib.*'
RM2:='.*?3SkuN[^\{]*\{bo.*?\}.*'
RR2:='`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)'
RT2:='.*?3SkuN[^\{]*\{di.*?;\}.*'
RM3:='.*?_3LKQ[^\{]*\{co.*?\}.*'
RR3:='`aim)(.*?_3LKQ[^\{]*\{)co.*?(\}.*)'
RT3:='.*?_3LKQ[^\{]*\{di.*?;\}.*'
REP:='$1display:none !important;$2'


If (DIR:=SteamDir())
  SetWorkingDir(DIR)
Else
   MsgBox("No matching file(s) found!`n`nQuitting.","STEAM CSS Error",0x1010),ExitApp()

X:=6,Y:=25,W:=400,H:=170
GOO:=Gui('+AlwaysOnTop +Owner +ToolWindow -Caption','Steam Library Fix')
GOO.BackColor:='000000'
GOO.AddProgress(CP(1,1,W-2,H-2,'192B3E',1,1))
;Top Section 25px
GOO.SetFont('s14','Consolas')
GOO.AddProgress(CP(1,1,W-2,24,'313842',1,1))
GOO.AddText(CP(2,2,W-28,22,'1A9FFF','171D25',2),'STEAM Library Fix 2026')
.OnEvent('Click',DT)
;Close Button 25px
GOO.AddProgress(CP(W-26,1,24,24,'313842',1,1))
GOO.AddText(CP(W-24,2,22,22,'FF0000','171D25',2),'X')
.OnEvent('Click',DT)
;Bot Section 15px
GOO.SetFont('s08')
GOO.AddProgress(CP(1,H-15,W-2,14,'313842',1,1))
UPD:=GOO.AddText(CP(2,H-14,W-4,12,'1A9FFF','171D25',2),'Github')
UPD.OnEvent('Click',DT)
;Sub Section H-40px
GOO.SetFont('s12')
;Assign 'Found' Sections
ARR:=[{T:'Steam Dir  :',I:1,C:0},{T:'CSS File   :',I:2,C:0}
     ,{T:'What`'s New :',I:3,C:1},{T:'Add Shelf  :',I:4,C:1}
     ,{T:'Big Picture:',I:5,C:1}]
Loop ARR.Length{
  I:=A_Index,P:=I-1
  GOO.AddText(CP(6,Y+P*20,,,'CDCDEDF','192B3E'),ARR[I].T)
  ARR[I].I:=GOO.AddText(CP(120,Y+P*20,W-124,,'506A82','192B3E'),'Searching...')
  If ARR[I].C{
    ARR[I].C:=GOO.AddCheckBox(CP(W-19,Y+P*20+1,14,18,1,'192B3E',3))
    ARR[I].C.Visible:=0
    ARR[I].C.OnEvent('Click',DT)
  }
}
;Main Button
GOO.AddProgress(CP(60,H-41,W-120,22,'1A9FFF',1,1))
GOO.AddText(CP(61,H-40,W-122,20,'1A9FFF','171D25',2) ' vBtnMain','...')
.OnEvent('Click',DT)
;Show GUI
GOO.Show('w' W ' h' H)

;Update Check
RES:=GetResponseText('https://api.github.com/repos/' RPO '/tags')
GIT:=RegExMatch(RES,'\d+\.\d+\.\d+',&MAT)?MAT[0]:VER
If (VerCompare(GIT,VER)>0){
  UPD.Value:='Update available!'
  UPD.SetFont("c00FF00")
}

;Show Steam's CSS Directory
ARR[1].I.Text:=SubStr(DIR,1,InStr(DIR,'Steam')+5),ARR[1].I.SetFont('c00FF00')
CSS:=FindCSS().C,FIL:=FindCSS().F
ARR[2].I.Text:=FIL,ARR[2].I.SetFont('c00FF00')

;Find Matching CSS Code
CNT:=0
Loop 3{
  I:=A_Index
  If POS:=RegExMatch(CSS,RM%I%)
    ARR[I+2].I.Text:='Match at ' POS ' bytes; fix?',ARR[I+2].C.Visible:=1,CNT++
  Else If POS:=RegExMatch(CSS,RT%I%)
    ARR[I+2].I.Text:='Already fixed at ' POS '.',ARR[I+2].I.SetFont('c00FF00')
  Else
    ARR[I+2].I.Text:='Error; new fix required!',ARR[I+2].I.SetFont('cFF0000')
}
GOO["BtnMain"].Text:=(!CNT?'Already done; exit':'Fix selected')

;Control Interaction Handler
DT(CT,*){
  If CT.Text{
    Switch{
      Case CT.Text='X':ExitApp()
      Case InStr(CT.Text,'exit'):ExitApp()
      Case InStr(CT.Text,'GitHub'):
        Run('https://github.com/' RPO)
      Case InStr(CT.Text,'Update available!'):
        Run('https://github.com/' RPO)
      Case InStr(CT.Text,'Fix selected'):FX(CT)
      Default:
        While GetKeyState('LButton','P')
          PostMessage(0xA1,0x2,,,"A")
    }
  }Else{
    CNT:=0
    Loop 3
      If ARR[A_Index+2].C.Value
        CNT++
    GOO['BtnMain'].Text:=(!CNT?'Exit without fixing':'Fix selected')
  }
}

;Main Fix Code
FX(CT){
  Global CSS,DIR
  EXE:='',SWH:='Steam ahk_exe steamwebhelper.exe'
  UND:=WinExist(SWH)
  DetectHiddenWindows(1)
  DET:=WinExist(SWH)
  If (DET||UND){
    RES:=MsgBox('Restart Steam when fixed?','Last question...',0x1023)
    If (RES='Cancel')
      Return
    EXE:=RegExReplace(WinGetProcessPath(SWH),'(.*)bin.*','$1steam.exe')
    If (RES='Yes')
      ProcessClose('steamwebhelper.exe')
  }
  CNT:=0,SIZ:=StrLen(CSS)
  Loop 3{
    I:=A_Index
    If ARR[I+2].C.Visible && ARR[I+2].C.Value{
      CSS:=RegExReplace(CSS,RR%I%,REP)
      ARR[I+2].C.Visible:=0
      ARR[I+2].I.Text:='Successfully replaced!'
      ARR[I+2].I.SetFont('c00FF00')
      CNT++
    }
  }



;xyzfix - replace with ini (changes only); regex vs. position (proximity check maybe)?!
  If CNT{
    FileMove(FIL,SubStr(FIL,1,-3) 'bup',1)
    FileAppend(CSS Format('{: ' SIZ-StrLen(CSS) '}',' '),FIL)
  }



  RunWait(RegExReplace(DIR,'steamui\\css\\','steam.exe'))
  If EXE{
    If (RES='Yes')
      Run(EXE)
    If UND
      DetectHiddenWindows(1),WinWait(SWH),WinShow(SWH)
  }
  CT.Text:='Fixed and saved! Exit?'
}

;GUI Parameter Shortener
CP(X,Y,W:=0,H:=0,F:=0,B:=0,O:=0)=>'x' X ' y' Y (W?' w' W:'') (H?' h' H:'') (F?' C' F:'') (B?' +Background' (B=1?F:B):'')
. (O=1?' Disabled':O=2?' Center':O=3?' Checked':'')

;Check all CSS files for matches
FindCSS(){
  Loop Files '*.css'{
    If RegExMatch(CSS:=FileRead(A_LoopFileName),RM1)
      Return {C:CSS,F:A_LoopFileName}



;xyzfix - check ini/file date changes? FileGetTime(FIL,'M') - Modified time!
    Else
      Return {C:FileRead('sp.css'),F:'sp.css'}



  }
}

;Steam Install Directory Finder
SteamDir(){
  DIR:=''
  Switch{
    Case EXE:=(WinExist(TMP:='Steam ahk_exe steamwebhelper.exe')?WinGetProcessPath(TMP):''):
      DIR:=RegExReplace(EXE,'(.*)bin.*','$1steamui\css\')
    Case FileExist('C:\Program Files (x86)\Steam\steam.exe'):
      DIR:='C:\Program Files (x86)\Steam\steamui\css\'
    Case EXE:=RegRead('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam','UninstallString'):
      DIR:=RegExReplace(EXE,'(.*)\\.*','$1\steamui\css\')
    Case EXE:=RegRead('HKCR\steam\Shell\Open\Command'):
      DIR:=RegExReplace(EXE,'^"(.*)\\.*','$1\steamui\css\')
    Default:
      Loop{
        DIR:=RegExReplace(FileSelect('1','C:\Program Files (x86)\Steam','Select your "steam.exe"...',
          'Steam (steam.exe)'),'(.*)\\.*','$1\steamui\css\')
      }Until !DIR || (DIR~="steamui")
  }
  Return DIR
}

;Get Webpage
GetResponseText(URL){
  For GET in ['WinHttp.WinHttpRequest.5.1','MSXML2.XMLHTTP.6.0']
    Try{
      WEB:=ComObject(GET)
      WEB.Open("GET",URL,0)
      (GET='WinHttp.WinHttpRequest.5.1') && WEB.SetRequestHeader('User-Agent',A_ThisFunc)
      WEB.Send()
      If (WEB.Status==200)
        Return WEB.ResponseText
    }
  Return ''
}