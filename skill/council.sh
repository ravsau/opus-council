#!/bin/bash
# council.sh - Query multiple LLMs via OpenRouter

set -e

# Load API key from ~/.env
if [ -f ~/.env ]; then
    export $(grep -E '^OPENROUTER_API_KEY=' ~/.env | xargs)
fi

if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "Error: OPENROUTER_API_KEY not found in ~/.env"
    exit 1
fi

QUERY="$1"

if [ -z "$QUERY" ]; then
    echo "Usage: council.sh \"your question here\""
    exit 1
fi

# Council members (customize as needed)
MODELS=(
    "openai/gpt-4o"
    "google/gemini-2.0-flash-001"
    "x-ai/grok-2-1212"
)

MODEL_NAMES=(
    "GPT-4o"
    "Gemini 2.0 Flash"
    "Grok 2"
)

echo "Council Responses:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Query each model
for i in "${!MODELS[@]}"; do
    MODEL="${MODELS[$i]}"
    NAME="${MODEL_NAMES[$i]}"

    RESPONSE=$(curl -s https://openrouter.ai/api/v1/chat/completions \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "Content-Type: application/json" \
        -H "HTTP-Referer: https://github.com/ravsau/opus-council" \
        -H "X-Title: Opus Council" \
        -d "{
            \"model\": \"$MODEL\",
            \"messages\": [{
                \"role\": \"user\",
                \"content\": $(echo "$QUERY" | jq -Rs .)
            }],
            \"max_tokens\": 1000
        }" 2>/dev/null)

    # Extract content from response
    CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // .error.message // "No response"')

    echo "**$NAME:**"
    echo "$CONTENT"
    echo ""
    echo "---"
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "As Chairman, please synthesize these perspectives and add your own analysis."
