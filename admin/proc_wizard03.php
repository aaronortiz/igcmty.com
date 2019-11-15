<?php 

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well
  
  // Get data from the session if available

  $MainFields = (isset($_SESSION["proc_wizard"]["main_fields"])) ? ($_SESSION["proc_wizard"]["main_fields"]) : -1;
  
  // Save data and send user to next screen depending on button pressed

  if (isset($_POST["action"])) {
    
    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 

    switch ($Action) {
    
      case "Continuar": // Store post data in session
        $MainTable = $_POST["main_table"];
        $Columns   = Recordset("SHOW COLUMNS FROM $MainTable");
        foreach($Columns as $Column){
          $IndexedColumns[$Column["Field"]] = $Column;
        }
        
        $_SESSION["proc_wizard"]["main_table"]["name"]    = $MainTable;
        $_SESSION["proc_wizard"]["main_table"]["columns"] = $IndexedColumns;
        $ProcedureType                                    = $_SESSION["proc_wizard"]["procedure_type"];

        if($ProcedureType == "DELETE") {
          header("location: proc_wizard04.php");
        }

      break;
      
      case "Regresar": 
        header("location: proc_wizard01.php");
      break;
      default:
        header("location: proc_wizard01.php");
    } 


  }  
  else {
    $Action        = $_SESSION["proc_wizard"]["action"];
    $MainTable     = $_SESSION["proc_wizard"]["main_table"]["name"];
    $Columns       = $_SESSION["proc_wizard"]["main_table"]["columns"];
    $ProcedureType = $_SESSION["proc_wizard"]["procedure_type"];
  }

  // DELETE does not need to select field names, but keys
  if ($_SESSION["proc_wizard"]["procedure_type"] == "DELETE") {
    $Legend = "Campos clave tabla principal"; }
  else {
    $Legend = "Campos tabla principal";
  }

  include("RecordBrowserHeader.php");

?>

<div id="RecordEditor">

  <div class="title">  
    <h1>Crear Procedimiento: Paso 3 de 6</h1>
  </div>

  <form name="proc_wizard03" method="post" action="proc_wizard04.php">
    <fieldset name="main_fields"><legend><?php print($Legend); ?></legend>
      <table id="zebra_table" style="width: 100%">
<?php
  $Toggle = "even";
  foreach($Columns as $Field) {
    if ($MainFields == -1) {
      if($ProcedureType != "CREATE" || $Columns["field"]["Key"] != "PRI")
        $Checked = "checked";
    } else {
      $Checked = (isset($MainFields[$Field[0]])) ? "checked" : "";
    }
      
    ?>
    
        <?php print("<tr class=\"$Toggle\">"); ?><td>
          <?php print("<input type=\"checkbox\" $Checked name=\"main_fields[]\" value=\"" . $Field[0] . "\"></td><td>" . $Field[0]); ?>
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