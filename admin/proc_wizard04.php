<?php 

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well

  // Get data from the session if available
  
  $Tables          = $_SESSION["proc_wizard"]["tables"];
  $MainTable       = $_SESSION["proc_wizard"]["main_table"]["name"];
  if(isset($_SESSION["proc_wizard"]["secondary_tables"])) {
    foreach($_SESSION["proc_wizard"]["secondary_tables"] as $Table){
      $SecondaryTables = array();
      $SecondaryTables[$Table] = $Table;
    }  
  }

  // Save data and send user to next screen depending on button pressed

  if (isset($_POST["action"])) {
  
    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 

    switch ($Action) {
      case "Continuar": // Store post data in session
            
        if($_SESSION["proc_wizard"]["procedure_type"] != "DELETE"){
          foreach($_POST["main_fields"] as $Field) {
            $MainFields[$Field] = $Field;      
          }  
        } else {
          foreach($_SESSION["proc_wizard"]["main_table"]["columns"] as $FieldKey => $Field) {
            $MainFields[$FieldKey] = $FieldKey;
          }  
        }
       $_SESSION["proc_wizard"]["main_fields"] = $MainFields; 
       
      break;
      
      case "Regresar": //This is when the user presses the "previous" button in step 3, 
        header("location: proc_wizard02.php"); // User should be sent to step 2
      break;
      default:
        header("location: proc_wizard01.php");
    }
  }
  else {
  
    $Action     = $_SESSION["proc_wizard"]["action"];
    
    if($_SESSION["proc_wizard"]["procedure_type"] != "DELETE"){
      $MainFields = $_SESSION["proc_wizard"]["main_fields"];
    } else {
      foreach($_SESSION["proc_wizard"]["main_table"]["columns"] as $FieldKey => $Field) {
        $MainFields[$FieldKey] = $FieldKey;
      }
      $_SESSION["proc_wizard"]["main_fields"] = $MainFields;
    }
  }
      
  include("RecordBrowserHeader.php");

?>

<div id="RecordEditor">

  <div class="title">  
    <h1>Crear Procedimiento: Paso 4 de 6</h1>
  </div>

  <form name="proc_wizard04" method="post" action="proc_wizard05.php">
    <fieldset name="secondary_tables"><legend>Tablas secundarias</legend>
      <table id="zebra_table" style="width: 100%">
<?php
  $Toggle = "even";
  
  
  foreach($Tables as $Row) {
  
    if ($Row[0] != $MainTable) {
      $Checked = ($Row[0] == $SecondaryTables[$Row[0]]) ? "checked" : "";
  
    ?>
        <?php print("<tr class=\"$Toggle\">"); ?><td>
          <?php print("<input type=\"checkbox\" $Checked name=\"secondary_tables[]\" value=\"" . $Row[0] . "\"></td><td>" . $Row[0]); ?>
        </td></tr>
    
    <?php
    
      $Toggle = ($Toggle == "even") ? "odd" : "even";
    }
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