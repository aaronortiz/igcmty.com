<?php 

  session_start();


  require("../Data/CheckLogin.php");

  include("../Presentation/Div.php");
  include("../Presentation/cls_HTMLForm.php");
  include("../Presentation/cls_EventQueue.php");
  include("../Presentation/cls_ScriptList.php");
  include("../Validation/Validation.php");

  $PreviousPage = "LideresGrupo.php";

  include_once("../Presentation/cls_RecordBrowserHandler.php");

// Preparar objetos globales

  $BodyOnLoad = new EventQueue("OnLoad");
  $BodyOnLoad->QueueAdd("PrepararValidacionJS()");
  $BodyOnLoad->QueueAdd("document.frmEdicion.id_lider_grupo.focus()");

  $ScriptList = new ScriptList();
  $ScriptList->Add("../Javascript/Validacion.js", "text/javascript");
  $ScriptList->Add("../Javascript/Expositor.js", "text/javascript");

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

    $Valores = array("'" . $_POST["nombres"] . "'",
                     "'" . $_POST["apellidos"] . "'",
                     "'" . $_POST["telefono"] . "'",
                     "'" . $_POST["email"] . "'");

    CallProcedure("prc_lider_grupo_grabar_crear", $Valores);

    return true;

  }

  function GrabarModificar() {
  //=========================================================================//
  // Proposito: Grabar una modificación
  //_________________________________________________________________________//

    $Valores = array("'" . $_SESSION["id_lider_grupo"] . "'",
                     "'" . $_POST["nombres"] . "'",
                     "'" . $_POST["apellidos"] . "'",
                     "'" . $_POST["telefono"] . "'",
                     "'" . $_POST["email"] . "'");
    CallProcedure("prc_lider_grupo_grabar_modificar", $Valores);

    return true;

  }

  function GrabarBorrar() {
  //=========================================================================//
  // Proposito: Grabar una eliminación
  //_________________________________________________________________________//

    $id_lider_grupo = $_POST["SQLIDField"];

    if(ExisteRegistro("grupos", "id_lider_grupo", "'$id_lider_grupo'")) {
      $_SESSION["Error"] = "No puedes borrar esta registro; esta siendo utilizado.";
    } else {
      Execute("CALL prc_lider_grupo_borrar($id_lider_grupo)");
    }

  }

  function ImprimirHTML($Subtitle, $Formulario) {
  //=========================================================================//
  // Este código genera la página de HTML que verá el usuario
  //_________________________________________________________________________//

    global $BodyOnLoad, $ScriptList;

    $HTML = "\n<div class=\"title\"><h1>Iglesia Gran Comisi&oacute;n</h1><h2>"
          . htmlentities($Subtitle, ENT_COMPAT, "utf-8", false) . "</h2></div>\n"
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
        $Subtitle = "Abrir Líder de Grupo '" . $FieldData["nombres"] . " " . $FieldData["apellidos"] . "'";
        break;
      case "Crear":
        $ButtonAction = "GrabarCrear";
        $frmEdicion = PrepararFormulario(array(), $ButtonAction);
        $Subtitle = "Crear Líder de Grupo";
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
    $_SESSION["id_lider_grupo"] = $SQLIDField;

    $Data       = Recordset("SELECT * FROM grupos_lideres WHERE id_lider_grupo = '$SQLIDField' LIMIT 1");
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

    // Teléfono
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["telefono"]);
    $frmEdicion->AddInputTel("fstEdicion", "telefono", "Teléfono", $Attributes);

    // Email
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["email"]);
    $frmEdicion->AddInputEmail("fstEdicion", "email", "Email", $Attributes);

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
    $Resultado = ValidarTexto($Form, "fstEdicion", "apellidos", $BodyOnLoad) && $Resultado;
//    $Resultado = ValidarTexto($Form, "fstEdicion", "telefono", $BodyOnLoad) && $Resultado;
    $Resultado = ValidarTelefono($Form, "fstEdicion", "telefono", $BodyOnLoad) && $Resultado;
//    $Resultado = ValidarTexto($Form, "fstEdicion", "email", $BodyOnLoad) && $Resultado;
    $Resultado = ValidarEmail($Form, "fstEdicion", "email", $BodyOnLoad) && $Resultado;
    
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
