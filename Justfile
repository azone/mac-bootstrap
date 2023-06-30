list_file := "formulae-list.json"

# generate all lists
@default:
    just generate-list > /dev/null
    just generate-cask-list > /dev/null
    just generate-crate-list

# generate installed homebrew formulae list json file
@generate-list: && preview
    brew leaves | xargs brew info --json | \
    jq '[.[]|{"name", "desc", "homepage", "tap", "caveats", "linked_keg"}]' > {{list_file}}

# install all formulae in the list file
@install-all:
    jq '.[]|.["name"]' {{list_file}} | xargs brew install

# install formulae interactively
install:
    #!/usr/bin/env bash
    comm -13i <(brew leaves) <(jq -r '.[]."name"' {{list_file}}) | \
    fzf -m --bind 'alt-a:select-all,alt-d:deselect-all' | \
    xargs brew install

# preview changes
@preview:
    MSG=$(./scripts/list-diff.py); test -z "$MSG" && echo "Nothing changes" || echo "$MSG"

# commit & push formulae changes
push-changes:
    #!/usr/bin/env bash
    MSG=$(./scripts/list-diff.py)
    if [[ -z $MSG ]]; then
        echo "Nothing to commit"
        exit 0
    fi

    DS=$(date +'%Y-%m-%d %H:%M:%S')
    HEADLINE="Updates ($DS)"
    COMMIT_MSG=$(cat << EOF
    $HEADLINE

    $MSG
    EOF
    )
    git commit -am "$COMMIT_MSG"
    git push

# generate installed casks list json file
@generate-cask-list: && preview
    brew list --cask | xargs brew info --cask --json=v2 | \
    jq '[."casks"|.[]|{token,full_token,name:.name[0],homepage,desc,caveats,installed}]' > installed-casks.json

# install all casks in the list file
@cask-install-all:
    jq '.[]|.["token"]' installed-casks.json | xargs brew install --cask

# install casks interactively
@cask-install:
    jq -r '.[]|{"token", "installed"} | "\(.token) \(.installed)"' installed-casks.json | \
    fzf -m --bind 'alt-a:select-all,alt-d:deselect-all' | \
    cut -d' ' -f1 | xargs brew install --cask

# generate installed rust crates list json file
@generate-crate-list: && preview
    cargo install --list | grep -E '^\w' | tr -d ':' > installed-crates-bins.txt

# install all crates in the list file
@crate-install-all:
    cat installed-crates-bins.txt | cut -d ' ' -f1 | xargs cargo install

# install crates interactively
@crate-install:
    cat installed-crates-bins.txt | fzf -m --bind 'alt-a:select-all,alt-d:deselect-all' | \
    cut -d ' ' -f1 | xargs cargo install
