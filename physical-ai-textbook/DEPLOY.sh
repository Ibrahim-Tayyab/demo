#!/bin/bash
# Deployment commands for Physical AI Chatbot to Vercel

# ============================================================================
# STEP 1: Prepare Your Code
# ============================================================================

# Make sure you're in the project root
cd physical-ai-textbook

# Check status
git status

# Stage all changes
git add -A

# Commit with descriptive message
git commit -m "Fix FastAPI Vercel deployment - resolves 404 error

- Add proper Vercel serverless handlers (api/chat/handler.py, api/health/handler.py)
- Configure vercel.json with correct routing
- Fix frontend API endpoint detection for production
- Add comprehensive deployment guides"

# Push to your repository
git push origin main

# ============================================================================
# STEP 2: Configure Vercel Dashboard
# ============================================================================

# Go to: https://vercel.com/dashboard/physical-ai-textbook
# Click: Settings → Environment Variables
# Add these 4 variables (for Production, Preview, Development):

# Variable 1: QDRANT_URL
# Value: https://[your-instance].europe-west3-0.gcp.cloud.qdrant.io:6333

# Variable 2: QDRANT_API_KEY
# Value: [your-qdrant-api-key]

# Variable 3: COHERE_API_KEY
# Value: [your-cohere-api-key]

# Variable 4: GOOGLE_API_KEY
# Value: [your-google-api-key]

# Optional: Add MODEL_NAME
# Value: gemini-1.5-flash-latest

# ============================================================================
# STEP 3: Deploy
# ============================================================================

# Option A: Automatic deployment (GitHub sync)
# - Vercel automatically deploys when you push to main
# - Check dashboard for deployment status

# Option B: Manual deployment with Vercel CLI
npm install -g vercel          # Install Vercel CLI (if not already)
vercel login                    # Login to your Vercel account
vercel --prod                   # Deploy to production

# ============================================================================
# STEP 4: Verify Deployment
# ============================================================================

# Check deployment status on Vercel Dashboard
# - Go to: https://vercel.com/dashboard/physical-ai-textbook
# - Click: Deployments
# - Should see your latest deployment as "Ready"

# ============================================================================
# STEP 5: Test
# ============================================================================

# Test endpoints:
# 1. Health check (should return status: ok)
#    GET https://your-domain.vercel.app/api/health

# 2. Try chatbot in browser
#    Visit https://your-domain.vercel.app
#    Click chat icon and send a message

# ============================================================================
# STEP 6: Monitor (if needed)
# ============================================================================

# View logs in Vercel Dashboard:
# - Go to: Deployments → [Your Deployment] → Functions
# - View real-time logs
# - Check for errors

# Enable debug logging (optional):
# - Settings → Environment Variables
# - Add: LOG_LEVEL = DEBUG
# - Redeploy

# ============================================================================
# STEP 7: Rollback (if something goes wrong)
# ============================================================================

# Vercel keeps deployment history
# - Go to: Deployments
# - Find previous working deployment
# - Click the 3-dot menu → "Promote to Production"

# ============================================================================
# LOCAL DEVELOPMENT (Unchanged)
# ============================================================================

# Terminal 1: Backend
cd physical-ai-textbook/chatbot
python api.py
# or
uvicorn api:app --reload

# Terminal 2: Frontend
cd physical-ai-textbook
npm start

# Visit http://localhost:3000

# ============================================================================
# TROUBLESHOOTING
# ============================================================================

# Problem: 404 Error in production
# Solution:
#   1. Check env vars in Vercel Dashboard (Settings → Environment Variables)
#   2. Make sure all 4 API keys are set
#   3. Go to Deployments → Latest deployment
#   4. Click "Redeploy"
#   5. Wait for rebuild to complete

# Problem: Backend not responding
# Solution:
#   1. Verify API keys are correct
#   2. Check Vercel logs: Deployments → Functions
#   3. Test locally first: cd chatbot && python api.py

# Problem: Chat doesn't respond with content
# Solution:
#   1. Check Cohere API key is valid
#   2. Check Qdrant URL and key are correct
#   3. Check Google Gemini API key
#   4. Enable DEBUG logging and check logs

# Problem: CORS errors
# Solution:
#   1. Already fixed in FastAPI
#   2. If still happening, check browser console for exact error
#   3. Refresh browser and try again

# ============================================================================
# USEFUL LINKS
# ============================================================================

# Vercel Dashboard: https://vercel.com/dashboard
# Your Project: https://vercel.com/dashboard/physical-ai-textbook
# Environment Variables: https://vercel.com/dashboard/physical-ai-textbook/settings/environment-variables
# Deployments: https://vercel.com/dashboard/physical-ai-textbook/deployments
# Logs: https://vercel.com/dashboard/physical-ai-textbook/monitoring

# Documentation:
# - Deployment Quick Start: DEPLOYMENT_QUICK_START.md
# - Full Guide: VERCEL_DEPLOYMENT_GUIDE.md
# - Technical Details: FASTAPI_VERCEL_FIX.md

# ============================================================================
# DONE!
# ============================================================================

echo "✅ Deployment setup complete!"
echo "Visit your Vercel domain to test the chatbot"
echo "For issues, check DEPLOYMENT_QUICK_START.md"
