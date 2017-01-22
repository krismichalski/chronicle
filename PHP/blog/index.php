<?php
  require_once 'vendor/autoload.php';
  foreach(glob('include/functions/*.php') as $filename) { require_once $filename; }
  require_once 'include/classes_autoload.php';

  session_start();

  $host = 'localhost';
  $dbname = 'blog';
  $user = 'blog';
  $pass = 'hunter2';

  try
  {
    $db = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  }
  catch(PDOException $e)
  {
    exit($e->getMessage());
  }

  if(isset($_GET['current-language'])) $_SESSION['current-language'] = $_GET['current-language'];
  $i18n = new i18n();
  $i18n->setCachePath('./cache/i18n');
  $i18n->setFilePath('./include/langfiles/lang_{LANGUAGE}.ini');
  $i18n->setFallbackLang('pl');
  $i18n->init();

  if($_SERVER["REQUEST_URI"] == '/')
  {
    $controller_name = 'pages';
    $action_name = 'index';
  }
  else
  {
    $request_uri = explode('/', $_SERVER["REQUEST_URI"]);
    $controller_name = $request_uri[1];
    $action_name = explode('?', $request_uri[2])[0];
  }

  $app = ApplicationController::get_instance($controller_name, $action_name);
  $app->db = $db;
  $app->current_language = $i18n->getUserLangs()[0];
  $app->execute();

  $_SESSION['REFERER_URI'] = $_SERVER["REQUEST_URI"];
  unset($_SESSION['message']);
  unset($_SESSION['message_type']);
  unset($_SESSION['form']);

  if(isset($_SESSION['return_after_login_count']))
  {
    if($_SESSION['return_after_login_count'] == 1)
    {
      $_SESSION['return_after_login_count'] = 0;
    }
    else
    {
      unset($_SESSION['return_after_login_count']);
      unset($_SESSION['return_after_login']);
    }
  }

  $DBH = null;
?>
