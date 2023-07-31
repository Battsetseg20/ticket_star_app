Welcome to the TicketStar app, you can set up and run the application either using Docker or by manually installing the dependencies.
    Please follow the instructions below to set up the application for your preferred method.
    ## Using Docker
    ### Prerequisites
    - Docker
    - Docker Compose
    ### Steps
    1. Clone the repository
    ```git clone https://github.com/battsetseg20/ticket-star-app.git```
    ```cd ticket-star-app```
    2. Run `docker-compose build` to build the application
    docker build -t ticket-star-app .
    3. Run `docker-compose up` to start the application
    docker run -p 3000:3000 ticket-star-app
    4. Seed the database
    docker exec -it docker exec -it <container_id> rails db:seed
    5. Open http://localhost:3000 in your browser to view the application

    ## Manually installing dependencies
    ### Prerequisites
    - Ruby 2.7.5
    - Rails 7.0.0
    - PostgreSQL
    - Frontend dependencies
      - Node.js
      - Yarn
    ### Steps
    1. Clone the repository
     ```git clone https://github.com/battsetseg20/ticket-star-app.git```
     ```cd ticket-star-app```
    2. Install dependencies
     ```bundle install```
     ```yarn install```
    3. Create and migrate the database
     ```rails db:create```
     ```rails db:migrate```
    ```rails db:seed```
    4. Start the Rails server
     ```rails server````


     