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
- PowerShell and bash are both supported. 