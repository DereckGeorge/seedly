# Seedly Data Flow & Types Summary

## Overview
This document provides a complete overview of how data flows through the Seedly e-commerce app, including all data types, relationships, and the complete user journey.

## Core Data Types

### 1. User
```typescript
interface User {
  id: string;                    // Unique identifier
  phone: string;                 // Phone number (unique)
  username: string;              // Display name (unique)
  password: string;              // Hashed password
  userType: 'customer' | 'seller'; // User role
  createdAt: string;             // ISO 8601 timestamp
  updatedAt: string;             // ISO 8601 timestamp
}
```

### 2. Post
```typescript
interface Post {
  id: string;                    // Unique identifier
  customerId: string;            // Reference to User.id
  customerName: string;          // Denormalized for performance
  title: string;                 // Post title
  description: string;           // Post description
  status: 'active' | 'completed'; // Post status
  createdAt: string;             // ISO 8601 timestamp
  updatedAt: string;             // ISO 8601 timestamp
  completedAt?: string;          // When post was completed
  selectedOfferId?: string;      // Reference to selected Offer.id
}
```

### 3. Offer
```typescript
interface Offer {
  id: string;                    // Unique identifier
  postId: string;                // Reference to Post.id
  sellerId: string;              // Reference to User.id
  sellerName: string;            // Denormalized for performance
  sellerPhone: string;           // Denormalized for phone calls
  price: number;                 // Offer price
  description: string;           // Offer description
  images: string[];              // Array of image URLs
  createdAt: string;             // ISO 8601 timestamp
  updatedAt: string;             // ISO 8601 timestamp
  isSelected: boolean;           // Whether this offer was selected
}
```

## Data Relationships

```
User (1) ←→ (N) Post
User (1) ←→ (N) Offer
Post (1) ←→ (N) Offer
```

## Complete User Journey

### Customer Journey

#### 1. Registration
```typescript
// Request
POST /auth/register
{
  phone: "1234567890",
  username: "john_customer",
  password: "password123",
  userType: "customer"
}

// Response
{
  success: true,
  data: {
    user: User,
    token: "jwt_token"
  }
}
```

#### 2. Create Post
```typescript
// Request
POST /posts
{
  title: "I want an iPhone 16",
  description: "Looking for a new iPhone 16 in good condition"
}

// Response
{
  success: true,
  data: {
    post: Post
  }
}
```

#### 3. View Offers
```typescript
// Request
GET /posts/{postId}/offers

// Response
{
  success: true,
  data: {
    offers: Offer[]
  }
}
```

#### 4. Select Offer & Complete Post
```typescript
// Request
PUT /posts/{postId}/complete
{
  selectedOfferId: "offer_123"
}

// Response
{
  success: true,
  data: {
    post: Post // status: "completed"
  }
}
```

### Seller Journey

#### 1. Registration
```typescript
// Request
POST /auth/register
{
  phone: "9876543210",
  username: "jane_seller",
  password: "password123",
  userType: "seller"
}
```

#### 2. Browse Active Posts
```typescript
// Request
GET /posts/active?page=1&limit=20&search=iphone

// Response
{
  success: true,
  data: {
    posts: Post[],
    pagination: {
      page: 1,
      limit: 20,
      total: 50,
      pages: 3
    }
  }
}
```

#### 3. Add Offer
```typescript
// Request
POST /posts/{postId}/offers
{
  price: 999.99,
  description: "Brand new iPhone 16, sealed box",
  images: [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ]
}

// Response
{
  success: true,
  data: {
    offer: Offer
  }
}
```

## State Management Flow

### Flutter App State

```typescript
// AuthProvider State
interface AuthState {
  currentUser: User | null;
  isLoading: boolean;
  error: string | null;
  isLoggedIn: boolean;
}

// PostProvider State
interface PostState {
  activePosts: Post[];           // For sellers
  myPosts: Post[];              // For customers
  currentPostOffers: Offer[];   // Current post's offers
  selectedPost: Post | null;    // Currently viewed post
  isLoading: boolean;
  error: string | null;
}
```

### State Updates

#### 1. User Authentication
```
Login/Register → AuthProvider → Update currentUser → Navigate to Home
```

#### 2. Post Creation
```
CreatePost → PostService → PostProvider → Update myPosts → Navigate back
```

#### 3. Offer Addition
```
AddOffer → PostService → PostProvider → Update currentPostOffers → Navigate back
```

#### 4. Post Completion
```
CompletePost → PostService → PostProvider → Update post status → Navigate back
```

## API Request/Response Patterns

### Standard Response Format
```typescript
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}
```

### Pagination Format
```typescript
interface PaginatedResponse<T> {
  success: boolean;
  message: string;
  data: {
    items: T[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      pages: number;
      hasNext: boolean;
      hasPrev: boolean;
    };
  };
}
```

### Error Response Format
```typescript
interface ErrorResponse {
  success: false;
  message: string;
  error: string;
  errors?: Record<string, string[]>;
}
```

## Database Schema Relationships

### Users Table
```sql
CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  user_type ENUM('customer', 'seller') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Posts Table
```sql
CREATE TABLE posts (
  id VARCHAR(36) PRIMARY KEY,
  customer_id VARCHAR(36) NOT NULL,
  customer_name VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  status ENUM('active', 'completed') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  completed_at TIMESTAMP NULL,
  selected_offer_id VARCHAR(36) NULL,
  FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Offers Table
```sql
CREATE TABLE offers (
  id VARCHAR(36) PRIMARY KEY,
  post_id VARCHAR(36) NOT NULL,
  seller_id VARCHAR(36) NOT NULL,
  seller_name VARCHAR(50) NOT NULL,
  seller_phone VARCHAR(20) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description TEXT NOT NULL,
  images JSON NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_selected BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE
);
```

## Real-time Data Flow

### WebSocket Events

#### 1. New Post Created
```typescript
// Event sent to all sellers
{
  event: "new_post",
  data: {
    post: {
      id: string,
      title: string,
      customerName: string,
      createdAt: string
    }
  }
}
```

#### 2. New Offer Added
```typescript
// Event sent to post owner
{
  event: "new_offer",
  data: {
    postId: string,
    offer: {
      id: string,
      sellerName: string,
      price: number,
      createdAt: string
    }
  }
}
```

#### 3. Post Completed
```typescript
// Event sent to all offer makers
{
  event: "post_completed",
  data: {
    postId: string,
    selectedOfferId: string,
    completedAt: string
  }
}
```

## Data Validation Rules

### User Validation
```typescript
const userValidation = {
  phone: {
    required: true,
    pattern: /^\+?[\d\s\-\(\)]{10,15}$/,
    message: "Please enter a valid phone number"
  },
  username: {
    required: true,
    minLength: 3,
    maxLength: 50,
    pattern: /^[a-zA-Z0-9_]+$/,
    message: "Username must be 3-50 characters, alphanumeric and underscore only"
  },
  password: {
    required: true,
    minLength: 6,
    message: "Password must be at least 6 characters"
  },
  userType: {
    required: true,
    enum: ["customer", "seller"],
    message: "User type must be customer or seller"
  }
};
```

### Post Validation
```typescript
const postValidation = {
  title: {
    required: true,
    minLength: 5,
    maxLength: 255,
    message: "Title must be 5-255 characters"
  },
  description: {
    required: true,
    minLength: 10,
    maxLength: 2000,
    message: "Description must be 10-2000 characters"
  }
};
```

### Offer Validation
```typescript
const offerValidation = {
  price: {
    required: true,
    min: 0.01,
    max: 999999.99,
    message: "Price must be between $0.01 and $999,999.99"
  },
  description: {
    required: true,
    minLength: 10,
    maxLength: 1000,
    message: "Description must be 10-1000 characters"
  },
  images: {
    maxLength: 10,
    message: "Maximum 10 images allowed"
  }
};
```

## Security Considerations

### Authentication
- JWT tokens with 7-day expiration
- Password hashing using bcrypt
- Rate limiting on auth endpoints

### Authorization
- Users can only edit their own posts
- Sellers can only add offers to active posts
- Customers can only complete their own posts

### Data Protection
- Phone numbers are validated and formatted
- Images are validated for type and size
- SQL injection prevention through parameterized queries
- XSS prevention through input sanitization

## Performance Optimizations

### Database Indexes
```sql
-- Performance indexes
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_customer_id ON posts(customer_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_offers_post_id ON offers(post_id);
CREATE INDEX idx_offers_seller_id ON offers(seller_id);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_username ON users(username);
```

### Caching Strategy
- Redis for session storage
- Cache frequently accessed posts
- Cache user data for 1 hour
- Cache search results for 5 minutes

### Pagination
- Default 20 items per page
- Maximum 100 items per page
- Efficient offset-based pagination

## Error Handling

### Client-Side Errors
```typescript
interface AppError {
  type: 'network' | 'validation' | 'auth' | 'server';
  message: string;
  code?: string;
  details?: any;
}
```

### Server-Side Errors
```typescript
interface ServerError {
  success: false;
  message: string;
  error: string;
  statusCode: number;
  timestamp: string;
}
```

## Testing Data

### Sample Test Users
```json
{
  "customers": [
    {
      "phone": "1234567890",
      "username": "test_customer",
      "password": "password123",
      "userType": "customer"
    }
  ],
  "sellers": [
    {
      "phone": "9876543210",
      "username": "test_seller",
      "password": "password123",
      "userType": "seller"
    }
  ]
}
```

### Sample Test Posts
```json
{
  "posts": [
    {
      "title": "Test Post - iPhone 16",
      "description": "This is a test post for iPhone 16"
    },
    {
      "title": "Test Post - MacBook",
      "description": "This is a test post for MacBook Pro"
    }
  ]
}
```

### Sample Test Offers
```json
{
  "offers": [
    {
      "price": 999.99,
      "description": "Test offer for iPhone 16",
      "images": ["https://via.placeholder.com/300x200?text=Test+Image"]
    }
  ]
}
```

This comprehensive data flow summary provides a complete understanding of how data moves through the Seedly app, from user registration to post completion, including all the types, validations, and relationships involved. 