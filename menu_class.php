<?php

class menu {

  var $items  = array();
  var $indent = "";
	var $id     = "";

  function  menu($id, $indent = "  ") {

		$this->id     = $id;
    $this->indent = "  ";

  }

  function add_item($url, $text, $class="") {

    $this->items[] = array("text" => $text, "url" => $url, "class" => $class);

  }

  function print_html() {

    $indent = $this->indent;
		
		
    $html = $indent . "<div id=\"" . $this->id . "\">\n"
  	      . $indent . $indent . "<ul>\n";
				
    foreach ($this->items as $item) {

  		$curr_url = trim(strrchr($_SERVER['SCRIPT_NAME'], "/"), "/");
  		$item_url = trim($item["url"], "/");
	
  	  $html .= $indent . $indent . $indent; 
		
  		if ($item_url == "") 

			  $html .= "<li>" . $item["text"] . "</li>\n";

  	  elseif ($curr_url != $item_url)

  		  $html .= "<li class=\"" . $item["class"] . "\"><a href=\"" . $item["url"] . "\">" 
  			      .  $item["text"] . "</a></li>\n";
			else

  		  $html .= "<li class=\"current " . $item["class"] . "\">" . $item["text"] . "</li>\n";
			
  	}

    $html .= $indent . $indent . "</ul>&nbsp;\n"
  	      .  $indent . "</div>\n";

    print $html;

  }

}

?>