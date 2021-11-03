# kurl
A new way to api!

# Introduction
The philosophy behind kurl is that it should be easy to call an JSON based API and collaborate with team members via version control.

## Why not Postman?
Postman requires that all of your rest calls be saved on their servers and does not work well with version control systems.

## Why not Httpie?
Httpie does not support the ingestion of a JSON based file to define the entire call, only the body.  This results in un-necessarily long command line calls.

# Features of Kurl
- All calls are stored in JSON format
- Variables can be injected into the requests to allow environment switching
- Silent Output can be piped as input to the next command (such as jq)
- Includes support for Authorization Bearer Tokens

# Installation
## Windows (Requires PowerShell)
1. Install jq via Chocolatey 
    ```
    choco install jq
    ```
1. Clone this repo to $HOME\bin 
   ```
   git clone https://github.com/stujfiter/kurl $HOME\bin\kurl
   ```
1. Setup an alias in Powershell 
   ```
   Add-Content -Path $profile -Value "`r`nSet-Alias -Name kurl -Value ""`$HOME\bin\kurl\kurl.ps1"""
   ```
1. Source the profile 
   ```
   . $profile
   ```

# Usage
```
kurl [-s] -f request_file.json `
[-e environment_file.json] `
[-v "KEY_1:value1","KEY_2:value2"] `
[-jwt $token] `

-f   Request template file in json format
-e   File of Environment Variables in json format (default ./env.json)
-v   Define additional variables "KEY_1:value1","KEY_2:value2"
     A variable set with -v will override one with the same name in 
     the environment variables file.
-jwt Set a Bearer token to use for Auth
-s   Supress Terminal Output and write the response body the pipeline
```