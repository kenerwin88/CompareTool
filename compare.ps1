# $services = 'ALRoot, AngiesList, B2BInternalAPI, BusinessCenter, BusinessCenterAPI, FileManager, Finance, Join, MailMadeSimple, PaymentAuthorization, TheBigDeal, Tools, Ubermail, VaultGuard, Visitor, WebAPI, WebHandlers'

# List of variables
$version = "221.00.00.06"
$packageLocation = "E:\DeploymentPackages\"
$comparison01 = 'Package'
$comparison02 = 'Production'
$filesToCompare = 'application.config','entlib.config','keyvaluestore.config','web.config'
$apps = import-csv 'applications.csv' | Select Application, $comparison01, $comparison02

$html = '<html>
<head>
<title>Config Compare Tool</title></head>
<body style="font-family: Calibri, Candara, Segoe, "Segoe UI", Optima, Arial, sans-serif;">
<center>
<div id="spaceship" style="text-align: left; margin: 0 auto; width: 100px;">
<PRE><B>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp; .--.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; / /&nbsp; `
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ \__,
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +&nbsp;&nbsp; `--`&nbsp; *
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +&nbsp;&nbsp; /\
&nbsp;&nbsp;&nbsp; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .`&nbsp; `.&nbsp;&nbsp; *
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /======\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;:.&nbsp; _&nbsp;&nbsp; ;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |:. (_)&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |:.&nbsp; _&nbsp;&nbsp; |
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |:. (_)&nbsp; |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;:.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .` \:.&nbsp;&nbsp;&nbsp; / `.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; / .-``:._.``-. \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |/&nbsp;&nbsp;&nbsp; /||\&nbsp;&nbsp;&nbsp; \|
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     _..--"""````"""--.._
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _.-```&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ```-._
&nbsp;&nbsp;&nbsp; -`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `-</B></PRE></div>
<br/>
<h1>Config Compare Tool</h1>'
$html = $html + '<h2>Comparing ',$comparison01,' with ',$comparison02,' (Version: ',$version,')</h2>'
foreach ($application in $apps) {
    $html = $html + '<hr/><b>',$application.Application,'</b><br/>'
    $appConfig = $application.Application + ".config" # Application name and add .config to it
    $allFilesToCompare = $filesToCompare + $appconfig # We're going to look for all the normal files, PLUS compare the applicationname.config if it exists!
    if ($application.Package -eq 'JAMS') {$path = $packageLocation + $version + "\JAMS\" + $application.Application}
        else {$path = $packageLocation + $version + "\" + $application.Application}
        write-host "PACKAGEPATH:"$path
        $path2 = $application.$comparison02
        write-host "COMPAREPATH:"$path2

    if (!(test-path -path $path)) {
        
            if($comparison01 -eq 'Package') {
                $html = $html + '<span style="color:blue"><b>',$path,'not included in package</b></span><br/>'
            }
            else {
                if ($path -eq 'NA') {
                $html = $html + '<span style="color:blue"><b>',$path,', not applicable on ',$comparison01,'</b></span><br/>'
                }
                else {
                $html = $html + '<span style="color:red"><b>COULD NOT CONNECT/FIND ',$path,' on ',$comparison01,'</b></span><br/>'
                }
            }
        }
        if (!(test-path -path $path2)) {
            if($comparison02 -eq 'Package') {
                $html = $html + '<span style="color:blue"><b>',$path2,', not included in package</b></span><br/>'
            }
            else {
                if ($path2 -eq 'NA') {
                $html = $html + '<span style="color:blue"><b>',$path2,', not applicable on ',$comparison02,'</b></span><br/>'
                }
                else {
                $html = $html + '<span style="color:red"><b>COULD NOT CONNECT/FIND ',$path2,' on ',$comparison02,'</b></span><br/>'
                }
            }
        }
    foreach ($fileName in $allFilesToCompare) {
        
        #Path Validation
        $p1 = $path + "\" + $fileName
        $p2 = $path2 + "\" + $fileName
        $path1exists = test-path -path $p1
        $path2exists = test-path -path $p2
        
        if ($path1exists -and $path2exists) {
            
            $first = .\diff.exe $p1 $p2 --unchanged-line-format="" --old-line-format="$comparison01 - %dn: %L" --new-line-format="$comparison02 - %dn: %L"
            if ($first) {
            $html = $html + '<p>',$fileName,'</p><textarea readonly="true" style="border: none; background-color:white; font-family: Courier New, Courier, monospace"; rows="20" cols="150">'
            $OFS = "`r`n"
            $html = $html + $first
            $html = $html + '</textarea>'
            }
            else {
                $html = $html + '<span style="color: green"><b>',$fileName,' is identical between ',$comparison01,' and ',$comparison02,'.</b></span><br/>'
            }
            
        }
        if ($path1exists -xor $path2exists) {
            if (test-path -path $path) {$html = $html + '<b><span style="color: red">',$fileName,' only found on ',$comparison01,'</b></span><br/>'}
            else {$html = $html + '<b><span style="color: red">',$fileName,' only found on ',$comparison02,'</b></span><br/>'}
        }
        else {
            #Skip, it wasn't in either package.
        }        
    }
    
}
$html = $html + '</div></center>
    </body>
    <html>'
$html > differences.html
invoke-item differences.html