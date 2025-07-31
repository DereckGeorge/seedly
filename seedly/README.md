# Seedly - E-commerce Platform

Seedly is a modern e-commerce platform where customers post what they want, and sellers compete with offers. Built with Flutter using clean architecture principles.

## Features

### For Customers
- **Post Requests**: Create posts describing what you need (e.g., "I want an iPhone 16")
- **Receive Offers**: Get multiple offers from different sellers
- **Compare Offers**: View offers with prices, descriptions, and images
- **Select Best Offer**: Choose the best offer and mark post as complete
- **Call Sellers**: Direct phone call functionality to contact sellers
- **Post History**: View all your posts (active and completed)

### For Sellers
- **Browse Posts**: Search and view active customer requests
- **Search Content**: Find relevant posts using search functionality
- **Make Offers**: Add offers with price, description, and images
- **Contact Customers**: Phone call integration for direct communication

### Authentication
- **Simple Registration**: Phone, username, and password only
- **User Types**: Choose between Customer and Seller roles
- **Secure Login**: Phone number and password authentication

## Architecture

The app follows clean architecture principles with the following structure:

```
lib/
├── models/          # Data models (User, Post, Offer)
├── services/        # Business logic and API calls
├── providers/       # State management using Provider
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── utils/           # Constants and utilities
```

### Key Components

- **Models**: Define data structures for User, Post, and Offer
- **Services**: Handle authentication, posts, and phone functionality
- **Providers**: Manage app state using Provider pattern
- **Screens**: Main UI screens for different user flows
- **Widgets**: Reusable components like CustomButton, CustomTextField

## Getting Started

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd seedly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

The app uses the following key dependencies:

- **provider**: State management
- **http**: HTTP requests (for future API integration)
- **image_picker**: Image selection (for offer images)
- **cached_network_image**: Efficient image loading
- **url_launcher**: Phone call functionality
- **shared_preferences**: Local storage
- **flutter_staggered_grid_view**: Advanced grid layouts
- **shimmer**: Loading animations

## Usage

### Customer Flow
1. Register/Login as a Customer
2. Create a post describing what you need
3. Wait for sellers to make offers
4. Review offers with prices and images
5. Select the best offer and mark post as complete
6. Call the seller to arrange the transaction

### Seller Flow
1. Register/Login as a Seller
2. Browse active posts from customers
3. Search for specific items using keywords
4. Make offers with price, description, and images
5. Wait for customer to select your offer
6. Receive phone calls from interested customers

## Features to Add

The app is designed to be easily extensible. Here are some planned features:

- **Real-time Notifications**: Push notifications for new offers
- **Chat System**: In-app messaging between customers and sellers
- **Payment Integration**: Secure payment processing
- **Rating System**: User ratings and reviews
- **Location Services**: Find nearby sellers/customers
- **Image Upload**: Real image upload to cloud storage
- **Push Notifications**: Real-time updates

## Scalability

The app is built with scalability in mind:

- **Modular Architecture**: Easy to add new features
- **Service Layer**: Business logic separated from UI
- **Provider Pattern**: Efficient state management
- **Reusable Components**: Consistent UI across the app
- **Clean Code**: Well-structured and maintainable codebase

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please contact the development team.

---

**Seedly** - Find what you need, get the best offers! 🛒✨
