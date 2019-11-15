<?php

  $Subtitulo = "20110904";
  $MenuName  = "menu_ar";
  include 'encabezado.php';
  include 'Data/MySQL.php';
  include("Data/LimitedUser.php");
  
  $_SESSION["Username"] = $LimitedUser;
  $_SESSION["Password"] = $LimitedPass;  

  if(isset($_GET["id_mensaje"])) {
    $IdMensaje = $_GET["id_mensaje"];
    $rsResumen = Recordset("SELECT resumen from mensajes where id_mensaje = '$IdMensaje'");
    $Resumen = $rsResumen[0]["resumen"];

?>

  <div id="texto_ma">
  <div id="encabezado_ma"></div>

    <?php print($Resumen); ?>

    <!--h1>CLICK</h1>
    <h2>¡Y mejora tu vida!</h2>
    
    <h3>Romanos 3:23</h3>
    <p>&ldquo;por cuanto todos pecaron, y están destituidos de la gloria de Dios,&rdquo;</p>
    
    <p>Todos cometemos errores, conscientes o inconscientes; intencionales o no.</p>
    
    <h3>Romanos 6:23</h3>
    <p>&ldquo;Porque la paga del pecado es muerte, mas la dádiva de Dios es vida eterna en Cristo Jesús Señor nuestro.&rdquo;</p>
    
    <p>Jamás podríamos pagar el precio.</p>
    
    <h3>Juan 3:16</h3>
    <p>&ldquo;Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna&rdquo;</p>
    
    <h3>Juan 6:47</h3>
    <p>&ldquo;De cierto, de cierto os digo: el que cree en mí, tiene vida eterna.&rdquo;</p>
    
    <h3>Tito 3:5</h3>
    <p>&ldquo;Nos salvó, no por obras de justicia que nosotros hubiéramos hecho, sino por su misericordia. . .&rdquo;</p>
    
    <h3>Efesios 2:8-9</h3>
    <p>&ldquo;<sup>8</sup>Porque por gracia sois salvos por medio de la fe; y esto no de vosotros, pues es don de Dios; <sup>9</sup> no por obras, para que nadie se gloríe.&rdquo;</p>
    
    <p>Las buenas obras son importantes, pero no para salvación.</p>
    
    <h3>Romanos 3:28</h3>
    <p>&ldquo;CONCLUIMOS, pues, que el hombre es JUSTIFICADO POR FE sin las obras de la ley&rdquo;</p>
    
    <h3>Juan 6:47</h3>
    <p>&ldquo;De cierto, de cierto os digo: el que cree en mí, tiene vida eterna.&rdquo;</p>
    
    <p>Si crees hoy en Jesús, puedes estar completamente seguro de ir al cielo el día que mueras.&rdquo;</p>
    
    <h3>1 Juan 5:13 </h3>
    <p>&ldquo;Estas cosas os he escrito a vosotros que creéis en el nombre del Hijo de Dios, para que sepáis que tenéis vida eterna, y para que creáis en el nombre del Hijo de Dios.&rdquo;</p-->


  <div id="pie_ma"></div>

  </div>

<?php

  }

  include 'pie.php';
  
?>
