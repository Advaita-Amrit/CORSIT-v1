import os
import json
from typing import List, Dict, Any
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from langchain_chroma import Chroma
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_core.runnables.history import RunnableWithMessageHistory
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

# Load environment variables
load_dotenv()
GEMINI_API_KEY = os.getenv("GOOGLE_API_KEY")

# Constants
CHROMA_PATH = "chroma"
MODEL_NAME = "gemini-2.5-flash-preview-05-20"
EMBEDDING_MODEL = "models/embedding-001"

# In-memory dictionary to store chat history
# In a production app, you would use a persistent database (e.g., PostgreSQL, MongoDB)
# to store chat history per user/session.
chat_histories: Dict[str, List[Any]] = {}

# Pydantic models for API request and response
class ChatMessage(BaseModel):
    """Represents a single message in the chat."""
    role: str = Field(..., description="The role of the message sender (e.g., 'user', 'bot').")
    text: str = Field(..., description="The text content of the message.")

class ChatRequest(BaseModel):
    """Represents the request body for a chat message."""
    user_message: str = Field(..., description="The user's message.")
    session_id: str = Field(..., description="A unique identifier for the chat session.")

class ChatResponse(BaseModel):
    """Represents the response body from the chatbot."""
    bot_message: str = Field(..., description="The bot's response.")
    source_documents: List[str] = Field(..., description="List of source documents used for the response.")

# Initialize FastAPI app
app = FastAPI()

# Initialize components on startup
def get_vector_store():
    """Initializes and returns the Chroma vector store."""
    if not os.path.exists(CHROMA_PATH):
        raise RuntimeError("Vector store not found. Please run ingest.py first.")
    embeddings = GoogleGenerativeAIEmbeddings(model=EMBEDDING_MODEL)
    return Chroma(persist_directory=CHROMA_PATH, embedding_function=embeddings)

def get_session_history(session_id: str) -> List[Any]:
    """Retrieves or initializes a chat history for a given session."""
    if session_id not in chat_histories:
        chat_histories[session_id] = []
    return chat_histories[session_id]

# Build the LangChain RAG pipeline
# This pipeline handles retrieval, context, and generation in a single chain.
vector_store = get_vector_store()
retriever = vector_store.as_retriever()
llm = ChatGoogleGenerativeAI(model=MODEL_NAME)
output_parser = StrOutputParser()

# Define the chat prompt template
prompt_template = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            "You are a helpful chatbot for the CORSIT robotics club. Your name is CORSIT Chatbot. "
            "You must answer questions based on the following context only:\n\n"
            "Context: {context}\n\n"
            "If the context doesn't contain the information, state that you don't know "
            "and suggest the user ask a club member. "
            "Always keep your answers concise and engaging."
        ),
        MessagesPlaceholder(variable_name="chat_history"),
        ("human", "{input}"),
    ]
)

# RAG chain that first retrieves context and then passes it to the LLM
# The retriever is now part of a separate runnable to be invoked
rag_chain = {
    "context": retriever,
    "input": RunnablePassthrough()
} | prompt_template | llm | output_parser

# Chain with memory
chain_with_history = RunnableWithMessageHistory(
    rag_chain,
    get_session_history,
    input_messages_key="input",
)

@app.post("/chat", response_model=ChatResponse)
async def chat_with_bot(request: ChatRequest) -> ChatResponse:
    """
    Main API endpoint for the chatbot.
    Receives a user message and returns a RAG-powered response.
    """
    try:
        # Get session history
        history = get_session_history(request.session_id)
        
        # Invoke the chain to get a response
        response = await chain_with_history.ainvoke(
            {"input": request.user_message},
            config={"configurable": {"session_id": request.session_id}},
        )

        # Get source documents for the response
        # Note: This is a simplified way to get sources. A more robust solution would pass
        # them through the chain explicitly.
        docs = await retriever.ainvoke(request.user_message)
        source_documents = [doc.page_content for doc in docs]

        return ChatResponse(
            bot_message=response,
            source_documents=source_documents
        )
    except Exception as e:
        print(f"An error occurred: {e}")
        raise HTTPException(
            status_code=500, 
            detail="An error occurred while processing your request."
        )
