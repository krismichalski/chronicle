<?php

  class PostsController
  {

    public function __construct($action_name)
    {
      if($action_name != 'index' && !current_user()) login_required();
    }

    public function new_post()
    {
      view()->categories = array('sport', 'movie', 'music');
    }

    public function create()
    {
      $stmt = app()->db->prepare('INSERT INTO posts (user_id, category, hidden, created_at, updated_at) VALUES (:user_id, :category, true, NOW(), NOW())');
      $stmt->execute(array(':user_id' => current_user()['user_id'], ':category' => $_POST['category']));
      $post_id = app()->db->lastInsertId();
      $stmt = app()->db->prepare('INSERT INTO posts_contents (post_id, title, content, language) VALUES (:post_id, :title, :content, :language)');
      $stmt->execute(array(':post_id' => $post_id, ':title' => $_POST['title'], ':content' => $_POST['content'], ':language' => $_POST['content_language']));
      redirect_to('posts/manage', L::posts_create_successfully_created, 'success');
    }

    public function manage()
    {
      $stmt = app()->db->prepare('SELECT posts.post_id, posts.hidden, posts.category, posts_contents.title FROM posts INNER JOIN posts_contents ON posts.post_id = posts_contents.post_id WHERE posts.user_id = :user_id');
      $stmt->execute(array(':user_id' => current_user()['user_id']));
      view()->posts = $stmt->fetchAll();
    }

    public function delete()
    {
      $post = $this->load_post();
      $stmt = app()->db->prepare('DELETE FROM posts WHERE post_id = :post_id');
      $stmt->execute(array(':post_id' => $user['post_id']));
      $stmt = app()->db->prepare('DELETE FROM posts_contents WHERE post_id = :post_id');
      $stmt->execute(array(':post_id' => $user['post_id']));
      redirect_to(previous_page(), L::posts_delete_successfully_deleted, 'success');
    }

    public function hide()
    {
      $post = $this->load_post();
      $stmt = app()->db->prepare('UPDATE posts SET hidden = true WHERE post_id = :post_id');
      $stmt->execute(array(':post_id' => $post['post_id']));
      redirect_to(previous_page(), L::posts_hide_success, 'success');
    }

    public function unhide()
    {
      $post = $this->load_post();
      $stmt = app()->db->prepare('UPDATE posts SET hidden = false WHERE post_id = :post_id');
      $stmt->execute(array(':post_id' => $post['post_id']));
      redirect_to(previous_page(), L::posts_unhide_success, 'success');
    }

    public function preview()
    {
      $stmt = app()->db->prepare('SELECT posts.post_id, posts.hidden, posts.category, posts_contents.title, posts_contents.content FROM posts INNER JOIN posts_contents ON posts.post_id = posts_contents.post_id WHERE posts.user_id = :user_id AND posts.post_id = :post_id AND posts_contents.language = :language');
      $stmt->execute(array(':user_id' => current_user()['user_id'], ':post_id' => $_GET['post_id'], ':language' => app()->current_language));
      if($stmt->rowCount() != 0)
      {
        view()->post = $stmt->fetch();
        view()->avaiable = true;
      }
      else
      {
        view()->avaiable = false;
      }
    }

    private function load_post()
    {
      if(isset($_GET['post_id'])) $post_id = $_GET['post_id'];
      if(!isset($post_id) && $_POST['post_id']) $post_id = $_POST['post_id'];
      $stmt = app()->db->prepare('SELECT * FROM posts WHERE post_id = :post_id AND user_id = :user_id LIMIT 1');
      $stmt->execute(array(':post_id' => $post_id, ':user_id' => current_user()['user_id']));
      $post = $stmt->fetch();
      if($post)
      {
        return $post;
      }
      else
      {
        redirect_to('posts/index', L::post_not_found, 'error');
      }
    }

  }

?>
