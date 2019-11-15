Site remediated by <a href="http://sucuri.net">Sucuri</a><br />
This script will clean the malware from this attack:
<a href="http://sucuri.net/malware/entry/MW:MROBH:1">http://sucuri.net/malware/entry/MW:MROBH:1</a>
<br />
<br />
If you need help, contact support@sucuri.net or visit us at <a href="http://sucuri.net/">
Sucuri.net</a>
<br />
<br />
<?php
set_time_limit(0);

$dir = "./";

$rmcode = `find $dir -name "*.php" -type f |xargs sed -i 's#<?php /\*\*/ eval(base64_decode("aWY.*?>##g' 2>&1`;
echo "Malware removed.<br />\n";
$emptyline = `find $dir -name "*.php" -type f | xargs sed -i '/./,$!d' 2>&1`;
echo "Empty lines removed.<br />\n";
?>
<br />
Completed.

