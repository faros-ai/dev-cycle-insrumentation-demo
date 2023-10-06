# Full Development Cycle Instrumentation

A demo of Faros events instrumentation for measuring full development cycle.

The invocations of `git` and `npm` commands will send events to Faros, e.g:

- `git checkout -b ...`
- `npm i`
- `npm run build`
- `npm run test`
- `git commit -m ...`

# Usage

1. Define environment variables:

```
export FAROS_URL="https://prod.api.faros.ai"
export FAROS_API_KEY="..."
export FAROS_GRAPH="..."
```

2. Run once `./setup_hooks.sh` to setup git hooks

🤗 Enjoy!
