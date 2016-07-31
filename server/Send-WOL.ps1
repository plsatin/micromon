﻿<#
MicroMonitoring: Send-WOL
Version 1.5
Description: Скрипт отправки WOL пакета для пробуждения компьютера.
Pavel Satin (c) 2015
pslater.ru@gmail.com
#>

#[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Send-WOL
{
<# 
  .SYNOPSIS  
    Отправка WOL пакета
  .PARAMETER mac
    MAC адрес пробуждаемого устройства
  .PARAMETER ip
    Броадкаст IP адрес
  .EXAMPLE 
   Send-WOL -mac 00:00:00:00:00:00 -ip 192.168.0.255 
#>

[CmdletBinding()]
param(
[Parameter(Mandatory=$True,Position=1)]
[string]$mac,
[string]$ip="255.255.255.255", 
[int]$port=9
)
$broadcast = [Net.IPAddress]::Parse($ip)
$mac=(($mac.replace(":","")).replace("-","")).replace(".","")
$target=0,2,4,6,8,10 | % {[convert]::ToByte($mac.substring($_,2),16)}
$packet = (,[byte]255 * 6) + ($target * 16)
$UDPclient = new-Object System.Net.Sockets.UdpClient
$UDPclient.Connect($broadcast,$port)
[void]$UDPclient.Send($packet, 102) 

}


$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3



Send-WOL -mac $args[0]
Write-Host "OK - Command send."
#[System.Environment]::Exit($returnStateOK)
