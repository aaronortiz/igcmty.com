<?php

include_once("MySQL.php");

class SQLQuery {
//============================================================================//
// Purpose: Encapsulate the essential components of an SQL query
//============================================================================//


  protected $Fields;          // 2 dimensinal array of headers and fields to be displayed
  protected $FromClause;      // the FROM clause of the query
  protected $WhereClause;     // the WHERE clause of the query
  protected $OrderByClause;   // the ORDER BY clause of the query
  protected $GroupByClause;   // the GROUP BY cluase of the query  
  protected $Limit;           // Limits the number of records returned by the query
  protected $LimitStart;      // Starting record for retrieval

  private $Recordset     = array();
  private $Resultset;
  private $DataIsCurrent = FALSE;
  private $FieldCount    = 0;
  private $RowCount      = 0;
  private $MetaData      = array();

  public function __construct($Fields, $FromClause, $WhereClause = "",
                              $OrderByClause = "", $GroupByClause = "", $Limit = 0) {
  //==========================================================================//
  // Purpose: set the initial state of the object on creation
  //__________________________________________________________________________//

    $this->Fields          = $Fields;
    $this->FromClause      = $FromClause;
    $this->WhereClause     = $WhereClause;
    $this->OrderByClause   = $OrderByClause;
    $this->GroupByClause   = $GroupByClause;
    $this->Limit           = $Limit;
    $this->FieldCount      = count($Fields);

    $this->DataIsCurrent = FALSE;

  }

  public function SetFields($Fields) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->Fields
  //__________________________________________________________________________//

    if (is_array($Fields) && $this->FieldCount > 0) {
      $this->Fields        = $Fields;
      $this->FieldCount    = count($Fields);
      $this->DataIsCurrent = FALSE;
    }

  }

  public function SetFromClause($FromClause) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->FromClause
  //__________________________________________________________________________//

    if (strlen($FromClause) > 0) {
      $this->FromClause    = $FromClause;
      $this->DataIsCurrent = FALSE;
    }

  }

  public function SetWhereClause($WhereClause) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->WhereClause
  //__________________________________________________________________________//

    if (strlen($WhereClause) > 0) {
      $this->WhereClause   = $WhereClause;
      $this->DataIsCurrent = FALSE;
    }

  }

  public function SetOrderByClause($OrderByClause) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->OrderByClause
  //__________________________________________________________________________//

    if (strlen($OrderByClause) > 0) {
      $this->OrderByClause = $OrderByClause;
      $this->DataIsCurrent = FALSE;
    }

  }

  public function SetGroupByClause($GroupByClause) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->GroupByClause
  //__________________________________________________________________________//

    if (strlen($GroupByClause) > 0) {
      $this->GroupByClause = $GroupByClause;
      $this->DataIsCurrent = FALSE;
    }

  }

  public function SetLimit($Limit, $LimitStart = 0) {
  //==========================================================================//
  // Purpose: Sets a new value for $this->Limit
  //__________________________________________________________________________//

    $this->Limit         = $Limit;
    $this->LimitStart    = $LimitStart;
    $this->DataIsCurrent = FALSE;

  }

  protected function ParseFieldList() {
  //--------------------------------------------------------------------------//
  // Purpose: Parse the field list
  //--------------------------------------------------------------------------//

    $strList  = "";
    $strComma = "";


    foreach ($this->Fields as $Item) {

      $strList .= $strComma . "$Item";

      if (strlen($strComma == 0)) {
        $strComma = ", ";
      }

    }

    return $strList;

  }

  protected function CreateQuery() {
  //--------------------------------------------------------------------------//
  // Purpose: Create SQL query based on the contents of the array $this->SQL
  //--------------------------------------------------------------------------//

    $Fields          = $this->Fields;
    $FromClause      = $this->FromClause;
    $WhereClause     = $this->WhereClause;
    $OrderByClause   = $this->OrderByClause;
    $GroupByClause   = $this->GroupByClause;
    $Limit           = $this->Limit;
    $LimitStart      = $this->LimitStart;

    if ($this->FieldCount > 0 && strlen($FromClause) > 0) {

      $SQL = "SELECT " . $this->ParseFieldList() . "\n"
           . $FromClause;

      if (strlen($WhereClause) > 0)
        $SQL .= "\n" . $WhereClause;
      if (strlen($OrderByClause) > 0)
        $SQL .= "\n" . $OrderByClause;
      if (strlen($GroupByClause) > 0)
        $SQL .= "\n" . $GroupByClause;

      if ($Limit > 0)
         if ($LimitStart > 0)
           $SQL .= "\nLIMIT $LimitStart, $Limit";
         else
           $SQL .= "\nLIMIT $Limit";

    } else {
      die("Error creating query. Field count: $this->FieldCount FROM Clause: $FromClause");
    }

    $this->Query = $SQL;

  }

  public function Refresh() {
  //--------------------------------------------------------------------------//
  // Purpose: Refresh the data
  //--------------------------------------------------------------------------//

    $this->Recordset = array();
    $this->Metadata  = array();
    unset($this->Resultset);

    $this->CreateQuery();

    $this->Resultset = Query($this->Query);

    // Collect meta-data
    if ($this->Resultset){
      for($i = 0; $i < $this->FieldCount; $i++) {
        $this->MetaData[$this->Fields[$i]] = mysqli_fetch_field($this->Resultset, $i);
        $FieldData = mysqli_fetch_field_direct($this->Resultset, $i);
        if($FieldData) {
          $this->MetaData[$this->Fields[$i]]->max_length = $FieldData->length . " ";
        }
        //$this->MetaData[$this->Fields[$i]]->max_length = mysqli_field_len($this->Resultset, $i) . " ";
        
      }
    }

    // Transfer result to 2 dimensional array
    for($i = 0; $Row = mysqli_fetch_array($this->Resultset); $i++) {
      $this->Recordset[$i] = $Row;    
    }

    $this->RowCount = count($this->Recordset);
    $this->DataIsCurrent = TRUE;

  }

  public function GetRecordset() {
  //--------------------------------------------------------------------------//
  // Purpose: Return the data as a 2 dimensional array. Refreshes if necessary
  //--------------------------------------------------------------------------//

    if (!$this->DataIsCurrent)
      $this->Refresh();

    return $this->Recordset;

  }

  public function GetResult() {
  //--------------------------------------------------------------------------//
  // Purpose: Return the data as a PHP MySQL result set. Refreshes if necessary
  //--------------------------------------------------------------------------//

    if (!$this->DataIsCurrent)
      $this->Refresh();

    return $this->Resultset;

  }

  public function GetQuery() {
  //--------------------------------------------------------------------------//
  // Purpose: Return the query. Re-creates it if necessary
  //--------------------------------------------------------------------------//

    if (!$this->DataIsCurrent)
      $this->CreateQuery();

    return $this->Query;

  }

  public function GetMetaData() {
  //--------------------------------------------------------------------------//
  // Purpose: Returns the meta data for the query
  //--------------------------------------------------------------------------//

    $TempLimit = $this->Limit;

    if (!$this->DataIsCurrent) {

      $this->CreateQuery();
      $this->Limit = 1;
      $this->Refresh();
      $this->Limit = $TempLimit;

    }

    return $this->MetaData;

  }

  public function GetFieldMetaData($Field) {
  //--------------------------------------------------------------------------//
  // Purpose: Returns the meta data for a field
  //--------------------------------------------------------------------------//

    $TempLimit = $this->Limit;

    if (!$this->DataIsCurrent) {

      $this->CreateQuery();
      $this->Limit = 1;
      $this->Refresh();
      $this->Limit = $TempLimit;

    }

    return $this->MetaData[$Field];

  }

  public function GetRowCount() {
  //--------------------------------------------------------------------------//
  // Purpose: Returns the current row count for the query
  //          If the query has a limit or hasn't been run yet,
  //          does a COUNT(*) query
  //--------------------------------------------------------------------------//

    if ($this->Limit > 0 || !$this->DataIsCurrent) {

      $Query = "SELECT COUNT(*) as RowCount $this->FromClause $this->WhereClause";
      $Result = Recordset($Query);
      return $Result[0]["RowCount"];

    } else {
      return $this->RowCount;
    }

  }

}
