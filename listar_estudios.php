<?php

  include_once("Data/MySQL.php");
  include("Data/LimitedUser.php");

  $_SESSION["Username"] = $LimitedUser;
  $_SESSION["Password"] = $LimitedPass;
  
  $DefaultVideoEmbed = "";
  
  $SQL = "SELECT a.id_serie FROM series as a " 
       . "INNER JOIN mensajes as b "
       . "ON b.id_serie = a.id_serie "
       . "WHERE b.fecha = (SELECT MAX(fecha) FROM mensajes)";
 
  $rsIdSerie = Recordset($SQL);
 
 /* 
  $rsMaxFecha  = Recordset("SELECT MAX(fecha) as max_fecha from mensajes;");
  $MaxFecha    = strtotime($rsMaxFecha[0]["max_fecha"]);
  $SerieActual = 0;
  
  if($MaxFecha < time()) {
    $SQL = "SELECT MAX(id_serie) as id_serie from mensajes";
    $rsIdSerie = Recordset($SQL);
  } else {
    $SQL = "SELECT MIN(id_serie) as id_serie from mensajes WHERE fecha >= CURDATE()";
    $rsIdSerie = Recordset($SQL);
  } 
  
*/
  
  $SQL = "SELECT * FROM series WHERE id_serie = " . $rsIdSerie[0]["id_serie"];
  
  $rsTitulos   = Recordset($SQL);
  $Headline    = $rsTitulos[0]["serie"];
  $Subhead     = $rsTitulos[0]["subtitulo"];
  $Image       = $rsTitulos[0]["imagen_archivo"];
  $ImageHeight = $rsTitulos[0]["imagen_altura"];
  $ImageWidth  = $rsTitulos[0]["imagen_anchura"];
  $Descripcion = $rsTitulos[0]["descripcion"];
  
  $SQL = "SELECT me.*, se.serie, se.subtitulo, se.descripcion " 
       . "FROM mensajes me INNER JOIN series se ON se.id_serie = me.id_serie "
       . "WHERE me.id_serie = " . $rsIdSerie[0]["id_serie"] . " "
       . "ORDER BY fecha ASC";
  
  $rsSerieActual = Recordset($SQL);
   
  $Temas = array();
  $Fechas = array();  
  foreach((array) $rsSerieActual as $Mensaje) {
    $IdMensaje             = $Mensaje["id_mensaje"];
    $Temas[$IdMensaje]     = $Mensaje["mensaje"];
    $Fechas[$IdMensaje]    = $Mensaje["fecha"];
    $Resumenes[$IdMensaje] = $Mensaje["resumen"];
  }

  $SQL = "SELECT * from series";
  
  $rsSeries = Recordset($SQL);

  $SQL = "SELECT sm.id_serie, "
       . "	mi.id_medio, "
       . "	mi.altura, "
       . "	mi.ancho, "
       . "	mi.texto_alterno, "
       . "	mi.src "
       . "FROM series_medios sm INNER JOIN medios_imagen mi ON sm.id_medio = mi.id_medio";

  $rsImagenes = Recordset($SQL);

  $SQL = "SELECT s.id_serie, s.serie, m.id_mensaje, m.mensaje, m.resumen, m.fecha, CONCAT(e.nombres, ' ', e.apellidos) as expositor "
       . "from series s "
       . "inner join mensajes m on m.id_serie = s.id_serie "
       . "inner join expositores e on e.id_expositor = m.id_expositor";
  
  $rsMensajes = Recordset($SQL);
  
  $SQL = "select s.id_serie, mm.id_mensaje, m.id_medio, ma.m3u as mp3 "
       . "from series s "
       . "inner join mensajes me on me.id_serie = s.id_serie "
       . "inner join mensajes_medios mm on mm.id_mensaje = me.id_mensaje "
       . "inner join medios m on m.id_medio = mm.id_medio and m.id_tipo_medio = 1 "
       . "left outer join medios_audio ma on ma.id_medio = mm.id_medio "
       . "order by s.id_serie, me.fecha";

  $rsAudio = Recordset($SQL);
  
  $SQL = "select s.id_serie, mm.id_mensaje, m.id_medio, mv.embed from series s inner join mensajes me on me.id_serie = s.id_serie inner join mensajes_medios mm on mm.id_mensaje = me.id_mensaje inner join medios m on m.id_medio = mm.id_medio and m.id_tipo_medio = 4 left outer join medios_video mv on mv.id_medio = mm.id_medio order by s.id_serie, me.fecha";
  
  $rsVideo = Recordset($SQL);
  
  $Series = array();
  
  foreach((array) $rsSeries as $Serie){
    $Series[$Serie["id_serie"]]["titulo"] = $Serie["serie"];
    $Series[$Serie["id_serie"]]["contador_medios"] = 0;
  } 
  
  foreach((array) $rsImagenes as $ImagenSerie) {
    $Series[$ImagenSerie["id_serie"]]["imagen"]["altura"]        = $ImagenSerie["altura"];
    $Series[$ImagenSerie["id_serie"]]["imagen"]["ancho"]         = $ImagenSerie["ancho"];
    $Series[$ImagenSerie["id_serie"]]["imagen"]["texto_alterno"] = $ImagenSerie["texto_alterno"];
    $Series[$ImagenSerie["id_serie"]]["imagen"]["src"]           = $ImagenSerie["src"];
  }
  
  foreach((array) $rsMensajes as $Mensaje) {
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["id_mensaje"] = $Mensaje["id_mensaje"];
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["titulo"]     = $Mensaje["mensaje"];
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["fecha"]      = $Mensaje["fecha"];
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["resumen"]    = $Mensaje["resumen"];
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["expositor"]  = $Mensaje["expositor"];
    $Series[$Mensaje["id_serie"]]["conferencias"][$Mensaje["id_mensaje"]]["contador_medios"] = 0;
  }
 
  foreach((array) $rsAudio as $Audio) {
    $Series[$Audio["id_serie"]]["contador_medios"]++;
    $Series[$Audio["id_serie"]]["conferencias"][$Audio["id_mensaje"]]["contador_medios"]++;
    $Series[$Audio["id_serie"]]["conferencias"][$Audio["id_mensaje"]]["MP3"] = str_replace("m3u", "mp3", $Audio["mp3"]);
  }
   
  foreach((array) $rsVideo as $Video) {
    $Series[$Video["id_serie"]]["contador_medios"]++;
    $Series[$Video["id_serie"]]["conferencias"][$Video["id_mensaje"]]["contador_medios"]++;
    $Series[$Video["id_serie"]]["conferencias"][$Video["id_mensaje"]]["video_embed"] = $Video["embed"];
    $DefaultVideoEmbed = $Video["embed"];  
  }
  
  ?>                             