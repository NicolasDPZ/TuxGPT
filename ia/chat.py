import subprocess

def ask_ai(prompt):
    try:
        result = subprocess.run(
            ["ollama", "run", "llama3"],
            input=prompt + "\n",
            text=True,
            capture_output=True,
            timeout=45
        )
        return result.stdout.strip() if result.stdout else "No hay respuesta"
    except subprocess.TimeoutExpired:
        return "El modelo tardó demasiado en responder"
