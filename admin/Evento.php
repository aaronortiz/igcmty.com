<?php 

  session_start();

  require("../Data/CheckLogin.php");

  include("../Presentation/Div.php");
  include("../Presentation/cls_HTMLForm.php");
  include("../Presentation/cls_EventQueue.php");
  include("../Presentation/cls_ScriptList.php");
  include("../Validation/Validation.php");

  $PreviousPage = "Eventos.php";

  include_once("../Presentation/cls_RecordBrowserHandler.php");

// Preparar objetos globales

  $BodyOnLoad = new EventQueue("OnLoad");
  $BodyOnLoad->QueueAdd("PrepararValidacionJS()");
  $BodyOnLoad->QueueAdd("document.frmEdicion.id_evento.focus()");

  $ScriptList = new ScriptList();
  $ScriptList->Add("../Javascript/Validacion.js", "text/javascript");
  $ScriptList->Add("../Javascript/Evento.js", "text/javascript");

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

    $Fecha = $_POST["fecha"]["Year"] . "-" 
           . $_POST["fecha"]["Month"] . "-" 
           . $_POST["fecha"]["Day"];

    $FechaFin = $_POST["fecha_fin"]["Year"] . "-" 
              . $_POST["fecha_fin"]["Month"] . "-" 
              . $_POST["fecha_fin"]["Day"];
     
    $OcultarPrecio = (isset($_POST["ocultar_precio"])) ? 1 : 0;         

    $Valores = array("'" . $_POST["titulo_evento"] . "'",
                     "'" . $_POST["subtitulo_evento"] . "'",
                     "'" . $_POST["resumen_evento"] . "'",
                     "'" . $Fecha . "'",
                     "'" . $FechaFin . "'",
                     "'" . $_POST["horario"] . "'",
                     "'" . $_POST["lugar"] . "'",
                     "'" . $_POST["precio"] . "'",
                       $OcultarPrecio);

    CallProcedure("prc_evento_grabar_crear", $Valores);

    return true;

  }

  function GrabarModificar() {
  //=========================================================================//
  // Proposito: Grabar una modificación
  //_________________________________________________________________________//

    if(isset($_SESSION["id_evento"])){ 

      $Fecha = $_POST["fecha"]["Year"] . "-" 
             . $_POST["fecha"]["Month"] . "-" 
             . $_POST["fecha"]["Day"];

      $FechaFin = $_POST["fecha_fin"]["Year"] . "-" 
                . $_POST["fecha_fin"]["Month"] . "-" 
                . $_POST["fecha_fin"]["Day"];
                
      $OcultarPrecio = (isset($_POST["ocultar_precio"])) ? 1 : 0;         

      $Valores = array($_SESSION["id_evento"],
                       "'" . $_POST["titulo_evento"] . "'",
                       "'" . $_POST["subtitulo_evento"] . "'",
                       "'" . $_POST["resumen_evento"] . "'",
                       "'" . $Fecha . "'",
                       "'" . $FechaFin . "'",
                       "'" . $_POST["horario"] . "'",
                       "'" . $_POST["lugar"] . "'",
                       "'" . $_POST["precio"] . "'",
                       $OcultarPrecio);

      CallProcedure("prc_evento_grabar_modificar", $Valores);

      return true;

    } else return false;

  }

  function GrabarBorrar() {
  //=========================================================================//
  // Proposito: Grabar una eliminación
  //_________________________________________________________________________//

    $id_evento = $_POST["SQLIDField"];

    Execute("CALL prc_evento_borrar($id_evento)");

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
        $Subtitle = "Abrir evento '" . $FieldData["titulo_evento"] . "'";
        break;
      case "Crear":
        $ButtonAction = "GrabarCrear";
        $frmEdicion = PrepararFormulario(array(), $ButtonAction);
        $Subtitle = "Crear evento";
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
    $_SESSION["id_evento"] = $SQLIDField;

    $Data       = Recordset("SELECT * FROM v_eventos WHERE id_evento = '$SQLIDField' LIMIT 1");
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

    // Titulo
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["titulo_evento"]);
    $frmEdicion->AddInputText("fstEdicion", "titulo_evento", "Título", $Attributes);

    // Subtitulo
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["subtitulo_evento"]);
    $frmEdicion->AddInputText("fstEdicion", "subtitulo_evento", "Subtítulo", $Attributes);
    
  //  print_r($FieldData); die();
      
    // Resumen
    $frmEdicion->AddTextArea("fstEdicion", "resumen_evento", "Resumen", 3, 500, array(), $FieldData["resumen_evento"]);
      
    // Fecha
    $Año = $FieldData["an_o"];
    $Mes = $FieldData["mes"];
    $Dia = $FieldData["dia"];
    
    $frmEdicion->AddDateSelect("fstEdicion", "fecha", "Fecha", $Año, $Mes, $Dia);

    // Fecha Fin
    $AñoFin = $FieldData["an_o_fin"];
    $MesFin = $FieldData["mes_fin"];
    $DiaFin = $FieldData["dia_fin"];
    
    $frmEdicion->AddDateSelect("fstEdicion", "fecha_fin", "Fecha Fin", $AñoFin, $MesFin, $DiaFin);
    
    // Horario
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["horario"]);
    $frmEdicion->AddInputText("fstEdicion", "horario", "Horario", $Attributes);

    // Lugar
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["lugar"]);
    $frmEdicion->AddInputText("fstEdicion", "lugar", "Lugar", $Attributes);
    
    // Precio
    $Attributes = array("size"      => "32",
                        "maxlength" => "64",
                        "value"     => $FieldData["precio"]);
    $frmEdicion->AddInputText("fstEdicion", "precio", "Precio", $Attributes);
      
    // Ocultar precio
    if($FieldData["ocultar_precio"] == 1)
      $Attributes = array("checked");
    else
      $Attributes = array();
      
    $frmEdicion->AddInputCheckbox("fstEdicion", "ocultar_precio", "Ocultar Precio", $Attributes);  
      
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

    $Resultado = ValidarTexto($Form, "fstEdicion", "titulo_evento", $BodyOnLoad, 2);
    $Resultado = $Resultado && ValidarTexto($Form, "fstEdicion", "horario", $BodyOnLoad, 2);
    $Resultado = $Resultado && ValidarTexto($Form, "fstEdicion", "lugar", $BodyOnLoad, 2);
    $Resultado = $Resultado && ValidarMonedaPositivo($Form, "fstEdicion", "precio", $BodyOnLoad);

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
