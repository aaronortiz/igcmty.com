<?php

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well
  
  include_once("../Presentation/cls_RecordBrowser.php");
    
    include("RecordBrowserHeader.php");
    
    $Title    = "Líderes de Grupo";
    $Fields   = array("nombres", "apellidos", "telefono", "email");
    $Headings = array("Nombres", "Apellidos", "Teléfono", "email");
  
    $RecordBrowser = new RecordBrowser($Title,
                                       "LiderGrupo.php",
                                       "id_lider_grupo",
                                       $Fields,
                                       $Headings,
                                       "FROM grupos_lideres",
                                       $WhereClause,
                                       'ORDER BY apellidos, nombres ASC');
  
    print $RecordBrowser->GenerateHTML();  

?>


