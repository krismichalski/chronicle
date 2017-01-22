<?php

  class Main_Model
  {

    private $errors = array();

    public function error($field, $text)
    {
      if(!isset($this->errors[$field])) $this->errors[$field] = array();
      $this->errors[$field][] = $text;
    }

    public function prepare_validation()
    {
      $this->errors = array();
    }

    public function check_validation()
    {
      if(count($this->errors) > 0)
      {
        redirect_to(previous_page(), $this->errors, 'error', $_POST);
      }
      else
      {
        return true;
      }
    }

  }

?>
