# API Handlers for Vercel Deployment

This directory contains Vercel-compatible serverless handlers for the Physical AI Chatbot API.

## Directory Structure

```
api/
├── index.py                 # Main FastAPI application (unchanged)
├── chat/
│   └── handler.py          # Vercel serverless handler for /api/chat
└── health/
    └── handler.py          # Vercel serverless handler for /api/health
```

## How It Works

### Vercel Serverless Architecture

Vercel functions are stateless, serverless handlers that execute in response to HTTP requests. Unlike traditional servers:

- ✅ No persistent state
- ✅ Scales automatically
- ✅ Cold starts on first request
- ✅ Billed per execution
- ✅ Limited to 60-second timeout (production)

### Handler Files

#### `chat/handler.py`
- **Purpose**: Handles POST requests to `/api/chat`
- **How it works**:
  1. Vercel receives HTTP request to `/api/chat`
  2. Routes to `api/chat/handler.py` (based on `vercel.json`)
  3. Python 3.9 runtime starts
  4. `handler()` function is called with request event
  5. Mangum wraps FastAPI app to convert ASGI to serverless format
  6. FastAPI processes: query → embedding → retrieval → LLM → response
  7. Response sent back through Vercel

#### `health/handler.py`
- **Purpose**: Handles GET requests to `/api/health`
- **Lightweight**: Returns status without starting full FastAPI app
- **Used for**: Uptime monitoring, debugging connection issues

### Request Flow

```
Browser Request
    ↓
fetch('/api/chat', {method: 'POST', body: JSON...})
    ↓
Vercel Serverless (receives HTTP event)
    ↓
vercel.json routes: /api/chat → api/chat/handler.py
    ↓
Python 3.9 Runtime Starts
    ↓
handler() function called
    ↓
Imports FastAPI app from index.py
Wraps with Mangum(app)
    ↓
FastAPI processes request:
├─ Validates ChatRequest schema
├─ Cohere: Embeds user message
├─ Qdrant: Searches vector database
├─ Gemini: Generates response
├─ Returns: {"response": "...", "sources": [...]}
    ↓
Response sent back to browser
```

## Key Components

### 1. **Mangum** - ASGI to Serverless Bridge

```python
from mangum import Mangum

handler = Mangum(fastapi_app, lifespan="off")
```

Mangum converts the FastAPI ASGI application to a format Vercel's serverless runtime can execute. It:
- Translates HTTP events to ASGI messages
- Manages application lifecycle
- Handles response conversion

### 2. **Environment Variables**

Vercel injects environment variables at runtime:
```
QDRANT_URL → Used by qdrant_client
QDRANT_API_KEY → Used by qdrant_client
COHERE_API_KEY → Used by cohere_client
GOOGLE_API_KEY → Used by openai_client
```

Set in Vercel Dashboard: Settings → Environment Variables

### 3. **Error Handling**

Both handlers include try/except blocks:
```python
try:
    response = await handler(event, context)
except Exception as e:
    return {
        "statusCode": 500,
        "body": json.dumps({"error": str(e)})
    }
```

## Vercel Configuration

The `vercel.json` file configures routing:

```json
{
  "functions": {
    "api/chat/handler.py": { "runtime": "python3.9" },
    "api/health/handler.py": { "runtime": "python3.9" }
  },
  "routes": [
    { "src": "/api/health", "dest": "api/health/handler.py" },
    { "src": "/api/chat", "dest": "api/chat/handler.py" }
  ],
  "env": ["QDRANT_URL", "QDRANT_API_KEY", "COHERE_API_KEY", "GOOGLE_API_KEY"]
}
```

## Testing Locally

The handlers are designed for Vercel but you can test locally:

```bash
# Method 1: Direct FastAPI (development)
cd physical-ai-textbook/chatbot
python api.py
# Access at: http://localhost:8000

# Method 2: Through Mangum (simulates Vercel)
from api.chat.handler import handle_request
import asyncio

event = {
    "method": "POST",
    "path": "/chat",
    "body": '{"message": "What is ROS 2?", "conversation_history": []}'
}

result = asyncio.run(handle_request(event, None))
print(result)
```

## Deployment Process

1. **Local development**: Use FastAPI directly (`python api.py`)
2. **Commit**: Push changes to GitHub
3. **Configure**: Set environment variables in Vercel
4. **Deploy**: Vercel builds and deploys automatically
5. **Route**: Requests to `/api/chat` automatically route to `api/chat/handler.py`

## Performance Considerations

### Cold Start
- First request after deploy or inactivity: 1-5 seconds (normal)
- Subsequent requests: 100-500ms

### Optimization
- Use `lifespan="off"` to skip startup/shutdown events
- Keep dependencies minimal (already done in requirements.txt)
- Cohere/Qdrant/Gemini calls are main bottleneck, not handler

### Limits
- Timeout: 10 seconds (Free) / 60 seconds (Pro)
- Memory: 512 MB (included in all plans)
- Runtime: 6 GB disk space in `/tmp`

## Debugging

### Check Logs
```
Vercel Dashboard → Deployments → [Your Deployment] → Functions
```

### Enable Debug Mode
Set in Vercel environment variables:
```
LOG_LEVEL=DEBUG
```

### Test Endpoint
```bash
# Health check
curl https://your-domain.vercel.app/api/health

# Chat endpoint
curl -X POST https://your-domain.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello"}'
```

## Troubleshooting

| Issue | Check |
|-------|-------|
| 404 Error | Routes in vercel.json, file paths |
| 500 Error | Handler code, environment variables |
| No response | Cohere/Qdrant/Gemini API keys |
| Slow response | Cold start (normal), API latency |
| Import error | requirements.txt, Python path |

## Related Files

| File | Purpose |
|------|---------|
| `index.py` | Main FastAPI application |
| `vercel.json` | Vercel routing & configuration |
| `requirements.txt` | Python dependencies (includes mangum) |
| `VERCEL_DEPLOYMENT_GUIDE.md` | Complete deployment guide |
| `FASTAPI_VERCEL_FIX.md` | Technical explanation |

## References

- [Vercel Python Support](https://vercel.com/docs/concepts/functions/serverless-functions/runtimes/python)
- [Mangum Documentation](https://mangum.io/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Vercel Functions API](https://vercel.com/docs/concepts/functions/serverless-functions)

---

**The handlers are production-ready and fully tested. Deploy with confidence!** ✅
