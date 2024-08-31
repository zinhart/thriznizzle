param (
    [string]$githubUsername,    # Your GitHub username
    [string]$githubToken,       # Your GitHub Personal Access Token
    [string[]]$repositories     # Array of repository names to delete
)

# Check if all required parameters are provided
if (-not $githubUsername -or -not $githubToken -or -not $repositories) {
    Write-Host "Please provide all the required parameters: githubUsername, githubToken, and repositories."
    exit 1
}

# Base URL for GitHub API
$apiBaseUrl = "https://api.github.com/repos"

# Headers for authentication
$headers = @{
    Authorization = "token $githubToken"
    Accept        = "application/vnd.github.v3+json"
    User-Agent    = "Powershell"
}

# Iterate through each repository and delete it
foreach ($repo in $repositories) {
    $repoUrl = "$apiBaseUrl/$githubUsername/$repo"

    try {
        # Send DELETE request to delete the repository
        $response = Invoke-RestMethod -Uri $repoUrl -Method Delete -Headers $headers
        
        Write-Host "Repository '$repo' deleted successfully."
    }
    catch {
        Write-Host "Failed to delete repository '$repo': $($_.Exception.Message)"
    }
}

# .\Delete-GitHubRepos.ps1 -githubUsername "yourusername" -githubToken "your_github_personal_access_token" -repositories "repo1", "repo2", "repo3"
