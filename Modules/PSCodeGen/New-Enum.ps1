function New-Enum
{
    <#
    .Synopsis
        Creates a New enumerated type
    .Description
        Creates a new enumerated type from a list of strings or a dictionary of values
    .Example
        New-Enum "Foo" "a","b","c"
    .Example
        New-Enum "Foo" @{"a" = 1;"b" = 2;"c" = 4} -Namespace "Bar" -PassThru
    .Example
        New-Enum "Foo" @{1 = "a";2="b";4="c"} -Namespace "Baz" -OutputText
    .Parameter Name
        The name of the enumerated type
    .Parameter Namespace
        The namespace of the enumerated type
    .Parameter PassThru
        If set, the enumerated type will be outputted
    .Parameter OutputText
        If set, the source code for the enum will be outputted
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param(
        [Parameter(Position=0,
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]$Name,
        [Parameter(Position=2,
            ValueFromPipelineByPropertyName=$true)]
        [string]$Namespace,
        [Parameter(ParameterSetName='List',
            Position=1,
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$List,
        [Parameter(ParameterSetName='Value',
            Position=1,
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true
            )]
        [Hashtable]$Dictionary,
        [switch]$PassThru,
        [switch]$OutputText
    )
    
    Process {
        switch ($psCmdlet.ParameterSetName) {
            List {
                $oldofs = $ofs
                $ofs = "," + [Environment]::NewLine
                $enumText = "$list"
            }
            Value {
                $enumText = ""
                foreach ($kv in $dictionary.GetEnumerator()) {
                    $key  = $kv.Key
                    $value = $kv.Value -as [int]
                    if ($value -isnot [int]) {
                        $key = $kv.Value
                        $value = $kv.Key -as [int] 
                    }
                    $enumText += "
                    $key = $value,"
                }
                $enumText = $enumText.TrimEnd("," + [Environment]::NewLine)
            }
        }
        $text = "
            public enum $name {
                $enumText
            }"
        if ($namespace) {
            $text = "
        namespace $namespace {
            $text
        }"
        }
        if ($outputText) { return $text } 
        Add-Type $text -PassThru:$passThru
    }
    
}