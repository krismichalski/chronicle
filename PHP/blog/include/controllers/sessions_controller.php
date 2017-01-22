<?php

  class SessionsController
  {

    public function login()
    {
      $error_message = null;
      $email = $_POST['email'];
      $password = $_POST['password'];

      if(empty($_POST['email']) || empty($_POST['password'])) $message = L::sessions_login_pass_user_and_password;

      $stmt = app()->db->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
      $stmt->execute(array(':email' => $email));
      $user = $stmt->fetch();

      if(empty($user)) $message = L::sessions_login_user_not_found;
      else
      {
        if(password_verify($password, $user['password']))
        {
          if($user['approved_at'] != null && time() > $user['approved_at'])
          {
            $_SESSION['current_user'] = $user['user_id'];
            apc_store('current_user', $user);
            if(isset($_SESSION['return_after_login']))
            {
              $redirect_to = $_SESSION['return_after_login'];
              unset($_SESSION['return_after_login']);
            }
            else
            {
              $redirect_to = previous_page();
            }
            redirect_to($redirect_to, L::sessions_login_logged, 'success');
          }
          else $message = L::sessions_login_not_approved;
        }
        else $message = L::sessions_login_password_mismatch;
      }
      redirect_to('pages/index', $message, 'error');
    }

    public function logout()
    {
      if(isset($_SESSION['current_user'])) unset($_SESSION['current_user']);
      if(apc_exists('current_user')) apc_delete('current_user');
      if(isset($_SESSION['redirect_after_logout']))
      {
        $message = $_SESSION['message_after_logout'];
        unset($_SESSION['redirect_after_logout']);
        unset($_SESSION['message_after_logout']);
        redirect_to('pages/index', $message, 'error');
      }
      else redirect_to('pages/index', L::sessions_logout_logged_out, 'success');
    }

  }

?>
