<?php

  $Subtitulo = "Mensajes";
  include 'encabezado.php';
  include 'listar_estudios.php';

?>

  <div id="mensajes">
  <div id="encabezado_oscuro"></div>
  
  <h1 class="dark_head">Mensajes en video y audio</h1>

  <div id="vimeo_screen"><?php 
  
    if (isset($_GET["id_serie"]) && isset($_GET["id_mensaje"])) {
      print($Series[$_GET["id_serie"]]["conferencias"][$_GET["id_mensaje"]]["video_embed"]);
    } else {
      print($DefaultVideoEmbed);
    }
    
  ?></div>
  
  <div id="message_list">

<?php

    $Count = 0;
    
    $SeriesReversa = array_reverse($Series, true);
    
    if (count($SeriesReversa) > 0) {?>
      <table><?php    
      
      foreach($SeriesReversa as $SerieId => $Serie) {
        if ($Serie["contador_medios"] > 0) { 
        $Count++;
        $Toggle = ($Count % 2 == 0) ? "even" : "odd";
?>


        <?php print("<tr class=\"$Toggle\">"); ?><td colspan="3" class="serie">.<?php print($Serie["titulo"]); ?></td></tr><?php
        
          foreach ($Serie["conferencias"] as $Conferencia) {

            if ($Conferencia["contador_medios"] > 0) {
              $Count++;
              $Toggle = ($Count % 2 == 0) ? "even" : "odd";

?>

        <?php print("<tr class=\"$Toggle\">"); ?><td class="conferencia"><?php print($Conferencia["titulo"]); ?></td>
            <td class="MP3"><?php
                       
              if (strlen($Conferencia["MP3"])>0) { 
                print("<a href=\"" . $Conferencia["MP3"] . "\" target=\"new\">O&iacute;r</a>"); 
              } else {
                print("&nbsp;");
              } 
?></td>
           <td class="Video"><?php 

              if (strlen($Conferencia["video_embed"])>0) { 
 
                print("<a href=\"" . $_SERVER["PHP_SELF"] . "?id_serie=" . $SerieId .
                      "&id_mensaje=" . $Conferencia["id_mensaje"] . "\">Ver</a>"); 
              } else {
                print("&nbsp;");
              } 
            }
?></td></tr><?php
              
          } // foreach
        } // end if (count($Serie["conferencias"])
      } // end for $Series ?>
      
      </table>
<?php      
    } // end if count($Series) > 0

?>

    </div> <!--Message list -->
	
	  <div id="rss_section">
	    <p>Suscr&iacute;bete para recibir una notificaci&oacute;n cada vez que subimos un nuevo mensaje.</p> 
	    <p>Puedes subscribirte por <b>correo electr&oacute;nico</b> (<a href="http://feedburner.google.com/fb/a/mailverify?uri=igcmty_audio&amp;loc=es_ES" target="_blank">audio</a>/<a href="http://feedburner.google.com/fb/a/mailverify?uri=igcmty_video&amp;loc=es_ES" target="_blank">video</a>), por lector de <b>RSS</b> (<a href="http://feeds.feedburner.com/igcmty_audio" target="_blank">audio</a>/<a href="http://feeds.feedburner.com/igcmty_video" target="_blank">video</a>) o podcast de <b>iTunes</b> (<a class="podcast" href="http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=388802785">audio</a>).</p>
	  </div>
		
  </div>

  
  <div id="pie_oscuro"></div>
		
<?php

  include 'pie.php';

?>