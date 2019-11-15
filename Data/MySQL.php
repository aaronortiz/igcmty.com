<?php

  $Host       = "localhost";
  $DBName     = "aeortizc_mensajes";

function SetCharacterVariables($Link) {

  mysqli_set_charset($Link, 'utf8') or die("Fallo cambiar conjunto de caracteres a unicode internacional (UTF8)");
  mysqli_query($Link, "SET COLLATION_CONNECTION = 'utf8_general_ci'") or die ("Fall&oacute; cambiar lenguaje de la conexi&oacute;n a internacional, UTF8, colaci&oacute;n utf8_general_ci. " . mysqli_error($Link));

}

function GetLink() {

  global $DBName, $Host;

  $Link = mysqli_connect($Host, 
                         $_SESSION["Username"], 
                         $_SESSION["Password"],
                         $DBName) or die("<p>GetLink: Fall&oacute; la conexi&oacute;n al servidor $Host con el usuario " . $_SESSION['Username'] . ".</p><p>" . mysqli_error() . "</p>");
  
  SetCharacterVariables($Link);
  return $Link;

}

function Execute($SQL) {

  global $DBName;

  $Link = GetLink();

  mysqli_query($Link, $SQL) or die("<p>Execute: Fall&oacute; la b&uacute;squeda en la base de datos<br />". $SQL . "</p><p>" . mysqli_error() . "</p>");

}

function Query($Query) {

  global $DBName;

  $Link = GetLink();

  SetCharacterVariables($Link);

  $Result = mysqli_query($Link, $Query) or die("<p>Query: Fall&oacute; la b&uacute;squeda en la base de datos<br />$Query</p><p>" . mysqli_error() . "</p>");

  return $Result;

}

function Recordset($Query) {

  global $DBName;

  $Link = GetLink();

  $Result = mysqli_query($Link, $Query) or die("<p>Fall&oacute; la b&uacute;squeda en la base de datos<br />$Query</p><p>" . mysqli_error() . "</p>");

  for($i=0; $Row = mysqli_fetch_array($Result); $i++) {
    $Array[$i] = $Row;
  }

  return $Array;

}

function ExisteRegistro($Tabla, $Campo, $Valor) {

  global $DBName;

  $Link = GetLink();

  if(!(is_numeric($Valor) || substr($Valor, 0, 1) == "'")) $Valor = "'" . $Valor . "'";

  $Query = "SELECT EXISTS(SELECT * FROM $Tabla WHERE $Campo = $Valor) as existe";
  $Result = mysqli_query($Link, $Query) or die("<p>Fall&oacute; la b&uacute;squeda en la base de datos<br />$Query</p><p>" . mysqli_error() . "</p>");

  $Row = mysqli_fetch_array($Result);

  return $Row["existe"];

}

function ExisteRegistroFromWhere($From, $Where, $Not = "") {

  global $DBName;

  $Link = GetLink();

  $Query = "SELECT $Not EXISTS(SELECT * $From $Where) as existe";  
  $Result = mysqli_query($Link, $Query) or die("<p>Fall&oacute; la b&uacute;squeda en la base de datos<br />$Query</p><p>" . mysqli_error() . "</p>");

  $Row = mysqli_fetch_array($Result);

  return $Row["existe"];

}

function Login($Username, $Password) {

  global $Host, $DBName;

  session_start();

  $result = 0;

  $save_err_reporting = error_reporting(0);

  unset($_SESSION["Username"]);
  unset($_SESSION["Password"]);

  $result = mysqli_connect($Host, $Username, $Password);
  $result = true;

  error_reporting($save_err_reporting);
  
  $_SESSION["Username"] = $Username;
  $_SESSION["Password"] = $Password;
  
  return $result;

}

function ObtenerRolesUsuario($Username = "") {

  global $DBName;

  $Link = GetLink();

  if(strlen($Username) == 0) $Username = $_SESSION["Username"];

 //$Result = Query("call prc_obtener_roles_usuario('$Username')");
  $Query = "SELECT id_rol FROM roles_usuarios WHERE id_usuario = '$Username'";
  $Result = mysqli_query($Link, $Query);

  for($i=0; $Row = mysqli_fetch_array($Result); $i++) {
    $Roles[$Row[0]] = 1;
  }

  return $Roles;

}

function CallProcedure($Procedure, $Params = array()) {

  $Link = GetLink();

  foreach($Params as $Param){
    $Param = mysqli_real_escape_string($Link, $Param);
  }  

  $Query = "CALL $Procedure(" . implode(", ", $Params) . ")";
  
  Execute($Query);

}

function CrearUsuario($Usuario, $Password, $Administrador = false) {

  global $DBName;

  $Privilegios = "SELECT, INSERT, DELETE, UPDATE, EXECUTE";
  $BasesDatos = "$DBName.*";

  if($Administrador) {
    Execute("GRANT ALL ON *.* TO '$Usuario'@'%' IDENTIFIED BY '$Password' WITH GRANT OPTION");
    /*Execute("GRANT CREATE USER ON *.* TO '$Usuario'@'%' IDENTIFIED BY '$Password' WITH GRANT OPTION");
    Execute("GRANT $Privilegios ON $BasesDatos TO '$Usuario'@'%' WITH GRANT OPTION");*/
  } else {
    Execute("GRANT $Privilegios ON $BasesDatos TO '$Usuario'@'%' IDENTIFIED BY '$Password'");
  }

}

function BorrarUsuario($Usuario) {

  global $DBName;

  Execute("REVOKE ALL PRIVILEGES ON *.* FROM '$Usuario'@'%'");
  Execute("DROP USER '$Usuario'@'%'");

}

function CambiarPermisosUsuario($Usuario, $Administrador = false) {

  global $DBName;
  $Privilegios = "SELECT, INSERT, DELETE, UPDATE, EXECUTE";
  $BasesDatos = "$DBName.*";

  if($Administrador) {
    Execute("GRANT ALL ON *.* TO '$Usuario'@'%' WITH GRANT OPTION");
/*    Execute("GRANT $Privilegios ON $BasesDatos TO '$Usuario'@'%' WITH GRANT OPTION");*/
  } else {
    Execute("REVOKE ALL PRIVILEGES ON *.* FROM '$Usuario'@'%'");
    Execute("GRANT $Privilegios ON $BasesDatos TO '$Usuario'@'%'");
  }

}

function CambiarPassword($Usuario, $Password) {

  Execute("SET PASSWORD FOR '$Usuario'@'%' = PASSWORD('$Password')");
  
  if($Usuario == $_SESSION["Username"]) {
    session_start();
    $_SESSION["Password"] = $Password;
  }

}

function ObtenerUsuario() {
  
  return $_SESSION["Username"];

}




?>
