from fastapi import FastAPI
from fastmcp import FastMCP
from app.routers import chat, health

app = FastAPI(title="FastAPI AI Stack", version="0.1.0")

# Initialize FastMCP
mcp = FastMCP("MyMCP")


@mcp.tool()
async def get_weather(city: str) -> str:
    """Get the current weather for a city."""
    return f"The weather in {city} is sunny."


# Include routers
app.include_router(chat.router, prefix="/api/chat", tags=["chat"])
app.include_router(health.router, prefix="/api/health", tags=["health"])


@app.get("/")
async def root():
    return {"message": "Welcome to FastAPI AI Stack"}
