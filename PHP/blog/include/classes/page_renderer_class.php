<?php

  class PageRenderer
  {

    public function __construct($controller = null, $action = null)
    {
      if(isset($controller) && isset($action))
      {
        $this->controller = stripcslashes($controller);
        $this->action = stripcslashes($action);
        $this->page_parts = new PageParts;
        $this->cache_page_file_path = 'cache/views/'.$this->controller.'/'.$this->action.'.haml.php';
        $this->page_content_path = 'include/views/'.$this->controller.'/'.$this->action.'.haml';
        $this->page_parts->change('content', $this->page_content_path);
      }
      else
      {
        new PrettyError('You have to pass controller and view');
      }
    }

    public function render()
    {
      require $this->get_page_file();
    }

    private function get_page_file()
    {
      $page_code = $this->generate_page_code();
      if($this->needs_compile($page_code))
      {
        $this->compile($page_code);
      }
      return $this->cache_page_file_path;
    }

    private function generate_page_code()
    {
      $page_code = '';
      foreach ($this->page_parts->get() as $page_part => $path) {
        $page_code .= file_get_contents($path);
      }
      return $page_code;
    }

    private function needs_compile($page_code)
    {
      return ($this->page_file_not_exists() ||
              $this->page_code_control_sum_not_match($page_code)
             );
    }

    private function page_file_not_exists()
    {
      return !file_exists($this->cache_page_file_path);
    }

    private function page_code_control_sum_not_match($page_code)
    {
      return md5($page_code) != mb_substr(file($this->cache_page_file_path)[0], 5, 32);
    }

    private function compile($page_code)
    {
      $old_umask = umask(0); //bo bez tego 0777 daje 0775
      $haml = new MtHaml\Environment('php');
      $page_code = '/'.md5($page_code).$page_code;
      $php_code = $haml->compileString($page_code, $this->page_content_path);

      $this->check_directory();

      $tempfile = tempnam('cache/pages'.$this->controller, $this->action);
      chmod($tempfile, 0777);
      file_put_contents($tempfile, $php_code);
      rename($tempfile, $this->cache_page_file_path);
      umask($old_umask);
      return true;
    }

    private function check_directory()
    {
      $directory = dirname($this->cache_page_file_path);
      if(!is_dir($directory))
      {
        mkdir($directory, 0777, true);
      }
      return true;
    }

  }

?>
