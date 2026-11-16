#!/bin/bash

# env
source "$(dirname -- "${BASH_SOURCE[0]}")/llm_env.sh"
llm_env 'OPENAI|ANTHROPIC|DEEP'

cd "$GIT_PATH"/linux-setup/submodules/librechat
docker compose up -d
