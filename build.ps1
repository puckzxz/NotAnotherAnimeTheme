$root = $PSScriptRoot

$wc = New-Object System.Net.WebClient

if (!(Test-Path "$root\minify.exe"))
{
    $minifyRepo = "tdewolff/minify"

    $minifyReleases = "https://api.github.com/repos/$minifyRepo/releases"

    $minifyTag = (Invoke-WebRequest $minifyReleases -UseBasicParsing | ConvertFrom-Json)[0].tag_name

    $minifyDownloadURL = "https://github.com/$minifyRepo/releases/download/$minifyTag/minify_windows_amd64.zip"

    $wc.DownloadFile($minifyDownloadURL, "$root\minify.zip")

    New-Item -ItemType Directory -Path $root\temp

    Expand-Archive -Path "$root\minify.zip" -Destination "$root\temp"

    Copy-Item -Path "$root\temp\minify.exe" -Destination "$root"

    Remove-Item -Path "$root\minify.zip"

    Get-ChildItem -Path "$root\temp" -Recurse | Remove-Item -force -recurse

    Remove-Item "$root\temp" -Force 
}

Start-Process -Wait -FilePath ".\minify.exe" -ArgumentList "-r -o .\build\ .\css\v3\"