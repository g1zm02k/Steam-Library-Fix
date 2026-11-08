#Requires AutoHotkey 2.0.13+
#SingleInstance Force
;Change the following line to your Steam CSS directory...
SetWorkingDir("C:\Program Files (x86)\Steam\steamui\css\")

Loop Files "Chunk*.css","F"
  F:=A_LoopFileName
If !F
  MsgBox("Matching CSS file not found!`n`nQuitting..."
   ,"CSS File Error",0x30),ExitApp()
S:=StrLen(H:=FileRead(F)),D:=0

; #####  What's New section  #####
If RegExMatch(H,".*?17uEB[^\{]*\{bo.*?\}\.Lib.*")
  H:=RegExReplace(H
   ,"`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
   ,"$1display:none !important;$2"),D:=1

; #####  Add Shelf section  #####
If RegExMatch(H,".*?3SkuN[^\{]*\{bo.*?\}.*")
  H:=RegExReplace(H
   ,"`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
   ,"$1display:none !important;$2"),D:=1

If D{
  FileMove(F,SubStr(F,1,-3) "bup",1)
  FileAppend(H Format("{: " S-StrLen(H) "}"," "),F)
}
MsgBox("All replacements have" (D?"":" already") " been made."
 . "`n`nFire up Steam and make sure it's worked!"
 ,"All done...",0x40)

/*
#Requires AutoHotkey 2.0.13+
#SingleInstance Force
SetWorkingDir("C:\Program Files (x86)\Steam\steamui\css\")

Loop Files "Chunk*.css","F"
  F:=A_LoopFileName
If !F
  MsgBox("Matching CSS file not found!`n`nQuitting..."
   ,"CSS File Error",0x30)
    ,ExitApp()
H:=FileRead(F)
S:=StrLen(H)
A:=B:=""

; #####  What's New section  #####
If RegExMatch(H,".*?17uEB[^\{]*\{bo.*?\}\.Lib.*"){
  A:=MsgBox('Remove "What`'s New"?','"What`'s New"',0x24)
  If (A~="Y")
    H:=RegExReplace(H
     ,"`aim)(.*?17uEB[^\{]*\{)bo.*?(\}\.Lib.*)"
     ,"$1display:none !important;$2")
  Else A:="N"
}

; #####  Add Shelf section  #####
If RegExMatch(H,".*?3SkuN[^\{]*\{bo.*?\}.*"){
  B:=MsgBox('Remove "Add Shelf"?','"Add Shelf"',0x24)
  If (B~="Y")
    H:=RegExReplace(H
     ,"`aim)(.*?3SkuN[^\{]*\{)bo.*?(\}.*)"
     ,"$1display:none !important;$2")
  Else B:="N"
}

If (A~="Y") || (B~="Y"){
  H.=Format("{: " S-StrLen(H) "}"," ")
  FileMove(F,SubStr(F,1,-3) "bup",1)
  FileAppend(H,F)
  MsgBox("All replacements have been made.`n`n"
   . "Fire up Steam and make sure it's worked!"
   ,"All done...",0x40)
}Else If (A="N") && (B="N"){
  MsgBox("No changes made.`n`n"
   . "Made for a good test run at least!"
   ,"Nothing to do...",0x40)
}Else{
  MsgBox("No matching CSS found.`n`n"
   . "It's either cleaned already, or "
   . "you don't have the recent update!"
   ,"Oh, bugger...",0x40)
}
*/