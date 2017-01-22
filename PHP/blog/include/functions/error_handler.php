<?php

  require_once 'request_handlers.php';

  function my_error_handler($error_number, $error_message, $error_file, $error_line)
  {
    if(basename($error_file) == '500.haml.php')
    {
      echo '<p>Błąd na stronie wyświetlającej błędy!<p>';
      echo '<p>'.$error_message.' IN '.$error_file.' ON '.$error_line.' line.</p>';
    }
    else
    {
      if(isset($_POST['error_message']))
      {
        $error_number = $_POST['error_number'];
        $error_message = $_POST['error_message'];
        $error_file = $_POST['error_file'];
        $error_line = $_POST['error_line'];

        $error_message = str_replace($_SERVER['DOCUMENT_ROOT'], '', $error_message);
        $error_file = str_replace($_SERVER['DOCUMENT_ROOT'], '', $error_file);
        if ($error_number == 256)
        {
          echo 'ERROR: '.$error_message;
        }
        else
        {
          $error_message = str_replace('called in ', 'called from <strong>', $error_message);
          $error_message = str_replace(' on line ', '</strong> on line <strong>', $error_message);
          $error_message = str_replace(' and defined', '</strong>  and defined', $error_message);
          $error_message = preg_replace('/[\s\n]+(\S+)[\s\n]*\(\)/', ' <strong>$1()</strong>', $error_message);
          echo 'ERROR: '.$error_message.' in <strong>'.$error_file.'</strong> on line <strong>'.$error_line.'</strong>';
        }
        exit();
      }
      render('errors/500', array('error_number' => $error_number,
                          'error_message' => $error_message,
                          'error_file' => $error_file,
                          'error_line' => $error_line));
    }
  }

  set_error_handler('my_error_handler');

?>
