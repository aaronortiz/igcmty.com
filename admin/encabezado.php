<?php ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head lang="es-MX">
  <meta charset="UTF-8">
    <title>Iglesia Gran Comisi&oacute;n Internacional, Monterrey</title>
  
    <style type="text/css">
      @import "../css/index.css";
      * html body { behavior: url(../htc/csshover.htc); /* call hover behaviour file */
      
    </style>
    
    <link rel="stylesheet" href="../sifr/css/sifr.css" type="text/css">
    <script src="../sifr/js/sifr.js" type="text/javascript"></script>
    <script src="../sifr/js/sifr-config.js" type="text/javascript"></script>

    
    <!--[if IE]>
    
      <link rel="stylesheet" type="text/css" href="../css/iehacks.css">
    
    <![endif]-->    
    
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"> 
    
  </head>
  
<div id="contenido">
  <div id="menu">
  <?php
  
  include("../menu_class.php");
  
  $menu = new menu("menu_items");
  
  $menu->add_item("../index.php",    "<img alt=\"Inicio\"   src=\"../img/menu_item.gif\" width=\"110\">", "inicio");
  $menu->add_item("../estudios.php", "<img alt=\"Mensajes\" src=\"../img/menu_item.gif\">", "mensajes");
  $menu->add_item("../grupos.php",   "<img alt=\"Grupos\"   src=\"../img/menu_item.gif\">", "grupos");
  $menu->add_item("../contacto.php", "<img alt=\"Contacto\" src=\"../img/menu_item.gif\">", "contacto");
  $menu->add_item("../nosotros.php", "<img alt=\"Nosotros\" src=\"../img/menu_item.gif\">", "nosotros");
  $menu->add_item("../donar.php",    "<img alt=\"Donar\"    src=\"../img/menu_item.gif\">", "donaciones");  
  $menu->add_item("../enlaces.php",  "<img alt=\"Enlaces\" src=\"../img/menu_item.gif\">",  "enlaces");  
  $menu->print_html();
  
  ?>
  
  </div>