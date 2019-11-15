<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>

 <title><?php print("$Title"); ?></title>

<style type="text/css" media="all">
   @import "../index.css";
   * html body { behavior: url(../htc/csshover.htc); /* call hover behaviour file */ }
</style>

  <style type="text/css" media="screen">
    @import "../Sifr/sIFR-screen.css";
  </style>
  
  <style type="text/css" media="print">
    @import "../Sifr/sIFR-print.css";
  </style>
  
  <script src="../Sifr/sifr.js" type="text/javascript"></script>
  <script src="../Sifr/sifr-config.js" type="text/javascript"></script>
 
</head>
<body>

  <!--div id="salir"><a href="../Data/LogOut.php">Salir del sistema</a></div-->

  <div id="encabezado_pagina">
    <div id="salir">
      <form action="../Data/LogOut.php"><button><span><div class="icon_exit"></div>Salir del sistema</span></button></form>
    </div>  
  </div>
  <div id="contenido">
    <div id="titulo">
<?php
    if ($Title)
      print("    <h1>$Title</h1>\n");

    if ($Subtitle)
      print("    <h2>$Subtitle</h2>\n");
  ?>
    </div>
