<?php

class WhereClauseParser {
//============================================================================//
// Purpose: Make the parsing of WHERE clauses easier
//============================================================================//

  private $Conditions;
  
  public function __construct() {
  //==========================================================================//
  // Purpose: set the initial state of the object on creation
  //__________________________________________________________________________//

    $this->Conditions = array();
  
  }
  
  public function AddCondition($LeftOperand, $RightOperand, $Operator = "=", 
                               $Conjuntion = "AND") {
  //==========================================================================//
  // Purpose: Add a condition to the clause
  //__________________________________________________________________________//
  
    $this->Conditions[] = array("LeftOperand" => $LeftOperand,
                                "RightOperand" => $RightOperand,
                                "Operator" => $Operator,
                                "Conjunction" => $Conjuntion);

  }

  public function AddBetween($LeftOperand, $LowRightOperand, $HighRightOperand, 
                               $Conjuntion = "AND") {
  //==========================================================================//
  // Purpose: Add a condition to the clause
  //__________________________________________________________________________//
  
    $this->Conditions[] = array("LeftOperand" => $LeftOperand,
                                "RightOperand" => $LowRightOperand . 
                                " AND " . $HighRightOperand,
                                "Operator" => "BETWEEN",
                                "Conjunction" => $Conjuntion);

  }
  
  public function AddIn($LeftOperand, $Values, $Not = false, $Conjuntion = "AND") {
  //==========================================================================//
  // Purpose: Add an "IN" condition to the clause
  //__________________________________________________________________________//
  
    if(count($Values) > 0) {
  
      $Operator = ($Not === true) ? "NOT IN" : "IN";
    
      // Crear una lista separada por comas de los valores
      $ValueString = "('" . implode("', '", $Values) . "')";
    
      $this->Conditions[] = array("LeftOperand"  => $LeftOperand,
                                  "RightOperand" => $ValueString,
                                  "Operator"     => "IN",
                                  "Conjunction"  => $Conjuntion);
    }  
  }

  public function GetClause() {
  //==========================================================================//
  // Purpose: Obtain the parsed clause
  //__________________________________________________________________________//
      
    $SQL = "";
    
    foreach($this->Conditions as $Index => $Condition) {

      if($Index == 0) { 
        $SQL = "WHERE ";
      } else {
        $Conjunction = $Condition["Conjunction"];
        $SQL .= "\n  $Conjunction ";
      }

      $SQL .= $Condition["LeftOperand"] . " " 
           .  $Condition["Operator"] . " " 
           .  $Condition["RightOperand"];
      
    }
      
    return $SQL;
  
  }
  
  public function GetCount() {
  //==========================================================================//
  // Purpose: Obtain the number of conditions in the clause
  //__________________________________________________________________________//
  
    return count($this->Conditions);
    
  } 

}
