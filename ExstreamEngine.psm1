function Get-Build {
    [CmdletBinding()]
    Param(
        [Parameter(
            HelpMessage = "Which build type do you want?"
        )]
        [ValidateSet("Integration", "Production", "Release-Candidate")]
        [string]$BuildType = "Integration",

        [Parameter(
            HelpMessage = "Which product do you want?"
        )]
        [ValidateSet("AFP-Studio", "Delivery-Manager", "Dialogue", "Empower", "Smart-Marketing-Suite", "Test", "Web")]
        [string]$Product = "Dialogue",

        [Parameter(
            HelpMessage = "Which release do you want? Code names will resolve to latest in their release"
        )]
        [ValidateSet(
            # "Metallica",
            "8.0.3",
            # "Oasis",
            "8.6.1",
            # "Police",
            "9.0.1",
            # "Styx",
            "9.5.3",
            # "Toto",
            "16.2.4",
            # "U2",
            "16.3.2",
            "16.3.3",
            # "VanHalen",
            "16.4.0",
            # "Wham",
            "16.4.1",
            "16.4.5"
        )]
        [string]$Release,
        # TODO: Dynamic parameters?
        [Parameter(
            HelpMessage = "Which build number to get in the release? Ex: For 16.4.5.185776, supply 185776"
        )]
        [int]$buildNum = -1, #assume latest if -1,

        [Parameter(
            HelpMessage = "Run command against the SBCS build instead of DBCS"
        )]
        [switch]$SBCS, # Assume DBCS if false

        [Parameter(
            HelpMessage = "Which folder should the files be copied to before their ultimate destination?"
        )]
        [ValidateScript( {
                if (-not ($_ | Test-Directory -Writable)) {
                    throw "Scratch Path is not writable"
                }
                return $true
            }
        )]
        [System.IO.DirectoryInfo]$ScratchPath = "C:\Users\wgillela\Desktop\Scratch",

        [Parameter(
            Mandatory = $true,
            HelpMessage = "Where should the ultimate destination of the build be?"
        )]
        [ValidateScript( {
                if (-not ($_ | Test-Directory -Writable)) {
                    throw "Destination Path is not writable"
                }
                return $true
            }
        )]
        [System.IO.DirectoryInfo]$Destination = "$((Get-ChildItem Env:\ProgramFiles).Value)\Exstream\"
    )
    Begin {
        $Bitness = "x64"
        if ($SBCS) {
            $Bitness = "x86"
        }
    }
    Process {
        $DriveMaps['Releases'].UncPath + "\Internal\$BuildType\$Product\$Release\$Release.$buildNum\$Product\WIN\$Bitness\DBCS\* -> $ScratchPath -> $Destination"
    }
}

function ConvertFrom-EngineDPI {
    [OutputType([float])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [int]$value,
        [ValidateSet("Inches", "Cm", "Mm", "Pt", "Px")]
        [string]$units = "Inches"
    )
    Process {
        $ret = $value / 1000
        switch ($units) {
            "Inches" { return $ret }
            "Cm" { return $ret * 2.54 }
            "Mm" { return $ret * 25.4 }
            "Pt" { return $ret * 72 }
            "Px" { return $ret * 96 }
        }
    }
}

function ConvertTo-EngineDPI {
    [OutputType([float])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [int]$value,
        [ValidateSet("Inches", "Cm", "Mm", "Pt", "Px")]
        [string]$units = "Inches"
    )
    Process {
        $ret = $value * 1000
        switch ($units) {
            "Inches" { return [Math]::Round($ret, 3) }
            "Cm" { return [Math]::Round($ret / 2.54, 3) }
            "Mm" { return [Math]::Round($ret / 25.4, 3) }
            "Pt" { return [Math]::Round($ret / 72, 3) }
            "Px" { return [Math]::Round($ret / 96, 3) }
        }
    }
}

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