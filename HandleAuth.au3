#RequireAdmin ; Mandatory to inject keys into security popups

Opt("WinTitleMatchMode", 2) ; Enables partial title matching

Local $sTitle = "Windows Security"
Local $sText = "EXCEL.EXE" ; Unique text inside your prompt

If WinWait($sTitle, $sText, 15) Then
    WinActivate($sTitle, $sText)
    WinWaitActive($sTitle, $sText, 5)
    
    Sleep(500) ; Brief pause to ensure focus rests on the Username field
    
    Send("TESTIX1")
    Send("{TAB}")
    Send("EXCELIX1_123")
    Send("{ENTER}")
    
    Exit
EndIf
