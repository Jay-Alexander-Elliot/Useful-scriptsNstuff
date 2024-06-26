from decimal import Decimal, getcontext

class WealthCalculator:
    def __init__(self, current_wealth, rate_of_return, income_sources):
        """
        Initialize the WealthCalculator with current wealth, rate of return, and income sources.

        :param current_wealth: Initial amount of wealth.
        :param rate_of_return: Estimated annual rate of return (as a percentage).
        :param income_sources: Dictionary of income sources with their monthly amounts.
        """
        self.current_wealth = Decimal(current_wealth)
        self.rate_of_return = Decimal(rate_of_return)
        self.income_sources = {k: Decimal(v) for k, v in income_sources.items()}

    def calculate_wealth_by_year(self, years):
        """
        Calculate the total wealth year by year over a specified number of years.

        :param years: The number of years to project.
        :return: List of strings detailing the wealth at the end of each year.
        """
        total_savings = self.current_wealth
        total_monthly_income = sum(self.income_sources.values())
        results = []
        for year in range(1, years + 1):
            total_savings = self._calculate_yearly_wealth(total_savings, total_monthly_income)
            results.append(f"Year {year}: Total wealth = {total_savings:.2f}")
        return results

    def calculate_years_till_freedom(self, target_wealth):
        """
        Calculate the number of years required to reach the target wealth for financial freedom.

        :param target_wealth: The target amount of wealth for financial freedom.
        :return: A string detailing the number of years required to reach financial freedom.
        """
        total_savings = self.current_wealth
        total_monthly_income = sum(self.income_sources.values())
        years_to_freedom = 0
        target_wealth = Decimal(target_wealth)
        while total_savings < target_wealth:
            years_to_freedom += 1
            total_savings = self._calculate_yearly_wealth(total_savings, total_monthly_income)
        return f"You will reach financial freedom in {years_to_freedom} years! Keep grinding!!"

    def _calculate_yearly_wealth(self, current_wealth, monthly_income):
        """
        Helper method to calculate the wealth for a year.

        :param current_wealth: Current amount of wealth.
        :param monthly_income: Total monthly income.
        :return: Wealth at the end of the year.
        """
        interest = current_wealth * (self.rate_of_return / Decimal(100))
        return current_wealth + interest + (monthly_income * Decimal(12))

    @staticmethod
    def validate_float_input(prompt):
        """
        Validate and return a float input from the user.

        :param prompt: The input prompt string.
        :return: The validated float input.
        """
        while True:
            try:
                return float(input(prompt))
            except ValueError:
                print("Invalid input. You must only enter numbers.")

    @staticmethod
    def validate_int_input(prompt):
        """
        Validate and return an integer input from the user.

        :param prompt: The input prompt string.
        :return: The validated integer input.
        """
        while True:
            try:
                return int(input(prompt))
            except ValueError:
                print("Invalid input. You must only enter whole numbers.")

def main():
    prog = input("Which program would you like to run? Type 'returns' or 'freedom': ").strip().lower()
    if prog not in {'returns', 'freedom'}:
        print("Invalid input. Type 'returns' or 'freedom'")
        return

    current_wealth = WealthCalculator.validate_float_input("Enter your current wealth: ")
    rate_of_return = WealthCalculator.validate_float_input("Enter estimated rate of return (%): ")

    income_sources = {}
    while True:
        income_source_name = input("Enter an income source name (or type 'done' to finish): ").strip()
        if income_source_name.lower() == 'done':
            break
        monthly_income = WealthCalculator.validate_float_input(f"Enter the monthly income for {income_source_name}: ")
        income_sources[income_source_name] = monthly_income

    calculator = WealthCalculator(current_wealth, rate_of_return, income_sources)

    if prog == 'returns':
        years = WealthCalculator.validate_int_input("Enter investment period in years: ")
        results = calculator.calculate_wealth_by_year(years)
        for result in results:
            print(result)
    elif prog == 'freedom':
        target_wealth = WealthCalculator.validate_float_input("How much money do you need to be financially free? ")
        result = calculator.calculate_years_till_freedom(target_wealth)
        print(result)

if __name__ == "__main__":
    main()
