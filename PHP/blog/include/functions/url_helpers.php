<?php

  function url_for($page, $params = null)
  {
    $protocol = 'http://';
    $domain = 'blog.dev/';
    $url = $protocol.$domain.$page;

    if(is_array($params))
    {
      $params_string = "?";
      foreach ($params as $key => $value) {
        if($params_string != "?") $params_string .= "&";
        $params_string .= "{$key}={$value}";
      }
      $url .= $params_string;
    }

    return $url;
  }

  function navbar_link($page, $name)
  {
    $li = '<li>';
    if ($page == current_page())
    {
      $li = '<li class="active">';
    }
    $url = url_for($page);
    $a = '<a href="'.$url.'">'.$name.'</a>';
    $navbar_link = $li.$a;
    echo $navbar_link."\n";
  }

  function current_page($full = false) {
    if ($_SERVER["REQUEST_URI"] == '/')
    {
      return 'pages/index';
    }
    if($full == false)
    {
      return substr(explode('?', $_SERVER["REQUEST_URI"])[0], 1);
    }
    else
    {
      return substr($_SERVER["REQUEST_URI"], 1);
    }
  }

  function previous_page()
  {
    return substr($_SESSION['REFERER_URI'], 1);
  }

?>
