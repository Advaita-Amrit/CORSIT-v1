import os
import shutil
from dotenv import load_dotenv
from langchain_chroma import Chroma
from langchain_community.document_loaders import TextLoader, WebBaseLoader
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter

# Load environment variables from the .env file
load_dotenv()
GEMINI_API_KEY = os.getenv("GOOGLE_API_KEY")

# Directory and URL paths
DATA_PATH = "data"
CHROMA_PATH = "chroma"

# URLs to scrape for additional data. Add your own URLs here.
WEB_URLS = [
    "https://example.com/about",
    "https://example.com/services",
]

def main():
    """
    Main function to load, process, and ingest documents from both
    local files and web pages into the vector database.
    """
    # Clear out the old database before ingesting new data
    if os.path.exists(CHROMA_PATH):
        shutil.rmtree(CHROMA_PATH)
        print(f"Removed existing Chroma database at {CHROMA_PATH}")

    # Load documents from both local files and web pages
    print("Loading documents from local files and web pages...")
    documents = load_local_documents() + load_web_documents()
    print(f"Loaded a total of {len(documents)} documents.")
    
    if not documents:
        print("No documents found. Exiting.")
        return

    # Split documents into smaller, manageable chunks
    print("Splitting documents into chunks...")
    chunks = split_documents(documents)
    print(f"Split into {len(chunks)} chunks.")

    # Create and ingest embeddings into ChromaDB
    print("Creating and ingesting into ChromaDB...")
    create_and_save_embeddings(chunks)
    print(f"Successfully created and saved {len(chunks)} embeddings to {CHROMA_PATH}.")

def load_local_documents():
    """
    Loads text documents from the specified data directory.
    """
    documents = []
    if not os.path.exists(DATA_PATH):
        print(f"Warning: Local data directory '{DATA_PATH}' not found. Skipping.")
        return documents

    for file_name in os.listdir(DATA_PATH):
        if file_name.endswith(".txt"):
            file_path = os.path.join(DATA_PATH, file_name)
            loader = TextLoader(file_path)
            documents.extend(loader.load())
    return documents

def load_web_documents():
    """
    Loads content from the specified list of web URLs.
    """
    documents = []
    if not WEB_URLS:
        print("Warning: No web URLs specified. Skipping web loading.")
        return documents
    
    for url in WEB_URLS:
        try:
            print(f"Loading from URL: {url}")
            loader = WebBaseLoader(url)
            documents.extend(loader.load())
        except Exception as e:
            print(f"Error loading {url}: {e}")
    return documents

def split_documents(documents):
    """
    Splits documents into smaller, manageable chunks.
    This helps the RAG system retrieve more specific information.
    """
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,
        chunk_overlap=200,
        length_function=len
    )
    return text_splitter.split_documents(documents)

def create_and_save_embeddings(chunks):
    """
    Generates embeddings for each document chunk and saves them
    to the ChromaDB vector database.
    """
    embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
    Chroma.from_documents(
        chunks, embeddings, persist_directory=CHROMA_PATH
    )

if __name__ == "__main__":
    main()
