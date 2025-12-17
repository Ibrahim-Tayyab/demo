"""
Vercel Serverless Function for Chat API
Handles POST requests to /api/chat
"""

import json
import os
import sys
import logging
from typing import Any, Dict

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Import the FastAPI app from the parent directory
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

try:
    from index import app as fastapi_app
    from mangum import Mangum
    
    # Wrap FastAPI app with Mangum for Vercel
    handler = Mangum(fastapi_app, lifespan="off")
    HANDLER_AVAILABLE = True
except Exception as e:
    logger.error(f"Failed to load FastAPI app: {e}", exc_info=True)
    HANDLER_AVAILABLE = False
    error_message = str(e)


async def handle_request(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Main handler function for Vercel serverless
    """
    if not HANDLER_AVAILABLE:
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": json.dumps({
                "error": "Backend initialization failed",
                "details": error_message,
            }),
        }
    
    try:
        # Call Mangum handler
        response = await handler(event, context)
        return response
    except Exception as e:
        logger.error(f"Request handling error: {e}", exc_info=True)
        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
            },
            "body": json.dumps({
                "error": "Internal server error",
                "details": str(e),
            }),
        }
