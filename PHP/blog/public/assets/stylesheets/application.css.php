<?php
  require_once $_SERVER['DOCUMENT_ROOT'].'/vendor/autoload.php';
  use Assetic\Asset\AssetCollection;
  use Assetic\Asset\FileAsset;

  $assets_path = $_SERVER['DOCUMENT_ROOT'].'/vendor/assets';
  $app_assets_path = $_SERVER['DOCUMENT_ROOT'].'/include/assets/stylesheets';

  $application = new AssetCollection(array(
                                     new FileAsset($assets_path.'/bootstrap/dist/css/bootstrap.min.css'),
                                     new FileAsset($assets_path.'/bootstrap/dist/css/bootstrap-theme.min.css'),
                                     new FileAsset($assets_path.'/seiyria-bootstrap-slider/dist/css/bootstrap-slider.min.css'),
                                     new FileAsset($app_assets_path.'/main.css')
                                     ));
  echo $application->dump();

?>
