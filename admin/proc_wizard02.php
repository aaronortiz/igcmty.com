<?php 

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well
  
  // Get data from the session if available
  
  $MainTableName = $_SESSION["proc_wizard"]["main_table"]["name"];

  // Save data and send user to next screen depending on button pressed
    
  if (isset($_POST["action"])) {
  
    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 

    switch ($Action) {
      case "Continuar": // This is normal, and requires no action
        $_SESSION["proc_wizard"]["procedure_name"] = $_POST["procedure_name"];
        $_SESSION["proc_wizard"]["procedure_type"] = $_POST["procedure_type"];
      break;
      case "Regresar": 
      break;
      default:
        header("location: proc_wizard01.php");
    } 
  }  
  else {
    $Action = $_SESSION["proc_wizard"]["action"];
  }
  
  include("RecordBrowserHeader.php");

  $Tables = Recordset("show tables");
  $_SESSION["proc_wizard"]["tables"] = $Tables;

?>

<div id="RecordEditor">

  <div class="title">  
    <h1>Crear Procedimiento: Paso 2 de 6</h1>
  </div>

  <form name="proc_wizard02" method="post" action="proc_wizard03.php">
    <fieldset name="main_table"><legend>Tabla principal</legend>
      <table id="zebra_table" style="width: 100%">
<?php
  $Toggle = "even";
  foreach($Tables as $Row) {
    
    ?>
    
        <?php 
          $Checked = ($MainTableName == $Row[0]) ? "checked" : "";
          print("<tr class=\"$Toggle\"><td>");  
          print("<input type=\"radio\" name=\"main_table\" $Checked value=\"" . $Row[0] . "\"></td><td>" . $Row[0]); ?>
        </td></tr>
    
    <?php
    
    $Toggle = ($Toggle == "even") ? "odd" : "even";
        
  }
    
      
?>
      </table>  
    </fieldset>
    
    <fieldset class="ButtonPanel">
      <input type="submit" name="action" value="Regresar">
      <input type="submit" name="action" value="Continuar">
    </fieldset>
  </form>
  <div class="bottom">&nbsp;</div> 
</div>
<?php 
  
  include("GUIFooter.php");

?>