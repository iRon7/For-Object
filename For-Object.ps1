<#PSScriptInfo
.VERSION 0.0.1
.GUID 19631007-c461-4682-a58d-0bfe9202908d
.AUTHOR iRon
.COMPANYNAME
.COPYRIGHT
.TAGS For Each Pipeline Index PSIndex
.LICENSE https://github.com/iRon7/For-Object/LICENSE
.PROJECTURI https://github.com/iRon7/For-Object
.ICON
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES #13772 ForEach-Object with a pipeline Index ($PSIndex)
.PRIVATEDATA
#>

[CmdletBinding(DefaultParameterSetName='ScriptBlockSet', SupportsShouldProcess=$true, ConfirmImpact='Low', HelpUri='https://go.microsoft.com/fwlink/?LinkID=2096867', RemotingCapability='None')]
param(
    [Parameter(ParameterSetName='ScriptBlockSet', ValueFromPipeline=$true)]
    [Parameter(ParameterSetName='PropertyAndMethodSet', ValueFromPipeline=$true)]
    [Parameter(ParameterSetName='ParallelParameterSet', ValueFromPipeline=$true)]
    [psobject]
    ${InputObject},

    [Parameter(ParameterSetName='ScriptBlockSet')]
    [scriptblock]
    ${Begin},

    [Parameter(ParameterSetName='ScriptBlockSet', Mandatory=$true, Position=0)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [scriptblock[]]
    ${Process},

    [Parameter(ParameterSetName='ScriptBlockSet')]
    [scriptblock]
    ${End},

    [Parameter(ParameterSetName='ScriptBlockSet', ValueFromRemainingArguments=$true)]
    [AllowNull()]
    [AllowEmptyCollection()]
    [scriptblock[]]
    ${RemainingScripts},

    [Parameter(ParameterSetName='PropertyAndMethodSet', Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]
    ${MemberName},

    [Parameter(ParameterSetName='PropertyAndMethodSet', ValueFromRemainingArguments=$true)]
    [Alias('Args')]
    [System.Object[]]
    ${ArgumentList},

    [Parameter(ParameterSetName='ParallelParameterSet', Mandatory=$true)]
    [scriptblock]
    ${Parallel},

    [Parameter(ParameterSetName='ParallelParameterSet')]
    [ValidateRange(1, 2147483647)]
    [int]
    ${ThrottleLimit},

    [Parameter(ParameterSetName='ParallelParameterSet')]
    [ValidateRange(0, 2147483)]
    [int]
    ${TimeoutSeconds},

    [Parameter(ParameterSetName='ParallelParameterSet')]
    [switch]
    ${AsJob},

    [Parameter(ParameterSetName='ParallelParameterSet')]
    [switch]
    ${UseNewRunspace})

begin {
    $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\ForEach-Object', [System.Management.Automation.CommandTypes]::Cmdlet)
    $scriptCmd = {& $wrappedCmd @PSBoundParameters }

    $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
    $steppablePipeline.Begin($True)

    $PSIndex = 0
}

process {
    $steppablePipeline.Process($_)
    $PSIndex ++
}

end {
    $steppablePipeline.End()
}

clean {
    if ($null -ne $steppablePipeline) {
        $steppablePipeline.Clean()
    }
}
<#

.ForwardHelpTargetName Microsoft.PowerShell.Core\ForEach-Object
.ForwardHelpCategory Cmdlet

#>

