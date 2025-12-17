# FastAPI Vercel Deployment - Complete Fix

## What Was Wrong

The original setup had several issues preventing the chatbot from working on Vercel:

1. **Incorrect Serverless Function Structure**: Vercel expects handlers in specific formats that weren't being used correctly
2. **Empty Routing Configuration**: The `vercel.json` was empty, so Vercel didn't know how to route API requests
3. **Missing Python Runtime Declaration**: Vercel didn't know these were Python functions
4. **Improper API URL Detection**: The frontend wasn't detecting the correct API endpoint for production

## The Solution

### 1. Created Proper Vercel Serverless Handlers

**Before**: Using legacy `chat.py` with `BaseHTTPRequestHandler` (incompatible with Vercel)

**After**: Created two new handler files:

#### `api/chat/handler.py`
- Wraps the FastAPI app with Mangum (serverless ASGI adapter)
- Exports an async `handle_request` function for Vercel
- Handles all `/api/chat` requests

#### `api/health/handler.py`
- Lightweight health check endpoint
- Returns status without needing the full FastAPI app

### 2. Configured `vercel.json`

**Before**: Empty configuration

**After**: Complete routing configuration:
```json
{
  "version": 2,
  "functions": {
    "api/chat/handler.py": { "runtime": "python3.9" },
    "api/health/handler.py": { "runtime": "python3.9" }
  },
  "routes": [
    { "src": "/api/health", "dest": "api/health/handler.py" },
    { "src": "/api/chat", "dest": "api/chat/handler.py" },
    { "src": "/(.*)", "dest": "/index.html", "status": 200 }
  ],
  "env": ["QDRANT_URL", "QDRANT_API_KEY", "COHERE_API_KEY", "GOOGLE_API_KEY", ...]
}
```

This tells Vercel:
- Where the Python functions are located
- What runtime to use (Python 3.9)
- How to route requests to functions
- What environment variables are needed

### 3. Updated Frontend API Detection

**Before**: 
```typescript
const API_URL = typeof window !== 'undefined' && window.location.hostname === 'localhost'
    ? 'http://localhost:8000'
    : '/api';
```
This caused issues in production because it was looking for `/api` but the routes were different.

**After**:
```typescript
const getAPIUrl = () => {
    const hostname = window.location.hostname;
    const isLocalhost = hostname === 'localhost' || hostname === '127.0.0.1';
    
    if (isLocalhost) {
        return 'http://localhost:8000';
    }
    return ''; // Use relative paths for production
};
```

Now it correctly uses relative paths (`/api/chat`, `/api/health`) in production.

### 4. Added Documentation

- **VERCEL_DEPLOYMENT_GUIDE.md**: Complete step-by-step guide for deployment
- **.env.example**: Template for required environment variables
- **Updated README.md**: Clear deployment instructions

## How to Deploy Now

### Step 1: Prepare Your Repository
```bash
# Make sure you have all the files
git add -A
git commit -m "Fix FastAPI Vercel deployment"
git push origin main
```

### Step 2: Set Environment Variables in Vercel Dashboard
1. Go to: https://vercel.com/your-username/physical-ai-textbook
2. Click **Settings** → **Environment Variables**
3. Add these variables (make sure they're set for Production, Preview, and Development):
   ```
   QDRANT_URL=https://[your-instance].europe-west3-0.gcp.cloud.qdrant.io:6333
   QDRANT_API_KEY=[your-key]
   COHERE_API_KEY=[your-key]
   GOOGLE_API_KEY=[your-key]
   MODEL_NAME=gemini-1.5-flash-latest
   ```

### Step 3: Redeploy
1. Go to **Deployments** → Click the latest deployment
2. Click **Redeploy** to rebuild with the environment variables

### Step 4: Test
- Open your Vercel domain
- Click the chat icon
- Try sending a message
- Should now work without 404 errors! ✅

## Why This Works Now

### Request Flow:
```
User Message
    ↓
Frontend: fetch('/api/chat', {...})
    ↓
Vercel: Routes to api/chat/handler.py
    ↓
Handler.py: Mangum wraps FastAPI app
    ↓
FastAPI:
  - Validates request
  - Embeds query with Cohere
  - Retrieves docs from Qdrant
  - Calls Gemini API
  - Returns response
    ↓
Response sent back to frontend
```

## Files Changed

| File | Changes |
|------|---------|
| `api/chat/handler.py` | **NEW** - Vercel handler for chat endpoint |
| `api/health/handler.py` | **NEW** - Vercel handler for health endpoint |
| `vercel.json` | **UPDATED** - Added complete routing configuration |
| `requirements.txt` | Already had `mangum` (no changes needed) |
| `src/components/ChatAssistant.tsx` | **UPDATED** - Fixed API URL detection |
| `README.md` | **UPDATED** - Added deployment instructions |
| `.env.example` | **NEW** - Template for environment variables |
| `VERCEL_DEPLOYMENT_GUIDE.md` | **NEW** - Comprehensive deployment guide |

## Troubleshooting

### Still getting 404?
1. Check environment variables are set in Vercel Dashboard
2. Trigger a redeploy after setting variables
3. Check Vercel logs: Deployments → Functions

### Backend returns empty?
1. Verify all API keys are correct
2. Check they're set in Production environment in Vercel
3. Test locally first: `cd chatbot && python api.py`

### CORS errors?
- Already fixed in FastAPI with `allow_origins=["*"]`
- If still issues, check browser console for exact error

### Cold start delays?
- Normal for serverless functions (Vercel free tier)
- Usually only happens after long idle periods
- Subsequent requests are much faster

## Local Development

Nothing changes! Still works the same:
```bash
cd physical-ai-textbook

# Install dependencies
pip install -r requirements.txt

# Create .env with your API keys
# Start backend
cd chatbot && python api.py

# In another terminal
npm start
```

Visit http://localhost:3000 and chat works as before.

## Next Steps

1. ✅ Verify all files are in place
2. ✅ Push to your repository
3. ✅ Set environment variables in Vercel
4. ✅ Redeploy
5. ✅ Test in production
6. ✅ Monitor logs if needed

Your chatbot should now work perfectly on Vercel! 🎉
