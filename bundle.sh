#!/bin/bash
tar -czvvf default_dotfiles.tar.gz .* --exclude=. --exclude=.. --exclude=.git
