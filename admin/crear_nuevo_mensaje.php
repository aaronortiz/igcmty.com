<?php


  include_once("../Data/MySQL.php");

  $_SESSION["Username"] = "aeortizc_aeortiz";
  $_SESSION["Password"] = "WhoAmI76";
  
  $id_serie    = $_POST["serie"];
  $Titulo      = utf8_decode($_POST["titulo"]);
  $Resumen     = utf8_decode($_POST["resumen"]);
  $IdExpositor = $_POST["id_expositor"];
  $Claves      = utf8_decode($_POST["claves"]);
  $Dia         = $_POST["dia"];
  $Mes         = $_POST["mes"];
  $Anio        = $_POST["anio"];
  $MP3         = $_POST["MP3"];

  $rsMax = Recordset("SELECT MAX(id_mensaje) as id_mensaje FROM mensajes");
  $id_mensaje = $rsMax[0]["id_mensaje"] + 1;

  $rsMax = Recordset("SELECT MAX(id_medio) as id_medio FROM medios");
  $id_medio = $rsMax[0]["id_medio"] + 1;

  
  if (!empty($Titulo)) {
  
    if (!empty($Dia) && !empty($Mes) && !empty($Anio)){
      $Fecha = sprintf("%04d-%02d-%02d", $Anio, $Mes, $Dia);
    }
  
    $SQL = "INSERT INTO mensajes VALUES( $id_mensaje, $id_serie, '$Titulo', '$Resumen', $IdExpositor, '$Claves', '$Fecha')";
    Execute($SQL);
    
    if(!empty($MP3)){
      $SQL = "INSERT INTO medios VALUES ( $id_medio, '', 1)";
      Execute($SQL);
    
      $SQL = "INSERT INTO mensajes_medios VALUES ($id_mensaje, $id_medio)";
      Execute($SQL);

      $SQL = "INSERT INTO medios_audio VALUES ($id_medio, '$MP3', '00:00:00', 0)";    
      Execute($SQL);
    }
  }
  
  if(ExisteRegistro("mensajes", "id_mensaje", $id_mensaje)) {

    include 'encabezado.php';
  
    print "<html>\n" .
  
          "<div id=\"texto\">" .
          "  <div id=\"encabezado\"></div>" .
  
          "  <head><title>Registro creado exitosamente</title></head>\n" .
          "  <body><h1>Resultados</h1>\n" .
          "    <p>Mensaje $id_mensaje, " . htmlentities("$Titulo: $MP3") . " <br>\n" .
          "     creada con &eacute;xito.</p>\n" . 
          "    <p><a href=\"http://www.grancomision.org.mx/herramientas.php\">Regresar</a></p>\n" .
          "  <div id=\"pie\"></div>" .
          "  </div>" .
          "</body></html>";
          
    include 'pie.php';
  
  }
  
?>