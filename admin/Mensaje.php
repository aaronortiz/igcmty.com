<?php

  include 'encabezado.php';

  include_once("data/MySQL.php");

  $_SESSION["Username"] = "aeortizc_aeortiz";
  $_SESSION["Password"] = "";
  
  $rsSeries      = Recordset("SELECT * FROM series");
  $rsExpositores = Recordset("SELECT * FROM expositores");
  
  array_reverse($rsSeries);
  
?>

  <div id="texto">
  <div id="encabezado"></div>

<h1>Mensaje</h1>

<form action="crear_nuevo_mensaje.php" method="post">
  <fieldset>
    <p>Serie: <br><select name="serie"><?php
         
      foreach($rsSeries as $Serie){
        print "<option value=\"" . $Serie["id_serie"] . "\">" . 
        htmlentities($Serie["serie"], ENT_COMPAT, 'utf8') . "</option>\n";
      }
    
    ?></select></p>
    <p>T&iacute;tulo: <br>
      <input type="text" name="titulo" size="32" maxlength="64">
    </p>
    
    <p>Fecha:<br>
      <select name="dia">
        <?php
          for ($i=1; $i<32; $i++){
            $dia = date("j");
            if($i != $dia)
              printf("<option value=\"%d\">%02d</option>\n", $i, $i);
            else
              printf("<option value=\"%d\" selected>%02d</option>\n", $i, $i);
          }
        ?>
      </select>
      <select name="mes">
        <?php
          for ($i=1; $i<13; $i++){
            $mes = date("m");
            if($i != $mes)
              printf("<option value=\"%d\">%02d</option>\n", $i, $i);
            else
              printf("<option value=\"%d\" selected>%02d</option>\n", $i, $i);
          }
        ?>
      </select>
      <select name="anio">
        <?php
          for ($i=2009; $i>=2007; $i--){
            $anio = date("y");
            if($i != $anio)
              printf("<option value=\"%d\">%04d</option>\n", $i, $i);
            else
              printf("<option value=\"%d\" selected>%04d</option>\n", $i, $i);
  
          }
        ?>
      </select>
    </p>
    
    <p>Expositor: <br><select name="id_expositor"><?php    
      foreach($rsExpositores as $Expositor){
        print "<option value=\"" . $Expositor["id_expositor"] . "\">" . 
        htmlentities($Expositor["nombres"], ENT_COMPAT, 'utf8') . ' ' .
        htmlentities($Expositor["apellidos"], ENT_COMPAT, 'utf8') . "</option>\n";
      }    
    ?></select></p>      

    <p>Resumen:<br>
      <textarea name="resumen" rows="3" cols="64"></textarea>
    </p>

    <p>Claves de b&uacute;squeda:<br>
      <input type="text" name="claves" size="64" maxlength="64">
    </p>

    <p>MP3:<br>
      <input type="text" name="MP3" size="64" maxlength="128">
    </p>
  
  </fieldset>
  <p><input type="submit" value="Grabar Mensaje"></p>
</form>

  <div id="pie"></div>
  </div>

<?php

  include 'pie.php';
  
?>
