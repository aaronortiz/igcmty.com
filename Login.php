<?php

  session_start();

  require("Config.php");
  include("Presentation/GenerateHTML.php");

  print "<html><head>\n\n  <title>$ApplicationName: $CompanyName</title>";

?>

  <style type="text/css" media="all">
      @import "css/index.css";
      @import "css/Login.css";
      * html body { behavior: url(htc/csshover.htc);  }
    </style>

  <style type="text/css" media="screen">
    @import "Sifr/sIFR-screen.css";
  </style>

  <style type="text/css" media="print">
    @import "Sifr/sIFR-print.css";
  </style>

  <script src="Sifr/sifr.js" type="text/javascript"></script>
  <script src="Sifr/sifr-config.js" type="text/javascript"></script>

</head>

<body onLoad="document.LoginForm.Username.focus()">
<div id="login_header">

<div id="logo"></div>

<?php 

//  print("  <h1>$CompanyName</h1>\n<h2>$ApplicationName</h2>\n\n");
  print("  <h1>" . strtoupper($ApplicationName) . "</h1>\n\n");
//  print("  <h1>$ApplicationName</h1>\n\n");

?>



</div>

<div id="login">


  <table>

<?php

if ($_SESSION["Errors"]["BadLogin"]) {
  print("<p class=\"err_msg\">El sistema no reconoce tu usuario y clave, favor intenta de nuevo</p>");
}

if ($_SESSION["Errors"]["BadFormat"]) {
  print("<p class=\"err_msg\">Tu usuario y clave deben ser alfanum&eacute;ricos de 6 a 32 posiciones.</p>");
}

if ($_SESSION["Errors"]["CookieError"]) {
  print("<p class=\"err_msg\">Tu navegador debe aceptar cookies para que puedas ingresar. Revisa la configuraci&oacute;n de tu navegador e intenta de nuevo.</p>");
}

?>

      <form action="Data/HandleLogin.php" method="post" name="LoginForm">
      <tr>
        <td width="100">Usuario:</td>
        <td align="right"><input type="text" name="Username" size=25 class="text"></td>
      </tr>
      <tr>
        <td>Clave:</td>
        <td align="right"><input type="password" name="Password" size=25 class="text"></td>
      </tr>
    </table>

    <table>
      <tr>
        <td align="right" height=30 valign="bottom">
          <?php print(AddButton("Ingresar", "icon_enter", "Ingresar", "Ingresar")); ?>
        </td>
      </tr>

    </table>
  </form>


</div>

<p id="login_footer">* Tu navegador debe aceptar cookies para que puedas avanzar desde este punto en adelante.</p>


</body></html>
