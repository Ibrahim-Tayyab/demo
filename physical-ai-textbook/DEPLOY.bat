@echo off
REM Deployment commands for Physical AI Chatbot to Vercel (Windows)

REM ============================================================================
REM STEP 1: Prepare Your Code
REM ============================================================================

echo.
echo ============================================================================
echo STEP 1: Prepare Your Code
echo ============================================================================
echo.

REM Make sure you're in the project root
cd physical-ai-textbook

REM Check status
echo Checking git status...
git status

REM Stage all changes
echo.
echo Staging all changes...
git add -A

REM Commit with descriptive message
echo Committing changes...
git commit -m "Fix FastAPI Vercel deployment - resolves 404 error"

REM Push to your repository
echo Pushing to repository...
git push origin main

echo.
echo ✅ Code prepared and pushed!
echo.

REM ============================================================================
REM STEP 2: Configure Vercel Dashboard (Manual)
REM ============================================================================

echo ============================================================================
echo STEP 2: Configure Vercel Dashboard
echo ============================================================================
echo.
echo Please follow these steps in your browser:
echo.
echo 1. Go to: https://vercel.com/dashboard/physical-ai-textbook
echo 2. Click: Settings → Environment Variables
echo 3. Add these 4 variables (for Production, Preview, Development):
echo.
echo    QDRANT_URL=https://[your-instance].europe-west3-0.gcp.cloud.qdrant.io:6333
echo    QDRANT_API_KEY=[your-qdrant-api-key]
echo    COHERE_API_KEY=[your-cohere-api-key]
echo    GOOGLE_API_KEY=[your-google-api-key]
echo.
echo 4. (Optional) Add MODEL_NAME=gemini-1.5-flash-latest
echo.

REM Open browser automatically
echo Opening Vercel Dashboard...
start https://vercel.com/dashboard/physical-ai-textbook/settings/environment-variables

REM Wait for user to set environment variables
pause
echo Press any key to continue...

REM ============================================================================
REM STEP 3: Deploy
REM ============================================================================

echo.
echo ============================================================================
echo STEP 3: Deploy
echo ============================================================================
echo.

REM Check if Vercel CLI is installed
where vercel >nul 2>nul
if errorlevel 1 (
    echo Vercel CLI not found. Installing...
    npm install -g vercel
)

REM Deploy to production
echo Deploying to Vercel...
vercel --prod

REM ============================================================================
REM STEP 4: Verify
REM ============================================================================

echo.
echo ============================================================================
echo STEP 4: Verify Deployment
echo ============================================================================
echo.
echo ✅ Your deployment is ready!
echo.
echo Next steps:
echo 1. Go to: https://vercel.com/dashboard/physical-ai-textbook/deployments
echo 2. Wait for your deployment to show "Ready"
echo 3. Click on it to see your domain URL
echo 4. Visit your domain and test the chatbot
echo.

start https://vercel.com/dashboard/physical-ai-textbook/deployments

REM ============================================================================
REM STEP 5: Local Development Commands
REM ============================================================================

echo.
echo ============================================================================
echo Local Development (For Testing Locally)
echo ============================================================================
echo.
echo To test locally before deploying:
echo.
echo Terminal 1 - Start Backend:
echo   cd physical-ai-textbook\chatbot
echo   python api.py
echo.
echo Terminal 2 - Start Frontend:
echo   cd physical-ai-textbook
echo   npm start
echo.
echo Then visit: http://localhost:3000
echo.

REM ============================================================================
REM TROUBLESHOOTING
REM ============================================================================

echo.
echo ============================================================================
echo Troubleshooting
echo ============================================================================
echo.
echo Problem: 404 Error
echo Solution: 1. Check env vars in Vercel Dashboard
echo           2. Make sure all 4 API keys are set
echo           3. Go to Deployments and click Redeploy
echo.
echo Problem: Backend not responding
echo Solution: 1. Verify all API keys are correct
echo           2. Check Vercel logs in Deployments ^> Functions
echo.
echo Problem: Chat doesn't respond
echo Solution: 1. Check Cohere, Qdrant, and Gemini API keys
echo           2. Test locally first
echo.
echo For more help, read:
echo - DEPLOYMENT_QUICK_START.md
echo - VERCEL_DEPLOYMENT_GUIDE.md
echo.

echo ✅ DEPLOYMENT COMPLETE!
echo.
pause
