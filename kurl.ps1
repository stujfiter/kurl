#Requires -Version 7.0

param (
    [Parameter(Mandatory = $true)][string]$f,  # Request template file in json format
    [Parameter(Mandatory = $false)][string]$e, # File of Environment Variables in json format
    [Parameter(Mandatory = $false)][array]$v,  # Define additional variables "KEY_1:value1,KEY2:value2"
    [Parameter(Mandatory = $false)][switch]$c  # Colorizes Output (Requires jq)
)

# Make sure the request template file exists
if ( -not( Test-Path -Path $f -PathType Leaf ) ) {
    throw "File does not exist: ${f}"
}

$request = Get-Content -Raw -Encoding UTF-8 $f

$environment = @{}

# Read the environment variables file into a Hash Table
if ( $PSBoundParameters.ContainsKey('e') ) {
    $environment = Get-Content -Raw -Encoding UTF-8 $e | ConvertFrom-Json -AsHashTable
}

# Add any other environment variables specified with the -v switch
foreach ( $value in $v ) {
    $kv = $value.Split(":")
    $environment += @{ $kv[0] = $kv[1] } 
}

# Print out the current value of the environment variables
$environment | Out-String | Write-Host

# Inject environment variables into the request
foreach ( $var in $environment.GetEnumerator()) {
    $pattern = "`${{{0}}}" -f $var.key
    $request = $request -replace ([regex]::Escape($pattern)), $var.Value
}

$tokens = ConvertFrom-Json $request -AsHashtable

Write-Host $tokens."method" $tokens."url"

if ( $tokens."body") {
    if ( $PSBoundParameters.ContainsKey('c') ) {
        ConvertTo-Json -Depth 10 $tokens."body" | jq -C .
    }
    else {
        ConvertTo-Json -Depth 10 $tokens."body"
    }
}

$response = Invoke-WebRequest -Uri $tokens."url" `
    -Method $tokens."method" `
    -Body ($tokens."body" | ConvertTo-Json -Depth 10) `
    -ContentType "application/json" `
    -Authentication Bearer `
    -Token (ConvertTo-SecureString $global:token -asplaintext -force) `
    -AllowUnencryptedAuthentication

Write-Host
Write-Host StatusCode $response."StatusCode"

if ( $PSBoundParameters.ContainsKey('c') ) {
    Write-Output $response."Content" | jq -C .
}
else {
    Write-Output $response."Content" | ConvertFrom-Json | ConvertTo-Json -Depth 10
}