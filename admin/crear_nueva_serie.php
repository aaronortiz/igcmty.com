<?php


  include_once("../Data/MySQL.php");

  $_SESSION["Username"] = "aeortizc_aeortiz";
  $_SESSION["Password"] = "WhoAmI76";
  
  $Serie = utf8_decode($_POST["titulo"]);
  $Descripcion = utf8_decode($_POST["descripcion"]);
  
  if (!empty($Serie)) {
  
    $SQL = "INSERT INTO series(serie, descripcion VALUES( '$Serie', '$Descripcion')";
    Execute($SQL);
  
  }
  
  if(ExisteRegistro("series", "id_serie", $id_serie)) {

    include 'encabezado.php';
  
    print "<html>\n" .
  
          "<div id=\"texto\">" .
          "  <div id=\"encabezado\"></div>" .
  
          "  <head><title>Registro creado exitosamente</title></head>\n" .
          "  <body><h1>Resultados</h1>\n" .
          "    <p>Serie $id_serie, " . htmlentities($Serie) . 
          ": " . htmlentities($Descripcion) . " <br>\n" .
          "     creada con &eacute;xito.</p>\n" . 
          "    <p><a href=\"http://www.grancomision.org.mx/herramientas.php\">Regresar</a></p>\n" .

          "  <div id=\"pie\"></div>" .
          "  </div>" .
          "</body></html>";
          
    include 'pie.php';
  
  }
  
?>