set objStdOut = WScript.StdOut

Const TrojanLogFile = "\temp\dfvt.log"
Const AttackLogFile = "\wb2010kb.log"
Const TrojanWMIProvider = "ASEventConsumerdr"
TrojanWMIEventFilters = Array("EF", "EFNMdr")
MinerProcesses = Array("smssm.exe", "z64.exe", "servies.exe", "msdc.exe")
MinerSchedTaskNames = Array("gm", "ngm","cell")

Const ScriptLogFile = "detection.log"
Const ConsoleLogLevel = 1
'Log levels
Const DBG = 0
Const INFO = 1

Const ForAppending = 8

Dim gLogger

initLog(ScriptLogFile)
main()
closeLog()


Function main()
    log INFO, "****************************************************"
    log INFO, "GuardiCore Botnet Cleanup Tool"
    log INFO, "Written By Guardicore Labs"
    log INFO, "Contact us at: support@guardicore.com"
    log INFO, "****************************************************" & vbCrLf
  
    If (WScript.Arguments.Count = 0) Then
        verify()
    ElseIf (WScript.Arguments.Count = 1) Then
        Set colNamedArguments = WScript.Arguments.Named
        If colNamedArguments.Exists("clean") Then 
            cleanup()
        ElseIf (colNamedArguments.Exists("help")) or (colNamedArguments.Exists("h")) Then
            printUsage()
        Else
            log INFO, "Invalid argument: " & WScript.Arguments.Item(0)
            printUsage()
        End If
    Else
        log INFO, "Invalid Usage - too many arguments."
        printUsage()
    End If
End Function

Function printUsage()
    log INFO, "Usage: cscript.exe " & Wscript.SCriptName & " [/clean]"
End Function

Function verify()
    ' Check for log files
    Dim logFiles
    Set logFiles = detectLogFiles(False)
    ' Check for WMI consumer
    Dim isTrojanInstalled
    isTrojanInstalled = detectWMITrojan(False)
    ' Check for open RDP connections
    Dim userBD
    Set userBD = detectUserBackdoor(False)
    ' Check for the miner
    Dim miner
    Set miner = detectMiner(False)
    
    dim isInfected
    If (0 < logFiles.Count) or (isTrojanInstalled) Then
        isInfected = True
        log INFO, "Status: INFECTED" & vbCrLf
    Else
        isInfected = False
        log INFO, "Status: CLEAN" & vbCrLf
    End If
    
    If 0 < logFiles.Count Then 
        log INFO, "Attack Log Files: FOUND"
        log INFO, "The following log files were found: " & Join(logFiles.Items(), ", ") & vbCrLf
    Else
        log INFO, "Attack Log Files: Not Found" & vbCrLf
    End If
    
    if isTrojanInstalled Then
        log INFO, "WMI Trojan: FOUND"
        log INFO, "The following WMI Provider was found: " & TrojanWMIProvider & vbCrLf
    Else
        log INFO, "WMI Trojan: Not Found" & vbCrLf
    End If
    
    set TaskObj = miner.Item("Task")
    If (TaskObj.Exists("TaskName")) or ("" <> miner.Item("Process")) Then
        log INFO, "Miner: FOUND"
        If "" <> miner.Item("Process") Then
            log INFO, "The following miner is currently running: " & miner.Item("Process")
        End If
        If TaskObj.Exists("TaskName") Then
            log INFO, "The following scheduled task was found: " & TaskObj.Item("TaskName")
            log INFO, "Running the following command: " & TaskObj.Item("TaskCommand")
        End If
        log INFO, ""
    Else
        log INFO, "Miner: Not Found" & vbCrLf
    End If

    If not userBD.Item("isGuestEnabled") Then
        log INFO, "User Backdoor: Not Found" & vbCrLf
    ElseIf isInfected Then 
        log INFO, "User Backdoor: FOUND" 
        If userBD.Item("isRDPEnabled") Then 
            log INFO, "Incoming Remote Desktop connections are enabled. If not required, you can disable it by running the following command:"
            log INFO, "reg add ""HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server"" /v fDenyTSConnections /t REG_DWORD /d 1 /f"
        End If
        log INFO, ""
    End If
    
    'More debug prints
    log DBG, "More Info:"
    log DBG, "Are Remote Desktop connections allowed? " & userBD.Item("isRDPEnabled") & vbCrLf
    log DBG, "Attack log file: " & vbCrLf & readAttackLog() & vbCrLf
    log DBG, "Trojan Log File: " & vbCrLf & readTrojanLog() & vbCrLf
    
    If isInfected Then 
        log INFO, "To clean the machine run: cscript.exe " & Wscript.SCriptName & " /clean"
    End If
End Function

Function cleanup()
    log INFO, "Starting to cleanup the machine..."
    
    detectLogFiles(True)
    detectWMITrojan(True)
    detectMiner(True)
    disableGuestAccount()

    log INFO, "Your machine is now cleaned!"
End Function

Function readAttackLog()
    readAttackLog = readWinFile(AttackLogFile)
End Function

Function readTrojanLog()
    readTrojanLog = readWinFile(TrojanLogFile)
End Function

Function detectLogFiles(cleanFlag)
    dim logFiles
    set logFiles = CreateObject("Scripting.Dictionary")
    ' Check for log files
    If doesExistUnderWindir(TrojanLogFile) Then
        logFiles.Add "TrojanLog", "%windir%" & TrojanLogFile
        If cleanFlag Then
            delFileUnderWindows(TrojanLogFile)
            log INFO, "Removed the trojan log file: %windir%" & TrojanLogFile
        End If
    End If
    If doesExistUnderWindir(AttackLogFile) Then
        logFiles.add "AttackLog", "%windir%" & AttackLogFile
        If cleanFlag Then
            delFileUnderWindows(AttackLogFile)
            log INFO, "Removed the attack log file: %windir%" & AttackLogFile
        End If
    End If
    set detectLogFiles = logFiles
End Function

Function detectWMITrojan(cleanFlag)
    Set oWMI = GetObject("winmgmts:\\.\root\subscription")
    Set colClasses = oWMI.ExecQuery("SELECT * FROM meta_class where __class = '" & TrojanWMIProvider & "'")
    If 0 <> getCount(colClasses) Then 
        detectWMITrojan = True
        If cleanFlag Then
            log INFO, "Removing the WMI trojan..."

            'Delete the class
            For Each oClass in colClasses
                oClass.Delete_
            Next
            'Delete the WMI  provider instance
            Set colProviders = oWMI.ExecQuery("SELECT * FROM __Win32Provider where Name = '" & TrojanWMIProvider & "'")
            If 0 <> getCount(colProviders) Then 
                For Each objRef In colProviders
                    objRef.Delete_
                Next
            End If
            'Delete the event filters
            For Each filterName in TrojanWMIEventFilters
                deleteEventFilter(filterName)
            Next

            log INFO, "The WMI trojan was removed successfuly."
        End If
    Else
        detectWMITrojan = False
    End If
End Function

Function detectMiner(cleanFlag)
    Dim miner
    Set miner = CreateObject("Scripting.Dictionary")
    miner.Add "Task", detectMinerTask(cleanFlag)
    miner.Add "Process", detectMinerProcess(cleanFlag)
    Set detectMiner = miner
End Function

Function detectMinerTask(cleanFlag)
    For Each taskName in MinerSchedTaskNames
        Set schedTask = findScheduleTask(taskName)
        If schedTask.Exists("TaskName") Then
            If cleanFlag Then
                deleteScheduleTask(taskName)
            End If
            Set detectMinerTask = schedTask
            Exit Function
        End If
    Next
    Set detectMinerTask = CreateObject("Scripting.Dictionary")
End Function

Function detectMinerProcess(terminateFlag)
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set cols = objWMIService.ExecQuery ("SELECT * FROM Win32_Process", , 48)
    For Each objProcItem In cols
        For Each minerProcess In MinerProcesses
            If InStr(1, LCase(objProcItem.ExecutablePath), LCase(minerProcess), 1) > 0 Then 
                detectMinerProcess = objProcItem.ExecutablePath
                If terminateFlag Then
                    killWaitAndDelete(objProcItem)
                    log INFO, "Killing the miner process: " & minerProcess
                End If
            Exit Function
            End If
        Next
    Next
    detectMinerProcess = ""
End Function

Function detectUserBackdoor(cleanFlag)
    Dim userBD
    Set userBD = CreateObject("Scripting.Dictionary")
    Dim objOutParams, uValue1
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\DEFAULT:StdRegProv")
    objOutParams = objWMIService.GetDWORDValue(&H80000002, "SYSTEM\\CurrentControlSet\\Control\\Terminal Server", "fDenyTSConnections", uValue1):
    userBD.Add "isRDPEnabled", 0 = uValue1
    
    dim GuestName
    GuestName = GetGuest()
    If "" <> GuestName Then
        Set objUser = GetObject("WinNT://./" & GuestName & ", user")
        userBD.Add "isGuestEnabled", not objUser.AccountDisabled
    Else
        userBD.Add "isGuestEnabled", False
    End If
    set detectUserBackdoor = userBD
End Function

' Utility functions

Function deleteEventFilter(eventFilterName)
    Set objFilter = GetObject("winmgmts:root\subscription:__EventFilter.Name='" & eventFilterName & "'")
    For Each objRef In objFilter.References_
        objRef.Delete_
    Next
End Function

Function findScheduleTask(taskName)
    If InStr(getOSVersion(), "5.") Then 'it's 5.0(2000), 5.1(XP),5.2(2003)
        Set findScheduleTask = findScheduleTaskOld(taskName)
    Else
    ' Else running in 6.0+
        Set findScheduleTask = findScheduleTaskModern(taskName)
    End If
End Function

Function findScheduleTaskOld(taskName)
    '5.0(2000), 5.1(XP),5.2(2003)
    Set taskD = CreateObject("Scripting.Dictionary")
    If doesExistUnderWindir("\\tasks\\" & taskName & ".job") Then
        'for sure trojan task, but lets collect more data'
        taskD.Add "TaskName", taskName
        result = runProg("schtasks /Query /FO LIST /V")
        TaskLines = Split(result, "\n")
        dim taskIndex
        For i = LBound(TaskLines) to UBound(TaskLines)
            If InStr(TaskLines(i), taskName) Then
                taskIndex = i
                Exit For
            End If
        Next
        commandIndex = taskIndex + 8
        dim taskCmd
        taskCmd = Mid(TaskLines(commandIndex), InStr(TaskLines(commandIndex), ":\") - 1)
        taskD.Add "TaskCommand", taskCmd
        Set findScheduleTaskOld = taskD
        Exit Function
    End If
    Set findScheduleTaskOld = taskD
End Function

Function findScheduleTaskModern(taskName)
    Set taskD = CreateObject("Scripting.Dictionary")
    Dim result
    result = runProg("schtasks /Query /FO CSV /V /TN " & taskName)
    strLine = Split(result, "\n")
    For Each line In strLine:
        If (InStr(line, taskName)) and (InStr(line, ".bat")) Then
            TaskCommands = Split(line, ",")
            taskD.Add "TaskName", taskName
            taskD.Add "TaskCommand", TaskCommands(8)
            Set findScheduleTaskModern = taskD
            Exit Function
        End If
	Next
    Set findScheduleTaskModern = taskD
End Function

Function getOSVersion()
    Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
    Set colOperatingSystem = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")

    Dim OSVer
    For Each objOperatingSystem in colOperatingSystem
        OSVer = Left(objOperatingSystem.Version, 3)
    Next
    getOSVersion = OSVer
End Function

Function deleteScheduleTask(taskName)
    dim command
    log INFO, "Removing the miner schedule task: " & taskName
    command = "schtasks.exe /Delete /F /TN """ & taskName & """"
    runProg(command)
    Set schedTask = findScheduleTask(taskName)
    If Not schedTask.Exists("TaskName") Then
        log INFO, "The miner schedule task was removed successfuly."
    Else
        log INFO, "FAILED to remove the miner schedule task: " & taskName
    End If
End Function

Function delFileUnderWindows(filePath)
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    windir = objFSO.GetSpecialFolder(0)
    deleteFileIfExist(windir + filePath)
    Set objFSO = Nothing
End Function

Function initLog(logFile)
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set gLogger = objFSO.OpenTextFile(logFile, ForAppending, True)
    Set objFSO = Nothing

    log DBG, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BEGINNING OF LOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
End Function

Function closeLog()
    log DBG, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> END OF LOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    gLogger.Close()
    Set Logger = Nothing
End Function

Function log(debugLevel, strLog)
    currTime = FormatDateTime(Now())
    If ConsoleLogLevel <= debugLevel Then
        objStdOut.WriteLine strLog
    End If
    logLine = "[" & currTime & "] " & strLog
    gLogger.WriteLine logLine
End Function

Function readWinFile(logPath)
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    windir = objFSO.GetSpecialFolder(0)
    If objFSO.FileExists(windir + logPath) Then
        Set f = objFSO.OpenTextFile(windir + logPath, 1, False)
        slog = f.ReadLine()
        f.Close
        Set objFSO = Nothing
        readWinFile = slog
        Exit Function
    End If
    readWinFile = "nolog"
End Function

Function doesExistUnderWindir(filepath):
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    windir = objFSO.GetSpecialFolder(0)
    If objFSO.FileExists(windir + filepath) Then
        doesExistUnderWindir = True
        Exit Function
    End If
    doesExistUnderWindir = False
End Function

function getCount(wmiCol)
    on error resume next
    getCount = wmiCol.Count
    if (err.number <> 0) then getCount = (0)
    on error goto 0
end function

Function disableGuestAccount()
    dim GuestName
    GuestName = GetGuest()
    If "" = GuestName Then
        disableGuestAccount = False
        Exit Function
    End If
    Set objUser = GetObject("WinNT://./" & GuestName & ", user")
    objUser.AccountDisabled = True
    objUser.SetInfo
    log INFO, "Disabled the guest account."
    disableGuestAccount = True
End Function

Function GetGuest()
    'Return guest account name, internationalised.'
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_UserAccount",,48) 
    For Each objItem In colItems 
        sid = Right(objItem.SID, 4)
        If sid = "-501" Then
            GetGuest = objItem.Name
            Exit Function
        End If
    Next
    GetGuest = ""
End Function

Function runProg(command)
	Set objShell = WScript.CreateObject("WScript.Shell")
	Set objExecObject = objShell.Exec(command)
	strText = ""
	Do While Not objExecObject.StdOut.AtEndOfStream
	    strText = strText & objExecObject.StdOut.ReadLine() & "\n" 
	Loop
	runProg = strText
End Function

Function killWaitAndDelete(procObj)
    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set colMonitoredProcesses = objWMIService.ExecNotificationQuery("Select * From __InstanceDeletionEvent Within 1 Where TargetInstance ISA 'Win32_Process'")
    procObj.Terminate
    Do Until i = 1
        Set objLatestProcess = colMonitoredProcesses.NextEvent
        If objLatestProcess.TargetInstance.ProcessID = procObj.ProcessId Then
            i = 1
        End If
    Loop
    deleteFileIfExist(procObj.ExecutablePath )
    deleteFileIfExist(procObj.ExecutablePath & ".bak")
End Function

Function deleteFileIfExist(filepath)
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If  objFSO.FileExists(filepath) Then
            objFSO.DeleteFile filepath, True
    End If
End Function