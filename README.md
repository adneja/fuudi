# Mealplanner
Mealplanner is an application that lets users find and create recipes and meal plans. 

Some features include:
  - find and create recipes
  - create and share meal plans
  - generate shopping list from recipes and meal plans
  
  
# Stack
Vue.js + Express + PostgreSQL
 

# Run locally
Start by cloning into repository: `git clone https://github.com/adneja/mealplanner.git`

## Client
- Go to /client directory and install dependencies: `npm install`
- To serve content locally, run: `npm run serve`

## API
- Go to /api directory and install dependencies: `npm install`
- Create `.env` file in root directory with following variables:
    - SQL_SERVER
    - SQL_PORT
    - SQL_DB
    - SQL_USER
    - SQL_PASSWORD
    - JWT_SECRET
- Run app with: `npm run serve`

## DB
- Install and run postgresql
- Restore from `/db/schema_backup` for empty db or `full_backup` to include test data
- Create a user named `api`, login credentials for this user must match .env variables
