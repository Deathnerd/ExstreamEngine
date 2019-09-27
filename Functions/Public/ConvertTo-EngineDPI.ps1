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
            "Inches" {
                return [Math]::Round($ret, 3)
            }
            "Cm" {
                return [Math]::Round($ret / 2.54, 3)
            }
            "Mm" {
                return [Math]::Round($ret / 25.4, 3)
            }
            "Pt" {
                return [Math]::Round($ret / 72, 3)
            }
            "Px" {
                return [Math]::Round($ret / 96, 3)
            }
        }
    }
}