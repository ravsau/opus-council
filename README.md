# Opus Council

> A Claude Code skill that orchestrates an LLM council with Claude Opus as chairman — optimized for Claude Max subscribers.

## The Idea

Inspired by [Karpathy's llm-council](https://github.com/karpathy/llm-council), but with a key cost optimization: **use your Claude Max subscription as the "free" chairman** while only paying OpenRouter for the council members.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Claude Code                          │
│                   (Claude Opus 4.5)                      │
│              ┌─────────────────────────┐                │
│              │   CHAIRMAN + MEMBER     │                │
│              │   • Synthesizes views   │                │
│              │   • Adds own opinion    │                │
│              │   • Resolves conflicts  │                │
│              └───────────▲─────────────┘                │
│                          │                               │
│              ┌───────────┴───────────┐                  │
│              │   /council skill      │                  │
│              └───────────┬───────────┘                  │
└──────────────────────────┼──────────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │      OpenRouter API      │
              └─────────────────────────┘
                    │     │     │
          ┌─────────┘     │     └─────────┐
          ▼               ▼               ▼
    ┌──────────┐   ┌──────────┐   ┌──────────┐
    │  GPT-4o  │   │ Gemini   │   │  Grok 2  │
    │          │   │2.0 Flash │   │          │
    └──────────┘   └──────────┘   └──────────┘
```

## Why This Works

| Component | Cost | Notes |
|-----------|------|-------|
| Claude Opus (Chairman) | $0 | Covered by Max subscription |
| Council Members | ~$0.01-0.05/query | Pay-per-token via OpenRouter |

Traditional llm-council calls Opus via API for the synthesis step — the most token-heavy operation since it sees ALL responses. By using Claude Code directly, that cost becomes $0.

## The Flow

1. **User asks Claude a hard question** via Claude Code
2. **Skill triggers** → Calls OpenRouter in parallel for council opinions
3. **Responses return** → Formatted and injected into conversation
4. **Claude synthesizes** → Acts as chairman AND contributes its own perspective
5. **User gets** → Multi-model wisdom, synthesized by Opus

## Example Usage

```
You: /council What's the best architecture for a real-time collaborative editor?

[Skill fetches responses from GPT-5.1, Gemini 3 Pro, Grok 4...]

Council Responses:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

GPT-5.1: CRDTs are the gold standard. Consider Yjs or Automerge...

Gemini 3 Pro: OT (Operational Transform) is battle-tested at Google scale...

Grok 4: Depends on your latency requirements. For <100ms, consider...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Claude (Chairman): Looking across these perspectives, there's an interesting
tension between CRDTs and OT. Here's my synthesis...

[Claude provides unified answer incorporating all viewpoints + its own analysis]
```

## Installation

### 1. Get an OpenRouter API Key

Sign up at [openrouter.ai](https://openrouter.ai) and get your API key.

### 2. Add API Key to ~/.env

```bash
echo "OPENROUTER_API_KEY=your_key_here" >> ~/.env
```

### 3. Install the Skill

**Option A: Symlink to Claude Code skills directory**
```bash
ln -s /path/to/opus-council/skill ~/.claude/skills/council
```

**Option B: Copy the skill**
```bash
mkdir -p ~/.claude/skills/council
cp -r skill/* ~/.claude/skills/council/
```

### 4. Update the script path

Edit `~/.claude/skills/council/SKILL.md` and update the path to `council.sh` if needed.

### 5. Use it!

```
/council What's the best way to implement authentication in a Next.js app?
```

## Files

```
skill/
├── SKILL.md      # Skill definition for Claude Code
└── council.sh    # Shell script that calls OpenRouter API
```

## Implementation Status

### Phase 1: Core Skill
- [x] Create `/council` Claude Code skill
- [x] OpenRouter API integration
- [x] Response formatting and injection
- [x] Basic model selection (GPT-4o, Gemini 2.0 Flash, Grok 2)

### Phase 2: Configuration
- [ ] Configurable council members via config file
- [ ] Custom system prompts per council member
- [ ] Token/cost tracking

### Phase 3: Advanced
- [ ] Parallel API calls (currently sequential)
- [ ] Council member review round (optional)
- [ ] Confidence scoring
- [ ] Response caching for identical queries

## Requirements

- Claude Max subscription (for Opus access via Claude Code)
- OpenRouter API key (in `~/.env`)
- Claude Code CLI installed
- `jq` installed (`brew install jq` on macOS)

## Key Differentiators from llm-council

| Feature | llm-council | opus-council |
|---------|-------------|--------------|
| Chairman model | Configurable (paid) | Always Opus (free via Max) |
| Interface | Web UI | CLI (Claude Code skill) |
| Opus calls | Via OpenRouter ($$$) | Via Max subscription ($0) |
| Interactivity | Static response | Full conversation context |

## License

MIT

---

*Built for Claude Max subscribers who want multi-model wisdom without multi-model bills.*
