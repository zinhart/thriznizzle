<#
git clone --bare 
git push --mirror https://github.com/yourusername/private-repo.git
git clone https://github.com/yourusername/private-repo.git
cd private-repo
git submodule add https://github.com/originaluser/public-repo.git path/to/submodule
git submodule update --init --recursive
git add .
git commit -m "Added public repository as a submodule"
git push origin main
#>

param (
    [string]$publicRepoUrl,  # URL of the public repository to fork as a submodule
    ##[string]$privateRepoName, # Name of the private repository
    ##[string]$privateRepoPath, # Local path to clone the private repository
    [string]$githubUsername  # Your GitHub username
#    [string]$githubToken      # Your GitHub Personal Access Token
)

# Check if all required parameters are provided
if (-not $publicRepoUrl <#-or -not $privateRepoName -or -not $privateRepoPath#> -or -not $githubUsername <#-or -not $githubToken#>) {
    #write-host "please provide all the required parameters: publicrepourl, privatereponame, privaterepopath, githubusername, and githubtoken."
    write-host "please provide all the required parameters: publicrepourl, githubusername."
    Write-Host "Add-PublicRepoAsSubmodule.ps1 -publicrepourl https://github.com/user/repo.git -githubusername zinhart"
    exit 1
}

# Extract the public repository name from the URL
$publicRepoName = ($publicRepoUrl -split '/')[(-1)]
$publicRepoName = $publicRepoName -replace '.git$', '' # Remove the .git suffix if present



<#
# Step 1: Create a Private Repository on GitHub using the GitHub API
$createRepoUrl = "https://api.github.com/user/repos"
$repoData = @{
    name = $privateRepoName
    private = $true
} | ConvertTo-Json

$headers = @{
    Authorization = "token $githubToken"
    Accept        = "application/vnd.github.v3+json"
    User-Agent    = "Powershell"
}

$response = Invoke-RestMethod -Uri $createRepoUrl -Method Post -Headers $headers -Body $repoData

if ($response -and $response.full_name) {
    Write-Host "Private repository '$($response.full_name)' created successfully."
} else {
    Write-Host "Failed to create private repository."
    exit 1
}

# Step 2: Clone the Private Repository Locally
$cloneUrl = "https://$githubUsername:$githubToken@github.com/$githubUsername/$privateRepoName.git"
git clone $cloneUrl $privateRepoPath

# Step 3: Navigate to the Repository Directory
Set-Location $privateRepoPath
#>
# Step 4: Add the Public Repository as a Submodule
#$submodulePath = "submodule" # Change this if you want to use a different path
git submodule add $publicRepoUrl $publicRepoName

# Step 5: Initialize and Update the Submodule
git submodule update --init --recursive

# Step 6: Commit the Changes and Push to GitHub
git add .
git commit -m "Added $publicRepoName as a submodule"
git push origin main

Write-Host "Public repository '$publicRepoName' added as a submodule and pushed to the private repository."