# Fuudi - recipe finder & meal planner

Fuudi lets you find and upload recipes without the clutter of adds, articles, autoplaying videos and the distractions found on many of todays recipes sites. It also functions as a mealplanner and its easy to generate shoppinglists from recipes and plans. I started this project to simplify my own grocery shopping, all I have to do is select a mealplan and click "Generate shoppinglist".

### Find recipes
![Landing page](/imgs/frontpage.png)

### Filter by ingredients
![Filtering](/imgs/filtering.png)

### Cut to the chase: no ads, popups, autoplaying videos or longwinded articles
![Details](/imgs/recipedetails.png)

### Add ingredients to your shopping list
![Shoppinglist](/imgs/addtoshoppinglist.png)
 
### More to come:
- Create mealplans 
- Generate shoppinglists for mealplan
- Search & filter mealplan
- "My cookbook": your saved recipes and mealplans
- Import recipes from links
- Shared shoppinglists & mealplans


## Stack
Vue.js + Node.js + PostgreSQL + NGINX

### Application arcitecture
fuudi.io uses NGINX to serve a Vue.js app. It also serves as a load balancer for the Node.js Express API. The API endpoints triggers PL/pgSQL functions in the PostgreSQL database.

![Application arcitecture](/arcitecture.png)
