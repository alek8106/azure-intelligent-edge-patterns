function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[System.String]
		$Ensure
	)
    
    $S2SInterface = Get-VPNS2SInterface -Name $Name -ErrorAction SilentlyContinue

	$returnValue = @{
		AdminStatus = [System.Boolean]$S2SInterface.AdminStatus
		ConnectionState = [System.String]$S2SInterface.ConnectionState
		Destination = [System.String]$S2SInterface.Destination
		Ensure = [System.String]$Ensure
		Name = [System.String]$S2SInterface.Name
	}

	$returnValue = @{
		Name = [System.String]
		Ensure = [System.String]
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	$Params = $PSBoundParameters
    $output = $Params.Remove('Ensure')
    $output = $Params.Remove('Debug')
    $output = $Params.Remove('Verbose')
    $output = $Params.Remove('DependsOn')

    if ($Ensure -eq 'Present') {
        Connect-VpnS2SInterface @Params
    }
    if ($Ensure -eq 'Absent') {
        Disconnect-VpnS2SInterface
    }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Name,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure
	)

	$result = [System.Boolean]$false
    $VpnS2SInterfaceConnection = Get-VpnS2SInterface

	if ($Ensure -eq 'Present' -and $VpnS2SInterfaceConnection.ConnectionState -eq 'Connected') {
        $result = [System.Boolean]$true
    }
    if ($Ensure -eq 'Absent' -and $VpnS2SInterfaceConnection.ConnectionState -eq 'Disconnected') {
        $result = [System.Boolean]$true
    }
	
	$result
}


Export-ModuleMember -Function *-TargetResource

