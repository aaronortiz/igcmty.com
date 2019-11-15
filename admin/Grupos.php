<?php

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well
  
  include_once("../Presentation/cls_RecordBrowser.php");
    
  include("RecordBrowserHeader.php");
    
  $Title    = "Grupos";
  $Fields   = array("nombre", "lider_grupo");
  $Headings = array("Nombre", "Líder");
  
  $RecordBrowser = new RecordBrowser($Title,
                                     "Grupo.php",
                                     "id_grupo",
                                     $Fields,
                                     $Headings,
                                     "FROM v_grupos",
                                     $WhereClause,
                                     'ORDER BY nombre, apellidos, nombres DESC');
  
  print $RecordBrowser->GenerateHTML();  

?>


