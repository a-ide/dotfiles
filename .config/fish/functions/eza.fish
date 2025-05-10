function eza
  set show_perms 0
  set use_gitignore 1
  set args

  for arg in $argv
    switch $arg
      case "--perm"
        set show_perms 1
      case "--no-ignore"
        set use_gitignore 0
      case "*"
        set args $args $arg
    end
  end

  set cmd eza

  if test $show_perms -eq 0
    set args --no-permissions $args
  end

  if test $use_gitignore -eq 1
    set args --git-ignore $args
  end

  command $cmd $args
end
