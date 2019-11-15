<?php

  // Resume the current session & destroy it
  session_start();
  session_destroy();

  header("location: ../index.php");

?>