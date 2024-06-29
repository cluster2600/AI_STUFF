import openai

# Remplacez 'your-api-key' par votre clé API OpenAI
openai.api_key = 'your-api-key'

def ask_openai(prompt):
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=150
    )
    return response.choices[0].text.strip()

if __name__ == "__main__":
    prompt = "Explain quantum computing in simple terms."
    print(ask_openai(prompt))
