default: generate-list

# generate installed homebrew formulae list json file
generate-list:
    brew leaves | xargs brew info --json | \
    jq '[.[]|{"name", "desc", "homepage", "tap", "caveats", "linked_keg"}]' > formulae-list.json
