<?php

  function myClassLoader($className)
  {
    $class_name = from_camel_case($className);

    $include_path = $_SERVER['DOCUMENT_ROOT'].'/include/';

    if(strpos($class_name, 'controller') !== false)
    {
      $subfolder = 'controllers/';
      $class_name .= '.php';
    }
    elseif(strpos($class_name, '_model') !== false)
    {
      $subfolder = 'models/';
      $class_name = explode('_', $class_name)[0].'.php';
    }
    else
    {
      $subfolder = 'classes/';
      $class_name .= '_class.php';
    }

    $class_file = $include_path.$subfolder.$class_name;

    if(!file_exists($class_file) && $subfolder == 'controllers/')
    {
      return true;
    }

    require_once($class_file);
    return true;
  }
  spl_autoload_register('myClassLoader');

?>
