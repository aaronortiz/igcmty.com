<?php

  include("MySQL.php");

  session_start();

  // Clean up any previous errors
  unset($_SESSION["Errors"]);

  if (preg_match("/^\w{6,32}$/", $_POST["Username"], $MatchesU) && 
      preg_match("/^[\w@.,;\:\-_?<>]{6,32}$/", $_POST["Password"], $MatchesP)) {
    
    if (Login($MatchesU[0], $MatchesP[0])) { 
    
//    if (Login($_POST["Username"], $_POST["Password"])) {

    	
      // Set the session variables
      $_SESSION["Username"] = $MatchesU[0];
      $_SESSION["Password"] = $MatchesP[0];
      
      // Detect crappy browsers
      if(preg_match("/MSIE/", $_SERVER["HTTP_USER_AGENT"], $MatchesIE))
        $_SESSION["MSIE"] = true;
      else 
        unset($_SESSION["MSIE"]);

      header ("location: ../admin/index.php");

    }
    else {

      // Register the bad login
      $_SESSION["Errors"]["BadLogin"] = 1;

      // Keep the user in the login script
      header ("location: ../Login.php");
      exit;
    }
  }
  else {
      
    // Register the bad format
    $_SESSION["Errors"]["BadFormat"] = 1;
        	    
    // Keep the user in the login script
    header ("location: ../Login.php");
    exit;
  }

?>
