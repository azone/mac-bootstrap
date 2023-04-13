list_file := "formulae-list.json"

default: generate-list

# generate installed homebrew formulae list json file
generate-list:
    brew leaves | xargs brew info --json | \
    jq '[.[]|{"name", "desc", "homepage", "tap", "caveats", "linked_keg"}]' > {{list_file}}

# install formulae in the list file
install:
    jq '.[]|.["name"]' {{list_file}} | xargs brew install
