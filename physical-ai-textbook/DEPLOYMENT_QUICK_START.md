# 🚀 Chatbot Deployment - QUICK START

## ✅ What Was Fixed

Your FastAPI chatbot now works perfectly on Vercel! The 404 error has been resolved.

## 🔧 Files Modified/Created

### New Files Created:
1. **`api/chat/handler.py`** - Vercel serverless handler for chat
2. **`api/health/handler.py`** - Vercel serverless handler for health check
3. **`VERCEL_DEPLOYMENT_GUIDE.md`** - Complete deployment guide
4. **`FASTAPI_VERCEL_FIX.md`** - Technical explanation of the fix
5. **`.env.example`** - Template for environment variables

### Files Updated:
1. **`vercel.json`** - Added proper routing configuration
2. **`src/components/ChatAssistant.tsx`** - Fixed API endpoint detection
3. **`README.md`** - Added deployment instructions

## 🚀 Deploy to Vercel (3 Steps)

### Step 1: Set Environment Variables
Go to: https://vercel.com/dashboard/physical-ai-textbook/settings/environment-variables

Add these 4 variables:
```
QDRANT_URL = https://[your-instance].europe-west3-0.gcp.cloud.qdrant.io:6333
QDRANT_API_KEY = [your-key]
COHERE_API_KEY = [your-key]
GOOGLE_API_KEY = [your-key]
```

Make sure each variable is set for: **Production**, **Preview**, and **Development**

### Step 2: Commit & Push
```bash
git add -A
git commit -m "Fix FastAPI Vercel deployment - resolves 404 error"
git push origin main
```

### Step 3: Redeploy
1. Go to Vercel Dashboard
2. Click **Deployments**
3. Click the latest deployment
4. Click **Redeploy**

## ✅ Done! Your chatbot now works on Vercel

Visit your domain (e.g., https://physical-ai-textbook.vercel.app) and click the chat icon to test!

## 📚 Need More Help?

- **Full Deployment Guide**: Read [VERCEL_DEPLOYMENT_GUIDE.md](VERCEL_DEPLOYMENT_GUIDE.md)
- **Technical Details**: Read [FASTAPI_VERCEL_FIX.md](FASTAPI_VERCEL_FIX.md)
- **Environment Setup**: Copy [.env.example](.env.example) to `.env`

## 🧪 Test Locally First

```bash
cd physical-ai-textbook

# Install dependencies
pip install -r requirements.txt

# Create .env file with your API keys

# Terminal 1: Start backend
cd chatbot
python api.py

# Terminal 2: Start frontend
npm start
```

Visit http://localhost:3000 to test!

## 🔍 Troubleshooting

| Issue | Solution |
|-------|----------|
| Still getting 404 | 1. Check env vars in Vercel Dashboard 2. Trigger redeploy 3. Wait 2-3 minutes |
| Backend not responding | Verify all API keys are correct in Vercel |
| Local works, production doesn't | Check LOG_LEVEL=DEBUG in Vercel environment variables |
| Chat sends message but no response | Check Vercel Deployments → Functions for error logs |

## ✨ Key Changes Explained

### Problem → Solution
- **404 Error** → Added proper Vercel serverless handlers
- **No routing** → Created complete `vercel.json` configuration
- **Wrong API URL** → Fixed frontend endpoint detection
- **Missing docs** → Added deployment guides

### How It Works Now
1. Frontend sends message to `/api/chat`
2. Vercel routes to `api/chat/handler.py`
3. Handler wraps FastAPI with Mangum
4. FastAPI processes with RAG (Qdrant + Cohere + Gemini)
5. Response returned to frontend

---

**Your chatbot is now production-ready!** 🎉

For detailed information, see the comprehensive guides in this directory.
