
![Logo](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/th5xamgrr6se0x5ro4g6.png)

# TicketStar 

This is an online simplistic event ticketing platform built using Ruby on Rails and integrated with ticketing, event management and Stripe API for payment processing. The platform allows event organizers to create and manage events , while users can browse and purchase tickets for various events.

## Demo

Quick Guest and Customer flow:

Quick Event Organizer flow:



### Features / Functional Requirements
#### User Registration and Authentication
- Allow users to sign up, log in, and manage their profiles.
- Implement authentication using Devise or a similar gem.
#### EventItem Creation and Management
- Provide event organizers with a dashboard to create and manage event_items.
- Specify event details such as title, description, date, time, location, ticket types, and pricing.
- Implement CRUD (Create, Read, Update, Delete) operations for events and associated ticket types.
#### EventItem Listing
- Allow users to browse event_items, and view them by type
- Users should be able to view event details and purchase tickets.
#### Secure Payment Processing
- Integrate the Stripe API to handle payment processing.
- Users should be able to purchase tickets instantly using Stripe Checkout system
#### Ticket Generation
- Generate unique tickets with QR codes for each succeeded purchase.
- Users should receive their tickets via email or have the option to download them.
#### User Dashboard
- Provide personalized dashboards for users to view and manage purchased tickets.
- Offer event organizers a dedicated dashboard to track ticket sales, view attendee information, and manage event details.
## Installation

### Using Docker
#### 1. Clone the repository

```bash
git clone https://github.com/battsetseg20/ticket-star-app.git
cd ticket-star-app
```
#### 2. Build the container images and run the up
```bash
     docker-compose up -d
````
#### 3. Run the migration and seed the database
````bash
    bundle exec rake db:setup db:migrate
``````
#### 4. View the app
````bash
    http://localhost:3000 in your browser 
`````

### Manually installing the app
####  Prerequisites
    - Ruby 2.7.5
    - Rails 7.0.0
    - PostgreSQL
    - Frontend dependencies
      - Node.js
      - Yarn
#### 1. Clone the repository
```bash
git clone https://github.com/battsetseg20/ticket-star-app.git
cd ticket-star-app
```
#### 2. Install dependencies
```bash
    bundle install
    yarn install
````
#### 3. Run the migration and seed the database
````bash
    bundle exec rails db:create
    bundle exec rails db:migrate
    bundle exec rails db:seed
``````
#### 4. Start the server and view the app
````bash
    rails server
    http://localhost:3000 in your browser 
`````
## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`STRIPE_PUBLISHABLE_KEY`
`STRIPE_SECRET_KEY`
`STRIPE_WEBHOOK_SIGNING_SECRET`

You can create an account on Stripe and from their dashboard > developers > you can find the API keys



## Deployment

Although the app is deployed on Heroku:

[![TicketStar](https://ticket-star-d0715dd880f4.herokuapp.com/)

Only production database and sengrid is configured in it. We will not be testing Stripe Checkout on production. After the review, I'll put the app in maintenance mode as Heroku has no free-tier anymore.




## Running Tests

To run tests, run the following command

```bash
  bundle exec rails rspec spec/*
```

```bash
  bundle exec rails rspec spec/requests/<file>/<line>
```


## Contributing

Contributions are always welcome!

## Authors

- [@battetseg20](https://www.github.com/battsetseg20)

