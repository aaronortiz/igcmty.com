<?php

  session_start();

  // Detect crappy browsers
  if(preg_match("/MSIE/", $_SERVER["HTTP_USER_AGENT"], $MatchesIE))
    $_SESSION["MSIE"] = true;
  else 
    unset($_SESSION["MSIE"]);

  // If the cookies are not set, LEAVE!
  if (!isset($_SESSION["Username"])) {
     header("location: ../Login.php");
     exit;
  }

  include("../Data/MySQL.php");
  include("../Presentation/Div.php");
  include("../Presentation/cls_ListOfLinks.php");
  include("../Config.php");

  $Nav = new ListOfLinks();

  $Nav->AddSeparator();

  $Title = $ApplicationName;
  $Subtitle = "Men&uacute; Principal";

  include("encabezado.php");

?>

  <h1>Administrar datos</h1>

<?php

  $Nav->AddItem("Series.php",       "Series");
  $Nav->AddItem("Mensajes.php",     "Mensajes");
  $Nav->AddItem("Expositores.php",  "Expositores");
  $Nav->AddItem("Grupos.php",       "Grupos");
  $Nav->AddItem("LideresGrupo.php", "Lideres de Grupo");
  $Nav->AddItem("Eventos.php",      "Eventos");
  
  $Nav->AddSeparator();

  $Nav->AddItem("proc_wizard01.php", "Generador de procedimientos");

  $Nav->AddSeparator();
	
  $Nav->AddItem("../Data/LogOut.php", "Salir del Sistema", "back_button");


  print WrapDivAround($Nav->GenerateHTML(), "", "nav");
  
  include("pie.php");

?>
