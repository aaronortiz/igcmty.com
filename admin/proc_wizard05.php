<?php 

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well

  // Get data from the session if available

  $ProcedureType   = $_SESSION["proc_wizard"]["procedure_type"];
  $MainTable       = $_SESSION["proc_wizard"]["main_table"]["name"];
  $MainColumns     = $_SESSION["proc_wizard"]["main_table"]["columns"];
  $SecondaryKeys   = $_SESSION["proc_wizard"]["secondary_keys"];
  $SecondaryLinks  = $_SESSION["proc_wizard"]["secondary_links"];
  $SecondaryFields = $_SESSION["proc_wizard"]["secondary_fields"];
  
  // Save data and send user to next screen depending on button pressed

  if (isset($_POST["action"])) {

    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 

    switch ($Action) {
      case "Continuar": 

        // Skip this screen if no secondary tables selected

        if(count($_POST["secondary_tables"]) == 0) {
          header("location: proc_wizard06.php");
        }

        // Store post data in session
        
        foreach($_POST["secondary_tables"] as $Table) {
          $SecondaryTables[$Table]   = $Table; 
          $SecondaryColumns          = Recordset("SHOW COLUMNS FROM $Table");
          foreach($SecondaryColumns as $Column){
            $IndexedColumns[$Column["Field"]] = $Column;
          }
          $SecondaryTableFields[$Table]["columns"] = $IndexedColumns;
        }  
  
        $_SESSION["proc_wizard"]["secondary_tables"]       = $SecondaryTables;
        $_SESSION["proc_wizard"]["secondary_table_fields"] = $SecondaryTableFields;
        
      break;
      case "Regresar": //This is when the user presses the "previous" button in step 4, 
        if($ProcedureType != "DELETE") {
          header("location: proc_wizard03.php"); // User should be sent to step 3
        } else {
          header("location: proc_wizard02.php"); // User should be sent to step 2        
        }
      break;
      default:
        header("location: proc_wizard01.php");
    }
  }
  else {
    $Action               = $_SESSION["proc_wizard"]["action"];
    $SecondaryTables      = $_SESSION["proc_wizard"]["secondary_tables"];
    $SecondaryTableFields = $_SESSION["proc_wizard"]["secondary_table_fields"];    
  }
  
  include("RecordBrowserHeader.php");

?>

<div id="RecordEditor">

  <div class="title">  
    <h1>Crear Procedimiento: Paso 5 de 6</h1>
  </div>

  <form name="proc_wizard05" method="post" action="proc_wizard06.php">
<?php
  $Toggle = "even";
  
  
  foreach($SecondaryTables as $Table) {
    if ($MainTable != $Table){
      print("    <fieldset name=\"$Table\"><legend>Selecciona los campos secundarios y los que usar&aacute;s para conectar <i>'$MainTable'</i> con <i>'$Table'</i></legend>");  ?>

        <table id="zebra_table" style="width: 100%">
  
      <?php 
      foreach($SecondaryTableFields[$Table]["columns"] as $Field) {
      
        if($ProcedureType != "DELETE" || $Field["Key"] == "PRI") {      

          $Checked = (isset($SecondaryFields[$Table][$Field[0]])) ? "checked" : "";
            
          print("<tr class=\"$Toggle\"><td>"); 
          if($ProcedureType != "DELETE") {
            print("<input type=\"checkbox\" $Checked name=\"" . $Table . "_fields[]\" value=\"" . $Field[0] . "\">");
          }
          print("</td><td>" . $Field[0] . "</td><td>"); 

          $SelectName = $Table . "_" . $Field[0];
          print("<select name=\"$SelectName\"><option value=\"\"></option>");
            
          foreach($MainColumns as $MainColumn) {

            if(isset($SecondaryLinks[$Table][$Field])) {
              $Selected = "selected";
            } else {
              $Selected = ($Field[0] == $MainColumn[0]) ? " selected" : "";
            }
            
            print("<option $Selected value=\"" . $MainColumn[0] . "\">" . $MainColumn[0] . "</option>");      
          }

          ?></select></td></tr>
    
          <?php
    
          $Toggle = ($Toggle == "even") ? "odd" : "even";
      
        }
      
      }
      ?>
        </table>
  
      </fieldset>
      <?php
    }
  }  
      
?>
    
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