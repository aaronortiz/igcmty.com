<?php

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well

  // Get data from the session if available

  $ProcedureName = $_SESSION["proc_wizard"]["procedure_name"];
  $ProcedureType = $_SESSION["proc_wizard"]["procedure_type"];  

  // Save data depending on where user is coming from
  if(isset($_POST["action"])) {
  
    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 
  
    switch ($Action) {
      case "Crear Procedimiento Similar": // do nothing
      break;
      case "Volver a Empezar": 
        unset($_SESSION["proc_wizard"]);
        unset($ProcedureName);
        unset($ProcedureType);
      break;
      case "Regresar": //This is when the user presses the "previous" button in step 6, 
        if(count($_SESSION["proc_wizard"]["secondary_tables"]) > 0) {
          header("location: proc_wizard05.php"); // User should be sent to step 5
        } else {
          header("location: proc_wizard04.php"); // User should be sent to step 4 if no secondary tables exist
        }
      break;
      default:
        unset($_SESSION["proc_wizard"]);
    }
  } else {
    $Action = $_SESSION["proc_wizard"]["action"];
  }
  
  $ProcedureTypes = array("INSERT", "UPDATE", "DELETE");

  include("RecordBrowserHeader.php");

?>

<div id="RecordEditor">

  <div class="title">
    <h1>Crear Procedimiento: Paso 1 de 6</h1>
  </div>

  <form name="proc_wizard01" method="post" action="proc_wizard02.php">

    <fieldset><legend>Datos B&aacute;sicos</legend>
 
      <p><label for="procedure_name">Nombre del procedimiento</label>
      <?php print("<input type=\"text\" maxlength=\"32\" name=\"procedure_name\" value=\"$ProcedureName\"></p>"); ?>
 
      <p><label for="procedure_type">Tipo de procedimiento:</label>
      <select name="procedure_type">
        <?php 
          foreach($ProcedureTypes as $Type){
            $Selected = ($Type == $ProcedureType) ? " selected" : "";
            print("        <option id=\"$Type\"$Selected>$Type</option>\n");  
          }
        ?>
      </select></p>
    
    </fieldset>
    <fieldset class="ButtonPanel">
      <input type="submit" name="action" value="Continuar">
    </fieldset>
  </form>
  <div class="bottom">&nbsp;</div> 
</div>
<?php 
  
  include("GUIFooter.php");

?>