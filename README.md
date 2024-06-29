# Ansible Playbook pour Installer et Configurer JupyterLab avec l'API OpenAI sur macOS

Ce dépôt contient un playbook Ansible pour installer JupyterLab sur macOS en utilisant Homebrew et configurer l'API OpenAI.

## Prérequis

- macOS
- Ansible installé localement

## Installation

### Étape 1 : Cloner le Dépôt

Clonez ce dépôt sur votre machine locale :

```sh
git clone https://github.com/votre-utilisateur/nom-du-depot.git
cd nom-du-depot
Étape 2 : Configuration du Playbook Ansible
Assurez-vous d'avoir Ansible installé. Si ce n'est pas le cas, vous pouvez l'installer via Homebrew :

sh
brew install ansible
Étape 3 : Exécuter le Playbook d'Installation
Exécutez le playbook avec la commande suivante en remplaçant your-api-key par votre clé API OpenAI :

sh

ansible-playbook -i localhost, playbook.yml --extra-vars "openai_api_key=your-api-key"
Structure des Répertoires
Le projet est structuré comme suit :

css

ansible-jupyter/
├── playbook.yml
└── roles/
    └── jupyter/
        ├── tasks/
        │   └── main.yml
        ├── files/
        │   └── openai_config.py
        └── templates/
            └── install_jupyter.sh.j2
Contenu des Fichiers
playbook.yml
yaml

---
- name: Install and configure JupyterLab with OpenAI
  hosts: localhost
  connection: local
  become: yes
  vars:
    openai_api_key: "your-api-key"
  roles:
    - jupyter
roles/jupyter/tasks/main.yml
yaml

---
- name: Ensure Homebrew is installed
  command: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  args:
    creates: /usr/local/bin/brew
  tags: homebrew

- name: Update Homebrew
  command: brew update
  tags: homebrew

- name: Ensure Python3 is installed
  homebrew:
    name: python
    state: present
  tags: python

- name: Create virtual environment for JupyterLab and OpenAI
  command: python3 -m venv /usr/local/bin/jupyterlab-env
  args:
    creates: /usr/local/bin/jupyterlab-env
  tags: python

- name: Install JupyterLab and ipykernel
  shell: |
    source /usr/local/bin/jupyterlab-env/bin/activate
    pip install jupyterlab ipykernel
  tags: jupyter

- name: Install OpenAI package
  shell: |
    source /usr/local/bin/jupyterlab-env/bin/activate
    pip install openai
  tags: openai

- name: Add virtual environment as Jupyter kernel
  shell: |
    source /usr/local/bin/jupyterlab-env/bin/activate
    python -m ipykernel install --user --name=jupyterlab-env --display-name "Python (jupyterlab-env)"
  tags: jupyter

- name: Copy OpenAI configuration file
  copy:
    src: openai_config.py
    dest: /usr/local/bin/jupyterlab-env/bin/openai_config.py
  tags: openai

- name: Update OpenAI API key
  lineinfile:
    path: /usr/local/bin/jupyterlab-env/bin/openai_config.py
    regexp: 'openai.api_key = .*'
    line: 'openai.api_key = "{{ openai_api_key }}"'
  tags: openai
roles/jupyter/files/openai_config.py
python
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
roles/jupyter/templates/install_jupyter.sh.j2
bash
#!/bin/bash

# Install Homebrew if not installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew could not be found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install Python3 if not installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 could not be found, installing..."
    brew install python
fi

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv /usr/local/bin/jupyterlab-env

# Activate virtual environment
echo "Activating virtual environment..."
source /usr/local/bin/jupyterlab-env/bin/activate

# Install JupyterLab and ipykernel
echo "Installing JupyterLab and ipykernel..."
pip install jupyterlab ipykernel

# Install OpenAI package
echo "Installing OpenAI package..."
pip install openai

# Add virtual environment as Jupyter kernel
echo "Adding virtual environment as Jupyter kernel..."
python -m ipykernel install --user --name=jupyterlab-env --display-name "Python (jupyterlab-env)"

# Copy OpenAI configuration file
echo "Copying OpenAI configuration file..."
cp /path/to/openai_config.py /usr/local/bin/jupyterlab-env/bin/openai_config.py

# Update OpenAI API key
echo "Updating OpenAI API key..."
sed -i '' 's/openai.api_key = "your-api-key"/openai.api_key = "{{ openai_api_key }}"/' /usr/local/bin/jupyterlab-env/bin/openai_config.py

echo "Installation and configuration completed."
Étape 4 : Lancer JupyterLab
Vous pouvez lancer JupyterLab avec la commande suivante :

sh
jupyter-lab
Étape 5 : Utiliser le kernel de l'environnement virtuel dans JupyterLab
Lorsque vous lancez JupyterLab, vous pouvez sélectionner le kernel "Python (jupyterlab-env)" pour utiliser l'environnement virtuel avec OpenAI configuré.

Utilisation de l'API OpenAI
Vous pouvez maintenant utiliser l'API OpenAI dans vos notebooks Jupyter. Voici un exemple d'utilisation dans un notebook Jupyter :

python
import openai
from openai_config import ask_openai

prompt = "What is the capital of France?"
response = ask_openai(prompt)
print(response)

import openai
from openai_config import ask_openai

prompt = "What is the capital of France?"
response = ask_openai(prompt)
print(response)
Contribution
Les contributions sont les bienvenues ! Veuillez soumettre une pull request pour toute amélioration ou correction.

Licence
Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus d'informations.

rust

Ce fichier README.md fournit des instructions complètes pour utiliser le playbook Ansible afin d'installer et de configurer JupyterLab avec l'API OpenAI sur macOS.






