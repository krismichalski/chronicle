<?php

  class PrettyError
  {

    public function __construct($error_message = 'Unknown error')
    {
      $caller = null;
      if (function_exists('debug_backtrace')) {
        $caller = debug_backtrace();
        $caller = next($caller);
        $reflFunc = new ReflectionMethod($caller['class'], $caller['function']);
        $function_defined = $reflFunc->getFileName();
        $function_start_line = $reflFunc->getStartLine();
      }
      $message = $error_message.' in <strong>'.$caller['function'].'()</strong> called from <strong>'.$caller['file'].'</strong> on line <strong>'.$caller['line'].'</strong> and defined in <strong>'.$function_defined.'</strong> on line <strong>'.$function_start_line.'</strong>';
      trigger_error($message, E_USER_ERROR);
    }

  }

?>
