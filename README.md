# Fuudi
## Recipe finder & meal planner

### Find recipes
![Landing page](/imgs/landingpage.png)

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
