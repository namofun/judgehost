# Judgehost

This judgehost is modified from DOMjudge.

Current base code version is v7.3.3.

# Configuring judgehosts

Note that there are several interactions in the configuration process. Please **don't simply copy** these commands into bash and run. Make sure you are currently running on **non-root user**.

```bash
# For apt install dependencies
sudo ./dependency.sh

# Configure and build
# When upgrades are needed, running this section only
./bootstrap
./configure
make
sudo make install

# Create the judgedaemon users, Setup systemd scripts
# Running chroot builder and Configure the grub script
#
# NOTE that this will simply configure the /etc/default/grub
# and do not guarantee the arguments are correctly installed
# You may only run on the first install on a clean install
sudo ./finalize.sh

# Setup the corresponding count of judgehosts
# NOTE that you may have to disable these manually if needed
sudo ./setup-batch.sh
```
