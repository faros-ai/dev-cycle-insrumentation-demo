# lighthouse

A demo repository with development cycle Faros events instrumentation 

# Usage

1. Define environment variables:
```
export FAROS_URL="https://prod.api.faros.ai"
export FAROS_API_KEY="..."
export FAROS_GRAPH="..."
```

2. Run `./setup_hooks.sh` once to setup git hooks.

All the invocations on `git` and `npm` commands will send events to Faros, e.g `git checkout -b ...`, `npm i`, `npm run build`, `npm run test`, `git commit -m ...`
