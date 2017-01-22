<?php

  class PageParts
  {

    private $legal_page_parts = ['head', 'navbar', 'content', 'footer'];

    public function __construct()
    {
      $this->page_parts = $this->generate_defaults();
    }

    public function get()
    {
      return $this->page_parts;
    }

    public function change($page_part, $path)
    {
      $this->check_before_action($page_part, $path);
      $this->page_parts[$page_part] = $this->page_part_path($path);
      return true;
    }

    public function add($name, $path = null, $after = null)
    {
      if(isset($after) && isset($path))
      {
        $this->page_part_exists($this->page_part_path($path));
        $this->is_page_part_legal($after);
        array_insert_after($after, $this->page_parts, $name, $this->page_part_path($path));
        array_insert_after_value($after, $this->legal_page_parts, $name);
      }
      elseif(isset($after) && !isset($path))
      {
        $this->is_page_part_legal($after);
        array_insert_after($after, $this->page_parts, $name, null);
        array_insert_after_value($after, $this->legal_page_parts, $name);
      }
      elseif(!isset($after) && isset($path))
      {
        $this->page_parts[$name] = $this->page_part_path($path);
        $this->legal_page_parts[] = $name;
      }
      else
      {
        $this->page_parts[$name] = null;
        $this->legal_page_parts[] = $name;
      }
      return true;
    }

    public function remove($name)
    {
      $this->is_page_part_legal($name);
      unset($this->page_parts[$name]);
      $position = array_search($name, $this->legal_page_parts);
      unset($this->legal_page_parts[$position]);
    }

    private function generate_defaults()
    {
      $page_parts = $this->legal_page_parts;
      foreach($page_parts as $page_part) {
        if($page_part == 'content')
        {
          $paths[$page_part] = null;
        }
        else
        {
          $paths[$page_part] = 'include/views/application/default/'.$page_part.'.haml';
        }
      }
      return $paths;
    }

    private function is_page_part_legal($page_part)
    {
      if(array_search($page_part, $this->legal_page_parts))
      {
        return true;
      }
      else
      {
        new PrettyError('Podana część strony ('.$page_part.') nie została zajerestrowana');
      }
    }

    private function page_part_exists($path)
    {
      if(file_exists($path))
      {
        return true;
      }
      else
      {
        new PrettyError('I could not find the following part of page: '.$path);
      }
    }

    private function check_before_action($page_part, $path)
    {
      $this->is_page_part_legal($page_part);
      $this->page_part_exists($this->page_part_path($path));
      return true;
    }

    private function page_part_path($path)
    {
      if(strpos('include/views', $path) !== false)
      {
        return 'include/views/application/'.$path.'.haml';
      }
      else
      {
        return $path;
      }
    }

  }

?>
