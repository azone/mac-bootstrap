list_file := "formulae-list.json"

default: generate-list

# generate installed homebrew formulae list json file
generate-list:
    brew leaves | xargs brew info --json | \
    jq '[.[]|{"name", "desc", "homepage", "tap", "caveats", "linked_keg"}]' > {{list_file}}

# install formulae in the list file
install:
    jq '.[]|.["name"]' {{list_file}} | xargs brew install

# commit & push formulae changes
@push-changes:
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
