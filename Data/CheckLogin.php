<?php

  include_once("MySQL.php");
  
//============================================================================//
// This is designed as an INCLUDE file
//----------------------------------------------------------------------------//
// Purpose: To kick out any intruders who haven't logged in
//============================================================================//

  session_start();

//  $WebRoot = str_repeat("../", (substr_count(str_replace($_SERVER['DOCUMENT_ROOT'], "", $_SERVER['SCRIPT_FILENAME']), '/') ));

//  die("Webroot: $WebRoot<br>\nDocroot: " . $_SERVER['DOCUMENT_ROOT'] . "<br>\nScript: " . $_SERVER['SCRIPT_FILENAME']);

  // Detect crappy browsers
  if(preg_match("/MSIE/", $_SERVER["HTTP_USER_AGENT"], $MatchesIE))
    $_SESSION["MSIE"] = true;
  else 
    unset($_SESSION["MSIE"]);

  // If the cookies are not set, LEAVE!
  if (!isset($_SESSION["Username"])) {
     //header("location: $WebRoot" . "AA/Login.php");
     header("location: ../Login.php");
     exit;
  }


?>
