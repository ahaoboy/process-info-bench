# Define paths
$vsDevCmd = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
$tempEnvFile = "$env:TEMP\env_vars.txt"

# Create output directory
New-Item -ItemType Directory -Force -Path .\dist

# Run VsDevCmd.bat and capture environment variables
cmd.exe /c "`"$vsDevCmd`" -arch=x86 && set > $tempEnvFile"

# Import environment variables into PowerShell
Get-Content $tempEnvFile | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        if ($name -eq "PATH") {
            # Append to PATH without overwriting
            $env:PATH = "$env:PATH;$value"
        } else {
            # Set other environment variables
            Set-Item -Path "env:$name" -Value $value
        }
    }
}

# Clean up temporary file
Remove-Item $tempEnvFile -ErrorAction SilentlyContinue

# Run cl.exe
cl /nologo .\c\main.c /O2 /Fo.\dist\ /Fe.\dist\msvc.exe /link /nologo /LTCG /OPT:REF /OPT:ICF