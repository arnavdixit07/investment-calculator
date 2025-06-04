#!/bin/bash

# Investment Calculator Setup and Run Script

# Colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}   Investment Time Machine Setup Script   ${NC}"
echo -e "${GREEN}=========================================${NC}"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed.${NC}"
    echo -e "Please install Python 3 and try again."
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 --version | cut -d " " -f 2)
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 8 ]); then
    echo -e "${YELLOW}Warning: Python version $PYTHON_VERSION detected.${NC}"
    echo -e "${YELLOW}This program works best with Python 3.8 or higher.${NC}"
    echo -e "Continue anyway? (y/n)"
    read -r response
    if [[ "$response" != "y" ]]; then
        echo "Setup cancelled."
        exit 0
    fi
else
    echo -e "${GREEN}Python $PYTHON_VERSION detected. ✓${NC}"
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo -e "\n${GREEN}Creating virtual environment...${NC}"
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create virtual environment.${NC}"
        echo "Please make sure you have the venv module installed."
        exit 1
    fi
    echo -e "${GREEN}Virtual environment created. ✓${NC}"
else
    echo -e "\n${GREEN}Virtual environment already exists. ✓${NC}"
fi

# Activate virtual environment
echo -e "\n${GREEN}Activating virtual environment...${NC}"
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to activate virtual environment.${NC}"
    exit 1
fi
echo -e "${GREEN}Virtual environment activated. ✓${NC}"

# Install dependencies
echo -e "\n${GREEN}Installing dependencies...${NC}"
echo -e "${YELLOW}This may take a few minutes, especially for the transformers and torch packages.${NC}"
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install dependencies.${NC}"
    echo "Please check your internet connection and try again."
    deactivate
    exit 1
fi
echo -e "${GREEN}Dependencies installed. ✓${NC}"

# Check for GPU
if python3 -c "import torch; print(torch.cuda.is_available())" | grep -q "True"; then
    echo -e "\n${GREEN}GPU detected! BLOOMZ model will use GPU acceleration. ✓${NC}"
else
    echo -e "\n${YELLOW}No GPU detected. The program will run on CPU, which may be slow.${NC}"
    echo -e "${YELLOW}Consider using a system with a GPU for better performance.${NC}"
fi

# Run the program
echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}   Running Investment Time Machine   ${NC}"
echo -e "${GREEN}=========================================${NC}"
python3 investment_calculator.py

# Deactivate virtual environment
deactivate