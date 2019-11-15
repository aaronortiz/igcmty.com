<?php

  $Subtitulo = "Grupos";
  include 'encabezado.php';
  include_once 'Data/MySQL.php';
  include("Data/LimitedUser.php");

  $_SESSION["Username"] = $LimitedUser;
  $_SESSION["Password"] = $LimitedPass;
 
  $SQL = "select * from aeortizc_mensajes.eventos "
       . "  where fecha_fin >= date(now())";

  $rsEventos = Recordset($SQL);
  
  $SQL = "select e.id_evento, mi.* " 
       . "from eventos e "
       . "inner join eventos_medios em on em.id_evento = e.id_evento "
       . "inner join medios_imagen  mi on mi.id_medio  = em.id_medio "
       . "where e.fecha_fin >= date(now()) "
       . "order by fecha asc";

  $rsImagenes = Recordset($SQL);
  
  $SQL = "select e.id_evento, mv.* " 
       . "from eventos e "
       . "inner join eventos_medios em on em.id_evento = e.id_evento "
       . "inner join medios_video   mv on mv.id_medio  = em.id_medio "
       . "where e.fecha_fin >= date(now())";
  
  $rsVideos = Recordset($SQL);

  if (!empty($rsEventos)) {
    $Eventos = array();
    foreach($rsEventos as $Evento) {
  
      $Eventos[$Evento["id_evento"]]["titulo"]         = $Evento["titulo_evento"];
      $Eventos[$Evento["id_evento"]]["subtitulo"]      = $Evento["subtitulo_evento"];
      $Eventos[$Evento["id_evento"]]["resumen"]        = $Evento["resumen_evento"];
      $Eventos[$Evento["id_evento"]]["fecha"]          = $Evento["fecha"];
      $Eventos[$Evento["id_evento"]]["horario"]        = $Evento["horario"];
      $Eventos[$Evento["id_evento"]]["lugar"]          = $Evento["lugar"];
      $Eventos[$Evento["id_evento"]]["precio"]         = $Evento["precio"];
      $Eventos[$Evento["id_evento"]]["ocultar_precio"] = $Evento["ocultar_precio"];
    }
   
    if (!empty($rsImagenes)) {
  
      foreach($rsImagenes as $Imagen) {
        $Eventos[$Imagen["id_evento"]]["medios"]["id_medio"]["altura"]        = $Imagen["altura"];
        $Eventos[$Imagen["id_evento"]]["medios"]["id_medio"]["ancho"]         = $Imagen["ancho"];
        $Eventos[$Imagen["id_evento"]]["medios"]["id_medio"]["texto_alterno"] = $Imagen["texto_alterno"];
        $Eventos[$Imagen["id_evento"]]["medios"]["id_medio"]["src"]           = $Imagen["src"];
        $Eventos[$Imagen["id_evento"]]["medios"]["id_medio"]["tipo"]          = "Imagen";
      }
    }
  
    if (!empty($rsVideos)) {
      foreach($rsVideos as $Video) {
        $Eventos[$Video["id_evento"]]["medios"]["id_medio"]["embed"] = $Video["embed"];  
        $Eventos[$Video["id_evento"]]["medios"]["id_medio"]["tipo"]  = "Video";  
      }
    }
  }
?>

  <div id="texto">
  <div id="encabezado"></div>

    <img src="img/eventos.jpg" alt="Eventos" width="780" height="425">
    
<h1>Eventos</h1> 

<?php 

  if (!empty($Eventos)) {
    foreach($Eventos as $Evento){
  
      print("<h2>" . htmlentities($Evento["titulo"]) . "</h2>\n");
    
      if (!empty($Evento["subtitulo"])) {
        print("<h3>" . htmlentities($Evento["subtitulo"]) . "</h3>\n");
      }

      if (!empty($Evento["resumen"])) {
        print("<p>" . htmlentities($Evento["resumen"]) . "</p>\n\n");
      }

      $EmptyCheck = $Evento["fecha"] . $Evento["horario"] . $Evento["lugar"] . $Evento["precio"];
      if (strlen($EmptyCheck) > 0) {

        print("<table>\n");
      
        if (!empty($Evento["fecha"])) {
          print("  <tr><td>Fecha:</td><td>" . htmlentities($Evento["fecha"]) . "</td></tr>\n");
        }

        if (!empty($Evento["horario"])) {
          print("  <tr><td>Horario:</td><td>" . htmlentities($Evento["horario"]) . "</td></tr>\n");
        }

        if (!empty($Evento["lugar"])) {
          print("  <tr><td>Lugar:</td><td>" . htmlentities($Evento["lugar"]) . "</td></tr>\n");
        }

        if (!(empty($Evento["precio"]) || $Evento["ocultar_precio"] == True)) {
          print("  <tr><td>Precio:</td><td>" . htmlentities($Evento["precio"]) . "</td></tr>\n");
        }
    
        print("</table>");
    
      }
    }
  } else {
  ?>
  
    <p><strong>Retiro de Jóvenes<br />
    </strong>24 y 25 de mayo </p>
    <p><strong>Conferencia &quot;Espiritu Santo&quot;<br />
    </strong>27-29 de septiembre<br />
    <br />
    <strong>Reunión de Comunidad</strong><br />
    Martes 5 de marzo y Martes 2 de abril<br />
    8:00pm<br />
    Salón Chipinque, Hotel Presidente</p>
    <p>
      <?php
  }

?>
    </p>
<div id="pie"></div>

  </div>

<?php

  include 'pie.php';
  
?>