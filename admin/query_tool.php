<?php

  session_start();
  
  if (!(isset($_SESSION["Username"]) && isset($_SESSION["Password"]))) {
      header('location:../Login.php');
  } else {
    
    include_once('../data/MySQL.php');
    include("encabezado.php");
    
?>
  
  <div id="content"> 
    <div id="texto"> 
      <div id="encabezado"></div>

      <form name="query_tool" action="query_tool.php" method="post">
        <h1>Query Tool</h1>
        
        <?php if (isset($_POST["action"])) {
        
          $rsQuery = Recordset(mysqli_real_escape_string($_POST["SQL"]));
          
          print("<h2>Results</h2>\n<table>");
            if (is_array($rsQuery))
            foreach($rsQuery as $Line){
              if (is_array($Line)) {
                print("<tr>");
                foreach($Line as $Column){
                  print("<td>". $Column . "<td>");
                }  
                print("</tr>\n");
              }
            }
            print("</table>");
        }
        
        ?>
  
        <label for="SQL">Query:</label>
        <textarea name="SQL" rows="30" cols="80"><?php print($_SESSION["query"]); ?></textarea>
        
        <input type="submit" name="action" value="Run query">
      
      </form>


      <div id="pie">&nbsp;</div> 
  </div>
  

<?php
    
    include("pie.php");
    
  }

?>