#!/bin/bash

cd $HOME/WRF/WRF \
    && echo -e "34\n1" | ./configure \
    && ./compile em_real > compile.log \
    && cd $HOME/WRF/WPS \
    && echo -e "3" | ./configure \
    && ./compile > compile.log \
    && touch $HOME/.wrf_installed
