<?php

  include("data/MySQL.php");
  include("listar_estudios.php");

  session_start();
  
  $_SESSION["Username"] = "aeortizc_aeortiz";
  $_SESSION["Password"] = "WhoAmI76";
  
  $SQL = "";
  
  foreach($Series as $IdSerie => $Serie) {
    $Titulo = $Serie["titulo"];
    $SQL = "INSERT INTO series VALUES($IdSerie, '$Titulo', '')";  
    print("<p>$SQL</p>\n");
  }
  
  
?>