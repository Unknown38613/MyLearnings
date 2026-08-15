Local $sUsername = "TESTIX1"
Local $sPassword = "EXCELIX1_123"
Local $sWinTitle = "Windows Security"

While 1
    If WinWait($sWinTitle, "", 5) Then
        WinActivate($sWinTitle)
        WinWaitActive($sWinTitle, "", 5)

        Send($sUsername)
        Send("{TAB}")
        Send($sPassword)
        Send("{ENTER}")

        Sleep(1000)
    EndIf
WEnd