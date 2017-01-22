<?php

  final class ApplicationController
  {

    private static $instance = false;

    public static function get_instance($controller_name = null, $action_name = null)
    {
      if(self::$instance == false)
      {
        if($controller_name == null || $action_name == null)
        {
          new PrettyError('You have to pass default controller and action');
        }
        self::$instance = new ApplicationController($controller_name, $action_name);
      }
      return self::$instance;
    }

    private function __construct($controller_name, $action_name)
    {
      $this->controller_name = $controller_name;
      $this->action_name = $action_name;
      $this->action_executed = false;
      $this->view = $this->load_view();
      $this->view_variables = new stdClass();
    }

    public function get_view()
    {
      return $this->view;
    }

    public function view()
    {
      return $this->view_variables;
    }

    public function execute()
    {
      $this->load_controller_and_call_action();
      $this->render_or_404();
    }

    private function load_controller_and_call_action()
    {
      $controller_class = ucfirst($this->controller_name).'Controller';
      if(class_exists($controller_class))
      {
        $controller = new $controller_class($this->action_name);
        if(method_exists($controller, $this->action_name))
        {
          $action = $this->action_name;
          $controller->$action();
          $this->action_executed = true;
        }
      }
    }

    private function load_view()
    {
      if(file_exists($this->view_path()))
      {
        return new PageRenderer($this->controller_name, $this->action_name);
      }
      else
      {
        return null;
      }
    }

    private function view_path()
    {
      return 'include/views/'.$this->controller_name.'/'.$this->action_name.'.haml';
    }

    private function render_or_404()
    {
      if($this->view == null)
      {
        if($this->action_executed == false)
        {
          redirect_to('errors/404');
        }
        else
        {
          echo 'There was no redirect or view to render!';
        }
      }
      else
      {
        $this->view->render();
      }
    }

  }

?>
