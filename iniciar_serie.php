<?php

  include 'encabezado.php';

  $titulo = $_POST["titulo"];

  if (strlen($titulo) == 0) {
    print "<p>Parametros incorrectos: <br>T&iacute;tulo: $titulo</p>";
  }
  else {

    $html = file_get_contents("estudios.php");

    $posicion = strpos($html, "<h2>");

    if ($posicion !== false) {

      $html = substr($html, 0, $posicion)
            . "<h2>" . htmlentities($titulo) . "</h2>\n\n"
            . "<ul>\n\n</ul>\n\n"
            . substr($html, $posicion);

      print "<h1>Resultados Crear Nueva Serie</h1>\n\n<p>Ver archivo <a href=\"estudios.php\">estudios.php</a>.</p>";

      file_put_contents("estudios.php", $html);

    }

  }

  print "<p><a href=\"herramientas.php\">Regresar a herramientas</a></p>";

  include 'pie.php';
  
?>
