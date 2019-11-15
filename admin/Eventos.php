<?php

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well
  
  include_once("../Presentation/cls_RecordBrowser.php");
    
  include("RecordBrowserHeader.php");
    
  $Title    = "Eventos";
  $Fields   = array("titulo_evento", "subtitulo_evento", "fecha");
  $Headings = array("Título", "Subtítulo", "Fecha");
  
  $RecordBrowser = new RecordBrowser($Title,
                                     "Evento.php",
                                     "id_evento",
                                     $Fields,
                                     $Headings,
                                     "FROM eventos",
                                     $WhereClause,
                                     'ORDER BY fecha DESC');
  
  print $RecordBrowser->GenerateHTML();  

?>


