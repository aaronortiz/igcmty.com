<?php

  include 'encabezado.php';

  print "  <div id=\"texto\">\n  <div id=\"encabezado\"></div>";

  $titulo = $_POST["titulo"];
  $urlm3u = $_POST["URLM3U"];

  print "<h1>Resultados de enlace</h1>";

  if (strlen($titulo) == 0 || strlen($urlm3u) == 0) {
    print "<p>Parametros incorrectos: <br>T&iacute;tulo: $titulo<br>URL M3U: $urlm3u</p>";
  }
  else {

    print "<p>Copia y pega el siguiente c&oacute;digo en el archivo estudios.php</p>";

    print "<form><textarea rows=\"3\" cols=\"50\"><li>" . htmlentities(htmlentities($titulo)) . " (<a href=\"$urlm3u\">MP3</a>)</li></textarea></form>";

  }

  print "<p><a href=\"herramientas.php\">Regresar a herramientas</a></p>";

  print "  <div id=\"pie\"></div>\n  </div>";

  include 'pie.php';
  
?>
