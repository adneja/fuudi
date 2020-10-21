# Fuudi.io

![Cover photo](/cover.png)

## About
I made this application to simplify my weekly grocery shopping. With fuudi.io all I have to do is select one of my meal plans and click "Generate shopping list". Then I check off on the ingredients I have at home, before I head to the store.

### Recipe filtering
When searching through fuudi.io, you can filter by your diatary constraints and allergies. You're also able to set a max cooking time. 

### Search by ingredients
Want to find recipes that use ingredients you already have at home? Fuudi.io lets you do this by clicking "Search by ingredients" and adding your chosen ingredients. The search results will now display how many of the recipes ingredients match your search.

### Meal planning
Easly find, create and share meal plans!

### Shopping lists
Generate shopping lists from meal plans or individual recipes!

### Cookbook
You will find all your saved recipes and mealplans in your online cookbook.
  
 
## Stack
Vue.js + Node.js + PostgreSQL + NGINX

### Application arcitecture
fuudi.io uses NGINX to serve a Vue.js app. It also serves as a load balancer for the Node.js Express API cluster. The API endpoints triggers PL/pgSQL functions in the PostgreSQL database.

![Application arcitecture](/arcitecture.png)
