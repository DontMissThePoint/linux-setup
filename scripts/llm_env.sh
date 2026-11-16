#!/bin/bash

llm_env() {
    local keys=$1
    local config="$HOME/Public/Journal/llm_mcp.json"
    [ -f "$config" ] || return 0
    eval "$(docker run --rm -i decknroll/json2env --export --upper <"$config" | grep -E "$keys")"
}
