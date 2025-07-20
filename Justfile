doc:
    vimcats -t -f -c -a \
    lua/tool-resolver/init.lua \
    lua/tool-resolver/config.lua \
    lua/tool-resolver/types.lua \
    > doc/tool-resolver.nvim.txt

    vim -c "helptags doc" -c "q"

set shell := ["bash", "-cu"]

test:
    @echo "Running tests in headless Neovim using test_init.lua..."
    nvim -l tests/minit.lua --minitest
