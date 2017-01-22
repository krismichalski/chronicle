<?php

  require_once 'url_helpers.php';

  function redirect_to($page, $message = null, $message_type = 'notice', $form = null)
  {
    $url = url_for($page);
    if(isset($message))
    {
      $_SESSION['message_type'] = $message_type;
      $_SESSION['message'] = $message;
    }
    if(isset($form))
    {
      unset($_SESSION['form']['password']);
      unset($_SESSION['form']['password_confirm']);
      $_SESSION['form'] = $form;
    }
    header('Location: '.$url);
    exit;
  }

  function render($page, array $data, array $headers = null)
  {
    $url = url_for($page);
    $params = array(
      'http' => array(
        'method' => 'POST',
        'content' => http_build_query($data)
      )
    );
    if(!is_null($headers))
    {
      $params['http']['header'] = '';
      foreach($headers as $k => $v)
      {
        $params['http']['header'] .= "$k: $v\n";
      }
    }
    $ctx = stream_context_create($params);
    $fp = @fopen($url, 'rb', false, $ctx);
    if($fp)
    {
      echo @stream_get_contents($fp);
      fclose($fp);
      die();
    }
    else
    {
      exit("Fatal error during rendering!");
    }
  }

?>
