function Invoke-DbcsEngine {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [System.IO.FileInfo]$ControlFile,
        [Parameter()]
        [System.IO.DirectoryInfo]$InstallDir = "C:\Program Files\Exstream"
    )
    Process {
        Invoke-AtLocation -Location $InstallDir -ExecutionBlock { Invoke-Expression ".\ProdEngine_dbcs.exe -CONTROLFILE=`"$ControlFile`"" }
    }
}