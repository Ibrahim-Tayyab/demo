"""
Vercel Serverless Function for Health Check
Handles GET requests to /api/health
"""

import json
from typing import Any, Dict


async def handle_request(event: Dict[str, Any], context: Any) -> Dict[str, Any]:
    """
    Health check endpoint
    """
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        },
        "body": json.dumps({
            "status": "ok",
            "message": "Physical AI Chatbot Backend is active!",
            "version": "1.0"
        }),
    }
