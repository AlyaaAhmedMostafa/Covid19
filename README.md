# Exploratory analysis of COVID-19 Dataset

# Data Description

These data contain 2 tables: COVID-19 Deaths Table and COVID-19 Vaccinations Table

# COVID-19 Deaths Table
- Table Description: This table contains data on COVID-19 related deaths worldwide. It provides a comprehensive overview of the pandemic's impact on global mortality.
  
# Key Fields:

•	Date: The date of data recording or reporting.

•	Country/Region: The specific country or region where the deaths occurred.

•	New Cases: The number of newly confirmed COVID-19 infections reported on that specific day.

•	Confirmed Deaths: The total number of confirmed COVID-19 deaths.

•	New Deaths: The number of new COVID-19 deaths reported on that date.


# Data Usage:

•	Trend Analysis: Analyze the temporal trend of COVID-19 deaths globally or in specific regions.

•	Comparative Analysis: Compare death rates across different countries or regions.

•	Impact Assessment: Evaluate the impact of various factors (e.g., lockdowns, vaccinations) on mortality rates.

# COVID-19 Vaccinations Table
Table Description: This table provides information on COVID-19 vaccinations administered globally. It offers insights into vaccination progress and coverage.

# Key Fields:
•	Date: The date of data recording or reporting.

•	Country/Region: The specific country or region where vaccinations were administered.

•	People Vaccinated: The total number of people who have received at least one dose of a COVID-19 vaccine.

•	People Fully Vaccinated: The total number of people who have completed a full course of a COVID-19 vaccine.

•	Daily Vaccinations: The number of vaccinations administered on that date.

# Data Usage:

•	Vaccination Progress Tracking: Monitor the pace of vaccination campaigns worldwide.

•	Coverage Analysis: Assess vaccination coverage in different regions.

•	Effectiveness Evaluation: Evaluate the impact of vaccination on reducing infections and deaths.

# Data Wrangling

During the data wrangling phase, I converted numerical columns from nvarchar to int data types. To address missing continent information, I updated the continent column with the corresponding location value for rows where continent was null, and location matched specific regional values. Subsequently, I removed global and regional level data from both the Covid19..CovidDeaths and Covid19..CovidVaccinations tables. This involved deleting rows where the location field contained global or regional values.

# Insights

•	As of April 30, 2021, the global COVID-19 pandemic had resulted in over 150 million confirmed cases and 3.18 million deaths.

•	Europe emerged as the hardest-hit continent, accounting for over 1 million deaths and 44 million cases. Asia and North America followed with significant case and death tolls. The United States, Brazil, and Mexico were the countries with the highest death counts. In terms of daily case and death rates, the US led the world, followed by India and Brazil.

•	A comparative analysis of global case and death numbers before, during, and after the initial lockdowns revealed a dramatic increase in both. While the pre-lockdown figures were relatively low, the pandemic surged during the lockdown period and continued to impact the world post-lockdown.

•	In terms of vaccination progress, Israel, the UAE, and Chile were among the leading countries in terms of vaccination rates. As of April 30, 2021, over 946 million vaccine doses had been administered globally, with Asia, North America, and Europe being the top regions in terms of vaccine distribution.

# ITALY AS A CASE STUDY: The impact of the first lockdown

- The reasons for choosing Italy as a case study:

Italy emerged as a global epicenter of the COVID-19 pandemic in early 2020. The country implemented strict lockdown measures to curb the rapid spread of the virus. This made Italy an ideal case study to analyze the impact of stringent lockdowns on the trajectory of the pandemic.
Key reasons for choosing Italy as a case study:
1.	Early and Severe Outbreak: Italy was one of the first Western countries to experience a severe outbreak, providing valuable early data and insights.
2.	Strict Lockdown Measures: Italy implemented one of the strictest lockdowns globally, offering a clear intervention to study its effects.
3.	Comprehensive Data Availability: Italy has a robust healthcare system and data collection infrastructure, ensuring reliable and detailed data on cases, deaths, and vaccinations.

# Insights

•	By April 30, 2021, Italy had recorded over 4 million COVID-19 cases and over 120,000 deaths. To assess the impact of lockdowns, three months were analyzed before, during, and after each lockdown period. In both instances, the month of the lockdown saw a significant surge in both cases and deaths, compared to the preceding and following months.

•	From January 1, 2020, to April 30, 2021, the number of cases and deaths in Italy steadily increased. In April 2021, Italy recorded over 11,000 deaths. Despite this grim figure, the country had administered over 132 million vaccine doses by that point.

