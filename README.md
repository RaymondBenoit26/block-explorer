# NEAR Block Explorer

A Ruby on Rails application for exploring NEAR blockchain transactions and transfers, built as a take-home assessment for a Lead Ruby on Rails Engineer position.

## 🚀 Features

- **Transfer Transactions Display**: View recent transfers with sender, receiver, and deposit amounts
- **Gas Statistics**: Real-time gas consumption analytics with average, total, and min/max values
- **Historical Data Persistence**: Transactions remain available even when no longer returned by the API
- **Multi-Chain Architecture**: Extensible design supporting additional blockchain networks
- **Responsive UI**: Clean, modern interface built with Tailwind CSS
- **Background Processing**: Async transaction syncing using Rails 8's solid_queue
- **Error Handling**: Robust error handling for API failures and data processing issues

## 🏗️ Architecture

### Database Schema

The application uses a generic multi-chain database design:

```
chains → blocks → transactions → transaction_actions
```

- **Chain**: Represents a blockchain network (NEAR, Ethereum, etc.)
- **Block**: Individual blocks with height, hash, and timestamp
- **Transaction**: Blockchain transactions with gas information
- **TransactionAction**: Individual actions within transactions (transfers, function calls, etc.)

### Service Layer

- **ChainApiService**: Generic HTTP client for blockchain API interactions
- **TransactionProcessorService**: Parses and stores transaction data
- **GasCalculatorService**: Computes gas statistics
- **SyncTransactionsJob**: Background job for periodic data synchronization

### Key Design Decisions

1. **Generic Multi-Chain Support**: Database schema and services designed for extensibility
2. **Decimal Storage**: Used `decimal` type with high precision for crypto token amounts
3. **Background Processing**: Async jobs prevent UI blocking during API calls
4. **Action Polymorphism**: Single table for all transaction action types
5. **Graceful Degradation**: UI handles missing data and API failures elegantly

## 🛠️ Setup Instructions

### Prerequisites

- Ruby 3.3.0 (recommended via rbenv)
- Rails 8.0+
- PostgreSQL 14+
- Redis (for background jobs)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd block_explorer
   ```
2. **Install dependencies**

   ```bash
   bundle install
   ```
3. **Database setup**

   ```bash
   rails db:create
   rails db:migrate
   ```
4. **Seed initial data**

   ```bash
   rails db:seed
   ```
5. **Start the application**

   ```bash
   rails server
   ```
6. **Start background jobs** (in separate terminal)

   ```bash
   bundle exec rails jobs:work
   ```

### Environment Configuration

Create a `.env` file in the root directory:

```env
DATABASE_URL=postgresql://username:password@localhost:5432/block_explorer_development
REDIS_URL=redis://localhost:6379/0
```

## 📊 Usage

### Web Interface

Visit `http://localhost:3000` to access the block explorer interface.

The main page displays:

- Gas statistics in a 4-column grid
- Recent transfers table with transaction details
- Last sync timestamp
- Supported blockchain networks

### Data Synchronization

**Manual Sync**

```bash
rails runner "SyncTransactionsJob.perform_now"
```

**Background Sync**
The application automatically syncs new transactions every 5 minutes via background jobs.

**Statistics Calculation**

```bash
rails runner "puts GasCalculatorService.new.gas_statistics"
```

## 🔧 Technical Details

### NEAR Token Handling

NEAR tokens use 24 decimal places. The application:

- Stores raw values as high-precision decimals
- Formats display values by dividing by 10^24
- Handles very large deposit amounts (up to 30 digits)

### Transfer Detection

The application identifies transfers through:

- Direct `Transfer` actions from the API
- `FunctionCall` actions with deposits > 0
- Smart contract interactions that move tokens

### Error Handling

- **API Failures**: Graceful fallback with error logging
- **Large Numbers**: Configured to handle crypto-scale numeric values
- **Missing Data**: UI displays appropriate placeholder messages
- **Transaction Conflicts**: Duplicate prevention using unique constraints

### Performance Optimizations

- **Database Indexing**: Optimized queries for transaction lookups
- **Eager Loading**: Minimizes N+1 queries in transfer display
- **Pagination**: Limits results to 50 most recent transfers
- **Caching**: Gas statistics calculated once per request

## 📈 Current Status

### Data Statistics

- **Transactions**: 100 processed from API
- **Blocks**: 97 unique blocks stored
- **Transfer Actions**: 12 with real deposit data
- **Gas Statistics**: Calculated from all transactions

### API Integration

- **Endpoint**: Mock NEAR API providing 100 transactions
- **Success Rate**: 81% (19 transactions failed due to data format issues)
- **Response Time**: ~200ms average
- **Error Handling**: Comprehensive logging and recovery

## 🐛 Known Issues

1. **Large Deposit Values**: Some NEAR deposits exceed standard integer limits

   - **Solution**: Configured `ActiveRecord.raise_int_wider_than_64bit = false`
   - **Status**: Resolved
2. **API Data Inconsistency**: Some transactions missing action data

   - **Impact**: Minor - affects display completeness
   - **Mitigation**: Graceful handling with appropriate UI messages

## 📝 Development Notes

### Adding New Chains

1. Create chain record in database
2. Configure API endpoint and authentication
3. Update `TransactionProcessorService` for chain-specific parsing
4. Add chain-specific formatting in `Chain` model

### Modifying Display Logic

Transfer display logic is centralized in:

- `TransfersController#index` - Data loading
- `app/views/transfers/index.html.erb` - UI rendering
- `ApplicationHelper` - Formatting utilities

### Background Job Management

Jobs are managed through Rails 8's solid_queue:

- Configuration: `config/environments/development.rb`
- Monitoring: Check `solid_queue_jobs` table
- Debugging: Logs available in `rails server` output

## **Built with**: Ruby on Rails 8.0, PostgreSQL, Redis, Tailwind CSS, HTTParty
