If you need access to more code, don't fetch individual files from the web.
I have a lot of repositories cloned in @~/clone and if we need more, ask me to clone more.

If you need sudo, first try to run it and see if it requires fingerprint authentication. I can help authenticate if needed.
On some systems that isn't set up, so I need to run the commands for you and paste the output.

Make sure to always create a plan file and update it so that we can continue at a later time.

If we need to check complex problems of system state with multiple commands to gather information about issues, it's best to create a script to run the same checks again later.

If you need to edit previous commits, best is to create a fixup git commit --fixup HASH and then git rebase --autosquash with the commit before the one we want to modify.

When writing scripts make sure they are compatible with any type of linux
distribution, e.g. NixOS, so if using bash, prefix it with /usr/bin/env.

If running on NixOS we can use nix-shell to get dependencies packages and run commands in there.
But if we're building a project, then we want to use the project config they have, probably a flake.nix

When working on Rust projects, make sure the compiler has no warnings, cargo fmt is ok, clippy has no errors.
Try to avoid unwrap and unsafe code and keep the code as idiomatic as possible.
Don't need to build in --release mode, debug is fine and much faster.
