<?php 

  include_once("listar_estudios.php");
  include_once("meses.php");

  $PreHead     = "";

  if(!empty($PreHead)) { 
    $Tooltip = $Prehead . '/n';
?>
<h2 class="subhead"><?php print(htmlentities($PreHead)); ?></h2>

<?php }

  if(!empty($Headline)) {
    $Tooltip .= strtoupper($Headline);
    if(strlen($Headline) < 24) {
?>

<h1 class="headline"><?php print($Headline/*, ENT_COMPAT, false*/); ?></h1>

<?php 
    } else if (strlen($Headline) < 30) {
?>

<h1 class="smaller headline"><?php print($Headline/*, ENT_COMPAT, false*/); ?></h1>

<?php     
    } else {
?>

<h1 class="sesquipedalian headline"><?php print($Headline/*, ENT_COMPAT, false*/); ?></h1>

<?php     
    }
  }

  if(!empty($Subhead)) {
    $Tooltip .= "\n$Subhead";
?>

<h2 class="subhead"><?php print($Subhead/*, ENT_COMPAT, false*/); ?></h2>

<?php }

  if (strlen($Descripcion) > 0)
    $Tooltip .= "\n\n$Descripcion";

print("<img src=\"img/$Image\" title =\"$Tooltip\" alt=\"$Tooltip\" height=\"$ImageHeight\" width=\"$ImageWidth\" class=\"banner\">");  ?>

<table id="temas">
<tr>
  <th><h3 class="coltitle">Temas</h3></th>
  <th class="spacer">&nbsp;</th>
  <th><h3 class="coltitle">S&iacute;guenos</h3></th>
  <th class="spacer">&nbsp;</th>
  <th><h3 class="coltitle">Vis&iacute;tanos</h3></th>
</tr>

<tr>
  <td class="column">

    <?php 
      if(count($Temas)>0) {
        print("<table id=\"fecha_y_desc\">\n");
        foreach($Temas as $IdTema => $Tema) {
          print("      <tr>\n" . 
                "        <td class=\"datestamp\"><span class=\"datestamp_day\">" .
                date("d", strtotime($Fechas[$IdTema])) . "</span><br>" .
                $Meses[date("m", strtotime($Fechas[$IdTema]))] . "</td>\n" .
                "        <td class=\"tema\">");
          if ((strlen($Resumenes[$IdTema])>0 && $Fechas[$IdTema] < date("Y-m-d")) || 
              ($Fechas[$IdTema] == date("Y-m-d") && date("G") >= 10)) {
            $MostrarResumen = true;
            print("<a href=\"mensaje.php?id_mensaje=$IdTema\">");
          }
          print($Tema/*, ENT_COMPAT, false*/);
          if ($MostrarResumen) {
            print("</a>");
          }
          print("</td>\n" . 
                "      </tr>\n"); 
        }
      print ("    </table>\n\n");
      }    
    ?>
  </td>

  <td class="spacer">&nbsp;</td>
  
  <td class="column" id="siguenos">
    <ul>
      <li><a href="http://www.facebook.com/IGC.Monterrey" target="_blank">En Facebook</a></li>
      <li>En twitter, <a href="http://twitter.com/GranComisionMTY" target="_blank">@GranComisionMTY</a></li>
      <li>Blog <a href="http://www.igcmty.org/" target="_blank">Noticias de Monterrey</a></li>
      <li>Blog de <a href="http://liderazgo.grancomision.org.mx/" target="_blank">Sergio Handal</a></li>
      <li><strong>Multiplica Multiplicadores</strong> <a href="http://multiplica.igcla.com/" target="_blank">Espiral</a></li>
    </ul>
  </td>


  <td class="spacer">&nbsp;</td>
  <td class="column" rowspan="4">
    <a class="no_border" target="new" href="https://goo.gl/maps/CrTk9mX6CzF2"><img src="img/mapa.jpg" height="124" width="200" align="mapa"></a>
    <p><b><a href="https://goo.gl/maps/CrTk9mX6CzF2" target="new">Auditorio Gran Comisión</a></b><br>
       Lic. Domingo M Treviño 131-4<br>
       Monterrey, NL, 64650<br>
       <strong>11:00am y 12:30pm</strong></p>
  </td>
</tr>
</table>