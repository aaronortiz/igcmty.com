<?php

  session_start();
  
  if (!(isset($_SESSION["Username"]) && isset($_SESSION["Password"]))) {
      header('location:../Login.php');
  } else {
  
    include_once("../Presentation/cls_RecordBrowser.php");
    
    include("RecordBrowserHeader.php");
    
    $Title    = "Expositores";
    $Fields   = array("nombres", "apellidos");
    $Headings = array("Nombres", "Apellidos");
  
    $RecordBrowser = new RecordBrowser($Title,
                                       "Expositor.php",
                                       "id_expositor",
                                       $Fields,
                                       $Headings,
                                       "FROM expositores",
                                       $WhereClause,
                                       'ORDER BY apellidos, nombres ASC');
  
    print $RecordBrowser->GenerateHTML();  
    
  }

?>


