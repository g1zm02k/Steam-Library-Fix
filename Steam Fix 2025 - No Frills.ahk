#Requires AutoHotkey 2.0+
#SingleInstance Force

; Change the following line to your Steam CSS directory...
SetWorkingDir("C:\Program Files (x86)\Steam\steamui\css\")

; Try to load the main UI CSS file
If !(F:="chunk~2dcc5aaf7.css")
  MsgBox("Matching CSS file not found!`n`nQuitting...","Error",0x30),ExitApp()
S:=StrLen(H:=FileRead(F)),R:="$1display:none !important;$2"

; #####  "What's New" section  #####
If RegExMatch(H,"17uEB[^\{]*\{bo.*?\}")
  H:=RegExReplace(H,"(17uEB[^\{]*\{)bo.*?(\})",R)

; #####  "Add Shelf" section  #####
If RegExMatch(H,"3SkuN[^\{]*\{bo.*?\}")
  H:=RegExReplace(H,"(3SkuN[^\{]*\{)bo.*?(\})",R)

; #####  "Big Picture" button  #####
If RegExMatch(H,"_3LKQ[^\{]*\{co.*?\}")
  H:=RegExReplace(H,"(_3LKQ[^\{]*\{)co.*?(\})",R)

; If changes were made, back-up the original and write changed file
If (S!=StrLen(H))
  FileMove(F,SubStr(F,1,-3) "bup",1),FileAppend(H Format("{: " S-StrLen(H) "}"," "),F)
MsgBox("Any replacements have been made.","All done...")
