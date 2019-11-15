<?php 

  include("../Data/CheckLogin.php"); // Starts session and includes MySQL.php as well

//-----------------------------------------------------------------

  function GetUniqueParamName($DestinationArray, $ProposedValue){
  
    $Suffix = 2;
  
    if(!in_array($ProposedValue, $DestinationArray)) {
      return $ProposedValue;
    } else {
      while(in_array($ProposedValue . "_$Suffix", $DestinationArray)) {
        $Suffix++;
      }
      return $ProposedValue . "_$Suffix";
    }
  }
  
//-----------------------------------------------------------------

  // Get data from the session if available

  $ProcedureName        = $_SESSION["proc_wizard"]["procedure_name"];
  $ProcedureType        = $_SESSION["proc_wizard"]["procedure_type"];
  $MainTable            = $_SESSION["proc_wizard"]["main_table"]["name"];
  $MainFields           = $_SESSION["proc_wizard"]["main_fields"];
  $MainColumns          = $_SESSION["proc_wizard"]["main_table"]["columns"];
  $SecondaryTables      = $_SESSION["proc_wizard"]["secondary_tables"];
  $SecondaryTableFields = $_SESSION["proc_wizard"]["secondary_table_fields"];
  
  // Save data and send user to next screen depending on button pressed

  if (isset($_POST["action"])) {

    $Action = $_POST["action"];
    $_SESSION["proc_wizard"]["action"] = $Action; 

    switch ($Action) {
      case "Continuar": // Store post data in session
      
        $SecondaryFields = array();
        $SecondaryLinks = array();

        if(is_array($SecondaryTables)){
          foreach($SecondaryTables as $Table){
            $TableFields = $_POST[$Table . "_fields"];
            
            if(is_array($TableFields)){
              foreach($TableFields as $Field){
                $SecondaryFields[$Table][$Field]["name"] = $Field;

                if(!empty($_POST[$Table . "_" . $Field])) {
                  $SecondaryLinks[$Table][$Field] = $Field;
                }
              }
            }
          }
        }
        
        $_SESSION["proc_wizard"]["secondary_fields"] = $SecondaryFields;
        $_SESSION["proc_wizard"]["secondary_links"]  = $SecondaryLinks; 

      break;
      case "Regresar": //This is when the user presses the "previous" button in step 5, 
        header("location: proc_wizard04.php"); // User should be sent to step 4
      break;
      default:
        // In this case, the default is OK, because we may have skipped step 5
    }
  }
  else {
    $Action = $_SESSION["proc_wizard"]["action"];
  }
  
  // Create parameter array, main fields first
  $Parameters      = array();      
  $ParameterTypes  = array();
  $TableParameters = array();  
        
  if(is_array($MainFields)){
    foreach($MainFields as $Field) {
      if($ProcedureType != "DELETE" || $MainColumns[$Field]["Key"] == "PRI") {
        $Name                                = "p_" . $Field;
        $Parameters[]                        = $Name;
        $TableParameters[$MainTable][$Field] = $Name;            
        $ParameterTypes[$Name]               = $MainColumns[$Field]["Type"];
      }
    }
  }  
  
  // Add secondary fields to parameter list, taking care of name collision
  if(is_array($SecondaryFields)){
    foreach($SecondaryFields as $TableKey => $Table){
          
      if(is_array($Table)){
        foreach($Table as $ColumnKey => $Column) {
              
          $Name = GetUniqueParamName($Parameters, "p_" . $ColumnKey);
                
          $Parameters[]                                        = $Name;
          $TableParameters[$TableKey][$ColumnKey]              = $Name;
          $ParameterTypes[$Name]                               = $SecondaryFields[$TableKey]["columns"][$ColumnKey]["Type"];
          $SecondaryFields[$TableKey][$ColumnKey]["parameter"] = $Name;
              
        }
      }
    }
  }

  $_SESSION["proc_wizard"]["secondary_fields"] = $SecondaryFields;
          
  // Add type data to parameters

  foreach($Parameters as $Key => $Parameter){
    $Parameters[$Key] = $Parameter . " " . $ParameterTypes[$Parameter]; 
  }            

  include("RecordBrowserHeader.php");

?>

<div id="RecordEditor">

  <div class="title">  
    <h1>Crear Procedimiento: Paso 6 de 6</h1>
  </div>

  <form name="proc_wizard06" method="post" action="proc_wizard01.php">
    <fieldset name="results"><legend>Resultado</legend>
      <textarea rows="20"><?php
            
        $SQL = "CREATE PROCEDURE $ProcedureName(\n  " . implode(", \n  ", $Parameters) . ")\n"
             .  "BEGIN\n\n";
            
        // Print SQL according to procedure type
        switch($ProcedureType){
        case "INSERT":
        
          $LastInsertId = array();
          // Declare last insert id variables, if necessary
          if(is_array($SecondaryLinks)) {

            foreach($SecondaryLinks as $TableKey => $Table) {
              if (is_array($Table)) {
                foreach($Table as $FieldKey => $Field) { 
                  if(!in_array($FieldKey, $LastInsertId)) {
                    array_push($LastInsertId, $FieldKey);
                  }
                }
              }
            }
  
            if(count($LastInsertId) > 0) {
              $SQL .= "DECLARE $Field " . $MainColumns[$LastInsertId[0]]["Type"] . ";\n";
            } 
            $SQL .= "\n";
          }
          
          
          // Create main table INSERT statement
        
          $SQL .= "  INSERT INTO $MainTable(" . implode(", ", $MainFields) 
               . ")\n  VALUES(" . implode(", ", $TableParameters[$MainTable]) . ");\n\n";
        
          // Get last insert id, if needed
          
          if(count($LastInsertId) > 0) {
            $SQL .= "  SELECT LAST_INSERT_ID() INTO " . $LastInsertId[0] . ";\n\n";
          }
          
          // Create secondary table inserts
          
          if(is_array($SecondaryTables)) { 
            foreach($SecondaryTables as $TableKey => $Table) {
            
              $SQL .= "  INSERT INTO $TableKey(";

              $SecondaryFieldList     = array();
              $SecondaryParameterList = array();
              
              if(is_array($SecondaryFields[$TableKey])) {
                foreach($SecondaryFields[$TableKey] as $ColumnKey => $Column) {
                
                  $SecondaryFieldList[] = $Column["name"];
                
                  if(isset($SecondaryLinks[$TableKey][$Column["name"]])) {
                    $SecondaryParameterList[] = $Column["name"];
                  } else {
                    $SecondaryParameterList[] = $Column["parameter"];
                  }
                }
              }
              
              $SQL .= implode(", ", $SecondaryFieldList) . ")\n"
                   .  "  VALUES(" . implode(", ", $SecondaryParameterList) . ");\n\n";
              
            }
          }
        
        break;
        case "UPDATE":
        
          // Organize parameters into "set" fields and "where" fields
        
          $WhereFields  = array();
          $Sets = array();        
                  
          if(is_array($MainFields)) {
            foreach($MainFields as $FieldKey => $Field) {            
              if($MainColumns[$FieldKey]["Key"] == "PRI") {
                $WhereFields[$FieldKey] = "$FieldKey = " . $TableParameters[$MainTable][$FieldKey]; 
              } else {
                $Sets[$FieldKey] = "$FieldKey = " . $TableParameters[$MainTable][$FieldKey];                 
              }
            }
          }
          
          // Create the main UPDATE statement with WHERE clause

          if(count($Sets) > 0) {
            $SQL .= "  UPDATE $MainTable set \n    " . implode(", \n    ", $Sets) . "\n";          
          }
                    
          if(count($WhereFields) > 0){
            $SQL .= "  WHERE " . implode("   AND ", $WhereFields) . ";\n\n";
          } else {
            $SQL .= ";\n\n";
          }
          
          // If there are secondary tables, create UPDATE statements for them

          if(is_array($SecondaryTables)){
            foreach($SecondaryTables as $TableKey => $Table){

              // Organize parameters into "set" fields and "where" fields
        
              $WhereFields  = array();
              $Sets = array();        
                                
              if(is_array($SecondaryFields[$TableKey])) {
                foreach($SecondaryFields[$TableKey] as $FieldKey => $Field) {   
                
                  $IsKey = $SecondaryTableFields[$TableKey]["columns"][$FieldKey]["Key"];  
                       
                  if($IsKey == "PRI") {
                    $WhereFields[$FieldKey] = "$FieldKey = " . $Field["parameter"]; 
                  } else {
                    $Sets[$FieldKey] = "$FieldKey = " . $Field["parameter"];                 
                  }
                }
              }
            
              if(count($Sets) > 0) {
                $SQL .= "  UPDATE $TableKey set \n    " . implode(", \n    ", $Sets) . "\n";
              }          
                    
              if(count($WhereFields) > 0){
                $SQL .= "  WHERE " . implode("   AND ", $WhereFields) . ";\n\n";
              } else {
                $SQL .= ";\n\n";
              }
            }
          }      
      
        break;
        case "DELETE":
        
          // Create main where clause
          
          $WhereFields = array();
          
          if(is_array($MainColumns)) {
            foreach($MainColumns as $FieldKey => $Field) {            
              if($Field["Key"] == "PRI") {
                $WhereFields[$FieldKey] = "$FieldKey = " . $TableParameters[$MainTable][$FieldKey]; 
              }
            }
          }

          if(count($WhereFields) > 0) { // SKIP EVERYTHING IF THE WHERE CLAUSE DOES NOT EXIST
          
            $MainWhereClause = "WHERE " . implode("   AND ", $WhereFields);

            // If there are secondary tables, create DELETE statements for them

            if(is_array($SecondaryTables)){
              foreach($SecondaryTables as $TableKey => $Table){
        
                $WhereFields  = array();
                                
                if(is_array($SecondaryTableFields[$TableKey]["columns"])) {
                  foreach($SecondaryTableFields[$TableKey]["columns"] as $FieldKey => $Field) {
                  
                    if($Field["Key"] == "PRI") {
                      if(isset($TableParameters[$MainTable][$FieldKey])) {          
                        $WhereFields[$FieldKey] = "$FieldKey = p_$FieldKey"; 
                      } else {
                        $Link = $SecondaryLinks[$TableKey][$FieldKey];
                        $WhereFields[$FieldKey] = "$FieldKey IN (SELECT $Link FROM $MainTable $MainWhereClause)";
                      }
                    }
                  }
                }
                                
                if(count($WhereFields) > 0){
                  $SQL .= "  DELETE $TableKey\n  WHERE " . implode("\n   AND ", $WhereFields) . ";\n\n";
                }
              }
            }      
                  
            // Create the main DELETE statement
          
            if(strlen($MainWhereClause) > 0){
              $SQL .= "  DELETE FROM $MainTable\n  $MainWhereClause;\n\n";
            }
          }         
                    
        break;
        default:
        }        
             
        $SQL .= "END\n";
      
        print($SQL);
      
      ?>
      
      </textarea>
      
      <?php 
        $_SESSION["proc_wizard"]["secondary_fields"] = $SecondaryFields;      
      ?>
            
    </fieldset>
    
    <fieldset class="ButtonPanel">
      <input type="submit" name="action" value="Regresar">
      <input type="submit" name="action" value="Volver a Empezar">
      <input type="submit" name="action" value="Crear Procedimiento Similar">
    </fieldset>
  </form>
  <div class="bottom">&nbsp;</div> 
</div>
<?php 
  
  include("GUIFooter.php");

?>