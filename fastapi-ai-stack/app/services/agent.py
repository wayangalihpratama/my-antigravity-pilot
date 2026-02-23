from typing import TypedDict, Annotated
from langgraph.graph import StateGraph, END
from langgraph.graph.message import add_messages
from langchain_core.messages import HumanMessage


class State(TypedDict):
    messages: Annotated[list, add_messages]


def call_model(state: State):
    # This is a placeholder for actual LLM call
    # In a real scenario, you would use:
    # llm = ChatOpenAI(model="gpt-4o")
    # response = llm.invoke(state["messages"])
    # return {"messages": [response]}

    user_message = state["messages"][-1].content
    return {
        "messages": [{"role": "assistant", "content": f"Echo: {user_message}"}]
    }


workflow = StateGraph(State)
workflow.add_node("agent", call_model)
workflow.set_entry_point("agent")
workflow.add_edge("agent", END)

agent = workflow.compile()


async def run_agent(message: str):
    initial_state = {"messages": [HumanMessage(content=message)]}
    try:
        result = await agent.ainvoke(initial_state)
        # LangGraph result messages might be dictionaries or objects
        last_msg = result["messages"][-1]
        if hasattr(last_msg, "content"):
            return last_msg.content
        if isinstance(last_msg, dict):
            return last_msg.get("content", str(last_msg))
        return str(last_msg)
    except Exception as e:
        print(f"Agent Error: {e}")
        raise
