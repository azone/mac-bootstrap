list_file := "formulae-list.json"

default: generate-list

# generate installed homebrew formulae list json file
@generate-list:
    brew leaves | xargs brew info --json | \
    jq '[.[]|{"name", "desc", "homepage", "tap", "caveats", "linked_keg"}]' > {{list_file}}

# install formulae in the list file
@install-all:
    jq '.[]|.["name"]' {{list_file}} | xargs brew install

# install interactively
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
    HEADLINE="Formulae updated ($DS)"
    COMMIT_MSG=$(cat << EOF
    $HEADLINE

    $MSG
    EOF
    )
    git commit -am "$COMMIT_MSG"
    git push
