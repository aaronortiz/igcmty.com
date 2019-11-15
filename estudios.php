<?php

  header("location: mensajes.php");

  $Subtitulo = "Mensajes";
  include 'encabezado.php';

?>

  <div id="texto">
  <div id="encabezado"></div>

    <img src="img/mensajes.jpg" alt="Mensaje" width="780" height="480">

<h1>Mensajes</h1>

<?php

    include 'listar_estudios.php';
    
    $SeriesReversa = array_reverse($Series, true);
    
    if (count($SeriesReversa) > 0) {
      foreach($SeriesReversa as $SerieId => $Serie) {
        if (count($Serie["conferencias"]) > 0) {
          print "<h2>" . $Serie["titulo"] . "</h2>\n" .
                "<ul>\n";
          
          foreach ($Serie["conferencias"] as $Conferencia) {
            if (strlen($Conferencia["MP3"])>0) {
              print "  <li>" . date("d/m/Y", strtotime($Conferencia["fecha"])) . ", esc&uacute;chalo en MP3: &ldquo;<a href=\"" . $Conferencia["MP3"] . "\" target=\"new\">" . 
                    $Conferencia["titulo"] . "</a>&rdquo;</li>\n";
            } elseif (strlen($Conferencia["fecha"])>0) {
              print "  <li>" . date("d/m/Y", strtotime($Conferencia["fecha"])) . ", " .
                $Conferencia["titulo"] . "</li>\n";
            } else {
              print "  <li>" . $Conferencia["titulo"] . "</li>\n";            
            } // if     
          } // foreach
          print "</ul>\n\n";
        } // end if (count($Serie["conferencias"])
      } // end for $Series
    } // end if count($Series) > 0

?>
		
  <div id="pie"></div>
  </div>
		
<?php

  include 'pie.php';

?>