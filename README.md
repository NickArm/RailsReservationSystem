
# Villa Booking System

A web-based application for managing property bookings, customer reservations, invoices, and payments. Built with **Ruby on Rails**, it provides functionality for both administrators and customers.

---

## Features

### Admin Functionality
- **Dashboard**: Access a summary of bookings, customers, and properties.
- **Manage Bookings**:
  - View, add, edit, or delete bookings.
  - Change booking statuses such as *Unpaid*, *Confirm Payment*, *Paid*, and *Canceled*.
- **Property Management**:
  - Create, update, and delete properties.
  - Set availability, price, and other property details.
- **Calendar Management**:
  - Manage availability and pricing for properties.
  - Add, edit, and delete availability for specific dates using the calendar.
- **Customer Management**:
  - View customer details.
  - Add or remove customers.
- **Payments**:
  - Add and manage payment methods (*Stripe*, *Pay on Arrival*, *Bank Transfer*).
  - Process and track payments for bookings.
  - Add descriptions to payment methods, which display when selected.
- **Settings**:
  - Configure company details (name, address, VAT number, etc.).
  - Manage enabled payment methods and their descriptions.
  - Configure taxes and payment options for properties.
  - Set weekly and monthly discounts.
- **Invoice Management**:
  - Generate and manage invoices.
  - Display company details and payment status in the invoice layout.
  - View detailed breakdowns of invoice amounts, including taxes.
- **Login & Authentication**:
  - Secure login for admins.
  - Logout option in the sidebar.
  - Displays error message for invalid login attempts.

### Customer Functionality
- **Reservation Management**:
  - Book properties based on availability.
  - View booking details and status.
- **Payment Options**:
  - Choose from multiple payment methods (*Stripe*, *Pay on Arrival*, *Bank Transfer*).
- **Customer Profile**:
  - Manage customer information, including contact details.

---

## Technology Stack
- **Framework**: Ruby on Rails
- **Database**: PostgreSQL
- **Front-end**:
  - HTML, CSS (Tailwind CSS)
  - JavaScript (FullCalendar.js for calendar management)
- **Authentication**: Devise
- **Payment Integration**: Stripe API
- **Invoices**: Includes company branding and detailed payment breakdowns.

---

## Installation & Setup

### Prerequisites
- Ruby 3.2.x
- Rails 8.x
- PostgreSQL
- Node.js & npm (for asset precompilation)

### Setup Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/villa-booking-system.git
   cd villa-booking-system
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Configure the database:
   - Set up your database credentials in `config/database.yml`.
   - Create and migrate the database:
     ```bash
     rails db:create db:migrate
     ```

4. Seed the database:
   ```bash
   rails db:seed
   ```

5. Start the server:
   ```bash
   rails server
   ```

6. Access the application at [http://localhost:3000](http://localhost:3000).

---

## Deployment

### Heroku
1. Add the necessary buildpacks:
   ```bash
   heroku buildpacks:add --index 1 heroku/nodejs
   heroku buildpacks:add --index 2 heroku/ruby
   ```

2. Push the application to Heroku:
   ```bash
   git push heroku main
   ```

3. Migrate and seed the database:
   ```bash
   heroku run rails db:migrate
   heroku run rails db:seed
   ```

4. Access the deployed application at your Heroku URL.

---

## Contribution

1. Fork the repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes and push the branch:
   ```bash
   git commit -m "Add feature"
   git push origin feature-name
   ```
4. Open a pull request on GitHub.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## API Endpoints

The application provides API endpoints for integration and external system access.

### Search Properties
- **Endpoint**: `GET /api/v1/search`
- **Description**: Search for available properties within a date range and guest count.
- **Example**:
  ```http
  http://localhost:3000/api/v1/search?start_date=2025-02-01&end_date=2025-02-05&guest_count=4
  ```

### Get Customers
- **Endpoint**: `GET /api/v1/customers`
- **Description**: Fetch all customers.
- **Example**:
  ```http
  http://localhost:3000/api/v1/customers
  ```

### Search Customer by Email
- **Endpoint**: `GET /api/v1/customers/search_by_email`
- **Description**: Fetch a specific customer by their email.
- **Example**:
  ```http
  http://localhost:3000/api/v1/customers/search_by_email?email=armenisnick@hotmail.com
  ```

### Future API Endpoints
- Additional API endpoints will be added in subsequent updates.
