#Requires AutoHotkey 2.0+
#SingleInstance Force

; Change the following line to your Steam CSS directory...
SetWorkingDir("C:\Program Files (x86)\Steam\steamui\css\")

; Try to load main CSS file
If !(F:="chunk~2dcc5aaf7.css")
  MsgBox("Matching CSS file not found!`n`nQuitting...","Error",0x30),ExitApp()
S:=StrLen(H:=FileRead(F)),D:=0

; #####  "What's New" section  #####
If RegExMatch(H,"17uEB[^\{]*\{bo.*?\}")
  H:=RegExReplace(H,"(17uEB[^\{]*\{)bo.*?(\})","$1display:none !important;$2"),D:=1

; #####  "Add Shelf" section  #####
If RegExMatch(H,"3SkuN[^\{]*\{bo.*?\}")
  H:=RegExReplace(H,"(3SkuN[^\{]*\{)bo.*?(\})","$1display:none !important;$2"),D:=1

; #####  "Big Picture" button  #####
If RegExMatch(H,"_3LKQ[^\{]*\{co.*?\}")
  H:=RegExReplace(H,"(_3LKQ[^\{]*\{)co.*?(\})","$1display:none !important;$2"),D:=1

; If changes were made, back-up the original and rewrite changed file
If D
  FileMove(F,SubStr(F,1,-3) "bup",1),FileAppend(H Format("{: " S-StrLen(H) "}"," "),F)
MsgBox("All replacements have" (D?"":" already") " been made.","All done...")