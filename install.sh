#!/bin/bash
set -euo pipefail

# Definição de cores
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'
GRAY='\033[0;37m'

# Funções para exibição de mensagens
log_info() {
  echo -e "${CYAN}[INFO]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[SUCESSO]${RESET} $1"
}

log_warning() {
  echo -e "${YELLOW}[AVISO]${RESET} $1"
}

log_error() {
  echo -e "${RED}[ERRO]${RESET} $1"
}

echo -e "\n${CYAN}
 █████╗ ██╗   ██╗████████╗ ██████╗     ███╗   ███╗██╗   ██╗███╗   ██╗███╗                           
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗    ████╗  ██║████╗ ████║██╔══██╗██╔══██╗
███████║██║   ██║   ██║   ██║   ██║    ██╔██╗ ██║██╔████╔██║███████║██████╔╝
██╔══██║██║   ██║   ██║   ██║   ██║    ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝ 
██║  ██║╚██████╔╝   ██║   ╚██████╔╝    ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║     
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝     ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝
${RESET}Made by ${CYAN}Alexzera${RESET}.\n"

# Função para detectar o gerenciador de pacotes
detect_package_manager() {
  log_info "Detectando gerenciador de pacotes..."
  if command -v apt &>/dev/null; then
    log_success "APT detectado (Debian/Ubuntu/Kali)"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
    PACKAGES=("nmap" "tor" "proxychains" "bat")
  elif command -v pacman &>/dev/null; then
    log_success "Pacman detectado (Arch/Manjaro)"
    UPDATE_CMD="sudo pacman -Sy"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    PACKAGES=("nmap" "tor" "proxychains-ng" "bat")
  elif command -v dnf &>/dev/null || command -v yum &>/dev/null; then
    log_success "DNF/YUM detectado (Fedora/RHEL/CentOS)"
    if command -v dnf &>/dev/null; then
      INSTALL_CMD="sudo dnf install -y"
    else
      INSTALL_CMD="sudo yum install -y"
    fi
    UPDATE_CMD="sudo $INSTALL_CMD epel-release && sudo $INSTALL_CMD update"
    PACKAGES=("nmap" "tor" "proxychains-ng")
    PKG_MANAGER="redhat"
  else
    log_error "Sistema não suportado. Apenas distribuições baseadas em APT, Pacman ou DNF/YUM são suportadas."
    exit 1
  fi
}

# Função para atualizar pacotes
update_packages() {
  log_info "Atualizando pacotes..."
  log_info "Executando: ${GRAY}${UPDATE_CMD}${RESET}"
  eval $UPDATE_CMD
  log_success "Atualização concluída."
}

# Função para instalar dependências
install_dependencies() {
  log_info "Instalando dependências..."
  log_info "Pacotes a instalar: ${PACKAGES[*]}"
  log_info "Executando: ${GRAY}${INSTALL_CMD} ${PACKAGES[*]}${RESET}"
  eval $INSTALL_CMD "${PACKAGES[@]}"
  log_success "Dependências instaladas com sucesso."
}

# Função para verificar e instalar o bat via Cargo (para sistemas Redhat)
install_bat_if_needed() {
  if ! command -v bat &>/dev/null && [ "${PKG_MANAGER:-}" = "redhat" ]; then
    log_warning "Bat não encontrado nos repositórios; instalando via Cargo..."
    # Verifica se o Cargo (Rust) está instalado
    if ! command -v cargo &>/dev/null; then
      log_info "Instalando Rust (Cargo)..."
      if sudo $INSTALL_CMD cargo 2>/dev/null; then
        log_success "Cargo instalado via repositórios."
      else
        log_warning "Instalando Cargo via Rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        log_success "Cargo instalado via Rustup."
      fi
    fi
    log_info "Compilando bat a partir do código-fonte com Cargo..."
    cargo install bat --locked
    log_success "Bat instalado via Cargo."
    log_info "Criando symlink global para batcat..."
    sudo ln -svf "$HOME/.cargo/bin/bat" /usr/local/bin/batcat
    log_success "Symlink para batcat criado."
  else
    log_success "Bat já está instalado ou não é necessário para este sistema."
  fi
}

# Função para criar o symlink do autonmap
create_autonmap_symlink() {
  log_info "Criando symlink para autonmap..."
  local target
  target="$(pwd)/autonmap"
  local link="/usr/local/bin/autonmap"
  
  if [ -e "$link" ] || [ -L "$link" ]; then
    log_warning "O symlink $link já existe. Removendo o symlink existente..."
    sudo rm -f "$link" && log_success "Symlink removido com sucesso." || {
      log_error "Falha ao remover o symlink existente."
      exit 1
    }
  fi
  
  log_info "Linkando: ${target} → ${link}"
  sudo ln -sv "$target" "$link" && log_success "Symlink do autonmap criado com sucesso." || {
    log_error "Falha ao criar o symlink do autonmap."
    exit 1
  }
}

# Função para ajustar permissões finais
set_permissions() {
  log_info "Ajustando permissões para autonmap..."
  sudo chmod -v 770 ./autonmap && log_success "Permissões atualizadas." || {
    log_error "Falha ao ajustar permissões."
    exit 1
  }
}

# Fluxo principal de execução
detect_package_manager
update_packages
install_dependencies
install_bat_if_needed
create_autonmap_symlink
set_permissions

log_success "Instalação e configuração concluídas com sucesso."
