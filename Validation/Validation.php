<?php

  include_once("../Data/MySQL.php");
  
  
  function ExtraerNombreCampo($Form, $Fieldset, $Control) {
  //-------------------------------------------------------------------------//
  // Propósito: Extraer la información del nombre de un campo
  //-------------------------------------------------------------------------//
  
    return htmlentities($Form->Fieldsets[$Fieldset]->Controls[$Control]->Label, ENT_COMPAT, 'utf-8', false);
    
  }
  

  function ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad) {
  //-------------------------------------------------------------------------//
  // Propósito: Extraer la información del tamaño de un campo
  //-------------------------------------------------------------------------//

    $MaxLength = $Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes["maxlength"];
    if (!isset($MaxLength))
      $MaxLength = $Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes["MAXLENGTH"];
    if (!isset($MaxLength))
      $MaxLength = $Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes["size"];
    if (!isset($MaxLength))
      $MaxLength = $Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes["SIZE"];

    if(isset($MaxLength))
      return $MaxLength;
    else {

      $Campo    = htmlentities($Form->Fieldsets[$Fieldset]->Controls[$Control]->Label, ENT_COMPAT, 'utf-8');
      $Mensaje  = "Error de HTML: El campo <em>$Campo</em> no tiene un largo definido";
      $Form->AddErrorMessage($Mensaje, $Fieldset, $Control);
      return 0;

    }
  }
  
  function ExtraerValor($Campo) {
  //-------------------------------------------------------------------------//
  // Propósito: extraer el valor de un campo, especialmente cuando este es
  //            parte de un arreglo
  //-------------------------------------------------------------------------//  

    if (isset($_POST[$Campo])) {
      $Valor = $_POST[$Campo];
    } else {
      // Test for arrays in the control names
      $PosStart = strpos($Campo, "[");
      $PosEnd = strpos($Campo, "]");

      if (!($PosStart === false || $PosEnd  === false)) {
        $Control = substr($Campo, 0, $PosStart);
        $Index   = substr($Campo, $PosStart + 1, $PosEnd - $PosStart - 1);    
        $Valor = $_POST[$Control][$Index];
      }
    }

    return $Valor;

  }

  function ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje) {
  //-------------------------------------------------------------------------//
  // Propósito: Usar expresiones regulares para prober un valor
  //            utliza &c como token para el nombre del campo
  //-------------------------------------------------------------------------//

    $ConError = false;

    $Valor      = ExtraerValor($Control);
    $Habilitado = VerificarHabilitado($Form, $Fieldset, $Control);

    if($Habilitado === true) {
      if(!preg_match($Regex, $Valor, $Matches)) {

        $ConError = true;
        $Campo    = ExtraerNombreCampo($Form, $Fieldset, $Control);
        $Mensaje  = str_replace("&c", $Campo, $Mensaje);

        RegistrarError($Form, $Fieldset, $Control, $BodyOnLoad, $Mensaje);

      } 
    }

    return $ConError;

  }

  function RegistrarError($Form, $Fieldset, $Control, $BodyOnLoad, $Mensaje) {
  //-------------------------------------------------------------------------//
  // Propósito: Registrar en error en el formulario
  //-------------------------------------------------------------------------//

    $Form->AddErrorMessage($Mensaje, $Fieldset, $Control);

    $BodyOnLoad->Clear();
    $BodyOnLoad->QueueAdd("document." . $Form->Name . ".$Control.focus()");
  
  }

  function ValidarClavesCoinciden($Form, $Fieldset, $Control1, $Control2, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError   = false;
    $MaxLength1 = ExtraerTamaño($Form, $Fieldset, $Control1, $BodyOnLoad);
    $MaxLength2 = ExtraerTamaño($Form, $Fieldset, $Control2, $BodyOnLoad);



    if ($MaxLength1 == 0 || $MaxLength2 == 0) {

      $ConError = true;
      $Mensaje  = "Error en el código HTML.";

      RegistrarError($Form, $Fieldset, $Control1, $BodyOnLoad, $Mensaje);
      RegistrarError($Form, $Fieldset, $Control2, $BodyOnLoad, $Mensaje);

    } else {

      $Regex = "/^[\w]{" . $MinLength . "," . $MaxLength . "}$/";
      $Mensaje  = "Escoge una clave alfanum&eacute;rica de 6 a 8 posiciones.";

      $ConError = ProbarValor($Form, $Fieldset, $Control1, $BodyOnLoad, $Regex, $Mensaje);

      if(!($ConError || $_POST[$Control1] == $_POST[$Control2])) {
        $ConError = true;
        $Mensaje  = "Claves no coinciden";

        RegistrarError($Form, $Fieldset, $Control2, $BodyOnLoad, $Mensaje);
      }
    }

    return !$ConError;

  }
  
  function ValidarExiste($Form, $Fieldset, $Control, $BodyOnLoad, $Tabla, $Campo, $And = "") {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradano exista ya antes de grabar
  //-------------------------------------------------------------------------//
  
    $ConError = false;

    $Valor       = ExtraerValor($Control);
    $NombreCampo = ExtraerNombreCampo($Form, $Fieldset, $Control);
  
    $From = "FROM $Tabla";
    
    $Where = "WHERE $Campo = '$Valor' $And";
  
    if(ExisteRegistroFromWhere($From, $Where)) {
    
      $Mensaje  = "El <em>$NombreCampo</em> '$Valor' ya existe en la base de datos";

      RegistrarError($Form, $Fieldset, $Control, $BodyOnLoad, $Mensaje);    
     
       $ConError = true;
      
    }
    
    return !$ConError;
    
  }
  function ValidarLetras($Form, $Fieldset, $Control, $BodyOnLoad) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0)
      $ConError = true;
    else {
      $Regex = "/[A-Z|a-z]{1,$MaxLength}$/";
      $Mensaje  = "El campo <em>&c</em> solo permite letras";
  
      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }  

  function ValidarMonedaPositivo($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0) 
      $ConError = true;
    else {
//      $Regex = "/^\d+(\.[\d]{1,2})?$/";
      $Regex = "/^\d{1,3}((,?\d{3})?)*(\.[\d]{1,2})?$/";
      $Mensaje  = "Ingresa un valor moneda positivo en el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }

  function ValidarNumerico($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0) 
      $ConError = true;
    else {
      $Regex = "/[\d.,]{" . $MinLength . "," . $MaxLength . "}$/";
      $Mensaje  = "Ingresa un n&uacute;mero en el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }

  function ValidarNumericoPositivo($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0) 
      $ConError = true;
    else {
      $Regex = "/^\d{1,3}((,?\d{3})?)*(\.[\d]{1,2})?$/";
      $Mensaje  = "Ingresa un n&uacute;mero positivo en el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }
 
  function ValidarTelefono($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 7) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0) 
      $ConError = true;
    else {
      $Regex = "/[\d-+ ()]{" . $MinLength . "," . $MaxLength . "}$/";
      $Mensaje  = "Ingresa un n&uacute;mero de tel&eacute;fono v&aacute;lido en el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }  

  function ValidarEmail($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 7) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0) 
      $ConError = true;
    else {
      $Regex = "/^[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,4}$/";
      $Mensaje  = "Ingresa un correo electr&oacute;nico v&aacute;lido en el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }  

  function ValidarTexto($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);

    if ($MaxLength == 0)
      $ConError = true;
    else {
      $Regex = "/[^\r\n<>`]{" . $MinLength . "," . $MaxLength . "}$/";
      if(strlen(ExtraerValor($Control)) > $MaxLength)
        $Mensaje  = "Llena el campo <em>&c</em> con al menos $MinLength posiciones, $MaxLength m&aacute;ximo";
      else {
        if($MinLength > 1)
          $Mensaje  = "Llena el campo <em>&c</em> con al menos $MinLength posiciones.";
        else
          $Mensaje  = "Por favor llena el campo <em>&c</em>";
      }
      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }

  function ValidarTextoEstricto($Form, $Fieldset, $Control, $BodyOnLoad, $MinLength = 1) {
  //-------------------------------------------------------------------------//
  // Propósito: validar que las entradas estén bien antes de grabar
  //-------------------------------------------------------------------------//

    $ConError  = false;
    $MaxLength = ExtraerTamaño($Form, $Fieldset, $Control, $BodyOnLoad);


    if ($MaxLength == 0) 
      $ConError = true;
    else {
      $Regex = "/^[\w\s]{" . $MinLength . "," . $MaxLength . "}$/";
      $Mensaje  = "Por favor llena el campo <em>&c</em>";

      $ConError = ProbarValor($Form, $Fieldset, $Control, $BodyOnLoad, $Regex, $Mensaje);
    }

    return !$ConError;

  }

  function VerificarHabilitado($Form, $Fieldset, $Control) {
  //-------------------------------------------------------------------------//
  // Propósito: verificar si el control está habilitado o no
  //-------------------------------------------------------------------------//
  
    $Habilitado = true;
  
    if(count($Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes)>0) {
      foreach($Form->Fieldsets[$Fieldset]->Controls[$Control]->Attributes as $Attribute) {
        if(strtoupper($Attribute) == "DISABLED") 
          $Habilitado = false;
      }
    }

    return $Habilitado;

  }

?>
