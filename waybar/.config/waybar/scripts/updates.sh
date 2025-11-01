#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour vérifier les mises à jour Pacman
check_pacman_updates() {
    echo -e "${BLUE}Vérification des mises à jour Pacman...${NC}"
    pacman_updates=$(checkupdates 2>/dev/null | wc -l)
    echo -e "${GREEN}$pacman_updates${NC} mise(s) à jour disponible(s) via Pacman"
}

# Fonction pour vérifier les mises à jour AUR
check_aur_updates() {
    if command -v yay &> /dev/null; then
        echo -e "${BLUE}Vérification des mises à jour AUR (yay)...${NC}"
        aur_updates=$(yay -Qua 2>/dev/null | wc -l)
        echo -e "${GREEN}$aur_updates${NC} mise(s) à jour disponible(s) via AUR"
        AUR_HELPER="yay"
    elif command -v paru &> /dev/null; then
        echo -e "${BLUE}Vérification des mises à jour AUR (paru)...${NC}"
        aur_updates=$(paru -Qua 2>/dev/null | wc -l)
        echo -e "${GREEN}$aur_updates${NC} mise(s) à jour disponible(s) via AUR"
        AUR_HELPER="paru"
    else
        echo -e "${YELLOW}Aucun helper AUR détecté (yay ou paru)${NC}"
        aur_updates=0
        AUR_HELPER=""
    fi
}

# Fonction pour effectuer les mises à jour
perform_updates() {
    echo -e "\n${BLUE}=== Début des mises à jour ===${NC}\n"

    # Mise à jour Pacman
    if [ "$pacman_updates" -gt 0 ]; then
        echo -e "${YELLOW}Mise à jour des paquets officiels...${NC}"
        sudo pacman -Syu
    fi

    # Mise à jour AUR
    if [ "$aur_updates" -gt 0 ] && [ -n "$AUR_HELPER" ]; then
        echo -e "\n${YELLOW}Mise à jour des paquets AUR...${NC}"
        $AUR_HELPER -Sua
    fi

    echo -e "\n${GREEN}=== Mises à jour terminées ===${NC}"
}

# Début du script
clear
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        MISE À JOUR DU SYSTÈME          ║${NC}"
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo ""

# Vérification des mises à jour
check_pacman_updates
check_aur_updates

total_updates=$((pacman_updates + aur_updates))

echo ""
echo -e "${BLUE}Total: ${GREEN}$total_updates${BLUE} mise(s) à jour disponible(s)${NC}"
echo ""

# Demande de confirmation
if [ "$total_updates" -eq 0 ]; then
    echo -e "${GREEN}Votre système est à jour !${NC}"
    echo ""
    read -p "Appuyez sur Entrée pour quitter..."
    exit 0
fi

echo -e "${YELLOW}Voulez-vous lancer les mises à jour ? (oui/non)${NC}"
read -r response

case "$response" in
    oui|o|O|OUI|Oui|yes|y|Y)
        perform_updates
        echo ""
        read -p "Appuyez sur Entrée pour quitter..."
        ;;
    non|n|N|NON|Non|no)
        echo -e "${RED}Mises à jour annulées.${NC}"
        sleep 1
        ;;
    *)
        echo -e "${RED}Réponse non reconnue. Mises à jour annulées.${NC}"
        sleep 1
        ;;
esac

exit 0
