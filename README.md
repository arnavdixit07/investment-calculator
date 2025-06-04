# Investment Time Machine

This program calculates how your bank balance would look today if you had invested in a specific company in the past. It uses historical stock data and the BLOOMZ 7B1 AI model to provide an analysis of your investment.

## Features

- Fetches historical stock data using the Yahoo Finance API
- Calculates the return on investment from a specified year to today
- Uses the BLOOMZ 7B1 model to generate an analysis of the investment
- Provides detailed information about the investment performance
- Includes a lite version that doesn't require the AI model

## Requirements

### Full Version (with AI Analysis)
- Python 3.8 or higher
- At least 16GB of RAM (32GB recommended for running BLOOMZ 7B1)
- GPU with at least 8GB VRAM (optional but recommended for faster inference)
- All dependencies listed in requirements.txt

### Lite Version
- Python 3.6 or higher
- Minimal RAM requirements (2GB should be sufficient)
- Only requires the yfinance package (`pip install yfinance`)

## Installation

1. Clone this repository or download the files
2. Install the required dependencies:

```bash
pip install -r requirements.txt
```

## Usage

### Full Version (with AI Analysis)

Run the full version with:

```bash
python investment_calculator.py
```

Or use the provided scripts:

```bash
# On macOS/Linux
./run_investment_calculator.sh

# On Windows
run_investment_calculator.bat
```

### Lite Version (without AI)

If you have limited system resources or don't want to install the large AI model dependencies, you can use the lite version:

```bash
python investment_calculator_lite.py
```

The lite version provides the same investment calculations but uses a simple rule-based analysis instead of the BLOOMZ 7B1 model.

### Input Requirements

Both versions will prompt you for:
- Company name (e.g., Apple)
- Stock ticker symbol (e.g., AAPL)
- Investment year (e.g., 2010)
- Initial investment amount in USD

## Example

```
================================================================================
INVESTMENT TIME MACHINE
================================================================================
This program calculates how much money you would have today if you had invested in a company in the past.
It uses the BLOOMZ 7B1 AI model to provide an analysis of your investment.
================================================================================
Enter the company name (e.g., Apple): Apple
Enter the stock ticker symbol (e.g., AAPL): AAPL
Enter the investment year (e.g., 2010): 2010
Enter your initial investment amount in USD: $1000

Fetching historical stock data...

================================================================================
INVESTMENT RESULTS FOR APPLE (AAPL)
================================================================================
Initial investment in 2010: $1000.00
Initial stock price: $7.78
Current stock price: $169.58
Price change: 2079.69%
Current value of your investment: $21796.92
Total profit: $20796.92

Generating investment analysis using BLOOMZ 7B1...
(This may take a moment depending on your system)

================================================================================
AI ANALYSIS
================================================================================
[AI-generated analysis will appear here]
```

## Notes

- The program uses the yfinance library to fetch stock data, which may have limitations for certain stocks or very old historical data.
- Running the BLOOMZ 7B1 model requires significant computational resources. If you encounter memory errors, try running on a system with more RAM or a GPU.
- For users with limited resources, you can modify the code to use a smaller language model.

## Alternative Options

### Smaller AI Models

If BLOOMZ 7B1 is too resource-intensive for your system but you still want AI analysis, you can modify the `generate_investment_analysis` function in `investment_calculator.py` to use a smaller model by changing the `model_name` variable to one of these alternatives:

- `"bigscience/bloomz-1b7"` (1.7B parameters)
- `"google/flan-t5-base"` (250M parameters)
- `"google/flan-t5-small"` (80M parameters)

### Lite Version

For the most lightweight option, use the provided `investment_calculator_lite.py` script which:
- Requires minimal system resources
- Provides all the same investment calculations
- Includes a simple rule-based analysis instead of using an AI model
- Compares your investment to the S&P 500 index for the same period