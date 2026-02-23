from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.services.agent import run_agent

router = APIRouter()


class ChatRequest(BaseModel):
    message: str


class ChatResponse(BaseModel):
    response: str


@router.post("/", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        result = await run_agent(request.message)
        return {"response": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
