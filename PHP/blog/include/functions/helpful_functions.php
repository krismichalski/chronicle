<?php

  /*
   * Inserts a new key/value before the key in the array.
   *
   * @param $key
   *   The key to insert before.
   * @param $array
   *   An array to insert in to.
   * @param $new_key
   *   The key to insert.
   * @param $new_value
   *   An value to insert.
   *
   * @return
   *   The new array if the key exists, FALSE otherwise.
   *
   * @see array_insert_after()
   */
  function array_insert_before($key, array &$array, $new_key, $new_value) {
    if (array_key_exists($key, $array)) {
      $new = array();
      foreach ($array as $k => $value) {
        if ($k === $key) {
          $new[$new_key] = $new_value;
        }
        $new[$k] = $value;
      }
      return $new;
    }
    return FALSE;
  }

  /*
   * Inserts a new key/value after the key in the array.
   *
   * @param $key
   *   The key to insert after.
   * @param $array
   *   An array to insert in to.
   * @param $new_key
   *   The key to insert.
   * @param $new_value
   *   An value to insert.
   *
   * @return
   *   The new array if the key exists, FALSE otherwise.
   *
   * @see array_insert_before()
   */
  function array_insert_after($key, array &$array, $new_key, $new_value) {
    if (array_key_exists($key, $array)) {
      $new = array();
      foreach ($array as $k => $value) {
        $new[$k] = $value;
        if ($k === $key) {
          $new[$new_key] = $new_value;
        }
      }
      return $new;
    }
    return FALSE;
  }

  /*
   * Inserts a new value after the value in the array.
   *
   * @param $value
   *   The value to insert after.
   * @param $array
   *   An array to insert in to.
   * @param $new_value
   *   An value to insert.
   *
   * @return
   *   The new array if the value exists, FALSE otherwise.
   *
   * @see array_insert_after()
   */
  function array_insert_after_value($value, array &$array, $new_value)
  {
    if(array_search($new_value, $array) !== false)
    {
      $position = array_search($value, $array);
      array_splice($array, $position + 1, 0, $new_value);
      return $array;
    }
    else
    {
      return FALSE;
    }
  }

  /**
   * Translates a camel case string into a string with underscores (e.g. firstName -&gt; first_name)
   * @param    string   $str    String in camel case format
   * @return    string            $str Translated into underscore format
   */
  function from_camel_case($str) {
    $str[0] = strtolower($str[0]);
    $func = create_function('$c', 'return "_" . strtolower($c[1]);');
    return preg_replace_callback('/([A-Z])/', $func, $str);
  }

  /**
   * Translates a string with underscores into camel case (e.g. first_name -&gt; firstName)
   * @param    string   $str                     String in underscore format
   * @param    bool     $capitalise_first_char   If true, capitalise the first char in $str
   * @return   string                              $str translated into camel caps
   */
  function to_camel_case($str, $capitalise_first_char = false) {
    if($capitalise_first_char) {
      $str[0] = strtoupper($str[0]);
    }
    $func = create_function('$c', 'return strtoupper($c[1]);');
    return preg_replace_callback('/_([a-z])/', $func, $str);
  }

  function app()
  {
    return ApplicationController::get_instance();
  }

  function page_parts()
  {
    return app()->get_view()->page_parts;
  }

  function view()
  {
    return app()->view();
  }

  function login_required()
  {
    $_SESSION['return_after_login'] = current_page(true);
    $_SESSION['return_after_login_count'] = 1;
    redirect_to('pages/index', L::login_required_alert, 'notice');
  }

?>
