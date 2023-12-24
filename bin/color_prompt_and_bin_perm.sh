
#!/bin/bash

BASHRC_PATH="$HOME/.bashrc"

# color prompt
sed -i '/#force_color_prompt/s/^#//' "$BASHRC_PATH"

# permission
sudo chown -R myuser:myuser bin/

