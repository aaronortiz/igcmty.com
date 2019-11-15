<?php

  $Subtitulo = "Grupos";
  include 'encabezado.php';
  include 'Data/MySQL.php';
  include 'listar_grupos.php';

?>

  <div id="texto">
  <div id="encabezado"></div>

    <img src="img/grupos.jpg" alt="Grupos" width="780" height="480">


<h1>Grupos</h1>


<h2>&Uacute;nete a un Grupo</h2>
<div>
  <h3><strong>&quot;Te invitamos a que puedas asistir a la reunión de grupo de crecimiento que más se acomode a ti.</strong> </h3>
</div>
<div>
  <h3><strong>Cada grupo es una reunión  de amigos que conversan acerca de diferentes aspectos de la vida con la  Biblia como base.</strong></h3>
</div>
<div>
  <h3><strong>¡No hay mejor manera de conocer mas acerca de Dios! En Gran Comisión creemos que estos grupos nos ayudan a formar el carácter de Jesucristo en un ambiente de aceptación y amistad.</strong></h3>
</div>
<div>
  <h3><strong>¡Lo más seguro es que te sentirás como en casa!&quot;</strong></h3>
</div>
<h3>&nbsp;</h3>
<table>
    
    <?php 

        foreach($Grupos as $Grupo) {
          ?>
          
    <tr>
        <td><strong>Grupo :</strong></td>
        <td><strong><?php 
        
        if(isset($Grupo["url"])) { 
          print("<a href=\"" . $Grupo["url"] . "\" target=\"new\">" . $Grupo["nombre"] . "</a>");
        }
        else {
          print($Grupo["nombre"]); 
        } 
        
        ?></a></strong></td>
    </tr>
      <tr>
        <td><strong>Lugar de reuni&oacute;n :</strong></td>
        <td><?php print($Grupo["ubicacion"]); ?></td>
      </tr>
      <tr>
        <td><strong>D&iacute;a de reuni&oacute;n :</strong></td>
        <td><?php print($Grupo["dia_reunion"]); ?></td>
      </tr>
      <tr>
        <td><strong>Encargado :</strong></td>
        <td><?php print($Grupo["lider_grupo"]); ?></td>
      </tr>
      <tr>
        <td><strong>Correo :</strong></td>
        <td><?php print("<a href=\"mailto:" . $Grupo["email"] . "\">" . $Grupo["email"]); ?></a></td>
      </tr>
      <tr>
        <td><strong>Celular :</strong></td>
        <td><?php print($Grupo["telefono"]); ?></td>
      </tr>

      <tr><td colspan="2">&nbsp;</td></tr>
      <tr><td colspan="2">&nbsp;</td></tr>              
<?php          
        } // End foreach  
          
?>          
    </table>
<div id="pie"></div>

  </div>

<?php

  include 'pie.php';
  
?>
