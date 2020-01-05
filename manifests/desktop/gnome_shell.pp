class profile::desktop::gnome_shell {
  $coderdojo_user = $::profile::user::coderdojo_user

  $gnome_config = {
    'daemon' => {
      'AutomaticLoginEnable' => 'True',
      'AutomaticLogin'       => $coderdojo_user,
    }
  }

  $gnome_defaults = {
    path              => '/etc/gdm/custom.conf',
    key_val_separator => '=',
  }

  create_ini_settings($gnome_config, $gnome_defaults)

  file { "/var/lib/AccountsService/icons/${coderdojo_user}":
    ensure => file,
    source => '/var/lib/coderdojo-deploy/assets/coderdojo_logo.png',
  }

  $gnome_shell_config = {
    'org/gnome/shell'                               => {
      'enabled-extensions' => [
        'dash-to-dock@micxgx.gmail.com',
        'custom-hot-corners@janrunx.gmail.com',
        'desktop-icons@csoriano',
        'places-menu@gnome-shell-extensions.gcampax.github.com',
        'apps-menu@gnome-shell-extensions.gcampax.github.com',
        'suspend-button@laserb'
      ],
      'enable-hot-corners' => 'true',
    },
    'org/gnome/shell/extensions/custom-hot-corners' => {
      'actions' => "[(0, true, true, 'toggleOverview', ''), (0, false, false, 'toggleOverview', '')]",
    },
    'org/gnome/shell/extensions/unite'              => {
      'window-buttons-theme' => 'yaru',
    },
    'org/gnome/desktop/interface'                   => {
      'cursor-theme'       => 'Yaru',
      'gtk-theme'          => 'Yaru',
      'icon-theme'         => 'Yaru',
      'font-name'          => 'Ubuntu 11',
      'document-font-name' => 'Ubuntu 11',
    },
    'org/gnome/desktop/sound'                       => {
      'theme-name' => 'Yaru',
    },
    'org/gnome/desktop/wm/preferences'              => {
      'button-layout' => 'close,minimize,maximize:'
    },
    'org/gnome/shell/extensions/dash-to-dock'       => {
      'apply-custom-theme'      => 'false',
      'background-color'        => '#000000',
      'custom-background-color' => 'true',
      'custom-theme-shrink'     => 'true',
      'dash-max-icon-size'      => '40',
      'dock-fixed'              => 'false',
      'extend-height'           => 'true',
      'icon-size-fixed'         => 'false',
      'transparency-mode'       => 'FIXED',
      'running-indicator-style' => 'DOTS',
      'click-action'            => 'previews',
      'scroll-action'           => 'cycle-windows',
    },
    'org/gnome/shell/extensions/desktop-icons'      => {
      'icon-size'  => 'small',
      'show-home'  => 'false',
      'show-trash' => 'false',
    },
  }

  $gnome_shell_defaults = {
    path              => '/etc/dconf/db/local.d/10-theme-yaru',
    key_val_separator => '=',
  }

  create_ini_settings($gnome_shell_config, $gnome_shell_defaults)
}
