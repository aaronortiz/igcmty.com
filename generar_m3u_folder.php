<?php

  include 'encabezado.php';

  $Domain     = "www.grancomision.org.mx";
  $CpanelUser = "aeortizc";
  $SubFolder  = "igcmty/";

  print "  <div id=\"texto\">\n  <div id=\"encabezado\"></div>";

  $year  = $_POST["year"];
  $month = $_POST["month"]; 

  print "<h1>Resultados de enlace</h1>";

  if ( strlen($year)==0 || strlen($month) == 0 || !is_numeric($year) || !is_numeric($month)) {
    print "Parametros incorrectos: <br>A&ntilde;o: $year<br>Mes: $month";
  }
  else {
    $folder = "/home/$CpanelUser/public_html/" . $SubFolder . "conferencias/$year$month/";
    $Handle = opendir($folder);

    while ($archivo = readdir($Handle)) {

      if (is_file($folder . "/" . $archivo)) {
        $largo_nombre = strlen($archivo);
        $extension = substr($archivo, $largo_nombre-3);

        switch (strtolower($extension)) {
        case "m3u": case "bak":
          unlink ($folder . "/" . $archivo);
          break;

        case "mp3":
          $data = "http://$Domain/conferencias/$year$month/$archivo\n";
          $data = str_replace(" ", "%20", $data);
          $data = str_replace("ñ", "%f1", $data);
          $m3ufile = $folder . substr($archivo, 0, largo_nombre-4) . ".m3u";

          print "<p>Archivo $m3ufile.</p>";

          $filepointer = fopen($m3ufile, "w");
          fwrite($filepointer, $data);
          fclose($filepointer);

          break;

        default:

        }

      }

    }

    closedir($Handle);

    print "<p>Folder: $folder</p>";

    print "<p><a href=\"herramientas.php\">Regresar a herramientas</a></p>";
 
  }
  
  print "  <div id=\"pie\"></div>\n  </div>";

  include 'pie.php';
  
?>
