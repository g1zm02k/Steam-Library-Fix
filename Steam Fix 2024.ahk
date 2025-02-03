#Requires AutoHotkey 2.0+
#SingleInstance Force
 
;Change the following line to your Steam CSS directory...
SetWorkingDir("C:\Program Files (x86)\Steam\steamui\css\")
 
Loop Files "Chunk*.css","F"
  F:=A_LoopFileName
If !F
  MsgBox("Matching CSS file not found!`n`nQuitting...","CSS File Error",0x30),ExitApp()
S:=StrLen(H:=FileRead(F)),D:=0
 
; #####  "What's New" section  #####
If RegExMatch(H,".*?17uEB[^\{]*\{bo.*?\}\.Lib.*")
  H:=RegExReplace(H,"`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)","$1display:none !important;$2"),D:=1
 
; #####  "Add Shelf" section  #####
If RegExMatch(H,".*?3SkuN[^\{]*\{bo.*?\}.*")
  H:=RegExReplace(H,"`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)","$1display:none !important;$2"),D:=1
 
If D
  FileMove(F,SubStr(F,1,-3) "bup",1),FileAppend(H Format("{: " S-StrLen(H) "}"," "),F)
MsgBox("All replacements have" (D?"":" already") " been made.","All done...")
