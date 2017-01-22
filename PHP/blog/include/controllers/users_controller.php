<?php

  class UsersController
  {

    public function __construct($action_name)
    {
      if($action_name != 'register' && $action_name != 'create' && !current_user()) login_required();
      if(current_user()['role'] != 'admin')
      {
        if($action_name == 'approve' || $action_name == 'index')
        {
          redirect_to('pages/index', L::no_permission, 'warning');
        }
      }
    }

    public function register()
    {
      if(current_user())
      {
        redirect_to('pages/index', L::users_register_cannot_create_while_login, 'warning');
      }
    }

    public function create()
    {
      $val = new User_Model();
      if($val->validate($_POST) == true)
      {
        $hashed_password = password_hash($_POST['password'], PASSWORD_BCRYPT);
        $stmt = app()->db->prepare('INSERT INTO users (email, password, role, approved_at) VALUES (:email, :password, :role, :approved_at)');
        $stmt->execute(array(':email' => $_POST['email'], ':password' => $hashed_password, ':role' => 'blogger', ':approved_at' => NULL));
        redirect_to('pages/index', L::users_create_successfully_created, 'success');
      }
    }

    public function approve()
    {
      $user = $this->load_user();
      $stmt = app()->db->prepare('UPDATE users SET approved_at = NOW() WHERE user_id = :user_id');
      $stmt->execute(array(':user_id' => $user['user_id']));
      redirect_to(previous_page(), L::users_approve_successfully_approved, 'success');
    }

    public function index()
    {
      view()->users = app()->db->query('SELECT * FROM users')->fetchAll();
    }

    public function delete()
    {
      $user = $this->load_user();
      if(current_user()['user_id'] == $user['user_id'])
      {
        $_SESSION['redirect_after_logout'] = 'pages/index';
        $_SESSION['message_after_logout'] = L::users_delete_deleted_and_loggout;
        $redirect_page = 'sessions/logout';
      }
      else
      {
        $redirect_page = previous_page();
      }
      $stmt = app()->db->prepare('DELETE FROM users WHERE user_id = :user_id');
      $stmt->execute(array(':user_id' => $user['user_id']));
      redirect_to($redirect_page, L::users_delete_successfully_deleted, 'success');
    }

    public function update()
    {
      $user = $this->load_user();
      $val = new User_Model();
      if($val->validate($_POST, $user))
      {
        if($_POST['password'])
        {
          $hashed_password = password_hash($_POST['password'], PASSWORD_BCRYPT);
        }
        else
        {
          $hashed_password = $user['password'];
        }
        $stmt = app()->db->prepare('UPDATE users SET email = :email, password = :password WHERE user_id = :user_id');
        $stmt->execute(array(':user_id' => $user['user_id'], ':email' => $_POST['email'], ':password' => $hashed_password));
        redirect_to('pages/index', L::users_update_successfully_updated, 'success');
      }
    }

    public function edit()
    {
      $user = $this->load_user();
      view()->user = $user;
    }

    private function load_user()
    {
      if(isset($_GET['user_id'])) $user_id = $_GET['user_id'];
      if(!isset($user_id) && $_POST['user_id']) $user_id = $_POST['user_id'];
      $stmt = app()->db->prepare('SELECT * FROM users WHERE user_id = :user_id LIMIT 1');
      $stmt->execute(array(':user_id' => $user_id));
      $user = $stmt->fetch();
      if($user)
      {
        return $user;
      }
      else
      {
        redirect_to('users/index', L::user_not_found, 'error');
      }
    }

  }

?>
