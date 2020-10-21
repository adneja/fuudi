# fuudiio

fuudio.io is a:
  - recipe finder
  - online cookbook
  - meal planner
  - food shopping assistant
  
I made this application to simplify my weekly grocery shopping. With fuudi.io all I have to do is select one of my meal plans and click "Generate shopping list". Then I check off on the ingredients I have at home, before I head to the store.

If I need 1 dl milk in one recipe and 2 dl milk in an other, fuud.io knows I need 3dl milk in my shopping list. It also standardizeds units of measurements so that no matter what units a recipe author decides to use, the shopping list will display an acurate total.
  
  
## Stack
Vue.js + Node.js + PostgreSQL + NGINX

### Application arcitecture
fuudi.io uses NGINX to serve a Vue.js app. It also serves as a load balancer for the Node.js Express API cluster. The API endpoints triggers PL/pgSQL functions in the PostgreSQL database.

