; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

!define APP "AntiKB-2021-03"

!finalize 'MySign "%1"'

; The name of the installer
Name "${APP}"

; The file to write
OutFile "${APP}.exe"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir "$APPDATA\${APP}"

!include "Time.nsh"

XPStyle on

;--------------------------------

; Pages

Page directory
Page components
Page instfiles

;--------------------------------

; The stuff to install
Section "更新を 14 日間一時停止" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ${time::GetLocalTimeUTC} $1 ; 11.03.2021 03:01:06
  
  ${time::MathTime} "date($1) + date(14.0.0 0:0:0) = date" $2

  StrCpy $R1 $2 4  6 ;yyyyy
  StrCpy $R2 $2 2  3 ;MM
  StrCpy $R3 $2 2  0 ;dd
  StrCpy $R4 $2 2 11 ;HH
  StrCpy $R5 $2 2 14 ;mm
  StrCpy $R6 $2 2 17 ;ss

  StrCpy $2 "$R1-$R2-$R3T$R4:$R5:$R6Z"

  StrCpy $R1 $1 4  6 ;yyyyy
  StrCpy $R2 $1 2  3 ;MM
  StrCpy $R3 $1 2  0 ;dd
  StrCpy $R4 $1 2 11 ;HH
  StrCpy $R5 $1 2 14 ;mm
  StrCpy $R6 $1 2 17 ;ss

  StrCpy $1 "$R1-$R2-$R3T$R4:$R5:$R6Z"

  # 2021-03-18T02:47:09Z

  SetRegView 64

  WriteRegStr HKLM "SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "PauseFeatureUpdatesEndTime" $2
  WriteRegStr HKLM "SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "PauseFeatureUpdatesStartTime" $1
  WriteRegStr HKLM "SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "PauseQualityUpdatesEndTime" $2
  WriteRegStr HKLM "SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "PauseQualityUpdatesStartTime" $1
  WriteRegStr HKLM "SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "PauseUpdatesExpiryTime" $2

  SetRegView lastused

SectionEnd ; end the section

!macro UninstallKB NUM
Section "更新プログラム KB${NUM} を削除"

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ExecWait "wusa /uninstall /kb:${NUM} /norestart" $0
  DetailPrint "結果: $0"

SectionEnd ; end the section
!macroend

!insertmacro UninstallKB 5000802
!insertmacro UninstallKB 5000808
