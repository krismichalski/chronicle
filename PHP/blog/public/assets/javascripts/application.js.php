<?php
  require_once $_SERVER['DOCUMENT_ROOT'].'/vendor/autoload.php';
  use Assetic\Asset\AssetCollection;
  use Assetic\Asset\FileAsset;
  use Assetic\Filter\CoffeeScriptFilter;

  $assets_path = $_SERVER['DOCUMENT_ROOT'].'/vendor/assets';
  $app_assets_path = $_SERVER['DOCUMENT_ROOT'].'/include/assets/javascripts';

  $application = new AssetCollection(array(
                                     new FileAsset($assets_path.'/jquery/dist/jquery.min.js'),
                                     new FileAsset($assets_path.'/bootstrap/dist/js/bootstrap.min.js'),
                                     new FileAsset($assets_path.'/seiyria-bootstrap-slider/dist/bootstrap-slider.min.js'),
                                     new FileAsset($app_assets_path.'/main.js')
                                     ));
  echo $application->dump();

?>
