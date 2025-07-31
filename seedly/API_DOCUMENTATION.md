# Seedly API Documentation

## Base URL
```
http://192.168.100.67:8001/api/v1
```

## Authentication
All API requests (except login/register) require a Bearer token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

## Data Types

### User
```typescript
interface User {
  id: string;
  phone: string;
  username: string;
  password: string; // hashed
  userType: 'customer' | 'seller';
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
}
```

### Post
```typescript
interface Post {
  id: string;
  customerId: string;
  customerName: string;
  title: string;
  description: string;
  status: 'active' | 'completed';
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
  completedAt?: string; // ISO 8601
  selectedOfferId?: string;
}
```

### Offer
```typescript
interface Offer {
  id: string;
  postId: string;
  sellerId: string;
  sellerName: string;
  sellerPhone: string;
  price: number;
  description: string;
  images: string[]; // URLs
  createdAt: string; // ISO 8601
  updatedAt: string; // ISO 8601
  isSelected: boolean;
}
```

### API Response Format
```typescript
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
}
```

## Authentication Endpoints

### 1. Register User
**POST** `/auth/register`

**Request Body:**
```json
{
  "phone": "1234567890",
  "username": "john_doe",
  "password": "password123",
  "userType": "customer"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": "user_123",
      "phone": "1234567890",
      "username": "john_doe",
      "userType": "customer",
      "createdAt": "2024-01-01T00:00:00Z"
    },
    "token": "jwt_token_here"
  }
}
```

### 2. Login User
**POST** `/auth/login`

**Request Body:**
```json
{
  "phone": "1234567890",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "user_123",
      "phone": "1234567890",
      "username": "john_doe",
      "userType": "customer",
      "createdAt": "2024-01-01T00:00:00Z"
    },
    "token": "jwt_token_here"
  }
}
```

### 3. Get Current User
**GET** `/auth/me`

**Response:**
```json
{
  "success": true,
  "message": "User retrieved successfully",
  "data": {
    "user": {
      "id": "user_123",
      "phone": "1234567890",
      "username": "john_doe",
      "userType": "customer",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 4. Update User
**PUT** `/auth/update`

**Request Body:**
```json
{
  "username": "new_username",
  "phone": "9876543210"
}
```

**Response:**
```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "user": {
      "id": "user_123",
      "phone": "9876543210",
      "username": "new_username",
      "userType": "customer",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z"
    }
  }
}
```

### 5. Change Password
**PUT** `/auth/change-password`

**Request Body:**
```json
{
  "currentPassword": "old_password",
  "newPassword": "new_password"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

### 6. Logout
**POST** `/auth/logout`

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

## Posts Endpoints

### 1. Create Post
**POST** `/posts`

**Request Body:**
```json
{
  "title": "I want an iPhone 16",
  "description": "Looking for a new iPhone 16 in good condition"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Post created successfully",
  "data": {
    "post": {
      "id": "post_123",
      "customerId": "user_123",
      "customerName": "john_doe",
      "title": "I want an iPhone 16",
      "description": "Looking for a new iPhone 16 in good condition",
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 2. Get All Active Posts (for sellers)
**GET** `/posts/active`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)
- `search` (optional): Search query

**Response:**
```json
{
  "success": true,
  "message": "Posts retrieved successfully",
  "data": {
    "posts": [
      {
        "id": "post_123",
        "customerId": "user_123",
        "customerName": "john_doe",
        "title": "I want an iPhone 16",
        "description": "Looking for a new iPhone 16 in good condition",
        "status": "active",
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "pages": 3
    }
  }
}
```

### 3. Get User's Posts (for customers)
**GET** `/posts/my-posts`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)
- `status` (optional): Filter by status ('active' | 'completed')

**Response:**
```json
{
  "success": true,
  "message": "Posts retrieved successfully",
  "data": {
    "posts": [
      {
        "id": "post_123",
        "customerId": "user_123",
        "customerName": "john_doe",
        "title": "I want an iPhone 16",
        "description": "Looking for a new iPhone 16 in good condition",
        "status": "active",
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 10,
      "pages": 1
    }
  }
}
```

### 4. Get Post by ID
**GET** `/posts/{postId}`

**Response:**
```json
{
  "success": true,
  "message": "Post retrieved successfully",
  "data": {
    "post": {
      "id": "post_123",
      "customerId": "user_123",
      "customerName": "john_doe",
      "title": "I want an iPhone 16",
      "description": "Looking for a new iPhone 16 in good condition",
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 5. Update Post
**PUT** `/posts/{postId}`

**Request Body:**
```json
{
  "title": "Updated title",
  "description": "Updated description"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Post updated successfully",
  "data": {
    "post": {
      "id": "post_123",
      "customerId": "user_123",
      "customerName": "john_doe",
      "title": "Updated title",
      "description": "Updated description",
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z"
    }
  }
}
```

### 6. Delete Post
**DELETE** `/posts/{postId}`

**Response:**
```json
{
  "success": true,
  "message": "Post deleted successfully"
}
```

### 7. Complete Post
**PUT** `/posts/{postId}/complete`

**Request Body:**
```json
{
  "selectedOfferId": "offer_123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Post completed successfully",
  "data": {
    "post": {
      "id": "post_123",
      "customerId": "user_123",
      "customerName": "john_doe",
      "title": "I want an iPhone 16",
      "description": "Looking for a new iPhone 16 in good condition",
      "status": "completed",
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z",
      "completedAt": "2024-01-02T00:00:00Z",
      "selectedOfferId": "offer_123"
    }
  }
}
```

## Offers Endpoints

### 1. Add Offer to Post
**POST** `/posts/{postId}/offers`

**Request Body:**
```json
{
  "price": 999.99,
  "description": "Brand new iPhone 16, sealed box",
  "images": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Offer added successfully",
  "data": {
    "offer": {
      "id": "offer_123",
      "postId": "post_123",
      "sellerId": "user_456",
      "sellerName": "jane_seller",
      "sellerPhone": "9876543210",
      "price": 999.99,
      "description": "Brand new iPhone 16, sealed box",
      "images": [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ],
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-01T00:00:00Z",
      "isSelected": false
    }
  }
}
```

### 2. Get Offers for Post
**GET** `/posts/{postId}/offers`

**Response:**
```json
{
  "success": true,
  "message": "Offers retrieved successfully",
  "data": {
    "offers": [
      {
        "id": "offer_123",
        "postId": "post_123",
        "sellerId": "user_456",
        "sellerName": "jane_seller",
        "sellerPhone": "9876543210",
        "price": 999.99,
        "description": "Brand new iPhone 16, sealed box",
        "images": [
          "https://example.com/image1.jpg",
          "https://example.com/image2.jpg"
        ],
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z",
        "isSelected": false
      }
    ]
  }
}
```

### 3. Update Offer
**PUT** `/offers/{offerId}`

**Request Body:**
```json
{
  "price": 899.99,
  "description": "Updated offer description",
  "images": [
    "https://example.com/new-image1.jpg"
  ]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Offer updated successfully",
  "data": {
    "offer": {
      "id": "offer_123",
      "postId": "post_123",
      "sellerId": "user_456",
      "sellerName": "jane_seller",
      "sellerPhone": "9876543210",
      "price": 899.99,
      "description": "Updated offer description",
      "images": [
        "https://example.com/new-image1.jpg"
      ],
      "createdAt": "2024-01-01T00:00:00Z",
      "updatedAt": "2024-01-02T00:00:00Z",
      "isSelected": false
    }
  }
}
```

### 4. Delete Offer
**DELETE** `/offers/{offerId}`

**Response:**
```json
{
  "success": true,
  "message": "Offer deleted successfully"
}
```

## Search Endpoints

### 1. Search Posts
**GET** `/posts/search`

**Query Parameters:**
- `q` (required): Search query
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "message": "Search results retrieved successfully",
  "data": {
    "posts": [
      {
        "id": "post_123",
        "customerId": "user_123",
        "customerName": "john_doe",
        "title": "I want an iPhone 16",
        "description": "Looking for a new iPhone 16 in good condition",
        "status": "active",
        "createdAt": "2024-01-01T00:00:00Z",
        "updatedAt": "2024-01-01T00:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "pages": 1
    }
  }
}
```

## File Upload Endpoints

### 1. Upload Image
**POST** `/upload/image`

**Request:**
- Content-Type: `multipart/form-data`
- Body: `file` (image file)

**Response:**
```json
{
  "success": true,
  "message": "Image uploaded successfully",
  "data": {
    "url": "https://example.com/uploads/image_123.jpg",
    "filename": "image_123.jpg"
  }
}
```

## Error Responses

### Validation Error
```json
{
  "success": false,
  "message": "Validation failed",
  "error": "Validation error details",
  "errors": {
    "field": ["Error message"]
  }
}
```

### Authentication Error
```json
{
  "success": false,
  "message": "Authentication failed",
  "error": "Invalid credentials"
}
```

### Authorization Error
```json
{
  "success": false,
  "message": "Access denied",
  "error": "You don't have permission to perform this action"
}
```

### Not Found Error
```json
{
  "success": false,
  "message": "Resource not found",
  "error": "Post with id 'post_123' not found"
}
```

### Server Error
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Something went wrong"
}
```

## Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error

## Rate Limiting

- Authentication endpoints: 5 requests per minute
- Other endpoints: 100 requests per minute

## Pagination

All list endpoints support pagination with the following query parameters:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)

Response includes pagination metadata:
```json
{
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

## WebSocket Events (Real-time Features)

### Connection
```
ws://192.168.100.67:8001/ws
```

### Events

#### New Offer
```json
{
  "event": "new_offer",
  "data": {
    "postId": "post_123",
    "offer": {
      "id": "offer_123",
      "sellerName": "jane_seller",
      "price": 999.99
    }
  }
}
```

#### Post Completed
```json
{
  "event": "post_completed",
  "data": {
    "postId": "post_123",
    "selectedOfferId": "offer_123"
  }
}
```

#### New Post
```json
{
  "event": "new_post",
  "data": {
    "post": {
      "id": "post_123",
      "title": "I want an iPhone 16",
      "customerName": "john_doe"
    }
  }
}
```

## Database Schema

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

### Indexes
```sql
CREATE INDEX idx_posts_status ON posts(status);
CREATE INDEX idx_posts_customer_id ON posts(customer_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_offers_post_id ON offers(post_id);
CREATE INDEX idx_offers_seller_id ON offers(seller_id);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_username ON users(username);
```

## Environment Variables

```env
# Server Configuration
PORT=8001
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=seedly_db
DB_USER=seedly_user
DB_PASSWORD=seedly_password

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# File Upload
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=5242880 # 5MB

# Redis (for caching and sessions)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# Email (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_email_password

# AWS S3 (for file storage)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
AWS_S3_BUCKET=seedly-uploads
```

## Testing

### Test Data

#### Sample Users
```json
{
  "customers": [
    {
      "phone": "1234567890",
      "username": "john_customer",
      "password": "password123",
      "userType": "customer"
    },
    {
      "phone": "0987654321",
      "username": "jane_customer",
      "password": "password123",
      "userType": "customer"
    }
  ],
  "sellers": [
    {
      "phone": "5555555555",
      "username": "tech_seller",
      "password": "password123",
      "userType": "seller"
    },
    {
      "phone": "6666666666",
      "username": "phone_seller",
      "password": "password123",
      "userType": "seller"
    }
  ]
}
```

#### Sample Posts
```json
{
  "posts": [
    {
      "title": "I want an iPhone 16",
      "description": "Looking for a new iPhone 16 in good condition, preferably sealed box"
    },
    {
      "title": "Need a MacBook Pro",
      "description": "Looking for a MacBook Pro 14-inch, M2 or M3 chip, good condition"
    },
    {
      "title": "Want to buy AirPods Pro",
      "description": "Looking for AirPods Pro 2nd generation, authentic only"
    }
  ]
}
```

#### Sample Offers
```json
{
  "offers": [
    {
      "price": 999.99,
      "description": "Brand new iPhone 16, sealed box, 128GB, Black",
      "images": ["https://example.com/iphone1.jpg", "https://example.com/iphone2.jpg"]
    },
    {
      "price": 899.99,
      "description": "iPhone 16, excellent condition, 256GB, Blue, comes with original box",
      "images": ["https://example.com/iphone3.jpg"]
    }
  ]
}
```

## Deployment

### Docker Configuration

#### Dockerfile
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 8001

CMD ["npm", "start"]
```

#### docker-compose.yml
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8001:8001"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: seedly_db
      MYSQL_USER: seedly_user
      MYSQL_PASSWORD: seedly_password
    volumes:
      - db_data:/var/lib/mysql
    ports:
      - "3306:3306"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  db_data:
```

This API documentation provides a complete reference for implementing the backend for the Seedly e-commerce app. The endpoints cover all the functionality needed by the Flutter app, including authentication, post management, offer handling, and real-time features. 