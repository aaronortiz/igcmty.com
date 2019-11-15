<?php

  include_once("Data/MySQL.php");
  include("Data/LimitedUser.php");
  
  $_SESSION["Username"] = $LimitedUser;
  $_SESSION["Password"] = $LimitedPass;
  
  $SQL = "SELECT * FROM v_grupos";
  
  $Datos = Recordset($SQL);
  
  foreach($Datos as $Grupo){
  
    switch($Grupo["dia_reunion"]) {
    case 0:
      $DiaReunion = "Domingo";
      break;
    case 1:
      $DiaReunion = "Lunes";
      break;
    case 2:
      $DiaReunion = "Martes";
      break;
    case 3:
      $DiaReunion = "Miércoles";
      break;
    case 4:
      $DiaReunion = "Jueves";
      break;
    case 5:
      $DiaReunion = "Viernes";
      break;
    case 6:
      $DiaReunion = "Sábado";
      break;
    default;    
    }
    
    $DiaReunion .= " " . substr($Grupo["hora_reunion"], 0, 5);
  
    $Grupos[] = array("nombre"      => $Grupo["nombre"],
                      "ubicacion"   => $Grupo["ubicacion"],
                      "dia_reunion" => $DiaReunion, 
                      "lider_grupo" => $Grupo["lider_grupo"], 
                      "email"       => $Grupo["email"], 
                      "telefono"    => $Grupo["telefono"]);    
  }

/*
  $Grupos[0]["nombre"]      = "Matrimonios (cuidado de niños)";
  $Grupos[0]["ubicacion"]   = "Colinas de San Jerónimo";
  $Grupos[0]["dia_reunion"] = "Viernes, 8:30pm";
  $Grupos[0]["lider_grupo"] = "Juan Manuel Cáceres";
  $Grupos[0]["email"]       = "jcaceres504@yahoo.com";
  $Grupos[0]["telefono"]    = "81 1044 9900";
  
  $Grupos[1]["nombre"]      = "Jóvenes Secundaria y Prepa";
  $Grupos[1]["ubicacion"]   = "Colonia del Valle";
  $Grupos[1]["dia_reunion"] = "Viernes, 8:00pm";
  $Grupos[1]["lider_grupo"] = "Andrés Handal";
  $Grupos[1]["email"]       = "andreshandal.04@gmail.com";
  $Grupos[1]["telefono"]    = "81 1035 1110";

  $Grupos[2]["nombre"]      = "Matrimonios";
  $Grupos[2]["ubicacion"]   = "Cumbres, Sector 2";
  $Grupos[2]["dia_reunion"] = "Viernes 8:30pm";
  $Grupos[2]["lider_grupo"] = "Samuel Ortiz";
  $Grupos[2]["email"]       = "samoro55@yahoo.com.mx";
  $Grupos[2]["telefono"]    = "81 8309 1231";

  $Grupos[3]["nombre"]      = "Universitarios Valle";
  $Grupos[3]["url"]         = "http://uva.yolasite.com";
  $Grupos[3]["ubicacion"]   = "Colonia del Valle";
  $Grupos[3]["dia_reunion"] = "Martes 8:00pm";
  $Grupos[3]["lider_grupo"] = "Alex Handal";
  $Grupos[3]["email"]       = "universitariosvalle@gmail.com";
  $Grupos[3]["telefono"]    = "81 1481 8209";

  $Grupos[4]["nombre"]      = "Jóvenes Prepa";
  $Grupos[4]["ubicacion"]   = "Colinas de San Jerónimo";
  $Grupos[4]["dia_reunion"] = "Viernes 8:00pm";
  $Grupos[4]["lider_grupo"] = "Oscar Gutierrez Jr.";
  $Grupos[4]["email"]       = "oz_drummer@hotmail.com";
  $Grupos[4]["telefono"]    = "81 1509 2977";

  $Grupos[5]["nombre"]      = "Parejas Jóvenes";
  $Grupos[5]["ubicacion"]   = "Cumbres";
  $Grupos[5]["dia_reunion"] = "Viernes 8:30pm";
  $Grupos[5]["lider_grupo"] = "Allan Handal";
  $Grupos[5]["email"]       = "allanhandal@yahoo.com";
  $Grupos[5]["telefono"]    = "81 1555 3640";

  $Grupos[6]["nombre"]      = "Adultos";
  $Grupos[6]["ubicacion"]   = "Ciudad Satélite";
  $Grupos[6]["dia_reunion"] = "Viernes 8:00pm";
  $Grupos[6]["lider_grupo"] = "Pablo Gaytan";
  $Grupos[6]["email"]       = "alfa.potencia@gmail.com";
  $Grupos[6]["telefono"]    = "81 8028 2583";

  $Grupos[7]["nombre"]      = "Profesionistas";
  $Grupos[7]["ubicacion"]   = "Colinas de San Jerónimo";
  $Grupos[7]["dia_reunion"] = "Viernes 8:30pm";
  $Grupos[7]["lider_grupo"] = "Adrián Rivera";
  $Grupos[7]["email"]       = "adrian.rr@gmail.com";
  $Grupos[7]["telefono"]    = "81 1286 4095";

  $Grupos[8]["nombre"]      = "Treinta y Tantos, mas o menos";
  $Grupos[8]["ubicacion"]   = "Lindavista";
  $Grupos[8]["dia_reunion"] = "Sábados 7:00pm";
  $Grupos[8]["lider_grupo"] = "Marco Peralta";
  $Grupos[8]["email"]       = "treintaytantosmasomentos@gmail.com";
  $Grupos[8]["telefono"]    = "81 1487 3312";

  $Grupos[9]["nombre"]      = "Unis y Jovenes Profesionistas";
  $Grupos[9]["ubicacion"]   = "Zona TEC";
  $Grupos[9]["dia_reunion"] = "Sábados 6:00om";
  $Grupos[9]["lider_grupo"] = "Henry Kattan";
  $Grupos[9]["email"]       = "hka87@hotmail.com";
  $Grupos[9]["telefono"]    = "81 1584 5889";
  */
?>