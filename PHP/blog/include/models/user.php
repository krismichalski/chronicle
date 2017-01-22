<?php

  class User_Model extends Main_Model
  {

    public function validate($attr, $model = null)
    {
      parent::prepare_validation();

      $stmt = app()->db->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
      $stmt->execute(array(':email' => $attr['email']));
      if($stmt->rowCount() != 0 && $model && $model['email'] != $attr['email']) $this->error('email', L::user_email_taken);
      if(!filter_var($attr['email'], FILTER_VALIDATE_EMAIL)) $this->error('email', L::user_email_not_valid);

      if($attr['password'])
      {
        if(strlen($attr['password']) < 8) $this->error('password', L::user_password_too_short);
        if($model && !$attr['current_password'])
        {
          $this->error('current_password', L::user_current_password_required);
        }
        else
        {
          if(isset($attr['current_password']) && !password_verify($attr['current_password'], $model['password']))
          {
            $this->error('current_password', L::user_current_password_mismatch);
          }
        }
        if($attr['password'] != $attr['password_confirm']) $this->error('password_confirm', L::user_password_mismatch);
      }

      return parent::check_validation();
    }

  }

?>
