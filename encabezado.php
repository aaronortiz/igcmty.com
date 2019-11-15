<?php header('Content-type: text/html; charset=utf-8'); ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head lang="es-MX">
  <meta charset="UTF-8">
    <title>Iglesia Gran Comisi&oacute;n Internacional, Monterrey</title>
  
    
    <?php 
      print("<style type=\"text/css\">\n" .      
            "      @import \"" . $PathToRoot . "css/index.css\";\n" .
            "    </style>"); 

      ?>
      
    <style type="text/css">
      * html body { behavior: url(htc/csshover.htc); /* call hover behaviour file */
      
    </style>
    
    <link href=' http://fonts.googleapis.com/css?family=Cantarell:regular,bold' rel='stylesheet' type='text/css'>
    
    <!--[if IE]>
      <link rel="stylesheet" type="text/css" href="css/iehacks.css">
    <![endif]-->    
    
    <link rel="alternate" type="application/rss+xml"  href="http://feeds.feedburner.com/igcmty_audio" title="Iglesia Gran Comision Monterrey, Mensajes en Audio">
    <link rel="alternate" type="application/rss+xml"  href="http://feeds.feedburner.com/igcmty_video" title="Iglesia Gran Comision Monterrey, Mensajes en Video">

    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"> 
    <meta name="google-site-verification" content="jYFILpKgZkVT3dC28oI9ES6gNyJ6hS4d7fBeuwo2OFo" />  
 <?php
 
       if(strstr($_SERVER['HTTP_USER_AGENT'],'iPhone') || strstr($_SERVER['HTTP_USER_AGENT'],'iPod') || strstr($_SERVER['HTTP_USER_AGENT'],'BlackBerry'))
        {
          print("<style type=\"text/css\">\n" .      
                "      @import \"" . $PathToRoot . "css/mobile.css\";\n" .
                "    </style>"); 
        }
        
  ?>   
  </head>
 
<div id="contenido">
  <div id="titulo">Iglesia Gran Comisi&oacute;n, Monterrey</div>
  <?php
  if(!isset($MenuName))
    $MenuName = "menu";
      
  print("<div id=\"$MenuName\">");

  include("menu_class.php");
  
  $menu = new menu("menu_items");

  $menu->add_item("$PathToRoot" ."index.php",    "Inicio",   "inicio");
  $menu->add_item("$PathToRoot" ."mensajes.php", "Mensajes", "mensajes");
  $menu->add_item("$PathToRoot" ."grupos.php",   "Grupos",   "grupos");
  $menu->add_item("$PathToRoot" ."contacto.php", "Contacto", "contacto");
  $menu->add_item("$PathToRoot" ."nosotros.php", "Nosotros", "nosotros");
  $menu->add_item("$PathToRoot" ."donar.php",    "Donar",    "donaciones");  
  $menu->add_item("$PathToRoot" ."enlaces.php",  "Enlaces",  "enlaces");  
  $menu->add_item("$PathToRoot" ."eventos.php",  "Eventos",  "eventos");  
  $menu->print_html();
  
  ?>
  
  </div>