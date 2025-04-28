# Installation Guide

## Prerequisites
- Ruby 3.x
- Rails 7.1
- PostgreSQL
- Node.js
- Yarn

## Setup Steps
1. Clone the repository
```bash
git clone [repository-url]
cd Admin-Dashboard
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Database setup
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the server
```bash
rails server
```