
#!/bin/bash

BASHRC_PATH="$HOME/.bashrc"

sed -i '/#force_color_prompt/s/^#//' "$BASHRC_PATH"

