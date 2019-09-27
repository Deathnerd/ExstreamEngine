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
            "Inches" {
                return $ret
            }
            "Cm" {
                return $ret * 2.54
            }
            "Mm" {
                return $ret * 25.4
            }
            "Pt" {
                return $ret * 72
            }
            "Px" {
                return $ret * 96
            }
        }
    }
}