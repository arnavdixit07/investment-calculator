import os
import datetime
import yfinance as yf
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

def get_stock_data(ticker, start_date):
    """
    Fetch historical stock data for a given ticker from a specific date until today.
    
    Args:
        ticker (str): Stock ticker symbol (e.g., 'AAPL' for Apple)
        start_date (str): Start date in YYYY-MM-DD format
        
    Returns:
        tuple: (initial_price, current_price, percent_change)
    """
    try:
        # Get stock data
        stock = yf.Ticker(ticker)
        
        # Get historical data from start_date to today
        today = datetime.datetime.now().strftime('%Y-%m-%d')
        hist = stock.history(start=start_date, end=today)
        
        if hist.empty:
            return None, None, None
        
        # Get the first available price after the start date
        initial_price = hist['Close'].iloc[0]
        
        # Get the most recent closing price
        current_price = hist['Close'].iloc[-1]
        
        # Calculate percent change
        percent_change = ((current_price - initial_price) / initial_price) * 100
        
        return initial_price, current_price, percent_change
    
    except Exception as e:
        print(f"Error fetching stock data: {e}")
        return None, None, None

def calculate_investment_return(initial_investment, percent_change):
    """
    Calculate the current value of an investment based on the percent change.
    
    Args:
        initial_investment (float): Initial investment amount
        percent_change (float): Percent change in stock price
        
    Returns:
        float: Current value of the investment
    """
    return initial_investment * (1 + (percent_change / 100))

def generate_investment_analysis(company, ticker, year, initial_investment, current_value, percent_change):
    """
    Generate an investment analysis using the BLOOMZ 7B1 model.
    
    Args:
        company (str): Company name
        ticker (str): Stock ticker
        year (int): Investment year
        initial_investment (float): Initial investment amount
        current_value (float): Current value of the investment
        percent_change (float): Percent change in stock price
        
    Returns:
        str: Generated analysis
    """
    # Load BLOOMZ 7B1 model and tokenizer
    model_name = "bigscience/bloomz-7b1"
    
    # Check if we're running on a system with a GPU
    device = "cuda" if torch.cuda.is_available() else "cpu"
    
    # Load tokenizer
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    
    # Load model with lower precision to save memory
    model = AutoModelForCausalLM.from_pretrained(
        model_name, 
        torch_dtype=torch.float16 if device == "cuda" else torch.float32,
        device_map="auto"
    )
    
    # Create prompt for the model
    years_held = datetime.datetime.now().year - year
    profit_loss = current_value - initial_investment
    
    prompt = f"""
    Analyze this investment:
    - Company: {company} ({ticker})
    - Investment year: {year} ({years_held} years ago)
    - Initial investment: ${initial_investment:.2f}
    - Current value: ${current_value:.2f}
    - Total profit/loss: ${profit_loss:.2f} ({percent_change:.2f}%)
    
    Provide a brief analysis of this investment, including whether it was a good decision, how it compares to market averages, and what factors might have influenced the company's performance during this period.
    """
    
    # Generate text
    inputs = tokenizer(prompt, return_tensors="pt").to(device)
    
    # Generate with parameters to control output
    outputs = model.generate(
        inputs.input_ids,
        max_length=500,
        temperature=0.7,
        top_p=0.9,
        do_sample=True
    )
    
    # Decode and return the generated text
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    
    # Clean up the response to remove the prompt
    response = response.replace(prompt, "").strip()
    
    return response

def main():
    print("=" * 80)
    print("INVESTMENT TIME MACHINE")
    print("=" * 80)
    print("This program calculates how much money you would have today if you had invested in a company in the past.")
    print("It uses the BLOOMZ 7B1 AI model to provide an analysis of your investment.")
    print("=" * 80)
    
    # Get user input
    company_name = input("Enter the company name (e.g., Apple): ")
    ticker = input("Enter the stock ticker symbol (e.g., AAPL): ")
    
    # Get investment year with validation
    while True:
        try:
            year = int(input("Enter the investment year (e.g., 2010): "))
            current_year = datetime.datetime.now().year
            if 1970 <= year < current_year:
                break
            else:
                print(f"Please enter a year between 1970 and {current_year-1}.")
        except ValueError:
            print("Please enter a valid year.")
    
    # Get investment amount with validation
    while True:
        try:
            initial_investment = float(input("Enter your initial investment amount in USD: $"))
            if initial_investment > 0:
                break
            else:
                print("Please enter a positive investment amount.")
        except ValueError:
            print("Please enter a valid number.")
    
    # Format the start date (January 1st of the investment year)
    start_date = f"{year}-01-01"
    
    print("\nFetching historical stock data...")
    initial_price, current_price, percent_change = get_stock_data(ticker, start_date)
    
    if initial_price is None:
        print(f"Could not find historical data for {ticker} starting from {year}.")
        print("Please check the ticker symbol and try a more recent year.")
        return
    
    # Calculate current investment value
    current_value = calculate_investment_return(initial_investment, percent_change)
    
    # Display results
    print("\n" + "=" * 80)
    print(f"INVESTMENT RESULTS FOR {company_name.upper()} ({ticker})")
    print("=" * 80)
    print(f"Initial investment in {year}: ${initial_investment:.2f}")
    print(f"Initial stock price: ${initial_price:.2f}")
    print(f"Current stock price: ${current_price:.2f}")
    print(f"Price change: {percent_change:.2f}%")
    print(f"Current value of your investment: ${current_value:.2f}")
    
    profit_loss = current_value - initial_investment
    if profit_loss >= 0:
        print(f"Total profit: ${profit_loss:.2f}")
    else:
        print(f"Total loss: ${-profit_loss:.2f}")
    
    # Generate and display AI analysis
    print("\nGenerating investment analysis using BLOOMZ 7B1...")
    print("(This may take a moment depending on your system)")
    
    try:
        analysis = generate_investment_analysis(
            company_name, ticker, year, initial_investment, current_value, percent_change
        )
        
        print("\n" + "=" * 80)
        print("AI ANALYSIS")
        print("=" * 80)
        print(analysis)
    except Exception as e:
        print(f"\nError generating analysis: {e}")
        print("This may be due to memory limitations or model availability.")
        print("Try running this program on a system with more RAM or a GPU.")
    
    print("\n" + "=" * 80)

if __name__ == "__main__":
    main()