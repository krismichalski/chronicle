<?php

  function current_user()
  {
    if(isset($_SESSION['current_user']))
    {
      if (apc_exists('current_user'))
      {
        return apc_fetch('current_user');
      }
      else
      {
        $stmt = app()->db->prepare('SELECT * FROM users WHERE user_id = :user_id LIMIT 1');
        $stmt->execute(array(':user_id' => $_SESSION['current_user']));
        $user = $stmt->fetch();

        if(!$user['user_id'])
        {
          $_SESSION['message_after_logout'] = L::such_user_already_exists;
          $_SESSION['redirect_after_logout'] = false;
          redirect_to('sessions/logout');
        }
        else
        {
          apc_store('current_user', $user);
          return $user;
        }
      }
    }
    return null;
  }

?>
