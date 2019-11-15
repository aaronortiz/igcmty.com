<?php 

  session_start();


  require("../Data/CheckLogin.php");

  include("../Presentation/Div.php");
  include("../Presentation/cls_HTMLForm.php");
  include("../Presentation/cls_EventQueue.php");
  include("../Presentation/cls_ScriptList.php");
  include("../Validation/Validation.php");

  $PreviousPage = "Expositores.php";

  include_once("../Presentation/cls_RecordBrowserHandler.php");

// Preparar objetos globales

  $BodyOnLoad = new EventQueue("OnLoad");
  $BodyOnLoad->QueueAdd("PrepararValidacionJS()");
  $BodyOnLoad->QueueAdd("document.frmEdicion.id_expositor.focus()");

  $ScriptList = new ScriptList();
  $ScriptList->Add("../Javascript/Validacion.js", "text/javascript");
  $ScriptList->Add("../Javascript/Expositor.js", "text/javascript");

  function Grabar($Formulario) {
  //=========================================================================//
  // Proposito: Grabar una creaci—n o una modificaci—n
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
  // Proposito: Grabar una creaci—n
  //_________________________________________________________________________//

    $Valores = array("'" . $_POST["nombres"] . "'",
                     "'" . $_POST["apellidos"] . "'");

    CallProcedure("prc_expositor_grabar_crear", $Valores);

    return true;

  }

  function GrabarModificar() {
  //=========================================================================//
  // Proposito: Grabar una modificaci—n
  //_________________________________________________________________________//

    $Valores = array("'" . $_SESSION["id_expositor"] . "'",
                     "'" . $_POST["nombres"] . "'",
                     "'" . $_POST["apellidos"] . "'");
    CallProcedure("prc_expositor_grabar_modificar", $Valores);

    return true;

  }

  function GrabarBorrar() {
  //=========================================================================//
  // Proposito: Grabar una eliminaci—n
  //_________________________________________________________________________//

    $id_expositor = $_POST["SQLIDField"];

    if(ExisteRegistro("mensajes", "id_expositor", "'$id_expositor'")) {
      $_SESSION["Error"] = "No puedes borrar esta registro; esta siendo utilizado.";
    } else {
      Execute("CALL prc_expositor_borrar($id_expositor)");
    }

  }

  function ImprimirHTML($Subtitle, $Formulario) {
  //=========================================================================//
  // Este c—digo genera la p‡gina de HTML que ver‡ el usuario
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
  // C—digo para iniciar las acciones Abrir, Crear y Borrar
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
        $Subtitle = "Abrir expositor '" . $FieldData["nombres"] . " " . $FieldData["apellidos"] . "'";
        break;
      case "Crear":
        $ButtonAction = "GrabarCrear";
        $frmEdicion = PrepararFormulario(array(), $ButtonAction);
        $Subtitle = "Crear expositor";
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
    $_SESSION["id_expositor"] = $SQLIDField;

    $Data       = Recordset("SELECT * FROM expositores WHERE id_expositor = '$SQLIDField' LIMIT 1");
    $FieldData  = $Data[0];

    return $FieldData;

  }

  function PrepararFormulario($FieldData, $ButtonAction) {
  //=========================================================================//
  // C—digo para configurar los campos del formulario
  //_________________________________________________________________________//

    $frmEdicion = new HTMLForm("frmEdicion", "POST", $_SERVER["PHP_SELF"], array());

    $Attributes = array("id" => "fstEdicion", "class" => "full_width");
    $frmEdicion->AddFieldset("fstEdicion", "Datos B&aacute;sicos", $Attributes);

    // Nombres
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["nombres"]);
    $frmEdicion->AddInputText("fstEdicion", "nombres", "Nombres", $Attributes);

    // Apellidos
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["apellidos"]);
    $frmEdicion->AddInputText("fstEdicion", "apellidos", "Apellidos", $Attributes);

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

    $Resultado = ValidarTexto($Form, "fstEdicion", "nombres", $BodyOnLoad);
    if($Resultado) $Resultado = ValidarTexto($Form, "fstEdicion", "apellidos", $BodyOnLoad);
    
    return $Resultado;

  }

//===========================================================================//
// Comienzo del c—digo principal
//___________________________________________________________________________//

  if(isset($_POST["Action"])) {         // Si estamos iniciando una acci—n

    IniciarAccion();

  } elseif(isset($_POST["Cancelar"])) { // Si estamos cancelando una acci—n

    header("location:$PreviousPage");

  } else {                              // Si estamos grabando una accion

    if (isset($_SESSION["frmEdicion"])) {

      $frmEdicion = unserialize($_SESSION["frmEdicion"]);
      $Subtitle = $_SESSION["Subtitle"];

      if(Grabar($frmEdicion))
        header("location:$PreviousPage");
      else                              // Si hubo error en la validaci—n
        $frmEdicion->SaveValues();
        ImprimirHTML($Subtitle, $frmEdicion);

    } else {                            // Si hubo algœn error no determinado
      header("location:$PreviousPage");
    }

  }

?>
