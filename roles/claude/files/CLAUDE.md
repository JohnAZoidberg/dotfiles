If you need access to more code, don't fetch individual files from the web.
I have a lot of repositories cloned in @~/clone and if we need more, ask me to clone more.

If you need sudo, first try to run it and see if it requires fingerprint authentication. I can help authenticate if needed.
On some systems that isn't set up, so I need to run the commands for you and paste the output.

Make sure to always create a plan file and update it so that we can continue at a later time.

If we need to check complex problems of system state with multiple commands to gather information about issues, it's best to create a script to run the same checks again later.

If you need to edit previous commits, best is to create a fixup git commit --fixup HASH and then git rebase --autosquash with the commit before the one we want to modify.
