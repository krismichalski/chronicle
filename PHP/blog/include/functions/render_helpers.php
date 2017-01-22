<?php

  require_once 'helpful_functions.php';

  function flash_message()
  {
    if(isset($_SESSION['message']) && !empty($_SESSION['message']) && !is_array($_SESSION['message']))
    {
      $flash = '';
      $flash .= '<div class="alert alert-'.flash_class($_SESSION['message_type']).' alert-dismissable">';
      $flash .= '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>';
      $flash .= $_SESSION['message'];
      $flash .= '</div>';

      echo $flash;
    }
  }

  function flash_class($level)
  {
    switch ($level)
    {
      case 'success':
        return 'success';
        break;

      case 'notice':
        return 'info';
        break;

      case 'error':
        return 'danger';
        break;

      case 'warning':
        return 'warning';
        break;
    }
  }

  function display_error($error_number, $error_message, $error_file, $error_line)
  {
    $error_message = str_replace($_SERVER['DOCUMENT_ROOT'], '', $error_message);
    $error_file = str_replace($_SERVER['DOCUMENT_ROOT'], '', $error_file);
    if ($error_number == 256)
    {
      return $error_message;
    }
    else
    {
      $error_message = str_replace('called in ', 'called from <strong>', $error_message);
      $error_message = str_replace(' on line ', '</strong> on line <strong>', $error_message);
      $error_message = str_replace(' and defined', '</strong>  and defined', $error_message);
      $error_message = preg_replace('/[\s\n]+(\S+)[\s\n]*\(\)/', ' <strong>$1()</strong>', $error_message);
      return $error_message.' in <strong>'.$error_file.'</strong> on line <strong>'.$error_line.'</strong>';
    }
  }

  function form_input($name, $text, $type = 'text', $value = '')
  {
    $form_group = '<div class="form-group">';
    $help_text = '';
    if($type != 'hidden')
    {
      if(isset($_SESSION['message']) && is_array($_SESSION['message']))
      {
        $errors = $_SESSION['message'];
        if(isset($errors[$name]))
        {
          $form_group = '<div class="form-group has-error">';
          $help_text = '<span class="help-block">'.implode(', ', $errors[$name]).'</span>';
        }
      }
      if(isset($_SESSION['form']) && isset($_SESSION['form'][$name]))
      {
        $value = $_SESSION['form'][$name];
      }
      if(isset(view()->$name))
      {
        $value = view()->$name;
      }
    }
    $form_input = '';
    $form_input .= $form_group;
    if($type != 'hidden')
    {
      $form_input .= '<label for="'.$name.'">'.$text.'</label>';
    }
    $form_input .= '<input id="'.$name.'" value="'.$value.'" class="form-control" name="'.$name.'" type="'.$type.'">';
    $form_input .= $help_text;
    $form_input .= '</div>';
    return $form_input;
  }

?>
