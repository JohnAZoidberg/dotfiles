# dotfiles

This repository provides several roles and playbooks for installing and configuring the tools Linux that I frequently use.

## Requirements
- An installed Linux distribution (Debian or Arch are recommended, others will probably fail)
- Ansible

## Usage

Copy to `template_vars.json` to `vars.json` and change the variables in vars.json to fit you. See section Variables for further explanations.

To run for example base.yml perform the following command
'''ansible-playbook base.yml --ask-become-pass --extra-vars "@vars.json"'''

## Variables
- `git_name`: The value to set for user.name in the gitconfig
- `git_email`: The value to set for user.email in the gitconfig
- `fish_user`: The user to create and give fish as shell
- `sudo_user`: The user to create and and as a sudoer
- `github_user`: Username on GitHub

# Playbooks
base:             Everything essential that I need on all my systems.
only_config_base: The same essential homedir configs but without installing any programs.
                  Use this if your distro is not compatible with the installation procedure.
laptop:           Basic config for touchpad, wifi and backlight.
gui:              Everything else you would need on a system that is more than a terminal.
only_config_base: The same essential homedir configs but without installing any programs.
                  Use this if your distro is not compatible with the installation procedure.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
