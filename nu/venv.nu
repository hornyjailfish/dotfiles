 export def --env activate [] {
    let venv_dir = (pwd)
    let venv_abs_dir = ($venv_dir | path expand)
    let venv_name = ($venv_abs_dir | path basename)
    let old_path = (if (is_windows) { $env.Path } else { $env.PATH } )
    let new_path = (if (is_windows) { (venv_path_windows $venv_abs_dir) } else { (venv_path_unix $venv_abs_dir) })

    load-env {
        VENV_OLD_PATH: $old_path,
        VIRTUAL_ENV: $venv_abs_dir,
        $new_path.0: $new_path.1
    }
}

 export def --env deactivate [] {
     $env.Path = $env.VENV_OLD_PATH
     hide-env VIRTUAL_ENV
     hide-env VENV_OLD_PATH

 }



def venv_path_unix [venv_dir] {
    let venv_path = ([$venv_dir "bin"] | path join)
    let new_path = ($env.PATH | prepend $venv_path )
    [PATH $new_path]
}

def venv_path_windows [venv_dir] {
    # 1. Conda on Windows needs a few additional Path elements
    # 2. The path env var on Windows is called Path (not PATH)
    let venv_path = ([$venv_dir "Scripts"] | path join)
    let new_path = ($env.Path | prepend $venv_path)
    [Path $new_path]
}

def is_windows [] {
    (sys host).name == "Windows"
}

def get_path_env [] {
    if (is_windows) { Path } else { PATH }
}

def path_sep [] {
    if (is_windows) { ";" } else { ":" }
}
