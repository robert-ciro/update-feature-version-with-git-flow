Write-Host "Updating master:`n" -ForegroundColor Green -BackgroundColor Black 
git pull origin master

Write-Host "`nUpdating develop:`n" -ForegroundColor Green -BackgroundColor Black 
git pull origin develop

$lastTag = git tag --sort=-creatordate | Select-Object -First 1
Write-Host "`nLast version $($lastTag)" -ForegroundColor Green -BackgroundColor Black

$versionComponents = $lastTag.Split('.')
$versionComponents[1] = [int]$versionComponents[1] + 1
$newTag = $versionComponents -join '.'

Write-Host "`nNew version $($newTag)`n" -ForegroundColor Green -BackgroundColor Black

$answer = $(Write-Host "Please enter 'yes' to accept the new version or provide your own version:" -ForegroundColor Green -BackgroundColor Black; Read-Host) 

if($answer -ne "yes" -and $answer -ne "")
{
    $newTag = $answer
}

git flow release start $newTag
git flow release finish $newTag -m "release/$($newTag)"

Write-Host "`nPushing to develop and master:`n" -ForegroundColor Green -BackgroundColor Black

git push origin develop
git push origin master