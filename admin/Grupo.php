<?php 

  session_start();

  require("../Data/CheckLogin.php");

  include("../Presentation/Div.php");
  include("../Presentation/cls_HTMLForm.php");
  include("../Presentation/cls_EventQueue.php");
  include("../Presentation/cls_ScriptList.php");
  include("../Validation/Validation.php");

  $PreviousPage = "Grupos.php";

  include_once("../Presentation/cls_RecordBrowserHandler.php");

// Preparar objetos globales

  $BodyOnLoad = new EventQueue("OnLoad");
  $BodyOnLoad->QueueAdd("PrepararValidacionJS()");
  $BodyOnLoad->QueueAdd("document.frmEdicion.id_grupo.focus()");

  $ScriptList = new ScriptList();
  $ScriptList->Add("../Javascript/Validacion.js", "text/javascript");
  $ScriptList->Add("../Javascript/Grupo.js", "text/javascript");

  function Grabar($Formulario) {
  //=========================================================================//
  // Proposito: Grabar una creación o una modificación
  //_________________________________________________________________________//

    $blnExito = false;

    if (isset($_POST["GrabarCrear"])) {
      if(Validar($Formulario)) {
        $blnExito = GrabarCrear();
      }
    } elseif(isset($_POST["GrabarModificar"])) {
      if(Validar($Formulario)) {
        $blnExito = GrabarModificar();
      }
    }

    return $blnExito;

  }

  function GrabarCrear() {
  //=========================================================================//
  // Proposito: Grabar una creación
  //_________________________________________________________________________//
     
    $HoraReunion = $_POST["hora_reunion"]["Hour"] . ":"
                 . $_POST["hora_reunion"]["Minute"] . ":"
                 . $_POST["hora_reunion"]["Second"];

    $Valores = array("'" . $_POST["nombre"] . "'",
                     "'" . $_POST["ubicacion"] . "'",
                     $_POST["dia_reunion"],
                     $_POST["id_lider_grupo"],
                     "'" . $_POST["url"] . "'",
                     "'" . $HoraReunion . "'");

    CallProcedure("prc_grupo_grabar_crear", $Valores);

    return true;

  }

  function GrabarModificar() {
  //=========================================================================//
  // Proposito: Grabar una modificación
  //_________________________________________________________________________//

    if(isset($_SESSION["id_grupo"])){ 
    
      $HoraReunion = $_POST["hora_reunion"]["Hour"] . ":"
                   . $_POST["hora_reunion"]["Minute"] . ":"
                   . $_POST["hora_reunion"]["Second"];
                  
      $Valores = array($_SESSION["id_grupo"],
                       "'" . $_POST["nombre"] . "'",
                       "'" . $_POST["ubicacion"] . "'",
                       $_POST["dia_reunion"],
                       $_POST["id_lider_grupo"],
                       "'" . $_POST["url"] . "'",
                       "'" . $HoraReunion . "'" );

      CallProcedure("prc_grupo_grabar_modificar", $Valores);

      return true;

    } else return false;

  }

  function GrabarBorrar() {
  //=========================================================================//
  // Proposito: Grabar una eliminación
  //_________________________________________________________________________//

    $id_grupo = $_POST["SQLIDField"];

    Execute("CALL prc_grupo_borrar($id_grupo)");

  }

  function ImprimirHTML($Subtitle, $Formulario) {
  //=========================================================================//
  // Este código genera la página de HTML que verá el usuario
  //_________________________________________________________________________//

    global $BodyOnLoad, $ScriptList;

    $HTML = "\n<div class=\"title\"><h1>Iglesia Gran Comisi&oacute;n</h1><h2>"
          . htmlentities($Subtitle, ENT_COMPAT/*, "utf-8", false*/) . "</h2></div>\n"
          . $Formulario->GenerateHTML()
          . "\n<div class=\"bottom\">&nbsp;</div>";
    $HTML = WrapDivAround($HTML, "", "RecordEditor");

    include("RecordBrowserHeader.php");

    print $HTML;

    include("GUIFooter.php");

  }

  function IniciarAccion(){
  //=========================================================================//
  // Código para iniciar las acciones Abrir, Crear y Borrar
  //_________________________________________________________________________//

    global $PreviousPage;

    $Action = $_POST["Action"];

    if($Action == "Borrar") {

      GrabarBorrar();
      header("location:$PreviousPage");

    } else {

      switch($Action) {
      case "Abrir":
        $FieldData    = ObtenerDatosAbrir();
        $ButtonAction = "GrabarModificar";
        $frmEdicion = PrepararFormulario($FieldData, $ButtonAction);
        $Subtitle = "Abrir grupo '" . $FieldData["titulo_grupo"] . "'";
        break;
      case "Crear":
        $ButtonAction = "GrabarCrear";
        $frmEdicion = PrepararFormulario(array(), $ButtonAction);
        $Subtitle = "Crear grupo";
        break;
      }

      $_SESSION["Subtitle"]   = $Subtitle;

      ImprimirHTML($Subtitle, $frmEdicion);

    }
  }

  function ObtenerDatosAbrir() {
  //=========================================================================//
  // Obtener los datos para abrir el formulario
  //_________________________________________________________________________//

    $FieldData              = array();
    $SQLIDField             = $_POST["SQLIDField"];
    $_SESSION["id_grupo"] = $SQLIDField;

    $Data       = Recordset("SELECT * FROM v_grupos WHERE id_grupo = '$SQLIDField' LIMIT 1");
    $FieldData  = $Data[0];

    return $FieldData;

  }

  function PrepararFormulario($FieldData, $ButtonAction) {
  //=========================================================================//
  // Código para configurar los campos del formulario
  //_________________________________________________________________________//

    $frmEdicion = new HTMLForm("frmEdicion", "POST", $_SERVER["PHP_SELF"], array());

    $Attributes = array("id" => "fstEdicion", "class" => "full_width");
    $frmEdicion->AddFieldset("fstEdicion", "Datos B&aacute;sicos", $Attributes);

    // Nombre
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["nombre"]);
    $frmEdicion->AddInputText("fstEdicion", "nombre", "Nombre", $Attributes);

    // Ubicacion
    $frmEdicion->AddTextArea("fstEdicion", "ubicacion", "Ubicacion", 3, 256, array(), $FieldData["ubicacion"]);    
                
    // Día de reunión
    $Semana[0] = "Domingo";
    $Semana[1] = "Lunes";
    $Semana[2] = "Martes";
    $Semana[3] = "Miercoles";
    $Semana[4] = "Jueves";
    $Semana[5] = "Viernes";
    $Semana[6] = "Sábado";
    $frmEdicion->AddSelect("fstEdicion", "dia_reunion", "Día Reunión", $Semana, array(), $FieldData["dia_reunion"]); 

    // Hora de reunión
    //print_r($FieldData); die();
    
    $HoraReunion = strtotime($FieldData["hora_reunion"]);
    $Hora    = date("G", $HoraReunion);
    $Minuto  = date("i", $HoraReunion);
    $Segundo = date("s", $HoraReunion);
    $frmEdicion->AddTimeSelect("fstEdicion", "hora_reunion", "Hora Reunión (24H)", $Hora, $Minuto, $Segundo, array());
    
    // Lider
    $SQL                   = array();
    $SQL["IDField"]        = "id_lider_grupo";
    $SQL["DisplayedField"] = "lider";
    $SQL["FromClause"]     = "FROM v_grupos_lideres";
    $SQL["DisplayKey"]     = false;
    $SQL["OrderByClause"]  = "ORDER BY nombres, apellidos ASC";

    $frmEdicion->AddSQLSelect("fstEdicion", "id_lider_grupo", "Líder grupo", $SQL, array(), $FieldData["id_lider_grupo"], false);    
               
    // URL
    $Attributes = array("size"        => "100",
                        "maxlength"   => "255",
                        "value"       => $FieldData["url"],
                        "placeholder" => "http://www.tuhermosositio.com/");
    $frmEdicion->AddInputText("fstEdicion", "url", "Dirección Web", $Attributes);

    $Attributes = array("id" => "fstButtonPanel", "class" => "ButtonPanel");
    $frmEdicion->AddFieldset("fstButtonPanel", "", $Attributes);

    $Attributes = array("onClick" => "return ValidarTodo();");
    $frmEdicion->AddSubmit($ButtonAction, "Grabar", $_SERVER["REQUEST_URI"], $Attributes, "fstButtonPanel", "icon_save");
    $frmEdicion->AddSubmit("Cancelar", "Cancelar", $_SERVER["REQUEST_URI"], array(), "fstButtonPanel", "icon_cancel");

    $_SESSION["frmEdicion"] = serialize($frmEdicion);

    return $frmEdicion;

  }

  function Validar($Form) {
  //=========================================================================//
  // Proposito: Validar la forma por si Javascript no lo hizo
  //_________________________________________________________________________//

    global $BodyOnLoad;

    $Resultado = ValidarTexto($Form, "fstEdicion", "nombre", $BodyOnLoad, 2);

    return $Resultado;

  }

//===========================================================================//
// Comienzo del código principal
//___________________________________________________________________________//

  if(isset($_POST["Action"])) {         // Si estamos iniciando una acción

    IniciarAccion();

  } elseif(isset($_POST["Cancelar"])) { // Si estamos cancelando una acción

    header("location:$PreviousPage");

  } else {                              // Si estamos grabando una accion

    if (isset($_SESSION["frmEdicion"])) {

      $frmEdicion = unserialize($_SESSION["frmEdicion"]);
      $Subtitle = $_SESSION["Subtitle"];

      if(Grabar($frmEdicion))
        header("location:$PreviousPage");
      else                              // Si hubo error en la validación
        $frmEdicion->SaveValues();
        ImprimirHTML($Subtitle, $frmEdicion);

    } else {                            // Si hubo algún error no determinado
      header("location:$PreviousPage");
    }

  }

?>
