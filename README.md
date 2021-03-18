# StackScripts

Linode StackScripts.

## Scripts

### devbox.sh

Confirmed workin w/ Debian 10. Check me out at https://cloud.linode.com/stackscripts/795165

1. Create a non-root user w/ specified password
2. Setup ssh w/ default authorized keys for the user
3. Setup oh-my-zsh with byobu for the user
4. Setup linuxbrew for the user

To deploy:

```sh
$ make update_nmcapule_devbox
```
