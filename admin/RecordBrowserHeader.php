<?php ?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head lang="es-MX">
    <meta charset="UTF-8">
    <title>Iglesia Gran Comisi&oacute;n Internacional, Monterrey</title>
  
    <style type="text/css">
      @import "../css/index.css";
      @import "../css/Icons.css";
      @import "../css/RecordBrowser.css";
      @import "../css/RecordEditor.css";
      
   * html body { behavior: url(../htc/csshover.htc); /* call hover behaviour file */
      
    </style>
    
    <link rel="stylesheet" href="../sifr/css/sifr.css" type="text/css">
    <script src="../sifr/js/sifr.js" type="text/javascript"></script>
    <script src="../sifr/js/sifr-config.js" type="text/javascript"></script>

    
    <!--[if IE]>
    
      <link rel="stylesheet" type="text/css" href="../css/iehacks.css">
    
    <![endif]-->    
    
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
    
    <!--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--> 

<?php
  if (isset($ScriptList))
    print ("\n" . $ScriptList->ParseHTML() . "\n");
?>
</head>
<?php

  include_once("../Presentation/cls_EventQueue.php");

  if (isset($BodyOnLoad)) {
    if(isset($_SESSION["Error"])) {
      $BodyOnLoad->QueueAdd("alert('" . $_SESSION["Error"] . "');");
      unset($_SESSION["Error"]);
    }
    print("<body " . $BodyOnLoad->ParseEvent() . ">\n");
  } else {
    if(isset($_SESSION["Error"])) {
      $BodyOnLoad = new EventQueue("OnLoad");
      $BodyOnLoad->QueueAdd("alert('" . $_SESSION["Error"] . "');");
      unset($_SESSION["Error"]);
      print("<body " . $BodyOnLoad->ParseEvent() . ">\n");  
    } else {
      print("<body>\n");
    }
  }
?>
<div id="contenido">
  <div id="menu">
  <?php
  
  include("../menu_class.php");
  
  $menu = new menu("menu_items");
  
  $menu->add_item("../Data/LogOut.php", "Salir",       "salir");
  $menu->add_item("index.php",          "Administrar", "administrar");
  $menu->add_item("Series.php",         "Series",      "series");
  $menu->add_item("Mensajes.php",       "Mensajes",    "mensajes");
  $menu->add_item("Expositores.php",    "Expositores", "expositores");
  $menu->add_item("Grupos.php",         "Grupos",      "grupos");  
  $menu->add_item("LideresGrupo.php",   "Lideres",     "lideres");
  $menu->add_item("Eventos.php",        "Eventos",     "eventos");
  $menu->print_html();
  
  ?>
  
  </div>

