<?php

  session_start();
  
  if (!(isset($_SESSION["Username"]) && isset($_SESSION["Password"]))) {
      header('location:../Login.php');
  } else {
  
    include_once("../Presentation/cls_RecordBrowser.php");
    
    include("RecordBrowserHeader.php");
    
    $Title    = "Mensajes";
    $Fields   = array("mensaje", "serie", "expositor");
    $Headings = array("Mensaje", "Serie", "Expositor");
  
    $RecordBrowser = new RecordBrowser($Title,
                                       "Mensaje.php",
                                       "id_mensaje",
                                       $Fields,
                                       $Headings,
                                       "FROM v_mensajes",
                                       $WhereClause,
                                       'ORDER BY fecha DESC');
  
    print $RecordBrowser->GenerateHTML();  
    
  }

?>


