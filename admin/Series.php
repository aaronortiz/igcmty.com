<?php

  session_start();
  
  if (!(isset($_SESSION["Username"]) && isset($_SESSION["Password"]))) {
      header('location:../Login.php');
  } else {
  
    include_once("../Presentation/cls_RecordBrowser.php");
    
    include("RecordBrowserHeader.php");
    
    $Title    = "Series";
    $Fields   = array("serie");
    $Headings = array("Serie");
  
    $RecordBrowser = new RecordBrowser($Title,
                                       "Serie.php",
                                       "id_serie",
                                       $Fields,
                                       $Headings,
                                       "FROM series",
                                       $WhereClause,
                                       'ORDER BY id_serie DESC');
  
    print $RecordBrowser->GenerateHTML();  
    
  }

?>


