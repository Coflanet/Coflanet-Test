[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$baseUrl = "https://repo1.maven.org/maven2/org/jetbrains/kotlin"
$destDir = "C:\Users\Administrator\Desktop\kotlin_deps"

New-Item -ItemType Directory -Force -Path $destDir | Out-Null

$files = @(
    "kotlin-gradle-plugin/1.9.23/kotlin-gradle-plugin-1.9.23.jar",
    "kotlin-compiler-embeddable/1.9.23/kotlin-compiler-embeddable-1.9.23.jar",
    "kotlin-stdlib/1.9.23/kotlin-stdlib-1.9.23.jar"
)

foreach ($file in $files) {
    $url = "$baseUrl/$file"
    $fileName = Split-Path $file -Leaf
    $destPath = "$destDir\$fileName"
    Write-Host "Downloading $fileName..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $destPath -UseBasicParsing
        Write-Host "Downloaded: $fileName"
    } catch {
        Write-Host "Failed: $fileName - $($_.Exception.Message)"
    }
}

Write-Host "Done!"
