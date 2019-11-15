<?php

  include 'encabezado.php';

  $titulo          = $_POST["titulo"];
  $archivo         = $_POST["archivo"];
  $year            = $_POST["year"];
  $month           = $_POST["month"];
  $ind_nueva_serie = $_POST["ind_nueva_serie"];
  $serie           = $_POST["serie"];

/*
  if (strlen($titulo) == 0 || strlen($archivo) == 0 || (!is_numeric($year)) || (!is_numeric($month)) || $month < 1 || $month > 12 || (ind_nueva_serie = true && strlen($serie) == 0)) { */
    print "<p>Parametros incorrectos: <br>" . 
          "T&iacute;tulo: $titulo<br>\n" .
          "Archivo: $archivo<br>\n" .
          "A&ntilde;o: $year<br>\n" .
          "Mes: $month<br>\n" .
          "Indicador Nueva Serie: $ind_nueva_serie<br>\n" .
          "Serie: $serie<br>\n" .
          "</p>" ;
/*  }
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

  }*/

  print "<p><a href=\"herramientas.php\">Regresar a herramientas</a></p>";

  include 'pie.php';
  
?>
