param (
    [string]$action,
    [PSCredential]$password
)

# Set t1 password in environment variable
function Set-Password {
    param (
        [string]$variableName,
        [string]$promptMessage = "Enter password"
    )

    # Prompt for t1 password
    $password = Read-Host -Prompt $promptMessage

    # Store t1 password in the environment variable
    [System.Environment]::SetEnvironmentVariable($variableName, $password, [System.EnvironmentVariableTarget]::User)

    Write-Host "Password set successfully for variable '$variableName'."
}

# Get t1 password from environment variable
function Get-Password {
    param (
        [string]$variableName
    )

    # Retrieve t1 password from the environment variable
    $password = [System.Environment]::GetEnvironmentVariable($variableName, [System.EnvironmentVariableTarget]::User)

    if (-not $password) {
        Write-Host "T1 Password is not set for '$variableName'."
        return
    }

    return $password
}

# Main script logic
switch ($action) {
    "set" {
        Set-Password -variableName "t1"
        Write-Output "Type t1 in any Powershell prompt to retrieve t1 password"
    }
    "get" {
        $retrievedPassword = Get-Password -variableName "t1"

        if ($retrievedPassword) {
            Write-Output $retrievedPassword
        }
    }
    default {
        Get-Password -variableName "t1"
    }
}

# Get the current script location
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define the alias and script name
$aliasName = "t1"
$scriptName = "tone.ps1"

# Create the full path to the script
$scriptPath = Join-Path -Path $scriptDirectory -ChildPath $scriptName

# Check if the alias already exists
if (-not (Get-Alias $aliasName -ErrorAction SilentlyContinue)) {
    # Create an alias for the script
    New-Alias -Name $aliasName -Value $scriptPath

    # Append alias creation to the user's profile (to make it persistent)
    Add-Content -Path $PROFILE -Value "New-Alias -Name $aliasName -Value $scriptPath"
}
