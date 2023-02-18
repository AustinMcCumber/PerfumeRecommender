# PerfumeRecommender

This is an R Shiny app that allows a user to find similar fragrances based on a selected fragrance name. The app can be seen here: [Perfume Recommender](https://austinmccumber.shinyapps.io/Perfume_Recommender/)

## Quick Start

To open the app click the shinyapps link above. Then, simply select your desired fragrance from the drop down list. Alternatively, backspace and begin typing to see if your fragrance is in the database. This will output three fragrances that are the most similar to the fragrance you chose. It will also show matching columns to help explain their similarities. 

## Background and Objective

Parfumo.net is a popular online community and database dedicated to fragrances. The website provides information on thousands of fragrances, including user reviews, ratings, notes, and accords. The objective of this project is to serve as a "cold-start" recommendation engine based on data scraped from the Parfumo database. For example, if we were starting a new fragrance site, how would we recommend perfumes to our users without having access to reviews and other user data? In this case we will create a distance/dissimilarity matrix based on a variety of fragrance "tags" collected from Parfumo. For our tags, we will be using "accords". In perfumery, a fragrance will usually be given two accords that serve as a summary of its scent. For example, a fragrance may be Sweet and Fruity, or Smoky and Spicy. This is different than notes ("tobacco, lavender, grapefruit, etc..") that we might identify in the scent. In this dataset there are 20 accords. 

## Process

1. Identify data source. For this project, the Parfumo subsections for Top 100 Men's, Top 100 Women's, and Top 100 Unisex fragrances were used. This provides significant variety and none of the fragrances overlap. 

2. Scrape. Data was scraped from these pages with the webscraper.io app and regex character matching. Data scraped includes: fragrance name, brand, sex, author, rating, and its two accords. Data is output to an Excel file. 

3. Clean/Format. Each fragrance has two accords. However, to work in the distance matrix, we need these to be factors. In Excel, formulas were used to identify all unique accords in the set(20). They were then added as columns, and simple logic was used to add yes or no for each accord, for each fragrance. Now our data is Tidy and nearly ready. 

4. Complete preparation in R. We import this dataset as a dataframe in RStudio. The columns for brand, rating, and author were removed. They were kept in the original dataset for further analysis but not used in this project. The remaining columns are fragrance name (used as an identifier), sex, and the 20 accords. These columns were then converted to factors. 

5. Calculate dissimilarity matrix. Because our data is categorical/factored, we need to use the Gower metric to create the matrix. This can be done easily through the daisy package in R. The data is now setup and we can begin the shiny app. 

6. Create UI. This was done in the most simple way possible. A text box is created with text saying "Type or select a fragrance name" and a drop down menu is included. When the user starts typing, it shows options from the list. The shinyWidget app has this feature. 

7. Create the first function. The function is passed user input from the text/selection box. It then uses the name to find the matching index in the original dataset. The index is then matched to the corresponding entry in the dissimilarity matrix we created. The function orders the results of the matrix and selects the top 3 closest indices. It then matches the indices to the dataframe and return the three names. 

8. Create the second function. This function is more simple. It is passed the top 3 indices from the previous function and checks which columns have matching "yes" factors. For example, similar entries are likely to have both accords matching - fruity and smoky might both be labeled yes for each pair in the dataframe. 

9. The final function outputs the results into text. It displays the three closest fragrances for eac choices, as well as the matching columns (if any exist). 

## Example

For this example I selected the fragrance Tobacco Vanille by Tom Ford. See the following:

![image](https://user-images.githubusercontent.com/98286027/219845130-8c6110ef-d9d9-4fa3-a9c6-4c068d4493b9.png)

## Final Thoughts

This project was a success and could easily be implemented as a cold-start recommedation system for other purposes and different datasets. The Gower metric works with mixed data types as well, so columns with non-categorical data could be used too. The only issue I have not yet solved is that sometimes the returned fragrances include the input fragrance as well. This will be fixed in the future. 






