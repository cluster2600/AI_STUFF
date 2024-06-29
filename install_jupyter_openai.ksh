#!/bin/ksh

# Fonction pour vérifier si une commande existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Installer Homebrew s'il n'est pas déjà installé
if ! command_exists brew; then
    echo "Homebrew n'est pas installé. Installation de Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew est déjà installé."
fi

# Mettre à jour Homebrew
echo "Mise à jour de Homebrew..."
brew update

# Installer Python3 s'il n'est pas déjà installé
if ! command_exists python3; then
    echo "Python3 n'est pas installé. Installation de Python3..."
    brew install python3
else
    echo "Python3 est déjà installé."
fi

# Créer un environnement virtuel pour JupyterLab et OpenAI
echo "Création d'un environnement virtuel pour JupyterLab et OpenAI..."
python3 -m venv jupyterlab-env

# Activer l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source jupyterlab-env/bin/activate

# Installer JupyterLab et ipykernel dans l'environnement virtuel
echo "Installation de JupyterLab et ipykernel..."
pip install jupyterlab ipykernel

# Installer le package OpenAI dans l'environnement virtuel
echo "Installation du package OpenAI..."
pip install openai

# Ajouter l'environnement virtuel comme kernel dans JupyterLab
echo "Ajout de l'environnement virtuel comme kernel dans JupyterLab..."
python -m ipykernel install --user --name=jupyterlab-env --display-name "Python (jupyterlab-env)"

# Créer un fichier de configuration pour OpenAI
echo "Création d'un fichier de configuration pour OpenAI..."
cat <<EOL > openai_config.py
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
EOL

echo "L'installation et la configuration sont terminées."
echo "Vous pouvez maintenant lancer JupyterLab avec la commande 'jupyter-lab'."
echo "N'oubliez pas de mettre à jour le fichier 'openai_config.py' avec votre propre clé API OpenAI."
