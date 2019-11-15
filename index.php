<?php

  include 'encabezado.php';

?>
  <div id="content">
    <div id="texto">
      <div id="encabezado"></div>
          
        <?php include 'serie.php'; ?>
      
        <!--h1 class="clickhead">Dios y t&uacute;&hellip;&iquest; hacen &ldquo;click&rdquo;?</h1-->
   
        <div id="multiplica_multiplicadores">
        
           <a href="http://multiplica.igcla.com/"><img src="img/multiplica-multiplicadores.jpg" alt="Multiplica Multiplicadores"></a>
        
        </div>
   
        <div id="proyecto_andres">
        
          <a href="buenanoticia.php" class="buena_noticia" title="La buena noticia">&nbsp;</a>
          <a href="contacto.php" class="contacto" title="Con&eacute;ctate">&nbsp;</a>
          <a href="grupos.php" class="grupos" title="Crece">&nbsp;</a>
                
        </div>     

      <div id="pie"></div>
    </div>       

   <div id="front_media_center">
   
     <div id="vimeo_widget">
     <h2>Mensajes en video y audio:</h2>
     
     <object type="application/x-shockwave-flash" width="400" height="150" data="http://vimeo.com/hubnut/?user_id=igcmty&amp;color=00adef&amp;background=000000&amp;fullscreen=1&amp;slideshow=0&amp;stream=uploaded_videos&amp;id=&amp;server=vimeo.com">	<param name="quality" value="best" />		<param name="allowfullscreen" value="true" />		<param name="allowscriptaccess" value="always" />	<param name="scale" value="showAll" />	<param name="movie" value="http://vimeo.com/hubnut/?user_id=igcmty&amp;color=00adef&amp;background=000000&amp;fullscreen=1&amp;slideshow=0&amp;stream=uploaded_videos&amp;id=&amp;server=vimeo.com" /></object>
     
     </div>
   
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


        <?php print("<tr class=\"$Toggle\">"); ?><td colspan="3" class="serie"><?php print htmlentities($Serie["titulo"]); ?></td></tr><?php
        
          foreach ($Serie["conferencias"] as $Conferencia) {

            if ($Conferencia["contador_medios"] > 0) {
              $Count++;
              $Toggle = ($Count % 2 == 0) ? "even" : "odd";

?>

        <?php print("<tr class=\"$Toggle\">"); ?><td class="conferencia"><?php print $Conferencia["titulo"]; ?></td>
            <td class="MP3"><?php
                       
              if (strlen($Conferencia["MP3"])>0) { 
                print("<a href=\"" . $Conferencia["MP3"] . "\" target=\"new\">O&iacute;r</a>"); 
              } else {
                print("&nbsp;");
              } 
?></td>
           <td class="Video"><?php 

              if (strlen($Conferencia["video_embed"])>0) { 
 
                print("<a href=\"mensajes.php"  . "?id_serie=" . $SerieId .
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
     
     </div>
   </div>
      
    <div id="footer">
      &nbsp;
    </div>
   
  </div>

</body>


</html>
